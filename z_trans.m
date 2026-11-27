clc;
clear;
close all;

% Define symbolic variable
syms n z

% Define the discrete exponential signal x[n] = 3^n * u[n]
a = 3;
x = a^n;

% Compute Z-transform
X = ztrans(x, n, z);
disp('Z-transform of x[n] = 3^n u[n] is:')
pretty(X)

% Convert symbolic to transfer function form
[num, den] = numden(X);
num = sym2poly(num);
den = sym2poly(den);
 

% Create transfer function representation
sys = tf(num, den, -1, 'variable', 'z^-1');

% Plot pole-zero diagram
figure;
pzmap(sys);
title('Pole-Zero Plot of x[n] = 3^n u[n]');
grid on;

% Annotate the poles and zeros
zplane(num, den);
title('Pole-Zero Plot using zplane()');
grid on;
