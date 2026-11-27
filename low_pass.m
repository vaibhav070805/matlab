%% LPF Impulse Response Comparison
% 1. Ideal LPF impulse response
% 2. Rectangular-windowed LPF
% 3. Bartlett-windowed LPF

clc; clear; close all;

%% Parameters
N  = 51;             % Filter length (odd preferred)
n  = 0:N-1;          % Sample index
alpha = (N-1)/2;     % Midpoint
wc = 0.3*pi;         % Cutoff frequency (normalized radian)

%% Step 1: Ideal LPF impulse response (sinc)
h_ideal = sin(wc*(n-alpha))./(pi*(n-alpha));
h_ideal(alpha+1) = wc/pi;   % fix division by zero

%% Step 2: Windows
w_rect = ones(1,N);          % Rectangular window
w_bart = bartlett(N)';       % Bartlett window

%% Step 3: Windowed Filters
h_rect = h_ideal .* w_rect;
h_bart = h_ideal .* w_bart;

%% Step 4: Visualization (Three Separate Plots)

% 1. Ideal LPF impulse response
subplot(3,1,1);
stem(n,h_ideal,'k','filled'); grid on;
title('Ideal LPF Impulse Response');
xlabel('n'); ylabel('h[n]');

% 2. Rectangular-windowed LPF impulse response
subplot(3,1,2);
stem(n,h_rect,'b','filled'); grid on;
title('LPF Impulse Response with Rectangular Window');
xlabel('n'); ylabel('h[n]');

% 3. Bartlett-windowed LPF impulse response
subplot(3,1,3);
stem(n,h_bart,'r','filled'); grid on;
title('LPF Impulse Response with Bartlett Window');
xlabel('n'); ylabel('h[n]');