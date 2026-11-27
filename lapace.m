% Experiment 07: Laplace Transform, Pole-Zero Plot, Fourier relation
clc; clear; close all;

syms t s w a
a = 2;   % decay constant > 0

% Define the signal
x = exp(-a*t) * heaviside(t);

% Laplace Transform
X_s = laplace(x, t, s);
disp('Laplace Transform X(s) = ');
disp(X_s);

% Poles and Zeros
[num, den] = numden(X_s);         % get numerator and denominator
poles = solve(den==0, s);         % poles
zeros = solve(num==0, s);         % zeros
disp('Poles:'); disp(poles);
disp('Zeros:'); disp(zeros);

% Pole-Zero plot
pzmap(tf(sym2poly(num), sym2poly(den)));
title('Pole-Zero Plot of X(s)');

% Verify Laplace -> Fourier (s = jω)
X_jw = subs(X_s, s, 1i*w);
disp('Fourier Transform X(jω) = ');
disp(X_jw);

% Plot Fourier Magnitude
w_vals = -20:0.1:20;
Xjw_vals = double(subs(X_jw, w, w_vals));
figure;
plot(w_vals, abs(Xjw_vals), 'LineWidth', 1.5);
grid on;
xlabel('\omega (rad/s)');
ylabel('|X(j\omega)|');
title('Magnitude Spectrum from Fourier Transform');