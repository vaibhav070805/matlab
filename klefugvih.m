clc;
close all;
clear all;
x=[1 2 3 4 ]
y=[2 3 4 5 ]
dt=0.000001;
z=conv2(x,y);
w=conv2(y,x*dt)
disp(z)
disp(w)