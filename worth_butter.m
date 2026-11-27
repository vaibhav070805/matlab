clc;
clear;
close all;

% Filter Order
n = 4;

% Normalized cutoff frequencies (0 to 1)
Wn_lp = 0.4;        % Low Pass
Wn_hp = 0.4;        % High Pass
Wn_bp = [0.3 0.6];  % Band Pass
Wn_bs = [0.3 0.6];  % Band Stop

% Design Butterworth Filters
[b_lp, a_lp] = butter(n, Wn_lp, 'low');
[b_hp, a_hp] = butter(n, Wn_hp, 'high');
[b_bp, a_bp] = butter(n, Wn_bp, 'bandpass');
[b_bs, a_bs] = butter(n, Wn_bs, 'stop');

%% -------- LOW PASS --------
[h,w] = freqz(b_lp, a_lp, 1024);

figure;
subplot(2,1,1);
plot(w/pi, abs(h), 'LineWidth', 1.5);
title('Low Pass Filter - Magnitude');
xlabel('Normalized Frequency');
ylabel('|H(w)|');
grid on;

subplot(2,1,2);
plot(w/pi, angle(h), 'LineWidth', 1.5);
title('Low Pass Filter - Phase');
xlabel('Normalized Frequency');
ylabel('Phase (radians)');
grid on;

%% -------- HIGH PASS --------
[h,w] = freqz(b_hp, a_hp, 1024);

figure;
subplot(2,1,1);
plot(w/pi, abs(h), 'LineWidth', 1.5);
title('High Pass Filter - Magnitude');
xlabel('Normalized Frequency');
ylabel('|H(w)|');
grid on;

subplot(2,1,2);
plot(w/pi, angle(h), 'LineWidth', 1.5);
title('High Pass Filter - Phase');
xlabel('Normalized Frequency');
ylabel('Phase (radians)');
grid on;

%% -------- BAND PASS --------
[h,w] = freqz(b_bp, a_bp, 1024);

figure;
subplot(2,1,1);
plot(w/pi, abs(h), 'LineWidth', 1.5);
title('Band Pass Filter - Magnitude');
xlabel('Normalized Frequency');
ylabel('|H(w)|');
grid on;

subplot(2,1,2);
plot(w/pi, angle(h), 'LineWidth', 1.5);
title('Band Pass Filter - Phase');
xlabel('Normalized Frequency');
ylabel('Phase (radians)');
grid on;

%% -------- BAND STOP --------
[h,w] = freqz(b_bs, a_bs, 1024);

figure;
subplot(2,1,1);
plot(w/pi, abs(h), 'LineWidth', 1.5);
title('Band Stop Filter - Magnitude');
xlabel('Normalized Frequency');
ylabel('|H(w)|');
grid on;

subplot(2,1,2);
plot(w/pi, angle(h), 'LineWidth', 1.5);
title('Band Stop Filter - Phase');
xlabel('Normalized Frequency');
ylabel('Phase (radians)');
grid on;