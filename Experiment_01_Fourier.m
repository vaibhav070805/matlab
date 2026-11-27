clc;
close all;
clear all;
N=128;
dt=0.1;
Fs=1/dt;
t=(-N/2:N/2-1)*dt;
x_fun=@(t) exp(-t.^2);
x=x_fun(t);
X=fftshift(fft(ifftshift(x)));
f=(-N/2:N/2-1)*Fs/N;
magnitude=abs(X);
phase=angle(X);
figure;
subplot(3,1,1)
plot(t,x);
subplot(3,1,2)
plot(f,magnitude);
subplot(3,1,3)
plot(f,phase);