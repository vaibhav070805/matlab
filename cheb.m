clc;
clear;
close all;

n = 4;          % Filter order
Rp = 1;         % Passband ripple (dB)

Wn_lp = 0.4;
Wn_hp = 0.4;
Wn_bp = [0.3 0.6];
Wn_bs = [0.3 0.6];

% Design filters
[b_lp, a_lp] = cheby1(n, Rp, Wn_lp, 'low');
[b_hp, a_hp] = cheby1(n, Rp, Wn_hp, 'high');
[b_bp, a_bp] = cheby1(n, Rp, Wn_bp, 'bandpass');
[b_bs, a_bs] = cheby1(n, Rp, Wn_bs, 'stop');

% ---- LOOP FOR PLOTTING ----
filters = {b_lp,a_lp; b_hp,a_hp; b_bp,a_bp; b_bs,a_bs};
names = {'LPF','HPF','BPF','BSF'};

for i = 1:4
    [h,w] = freqz(filters{i,1}, filters{i,2}, 1024);

    figure;

    subplot(2,1,1);
    plot(w/pi, abs(h), 'LineWidth',1.5);
    title(['Chebyshev Type I - ' names{i} ' Magnitude']);
    xlabel('Normalized Frequency');
    ylabel('|H(w)|');
    grid on;

    subplot(2,1,2);
    plot(w/pi, angle(h), 'LineWidth',1.5);
    title(['Chebyshev Type I - ' names{i} ' Phase']);
    xlabel('Normalized Frequency');
    ylabel('Phase (radians)');
    grid on;
end