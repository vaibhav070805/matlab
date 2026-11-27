
% EXPERIMENT 7: LAPLACE TRANSFORM, POLE-ZERO PLOT, AND STABILITY ANALYSIS

% Clear workspace, command window, and close all figures for a clean run
clear;
clc;
close all;

%% 1. Define the Signal and Find its Laplace Transform Symbolically
% We use the Symbolic Math Toolbox to work with mathematical expressions.
syms t s; % Define symbolic variables for time 't' and Laplace variable 's'

% Define the continuous-time signal: x(t) = exp(-3t)u(t)
% heaviside(t) is the MATLAB function for the unit step function u(t).
xt = exp(-3*t) * heaviside(t);

% Calculate the Laplace Transform of x(t)
Xs = laplace(xt, t, s);

% Display the results in a readable format
fprintf('The signal is x(t) = exp(-3*t)u(t)\n');
fprintf('The calculated Laplace Transform is X(s) = \n');
pretty(Xs); % 'pretty' prints the symbolic expression in a more readable way


%% 2. Generate the Pole-Zero Plot and Analyze the System
fprintf('\n--- System Analysis from Pole-Zero Plot ---\n');

% To create a pole-zero plot, we define a transfer function model.
% For our result X(s) = 1 / (s + 3):
% The numerator polynomial coefficients are: [1]
% The denominator polynomial coefficients are: [1, 3]
num = [1];
den = [1, 3];

% Create a transfer function object
sys = tf(num, den);
disp(sys);
% Generate and display the pole-zero plot
figure;
pzmap(sys);
title('Pole-Zero Plot of X(s) = 1/(s+3)');
grid on;

% Programmatically analyze stability based on pole locations
poles = pole(sys); % Get the poles of the system
fprintf('Pole is located at s = %f\n', poles);

% Check if all poles are in the left-half of the s-plane (real part < 0)
if all(real(poles) < 0)
    disp('Stability: The system is STABLE because all poles are in the Left-Half Plane.');
    disp('The Region of Convergence (ROC), Re{s} > -3, includes the jw-axis.');
else
    disp('Stability: The system is UNSTABLE because at least one pole is not in the Left-Half Plane.');
end

disp('Causality: The signal is causal, and its ROC is a right-half plane, which is consistent.');


%% 3. Show Convergence to Fourier Transform
fprintf('\n--- Convergence to Fourier Transform ---\n');

syms w; % Define a symbolic variable for frequency 'omega'

% The Fourier Transform is found by substituting s = jw into the Laplace Transform X(s)
% This is only valid if the jw-axis is within the ROC. In our case, it is.
Xjw = subs(Xs, s, 1i*w); % Use 1i for the imaginary unit 'j' in MATLAB

fprintf('By substituting s = jw, the Fourier Transform is X(jw) = \n');
pretty(Xjw);

% Plot the frequency response (Magnitude and Phase)
figure;
% Subplot 1: Magnitude Response
subplot(2,1,1);
fplot(abs(Xjw), [-15, 15]); % Plot the magnitude of X(jw) from w = -15 to 15
title('Magnitude Response |X(j\omega)|');
xlabel('Frequency (\omega) [rad/s]');
ylabel('Magnitude');
grid on;

% Subplot 2: Phase Response
subplot(2,1,2);
fplot(angle(Xjw), [-15, 15]); % Plot the phase angle of X(jw)
title('Phase Response \angleX(j\omega)');
xlabel('Frequency (\omega) [rad/s]');
ylabel('Phase (radians)');
grid on;