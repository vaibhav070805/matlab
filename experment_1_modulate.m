clc;
close all;
clear all;
Am=2;
Fm=10;
N=2048;
Fc=100;
Fs=2000;
t=(-N/2:N/2-1)/Fs;
m_t=Am*sin(2*pi*Fm*t);
c_t=sin(2*pi*Fc*t);
s=m_t.*c_t;
S=fftshift(fft(ifftshift(s)));
magnitude=abs(S);
phase=angle(S);
f=(-N/2:N/2-1)*Fs/N;
figure;
subplot(4,1,1)
plot(t,c_t);
subplot(4,1,2);
plot(t,m_t);
subplot(4,1,3);
plot(f,magnitude);
subplot(4,1,4)
plot(f,phase);


