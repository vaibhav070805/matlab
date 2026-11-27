clc;
clear all;
close all;
t=0:0.5:7;
a1=0.5;
a2=2;
Am=1;
y1=Am*sin(t);
y2=a1*Am*sin(t+a1);
y3=a2*Am*sin(t+a2);
figure;
subplot(3,1,1);
stem(t,y1);
title('Original sine wave')
subplot(3,1,2);
stem(t,y2);
title('reduced amplitude sine wave')
subplot(3,1,3);
stem(t,y3);
title('increased amplitude sine wave');

