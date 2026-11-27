clc;
close all;
clear all;
A1=1,A2=2;
w1=20,w2=40;
t=0:0.01:pi;
s1_t=A1*sin(2*pi*w1*t);
s2_t=A2*sin(2*pi*w2*t);
s_t=s1_t+s2_t;
S2_f=fft(s2_t);
S1_f=fft(s1_t);
S_f=fft(s_t);
figure
plot(s1_t)
figure
plot(s2_t)
figure
plot(s_t)
figure
plot(abs(S1_f))
figure
plot(abs(S2_f))
figure
plot(abs(S_f))

