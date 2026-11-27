clc;
close all;
clear all;
t=[-4,-3,-2,-1,0,1,2,3,4];
x=[1,2,-1,7,3,0,1,5,3];
figure;
subplot(5,1,1);
stem(t,x);
grid on;
title('original signal');
subplot(5,1,2);
stem(2*t,x);
grid on;
title('time scaling');
subplot(5,1,3);
stem(t,x*2);
grid on;
title('amplitude scaling')
subplot(5,1,4);
stem(t+1,x);
title('time shifting');
grid on;
subplot(5,1,5);
stem(t+1,x.*sin(t));
title('multiply with sine');
grid on;



