clc;
close all;
clear all;
t=0:1/2000:5;
x1=t+1;
x2=2*t+3;
x3=x1+x2;
h=1;
y1=conv2(h,x1);
y2=conv2(h,x2);
y3=conv2(h,x3);
if y3==(y1+y2)
    disp('Linear');
else
    disp('non linear');
end

