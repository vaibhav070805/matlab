clc;
clear all;
close all;
t=0:1/20:7;
a1=0.5;
a2=2;
Am=1;
y1=Am*sin(t);
y2=Am*sin(a1*t);
y3=Am*sin(a2*t);
figure;
subplot(3,1,1);
stem(t,y1);
title('Original sine wave')
subplot(3,1,2);
stem(t,y2);
title('expanded sine wave')
subplot(3,1,3);
stem(t,y3);
title('compressed sine wave');

