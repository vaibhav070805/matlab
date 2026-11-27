% Passband BPSK Simulation in AWGN with Tx & Rx Spectra
clc; clear; close all;

%% Parameters
N = 10^4;             % Number of bits
EbN0_dB = 0:2:10;     % Eb/N0 range in dB
EbN0_lin = 10.^(EbN0_dB/10); 

% Passband parameters
fc = 1000;            % Carrier frequency (Hz)
fs = 10000;           % Sampling frequency (Hz)
Tb = 0.01;            % Bit duration (seconds)
t = 0:1/fs:Tb-1/fs;   % Time vector for one bit
samples_per_bit = length(t);
carrier = sqrt(2/Tb) * cos(2*pi*fc*t); 

% Generate random binary data
data = randi([0 1], 1, N);

%% Modulation
tx_passband = zeros(1, N * samples_per_bit);
for i = 1:N
    if data(i) == 1
        tx_passband((i-1)*samples_per_bit + 1 : i*samples_per_bit) = carrier;
    else
        tx_passband((i-1)*samples_per_bit + 1 : i*samples_per_bit) = -carrier;
    end
end

%% BER Calculation Loop
ber_sim = zeros(1, length(EbN0_dB));
for idx = 1:length(EbN0_dB)
    N0 = 1 / EbN0_lin(idx);
    noise_sigma = sqrt(N0 * fs / 2); 
    
    % Add AWGN
    noise = noise_sigma * randn(1, length(tx_passband));
    rx_passband = tx_passband + noise;
    
    % Coherent Demodulation
    rx_data = zeros(1, N);
    for i = 1:N
        rx_bit_period = rx_passband((i-1)*samples_per_bit + 1 : i*samples_per_bit);
        correlator_output = sum(rx_bit_period .* carrier) * (1/fs);
        rx_data(i) = correlator_output > 0;
    end
    
    % Calculate Errors
    ber_sim(idx) = sum(data ~= rx_data) / N;
end

%% Theoretical BER for BPSK
ber_theory = 0.5 * erfc(sqrt(EbN0_lin));

%% Visualization: Time and Frequency Domains (at Eb/N0 = 5 dB)
plot_EbN0 = 5;
plot_N0 = 1 / 10^(plot_EbN0/10);
plot_sigma = sqrt(plot_N0 * fs / 2);
rx_plot_passband = tx_passband + plot_sigma * randn(1, length(tx_passband));

figure('Name', 'Passband BPSK Analysis', 'NumberTitle', 'off', 'Position', [150 50 1000 1000]);

% 1. Transmitted Time Domain Plot
subplot(5,1,1);
time_axis = (0:(5*samples_per_bit - 1)) / fs;
plot(time_axis, tx_passband(1:5*samples_per_bit), 'b', 'LineWidth', 1.5);
title('Transmitted Passband Signal (Ideal)');
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-20 20]);

% 2. Received Time Domain Plot
subplot(5,1,2);
plot(time_axis, rx_plot_passband(1:5*samples_per_bit), 'r', 'LineWidth', 1);
title(['Received Passband Signal (Noisy) at E_b/N_0 = ' num2str(plot_EbN0) ' dB']);
xlabel('Time (s)'); ylabel('Amplitude');
grid on; ylim([-40 40]);

% 3. Transmitted Frequency Domain (FFT)
subplot(5,1,3);
L = length(tx_passband);
tx_fft_passband = fftshift(fft(tx_passband));
f_axis_passband = fs/2 * linspace(-1, 1, L);
plot(f_axis_passband, 10*log10(abs(tx_fft_passband).^2/L), 'b');
title('Frequency Domain (Power Spectrum) of Transmitted Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
xlim([-2500 2500]); 
grid on;

% 4. Received Frequency Domain (FFT)
subplot(5,1,4);
rx_fft_passband = fftshift(fft(rx_plot_passband));
plot(f_axis_passband, 10*log10(abs(rx_fft_passband).^2/L), 'k');
title('Frequency Domain (Power Spectrum) of Received Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude (dB)');
xlim([-2500 2500]); 
grid on;

% 5. BER Plot
subplot(5,1,5);
semilogy(EbN0_dB, ber_theory, 'b-', 'LineWidth', 2); hold on;
semilogy(EbN0_dB, ber_sim, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
title('BER vs E_b/N_0 for Passband BPSK in AWGN');
xlabel('E_b/N_0 (dB)'); ylabel('Bit Error Rate (BER)');
legend('Theoretical', 'Simulated');
grid on; axis([0 10 1e-5 1]);