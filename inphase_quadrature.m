Generation of I/Q Signals and Estimation of
Transmitter-Receiver Frequency Discrepancy

clc;
clear;
close all;
rng(7);

%1. System Parameters

Fs = 1e6;                  % Sampling frequency (Hz)
N = 128;                   % Preamble length
numPayloadSymbols = 2000;  % Number of QPSK data symbols
SNR_dB = 25;               % Signal-to-noise ratio (dB)

fTx = 2.401e9;             % Transmitter carrier frequency (Hz)
fRx = 2.4009985e9;         % Receiver reference frequency (Hz)

deltaF = fTx - fRx;        % Actual frequency discrepancy (Hz)

fprintf('TRANSMITTER-RECEIVER FREQUENCY ANALYSIS\n');
fprintf('Sampling frequency       : %.2f MHz\n', Fs/1e6);
fprintf('Transmitter frequency    : %.6f GHz\n', fTx/1e9);
fprintf('Receiver reference       : %.6f GHz\n', fRx/1e9);
fprintf('Actual frequency offset  : %.2f Hz\n\n', deltaF);

%2. Generation of QPSK I/Q Symbols

Generate a known QPSK preamble
bitsI = randi([0 1], 1, N);
bitsQ = randi([0 1], 1, N);

preamble = ((2*bitsI-1) + 1j*(2*bitsQ-1))/sqrt(2);

Generate random QPSK payload symbols
dataI = randi([0 1], 1, numPayloadSymbols);
dataQ = randi([0 1], 1, numPayloadSymbols);

payload = ((2*dataI-1) + 1j*(2*dataQ-1))/sqrt(2);

Repeat the preamble twice for CFO estimation
tx = [preamble, preamble, payload];

In-phase and quadrature components
I_tx = real(tx);
Q_tx = imag(tx);

fprintf('Total transmitted samples: %d\n', length(tx));

%3. Channel Model: Frequency Offset and AWGN

n = 0:length(tx)-1;

Model the relative transmitter-receiver frequency offset
frequencyRotation = exp(1j*2*pi*deltaF*n/Fs);

Received signal before noise
rx_clean = tx .* frequencyRotation;

Add complex AWGN
signalPower = mean(abs(rx_clean).^2);
noisePower = signalPower / (10^(SNR_dB/10));

noise = sqrt(noisePower/2) .* ...
        (randn(size(tx)) + 1j*randn(size(tx)));

rx = rx_clean + noise;

I_rx = real(rx);
Q_rx = imag(rx);

%4. Frequency Offset Estimation

Extract the two received copies of the known preamble
r1 = rx(1:N);
r2 = rx(N+1:2*N);

Correlation between the repeated preambles
R = sum(conj(r1) .* r2);

Estimate the frequency discrepancy
deltaF_est = angle(R) * Fs / (2*pi*N);

Estimation error
frequencyError = deltaF_est - deltaF;

fprintf('\nFREQUENCY OFFSET ESTIMATION\n');
fprintf('Actual offset             : %.2f Hz\n', deltaF);
fprintf('Estimated offset          : %.2f Hz\n', deltaF_est);
fprintf('Estimation error          : %.2f Hz\n', frequencyError);
fprintf('Absolute error             : %.2f Hz\n', abs(frequencyError));

%5. Compensation of Frequency Offset

Remove the estimated frequency rotation
rx_corrected = rx .* exp(-1j*2*pi*deltaF_est*n/Fs);

I_corrected = real(rx_corrected);
Q_corrected = imag(rx_corrected);

%6. Plot the Transmitted and Received I/Q Signals

numPlot = min(250, length(tx));
sampleIndex = 0:numPlot-1;

figure('Name','I/Q Signal Generation');

subplot(2,1,1);
plot(sampleIndex, I_tx(1:numPlot), 'b', 'LineWidth', 1.1);
hold on;
plot(sampleIndex, Q_tx(1:numPlot), 'r', 'LineWidth', 1.1);
grid on;
xlabel('Sample Index');
ylabel('Amplitude');
title('Transmitted I/Q Signal');
legend('In-phase (I)','Quadrature (Q)');

subplot(2,1,2);
plot(sampleIndex, I_rx(1:numPlot), 'b', 'LineWidth', 1.1);
hold on;
plot(sampleIndex, Q_rx(1:numPlot), 'r', 'LineWidth', 1.1);
grid on;
xlabel('Sample Index');
ylabel('Amplitude');
title('Received I/Q Signal with Frequency Offset and AWGN');
legend('In-phase (I)','Quadrature (Q)');

%7. Constellation Before and After Compensation

payloadStart = 2*N + 1;
payloadRx = rx(payloadStart:end);
payloadCorrected = rx_corrected(payloadStart:end);

figure('Name','Frequency Offset Correction');

subplot(1,2,1);
plot(real(payloadRx), imag(payloadRx), '.', ...
     'MarkerSize', 7);
grid on;
axis equal;
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title('Before Frequency Correction');

subplot(1,2,2);
plot(real(payloadCorrected), imag(payloadCorrected), '.', ...
     'MarkerSize', 7);
grid on;
axis equal;
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title('After Frequency Correction');

%8. Frequency Offset Estimation Summary

fprintf('\nESTIMATION SUMMARY\n');
fprintf('SNR                      : %.1f dB\n', SNR_dB);
fprintf('Preamble length          : %d samples\n', N);
fprintf('Unambiguous offset range : +/- %.2f Hz\n', Fs/(2*N));
fprintf('Estimated discrepancy   : %.2f Hz\n', deltaF_est);
fprintf('Frequency error          : %.2f Hz\n', frequencyError);