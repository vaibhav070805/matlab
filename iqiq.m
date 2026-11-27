
clc;
clear;
close all;

%% 1. SYSTEM PARAMETERS
Fs = 1e6;                  % Sampling frequency: 1 MHz
N = 128;                   % Repeated preamble length
numPayloadSymbols = 2000;
SNR_dB = 16;

fTx = .2401e9;             % Transmitter frequency
fRx = .24009985e9;         % Receiver frequency

% Frequency discrepancy between Tx and Rx
CFO_actual = fTx - fRx;

fprintf('\n============================================\n');
fprintf('       I/Q SIGNAL AND CFO ANALYSIS\n');
fprintf('============================================\n');
fprintf('Transmitter frequency : %.7f GHz\n', fTx/1e9);
fprintf('Receiver frequency    : %.7f GHz\n', fRx/1e9);
fprintf('Actual frequency offset: %.2f Hz\n', CFO_actual);
fprintf('============================================\n');

%% 2. GENERATE TRANSMITTED QPSK SIGNAL
% QPSK symbols have I and Q components of +/-1/sqrt(2)

rng(10);                   % Reproducible results

bits = randi([0 1], 2, N + numPayloadSymbols);

% QPSK mapping
symbols = ((2*bits(1,:)-1) + ...
    1j*(2*bits(2,:)-1))/sqrt(2);

% Preamble repeated twice for CFO estimation
preamble = symbols(1:N);
payload = symbols(N+1:end);

tx = [preamble, preamble, payload];

% Normalize signal power
tx = tx / sqrt(mean(abs(tx).^2));

I_tx = real(tx);
Q_tx = imag(tx);

%% 3. MODEL THE RECEIVED SIGNAL WITH CFO AND NOISE
n = 0:length(tx)-1;
t = n/Fs;

% Baseband equivalent carrier-frequency offset
rx_noiseless = tx .* exp(1j*2*pi*CFO_actual*n/Fs);

% Complex AWGN
signalPower = mean(abs(rx_noiseless).^2);
noisePower = signalPower / (10^(SNR_dB/10));

noise = sqrt(noisePower/2) .* ...
    (randn(size(tx)) + 1j*randn(size(tx)));

rx = rx_noiseless + noise;

I_rx = real(rx);
Q_rx = imag(rx);

%% 4. ESTIMATE CARRIER FREQUENCY OFFSET
% Compare two repeated preamble sections
r1 = rx(1:N);
r2 = rx(N+1:2*N);

R = sum(conj(r1).*r2);

CFO_estimated = angle(R)*Fs/(2*pi*N);

fprintf('\n------------- CFO ESTIMATION -------------\n');
fprintf('Actual CFO           : %10.3f Hz\n', CFO_actual);
fprintf('Estimated CFO        : %10.3f Hz\n', CFO_estimated);
fprintf('Estimation error     : %10.3f Hz\n', ...
    CFO_estimated-CFO_actual);

%% 5. COMPENSATE THE FREQUENCY OFFSET
rx_corrected = rx .* exp(-1j*2*pi*CFO_estimated*n/Fs);

I_corrected = real(rx_corrected);
Q_corrected = imag(rx_corrected);

% Estimate residual offset using the same repeated preamble
c1 = rx_corrected(1:N);
c2 = rx_corrected(N+1:2*N);

CFO_residual = angle(sum(conj(c1).*c2))*Fs/(2*pi*N);

fprintf('Residual CFO         : %10.3f Hz\n', CFO_residual);
fprintf('===========================================\n');

%% 6. TRANSMITTED I/Q SIGNAL
% Plot a short section for readability
L = min(300, length(tx));

figure('Name','Transmitted I/Q Signal','Color','w');

subplot(2,1,1);
plot(t(1:L)*1e3, I_tx(1:L), 'b');
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Transmitted In-phase Signal (I)');

subplot(2,1,2);
plot(t(1:L)*1e3, Q_tx(1:L), 'r');
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Transmitted Quadrature Signal (Q)');

%% 7. RECEIVED I/Q BEFORE COMPENSATION
figure('Name','Received I/Q Before Compensation','Color','w');

subplot(2,1,1);
plot(t(1:L)*1e3, I_rx(1:L), 'b');
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Received In-phase Signal Before CFO Compensation');

subplot(2,1,2);
plot(t(1:L)*1e3, Q_rx(1:L), 'r');
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Received Quadrature Signal Before CFO Compensation');

%% 8. RECEIVED I/Q AFTER COMPENSATION
figure('Name','Received I/Q After Compensation','Color','w');

subplot(2,1,1);
plot(t(1:L)*1e3, I_corrected(1:L), 'b');
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Received In-phase Signal After CFO Compensation');

subplot(2,1,2);
plot(t(1:L)*1e3, Q_corrected(1:L), 'r');
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Received Quadrature Signal After CFO Compensation');

%% 9. RECEIVER CONSTELLATION DIAGRAMS
% Use payload symbols only, excluding the preamble
payloadStart = 2*N + 1;

rx_payload = rx(payloadStart:end);
corrected_payload = rx_corrected(payloadStart:end);
tx_payload = tx(payloadStart:end);

figure('Name','QPSK Receiver Constellations','Color','w');

subplot(1,3,1);
plot(real(tx_payload), imag(tx_payload), 'bo');
grid on;
axis square;
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title('Transmitted Constellation');

subplot(1,3,2);
plot(real(rx_payload), imag(rx_payload), 'r.');
grid on;
axis square;
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title('Received Before Compensation');

subplot(1,3,3);
plot(real(corrected_payload), imag(corrected_payload), 'g.');
grid on;
axis square;
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title('Received After Compensation');

%% 10. SPECTRUM ANALYSIS
% Centered FFT spectrum in dB relative to each signal's peak
% Use the same FFT length for all three signals

nfft = 8192;
freq = (-nfft/2:nfft/2-1)*(Fs/nfft);

TXspec = fftshift(fft(tx, nfft));
RXspec = fftshift(fft(rx, nfft));
CORspec = fftshift(fft(rx_corrected, nfft));

TXdB = 20*log10(abs(TXspec)/(max(abs(TXspec))+eps) + eps);
RXdB = 20*log10(abs(RXspec)/(max(abs(RXspec))+eps) + eps);
CORdB = 20*log10(abs(CORspec)/(max(abs(CORspec))+eps) + eps);

figure('Name','Spectrum Analysis','Color','w');

subplot(3,1,1);
plot(freq/1e3, TXdB, 'b');
grid on;
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');
title('Transmitted Baseband Spectrum');
xlim([-Fs/2 Fs/2]/1e3);
ylim([-80 5]);

subplot(3,1,2);
plot(freq/1e3, RXdB, 'r');
grid on;
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');
title(sprintf('Received Spectrum Before Compensation (CFO = %.1f Hz)', ...
    CFO_estimated));
xlim([-Fs/2 Fs/2]/1e3);
ylim([-80 5]);

subplot(3,1,3);
plot(freq/1e3, CORdB, 'g');
grid on;
xlabel('Frequency (kHz)');
ylabel('Magnitude (dB)');
title(sprintf('Received Spectrum After Compensation (Residual CFO = %.1f Hz)', ...
    CFO_residual));
xlim([-Fs/2 Fs/2]/1e3);
ylim([-80 5]);

%% 11. OVERLAY SPECTRA FOR DIRECT COMPARISON
figure('Name','Spectrum Comparison','Color','w');

plot(freq/1e3, TXdB, 'b', 'LineWidth', 1);
hold on;
plot(freq/1e3, RXdB, 'r', 'LineWidth', 1);
plot(freq/1e3, CORdB, 'g', 'LineWidth', 1);
grid on;

xlabel('Frequency (kHz)');
ylabel('Normalized Magnitude (dB)');
title('Transmitted vs Received vs Compensated Spectrum');
legend('Transmitted','Received Before Compensation', ...
    'Received After Compensation','Location','best');

xlim([-Fs/2 Fs/2]/1e3);
ylim([-80 5]);

%% 12. I/Q COMPARISON IN ONE FIGURE
figure('Name','I/Q Comparison','Color','w');

subplot(2,1,1);
plot(t(1:L)*1e3, I_tx(1:L), 'b');
hold on;
plot(t(1:L)*1e3, I_rx(1:L), 'r');
plot(t(1:L)*1e3, I_corrected(1:L), 'g');
grid on;
xlabel('Time (ms)');
ylabel('I Amplitude');
title('In-phase Component Comparison');
legend('Transmitted','Received Before Compensation', ...
    'Received After Compensation');

subplot(2,1,2);
plot(t(1:L)*1e3, Q_tx(1:L), 'b');
hold on;
plot(t(1:L)*1e3, Q_rx(1:L), 'r');
plot(t(1:L)*1e3, Q_corrected(1:L), 'g');
grid on;
xlabel('Time (ms)');
ylabel('Q Amplitude');
title('Quadrature Component Comparison');
legend('Transmitted','Received Before Compensation', ...
    'Received After Compensation');

fprintf('\nAnalysis complete. All figures have been generated.\n');
