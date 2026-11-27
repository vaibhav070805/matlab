% 0 ke liye -1 1 in the form of 1(180*)
%psk me 1 bit
%qpsk ke liye max phase max 90 ka diff
%+- 1 +-j
clc;close all;clear all;
N1=randi([0,1],10000,1);
bpsk = pskmod(N1,2,0);
figure
plot(real(bpsk), imag(bpsk), '.');
xlim([-1.5 1.5]);
axis equal; grid on;

% N2=randi([0,3],10000,1);
% qpsk = pskmod(N2,2,0);
% figure
% plot(real(qpsk), imag(qpsk), '.');
% axis equal; grid on;
