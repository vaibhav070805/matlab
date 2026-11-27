clc;
clear;
close all;

%% Specifications
Fs = 8000;              % Sampling frequency
fc = 1000;              % Cutoff frequency (Hz)
N  = 50;                % Filter order
M  = N + 1;             % Number of points

%% Normalized cutoff (relative to Nyquist)
fc_norm = fc / (Fs/2);

%% Ideal LPF impulse response (sinc)
n = 0:N;
alpha = N/2;
h_lp_ideal = fc_norm * sinc(fc_norm*(n - alpha));

%% Window functions
w_ham   = 0.54 - 0.46*cos(2*pi*n/N);
w_han   = 0.5*(1 - cos(2*pi*n/N));
w_black = 0.42 - 0.5*cos(2*pi*n/N) + 0.08*cos(4*pi*n/N);

%% Apply windows
h_ham   = h_lp_ideal .* w_ham;
h_han   = h_lp_ideal .* w_han;
h_black = h_lp_ideal .* w_black;

%% Frequency responses (zero-padded FFT for smoothness)
L = 1024;
H_ham   = fft(h_ham, L);
H_han   = fft(h_han, L);
H_black = fft(h_black, L);

f = linspace(0, Fs/2, L/2); % Frequency axis (Hz)

%% Plot magnitude responses
figure;
subplot(3,1,1);
plot(f, abs(H_black(1:L/2)));
title('LPF with Blackman Window');
xlabel('Frequency (Hz)'); ylabel('|H(f)|'); grid on;

subplot(3,1,2);
plot(f, abs(H_ham(1:L/2)));
title('LPF with Hamming Window');
xlabel('Frequency (Hz)'); ylabel('|H(f)|'); grid on;

subplot(3,1,3);
plot(f, abs(H_han(1:L/2)));
title('LPF with Hanning Window');
xlabel('Frequency (Hz)'); ylabel('|H(f)|'); grid on;