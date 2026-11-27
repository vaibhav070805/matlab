clc;
close all;
clear all;
t=-1.57:1/2:1.57;
x=2*sin(t);
h=t>=0;
y=conv2(h,x);
disp(y);
figure;
subplot(3,1,1);
stem(t,x);
title('original input')
subplot(3,1,2);
stem(t,h);
title('unit step function');
subplot(3,1,3);
stem(y);
title('convolution');

