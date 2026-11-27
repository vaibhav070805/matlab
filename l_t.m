% Experiment No. 07: Laplace Transform and Pole-Zero Plot
clc; clear; close all;

syms t s w

% Define signal

x = exp(-t) *heaviside(t) ;

% Laplace Transform
X = laplace(x, t, s);
disp('Laplace Transform of x(t) = ');
pretty(X)

% Simplify
X_simplified = simplify(X)

% Pole-Zero plot
[num, den] = numden(X_simplified);     % Extract numerator & denominator
num = sym2poly(num);
den = sym2poly(den);
figure;
pzmap(tf(num, den));
grid on;

title('Pole-Zero Plot of X(s)');

% Check convergence to Fourier Transform
Xjw = subs(X, s, 1i*w);
disp('Fourier Transform (Laplace evaluated on jω axis) = ');
pretty(simplify(Xjw))

% Plot Magnitude and Phase Spectrum
w_vals = -10:0.1:10;
Xjw_vals = double(subs(Xjw, w, w_vals));

figure;
subplot(2,1,1);
plot(w_vals, abs(Xjw_vals));
xlabel('ω (rad/s)');
ylabel('|X(jω)|');
title('Magnitude Spectrum');

subplot(2,1,2);
plot(w_vals, angle(Xjw_vals));
xlabel('ω (rad/s)');
ylabel('∠X(jω)');
title('Phase Spectrum');