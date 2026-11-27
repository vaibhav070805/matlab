clc;
close all;
clear all;
fs =600;
t=0:1/fs:3;
fm=50;
x1=sin(2*pi*fm*t);
n=fs/fm;
disp(n);
x2=zeros(n);
for i=0:n-1
    x2(i)=x1()
    