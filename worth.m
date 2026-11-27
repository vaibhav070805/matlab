clc;
clear;
close all;

n = 4;

Wn_lp = 0.4;
Wn_hp = 0.4;
Wn_bp = [0.3 0.6];
Wn_bs = [0.3 0.6];

[b_lp, a_lp] = butter(n, Wn_lp, 'low');
[b_hp, a_hp] = butter(n, Wn_hp, 'high');
[b_bp, a_bp] = butter(n, Wn_bp, 'bandpass');
[b_bs, a_bs] = butter(n, Wn_bs, 'stop');

figure;
freqz(b_lp, a_lp); title('LPF');

figure;
freqz(b_hp, a_hp); title('HPF');

figure;
freqz(b_bp, a_bp); title('BPF');

figure;
freqz(b_bs, a_bs); title('BSF');