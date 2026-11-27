clc;
close all;
clear all;
t=0:1/20:5;
h1=dirac(t);
ind=h1==Inf;
y1=t+2;
y2=t+2-1;
h=1;
w1=conv2(h,y1);
w2=conv2(h,y2);
if w2==w1-1
    disp('LTI');
else 
    disp('LTV');
end