function compare_convolution_times()
    clc; clear; close all;
    
    % --- SETUP ---
    % We test lengths from 10 to 1,000,000 (powers of 10)
    N_values = round(logspace(1, 6, 20)); 
    t_builtin = zeros(size(N_values));
    t_fft     = zeros(size(N_values));
    
    fprintf('Running Time Comparison...\n');
    fprintf('%-10s | %-15s | %-15s\n', 'N', 'Built-in (sec)', 'FFT-based (sec)');
    fprintf('%s\n', repmat('-', 1, 45));

    for k = 1:length(N_values)
        N = N_values(k);
        x = randn(N, 1);
        h = randn(N, 1);
        
        % 1. Measure Built-in conv()
        % We use @() to create a function handle for timeit
        func1 = @() conv(x, h); 
        t_builtin(k) = timeit(func1);
        
        % 2. Measure Custom FFT method
        % We force FFT even for small N to see the penalty
        func2 = @() fft_conv_forced(x, h);
        t_fft(k) = timeit(func2);
        
        fprintf('%-10d | %-15.6f | %-15.6f\n', N, t_builtin(k), t_fft(k));
    end
    
    % --- PLOTTING ---
    figure('Color', 'w');
    loglog(N_values, t_builtin, '-o', 'LineWidth', 2, 'DisplayName', 'Built-in conv()');
    hold on;
    loglog(N_values, t_fft, '-s', 'LineWidth', 2, 'DisplayName', 'Forced FFT Conv');
    
    grid on;
    xlabel('Signal Length (N)');
    ylabel('Execution Time (seconds)');
    title('Time Comparison: Adaptive (Built-in) vs. Forced FFT');
    legend('Location', 'northwest');
    
    % Add text to explain the graph
    text(20, 1e-4, '\leftarrow Direct Convolution is faster here', 'FontSize', 10);
    text(1e5, 1e-1, 'FFT methods converge \rightarrow', 'FontSize', 10, 'HorizontalAlignment', 'right');
end

% --- HELPER FUNCTION ---
function y = fft_conv_forced(x, h)
    L = length(x) + length(h) - 1;
    Nfft = 2^nextpow2(L); % Power of 2 is critical for speed
    X = fft(x, Nfft);
    H = fft(h, Nfft);
    y = ifft(X .* H, 'symmetric');
    y = y(1:L);
end