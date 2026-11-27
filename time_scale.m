clc;
clear all;
close all;
t1=0:1/20:7;
t2=0:1/1000:7;
a1=0.5;
a2=2;
Am=1;
y1=Am*sin(t1);
y2=Am*sin(a1*t1);
y3=Am*sin(a2*t1);
y4=Am*sin(t2);
y5=Am*sin(a1*t2);
y6=Am*sin(a2*t2);
figure;
subplot(6,1,1);
plot(t2,y4);
title('Original sine wave')
subplot(6,2,4);
stem(t1,y1);
title('Original sine wave');

subplot(6,1,2);
plot(t2,y5);
title('expanded sine wave')
subplot(6,2,5);
stem(t1,y2);
title('expanded sine wave');

subplot(6,1,3);
plot(t2,y6);
title('compressed sine wave');

subplot(6,2,6);
stem(t1,y3);
title('compressed sine wave');
