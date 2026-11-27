% Baseband BPSK Simulation in AWGN with Tx & Rx Spectra
clc; clear; close all;

%% Parameters
N = 100;             % Number of bits
EbN0_dB = 0:2:10;     % Eb/N0 range in dB
EbN0_lin = 10.^(EbN0_dB/10); 

% Generate random binary data
data = randi([0 1], 1, N);

% Baseband Modulation (BPSK: 0 -> -1, 1 -> 1)
tx_signal = 2*data - 1; 

%% BER Calculation Loop
ber_sim = zeros(1, length(EbN0_dB));
for i = 1:length(EbN0_dB)
    % Calculate noise variance (N0/2) for baseband
    noise_sigma = sqrt(1 / (2 * EbN0_lin(i)));
    
    % Add AWGN
    noise = noise_sigma * randn(1, N);
    rx_signal = tx_signal + noise;
    
    % Receiver / Decision Making
    rx_data = rx_signal > 0;
    
    % Calculate Errors
    errors = sum(data ~= rx_data);
    ber_sim(i) = errors / N;
end

%% Theoretical BER for BPSK
ber_theory = 0.5 * erfc(sqrt(EbN0_lin));

%% Visualization: Time and Frequency Domains (at Eb/N0 = 5 dB)
plot_EbN0 = 5;
plot_sigma = sqrt(1 / (2 * 10^(plot_EbN0/10)));
rx_plot_signal = tx_signal + plot_sigma * randn(1, N);

figure('Name', 'Baseband BPSK Analysis', 'NumberTitle', 'off', 'Position', [100 50 1000 1000]);

% 1. Transmitted Time Domain Plot
subplot(5,1,1);
stairs(1:50, tx_signal(1:50), 'b', 'LineWidth', 1.5);
title('Transmitted Baseband Signal (Ideal)');
xlabel('Bit Index'); ylabel('Amplitude');
grid on; ylim([-2 2]);

% 2. Received Time Domain Plot
subplot(5,1,2);
plot(1:50, rx_plot_signal(1:50), 'r.-', 'MarkerSize', 10, 'LineWidth', 1);
title(['Received Baseband Signal (Noisy) at E_b/N_0 = ' num2str(plot_EbN0) ' dB']);
xlabel('Bit Index'); ylabel('Amplitude');
grid on; ylim([-3 3]);

% 3. Transmitted Frequency Domain (FFT)
subplot(5,1,3);
N_fft = 2048; 
f_axis = linspace(-0.5, 0.5, N_fft);
tx_fft = fftshift(fft(tx_signal, N_fft));
plot(f_axis, 10*log10(abs(tx_fft).^2/N_fft), 'b');
title('Frequency Domain (Power Spectrum) of Transmitted Signal');
xlabel('Normalized Frequency (\times \pi rad/sample)'); ylabel('Magnitude (dB)');
grid on;

% 4. Received Frequency Domain (FFT)
subplot(5,1,4);
rx_fft = fftshift(fft(rx_plot_signal, N_fft));
plot(f_axis, 10*log10(abs(rx_fft).^2/N_fft), 'k');
title('Frequency Domain (Power Spectrum) of Received Signal');
xlabel('Normalized Frequency (\times \pi rad/sample)'); ylabel('Magnitude (dB)');
grid on;

% 5. BER Plot
subplot(5,1,5);
semilogy(EbN0_dB, ber_theory, 'b-', 'LineWidth', 2); hold on;
semilogy(EbN0_dB, ber_sim, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
title('BER vs E_b/N_0 for Baseband BPSK in AWGN');
xlabel('E_b/N_0 (dB)'); ylabel('Bit Error Rate (BER)');
legend('Theoretical', 'Simulated');
grid on; axis([0 10 1e-5 1]);