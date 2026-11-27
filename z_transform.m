clc;
clear;
close all;

% Define symbolic variable
syms n z

% Define the discrete exponential signal x[n] = a^n * u[n]
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

% Annotate the poles and zeros using zplane
figure;
zplane(num, den);
title('Pole-Zero Plot using zplane()');
grid on;

% --- Causality Checking Section ---
poles = roots(den);
zeros_ = roots(num);

fprintf('\nPoles:\n');
disp(poles);
fprintf('Zeros:\n');
disp(zeros_);

% Compute ROC based on given sequence
if abs(a) < 1
    roc = sprintf('|z| > %.2f', abs(a));  % causal ROC
    causality = 'Causal (ROC is outside the outermost pole)';
elseif abs(a) > 1
    roc = sprintf('|z| < %.2f', abs(a));  % anti-causal ROC
    causality = 'Anti-Causal (ROC is inside the innermost pole)';
else
    roc = '|z| ≠ 1';
    causality = 'Two-sided (neither causal nor anti-causal)';
end

% Display results
fprintf('\n--- Causality Check ---\n');
fprintf('Region of Convergence (ROC): %s\n', roc);
fprintf('System type: %s\n', causality);

% --- Stability Check ---
if abs(a) < 1
    fprintf('System is stable (ROC includes the unit circle).\n');
else
    fprintf('System is unstable (ROC does not include the unit circle).\n');
end
