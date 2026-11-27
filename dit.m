clc;
close all;
clear all;
% Example input sequence
x = [1 2 3 4 5 6 7 8];

% Compute FFT using custom function
X_DIT= myFFT_recursive(x)

% Compare with MATLAB built-in FFT
X_builtin = fft(x);

disp('Custom FFT result:');
disp(X_DIT);

disp('MATLAB FFT result:');
disp(X_builtin);
function X = myFFT_recursive(x)
    % myFFT_recursive - Recursive Radix-2 DIT FFT
    % Input:  x - input sequence (length must be a power of 2)
    % Output: X - FFT of the input sequence
    
    N = length(x);  % Length of input sequence
    
    % --- Base case: FFT of length 1 is itself ---
    if N == 1
        X = x;
        return;
    end
    
    % --- Step 1: Split into even and odd indexed parts ---
    x_even = x(1:2:end);  % Elements at even indices
    x_odd  = x(2:2:end);  % Elements at odd indices
    
    % --- Step 2: Recursively compute FFT of each half ---
    X_even = myFFT_recursive(x_even);
    X_odd  = myFFT_recursive(x_odd);
    
    % --- Step 3: Compute twiddle factors ---
    k = 0:(N/2 - 1);
    W_N = exp(-2*pi*1i*k/N);  % Twiddle factors
    
    % --- Step 4: Combine results using butterfly ---
    X_top    = X_even + W_N .* X_odd;
    X_bottom = X_even - W_N .* X_odd;
    
    % --- Step 5: Concatenate results ---
    X = [X_top, X_bottom];
end