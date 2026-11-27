clc;
close all;
clear all;
t=0:1/20:5;
h1=dirac(t);
ind=h1==Inf;
y1=t+2;
h=1;
w1=conv2(h,y1);
if w1==Inf | t==Inf
    disp('Unstable');
elseif w1 <=Inf & t< Inf
    disp('Stable');
end