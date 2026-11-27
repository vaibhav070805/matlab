clc;
close all;
clear all;
t=-5:1/2000:5;
x=2*sin(t);
h=t>=0;
y=conv2(h,x);
disp(y);
figure;
subplot(3,1,1);
plot(t,x);
title('original input')
subplot(3,1,2);
plot(t,h);
title('unit impulse function');
subplot(3,1,3);
plot(y);
title('convolution');

