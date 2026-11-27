clc;
clear all;
close all;
t=0:0.5:7;
%a1=-1.57;
a2=1.57;
Am=1;
y1=Am*sin(t);
y2=a2.^(t);
y3=y1.*y2;
figure;
subplot(3,1,1);
stem(t,y1);
title('Original sine wave')
subplot(3,1,2);
stem(t,y2);
title('exponential function')
subplot(3,1,3);
stem(t,y3);
title('multiplied sine wave');

