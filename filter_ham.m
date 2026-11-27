clc;
clear;
close all;

%% Input frequency-domain sequence X[k]
X = [3 1+2*1j -1+1*1j 1-2*1j ];      % You can change this

N = length(X);      % Number of points
n = 0:N-1;          % Time index
k = 0:N-1;          % Frequency index

x = zeros(1,N);     % Output time-domain sequence

%% IDFT Calculation
for ni = 1:N
    for ki = 1:N
        x(ni) = x(ni) + X(ki)*exp(1j*2*pi*(ki-1)*(ni-1)/N);
    end
end

x = x/N;            % Scaling factor

disp('IDFT Result x[n] = ');
disp(x);
