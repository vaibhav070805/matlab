clc;
close all;
clear all;
t=-5:0.001:5;
pulse=rectangularPulse(-0.3,0.3,t);
figure
plot(t,pulse)
S_f=fft(pulse);
S_cent=fftshift(S_f);
figure
plot(abs(S_cent));
