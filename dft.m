clc; clear all; close all;

% Example input sequence
x = [1,2,3,4,5,6,7,8,9,10];   % You can change this
N1 = length(x);   % Case 2: N = length(x)
N2 = N1 + 4;      % Case 3: N > length(x)
N3 = N1 - 4;      % Case 1: N < length(x)

% --- Compute DFTs ---
% Case 1: N < length(x)
X1 = zeros(1, N3);
for k = 0:N3-1
    sum_val = 0;
    for n = 0:N3-1
        sum_val = sum_val + x(n+1) * exp(-1j * 2 * pi * k * n / N3);
    end
    X1(k+1) = sum_val;
end

% Case 2: N = length(x)
X2 = zeros(1, N1);
for k = 0:N1-1
    sum_val = 0;
    for n = 0:N1-1
        sum_val = sum_val + x(n+1) * exp(-1j * 2 * pi * k * n / N1);
    end
    X2(k+1) = sum_val;
end

% Case 3: N > length(x) (zero-padding)
X3 = zeros(1, N2);
for k = 0:N2-1
    sum_val = 0;
    for n = 0:N1-1   % only up to length(x)
        sum_val = sum_val + x(n+1) * exp(-1j * 2 * pi * k * n / N2);
    end
    X3(k+1) = sum_val;
end

% --- Normalize lengths for fair comparison ---
% Interpolate/resize each spectrum to N1 points
X1_resized = interp1(0:N3-1, abs(X1), linspace(0, N3-1, N1), 'linear', 0);
X2_resized = abs(X2); % already N1 points
X3_resized = interp1(0:N2-1, abs(X3), linspace(0, N2-1, N1), 'linear', 0);

% --- Plot results ---
figure;

subplot(4,1,1);
stem(0:N1-1, x, 'o-', 'LineWidth', 1.5);
title('Original Signal');
xlabel('n'); ylabel('x[n]'); grid on;

subplot(4,1,2);
stem(0:N1-1, X1_resized, 'o-', 'LineWidth', 1.5);
title(['DFT Magnitude (N = ' num2str(N3) ', resized to ' num2str(N1) ')']);
xlabel('k'); ylabel('|X1[k]|'); grid on;

subplot(4,1,3);
stem(0:N1-1, X2_resized, 'o-', 'LineWidth', 1.5);
title(['DFT Magnitude (N = ' num2str(N1) ', exact length)']);
xlabel('k'); ylabel('|X2[k]|'); grid on;

subplot(4,1,4);
stem(0:N1-1, X3_resized, 'o-', 'LineWidth', 1.5);
title(['DFT Magnitude (N = ' num2str(N2) ', resized to ' num2str(N1) ')']);
xlabel('k'); ylabel('|X3[k]|'); grid on;