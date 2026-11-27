clc;
clear all;
close all;
t=0:1/10:10;
a1=-1.57;
a2=1.57;
Am=1;
y1=Am*sin(t);
y2=Am*sin(t+a1);
y3=Am*sin(t+a2);
figure;
subplot(3,1,1);
stem(t,y1);
title('Original sine wave')
subplot(3,1,2);
stem(t,y2);
title('right shifted sine wave')
subplot(3,1,3);
stem(t,y3);
title('left shifted sine wave');

