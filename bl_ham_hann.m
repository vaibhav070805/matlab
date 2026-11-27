clc;
clear;
close all;

%% Specifications
Fs = 8000;          % Sampling frequency (Hz)
N  = 50;            % Filter order

% Cutoff frequencies (normalized w.r.t Nyquist freq = Fs/2)
fc_lp = 1000/(Fs/2);
fc_hp = 1000/(Fs/2);
fc_bp = [1000 2000]/(Fs/2);
fc_bs = [1000 2000]/(Fs/2);

%% Windows
w_hamming = hamming(N+1);
w_hanning = hann(N+1);        % Hanning (Hann) window
w_blackman = blackman(N+1);

windows = {w_hamming, w_hanning, w_blackman};
w_names = {'Hamming', 'Hanning', 'Blackman'};

%% Loop over windows
for k = 1:length(windows)

    w = windows{k};

    % FIR filter design
    b_lp = fir1(N, fc_lp, 'low',  w);
    b_hp = fir1(N, fc_hp, 'high', w);
    b_bp = fir1(N, fc_bp, 'bandpass', w);
    b_bs = fir1(N, fc_bs, 'stop', w);

    % Frequency responses
    [H_lp, f] = freqz(b_lp,1,1024,Fs);
    [H_hp, ~] = freqz(b_hp,1,1024,Fs);
    [H_bp, ~] = freqz(b_bp,1,1024,Fs);
    [H_bs, ~] = freqz(b_bs,1,1024,Fs);

    %% Plot magnitude responses
    figure('Name',['Magnitude Response - ' w_names{k}]);

    subplot(2,2,1)
    plot(f, abs(H_lp)), grid on
    title(['LPF - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('|H(f)|')

    subplot(2,2,2)
    plot(f, abs(H_hp)), grid on
    title(['HPF - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('|H(f)|')

    subplot(2,2,3)
    plot(f, abs(H_bp)), grid on
    title(['BPF - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('|H(f)|')

    subplot(2,2,4)
    plot(f, abs(H_bs)), grid on
    title(['BSF - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('|H(f)|')

    %% Plot phase responses
    figure('Name',['Phase Response - ' w_names{k}]);

    subplot(2,2,1)
    plot(f, unwrap(angle(H_lp))), grid on
    title(['LPF Phase - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('Phase (rad)')

    subplot(2,2,2)
    plot(f, unwrap(angle(H_hp))), grid on
    title(['HPF Phase - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('Phase (rad)')

    subplot(2,2,3)
    plot(f, unwrap(angle(H_bp))), grid on
    title(['BPF Phase - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('Phase (rad)')

    subplot(2,2,4)
    plot(f, unwrap(angle(H_bs))), grid on
    title(['BSF Phase - ' w_names{k}])
    xlabel('Frequency (Hz)'), ylabel('Phase (rad)')

end