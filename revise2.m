clc;
close all;
clear all;
x_n=input("Enter x_n");
N=length(x_n);
X_k=my_fft(x_n);
subplot(2,1,1)
stem(0:N-1,abs(X_k),"filled");
grid on;
subplot(2,1,2)
stem(0:N-1,angle(X_k),"filled");
grid on;
function X = my_fft(x)
    N = length(x);
    
    % Base Case: If length is 1, DFT is just the point itself
    if N == 1
        X = x;
        return;
    end
    
    % Split into Even and Odd
    x_even = x(1:2:end); 
    x_odd  = x(2:2:end);
    
    % Recursive Calls
    E = my_fft(x_even);
    O = my_fft(x_odd);
    
    % Combine using the Butterfly logic
    X = zeros(1, N);
    W_N = exp(-2j * pi * (0:N/2-1) / N); % Twiddle factors
    
    % Danielson-Lanczos combination
    X(1:N/2)     = E + W_N .* O;
    X(N/2+1:end) = E - W_N .* O;
end
