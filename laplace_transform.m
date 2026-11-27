% Experiment No. 07: Laplace Transform and Colored ROC Visualization
clc; clear; close all;

syms t s w

% Define signal
x = exp(-2*t) * heaviside(t);

% Laplace Transform
X = laplace(x, t, s);
disp('Laplace Transform of x(t):');
pretty(X)

% Simplify
X_simplified = simplify(X)

% === PZ MAP ===
[num, den] = numden(X_simplified);
num = sym2poly(num);
den = sym2poly(den);
sys = tf(num, den);

figure;
pzmap(sys)
title('Pole-Zero Plot of X(s)');
grid on;

% === ROC Visualization ===
figure;
hold on;
title('Region of Convergence (ROC) in s-plane');
xlabel('Re(s)'); ylabel('Im(s)');
xlim([-6 4]); ylim([-10 10]);
grid on;

% Draw pole
plot(-2, 0, 'rx', 'MarkerSize', 12, 'LineWidth', 2);
text(-2.3, 0.5, 'Pole at s = -2', 'Color', 'r');

% Create ROC region (Re(s) > -2)
x = linspace(-6, 4, 300);
y = linspace(-10, 10, 300);
[Re, Im] = meshgrid(x, y);
mask = Re > -2; % ROC condition

% Display ROC as a colored transparent patch
imagesc(x, y, mask);
colormap([1 0.8 0.8; 0.7 1 0.7]); % red for excluded, green for ROC
alpha(0.3);
set(gca,'YDir','normal');

% Draw line for pole boundary
plot([-2 -2], ylim, 'r--', 'LineWidth', 2);
text(-1.8, 9, 'ROC: Re(s) > -2', 'Color', 'g', 'FontWeight', 'bold');

hold off;

% === Convergence to Fourier Transform ===
Xjw = subs(X_simplified, s, 1i*w);
disp('Fourier Transform (X(jω)) = ');
pretty(simplify(Xjw))

% === Magnitude and Phase Plots ===
w_vals = -10:0.1:10;
Xjw_vals = double(subs(Xjw, w, w_vals));

figure;
subplot(2,1,1);
plot(w_vals, abs(Xjw_vals), 'LineWidth', 1.8);
xlabel('\omega (rad/s)'); ylabel('|X(j\omega)|');
title('Magnitude Spectrum');
grid on;

subplot(2,1,2);
plot(w_vals, angle(Xjw_vals), 'LineWidth', 1.8);
xlabel('\omega (rad/s)'); ylabel('∠X(j\omega)');
title('Phase Spectrum');
grid on;