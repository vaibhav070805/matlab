% MATLAB/Octave code for a periodic square wave
fs = 1000; % Sampling frequency
T = 2;     % Period of the signal
t = 0:1/fs:T-1/fs; % Time vector for one period

% Generate one period of the square wave
x = square(2*pi*(1/T)*t);

% Compute the FFT
X = fft(x);

% Calculate the spectral components (coefficients)
N = length(x);
c = fftshift(X)/N; % fftshift centers the zero-frequency component

% Frequency axis for plotting
f = (-N/2:N/2-1)*(fs/N);

% Plotting the Magnitude Spectrum
subplot(2,1,1);
stem(f, abs(c), 'filled');
title('Magnitude Spectrum of a Periodic Square Wave');
xlabel('Frequency (Hz)');
ylabel('|c_n|');
xlim([-6 ,6]); % Limit x-axis to view first few harmonics
grid on;

% Plotting the Phase Spectrum
subplot(2,1,2);
stem(f, angle(c)*180/pi, 'filled');
title('Phase Spectrum of a Periodic Square Wave');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
xlim([-10 10]);
grid on;