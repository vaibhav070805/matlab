% Sampling parameters
clc;
close all;
clear all;

Fs = 100;                  % Sampling frequency (Hz)
T = 1/Fs;                   % Sampling period
t = 0:T:0.1;                % Time vector (0 to 0.1 sec)
n = 0:length(t)-1;          % Discrete-time indices

% Original continuous-time signal sampled
x = sin(2*pi*60*t) + sin(2*pi*100*t);   % x(t) sampled

% Frequency range for DTFT
omega = linspace(-pi, pi, 100);       % Normalized frequency
X = zeros(size(omega));                % DTFT values

% Compute DTFT
for k = 1:length(omega)
    X(k) = sum(x .* exp(-1j * omega(k) * n));
end
f=(omega*Fs)/2*pi;
% Inverse DTFT approximation
x_recon = zeros(size(n));
d_omega = omega(2) - omega(1);

for i = 1:length(n)
    x_recon(i) = (1/(2*pi))*sum(X .* exp(1j * omega * n(i)) * d_omega);
end

% Plot all in one figure
figure;

% Original signal
subplot(3,1,1);
stem(t, x, 'LineWidth', 2.5);
title('Original Signal: sin(2π·60t) + sin(2π·100t)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Magnitude of DTFT
subplot(3,1,2);
plot(omega, abs(X), 'LineWidth', 1.5);
title('Magnitude of DTFT')
xlabel('\omega (rad/sample)');
ylabel('|X(\omega)|');
grid on;

% Original vs Reconstructed Signal
subplot(3,1,3);
stem(n, x, 'filled', 'DisplayName', 'Original');
hold on;
stem(n, real(x_recon), 'r', 'DisplayName', 'Reconstructed');
title('Original vs Reconstructed Signal via Inverse DTFT');
xlabel('n (sample index)');
ylabel('Amplitude');
legend;
grid on;