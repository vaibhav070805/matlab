clc; close all; clear all;
N = randi([0 15], 10000, 1); 
qm = qammod(N,16,'UnitAveragePower',true);
plot(real(qm), imag(qm), '.');
ylim([-2 2])
axis equal; grid on;
