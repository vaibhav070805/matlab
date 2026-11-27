clc;
clear all;
close all;

% --- 1. User Input ---
M = input('Enter the filter length (e.g., 21 or 31): ');
wc_norm = input('Enter the normalized cutoff frequency (0 to 1, e.g., 0.4): ');

% Convert normalized frequency (0 to 1) to radians (0 to pi)
wc = wc_norm * pi;

n = 0:M-1;
tau = (M-1)/2;

% --- 2. Ideal Impulse Response (Sinc Function) ---
% We use ./ for element-wise division and +eps to prevent 0/0
h_d = sin(wc * (n - tau)) ./ (pi * (n - tau) + eps);

% Handle the center point for Odd lengths using L'Hopital's Rule
if rem(M, 2) ~= 0
   h_d(tau + 1) = wc / pi;
end

% --- 3. Window Selection ---
disp('Choose Window Type:');
disp('1. Rectangular');
disp('2. Bartlett (Triangular)');
choice = input('Enter choice (1 or 2): ');

if choice == 1
    w = ones(1, M);
    win_name = 'Rectangular';
else
    % Manual Bartlett formula or built-in bartlett(M)
    w = 1 - (2 * abs(n - tau)) / (M - 1);
    win_name = 'Bartlett';
end

% --- 4. Final Filter Coefficients ---
h = h_d .* w;

% --- 5. Frequency Response (High Resolution) ---
N = 1024; % 1024-point FFT for smooth curves
H = fft(h, N);
mag = abs(H(1:N/2));           % Magnitude (first half)
phase = angle(H(1:N/2));       % Phase (first half)
f = linspace(0, 1, N/2);       % Normalized frequency scale (0 to 1)

% --- 6. Plotting ---
figure('Name', ['FIR LPF Design - ', win_name]);

subplot(2,1,1);
plot(f, mag, 'LineWidth', 1.5);
title(['Magnitude Response using ', win_name, ' Window']);
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude');
grid on;

subplot(2,1,2);
plot(f, phase, 'LineWidth', 1.5);
title('Phase Response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (radians)');
grid on;

% Display coefficients in command window
disp('Designed Filter Coefficients (h):');
disp(h);