clc;
clear all;
close all;
x_n=input("Enter x_n");
N=length(x_n);
X_k=zeros(1,N);
for k=0:N-1
    sum=0;
    for n=0:N-1
        t=x_n(n+1)*exp(-1j*pi*2*k*n/N);
        sum=sum+t;
    end
    X_k(k+1)=sum;
end
subplot(2,1,1)
stem(0:N-1,abs(X_k),"filled");
grid on;
subplot(2,1,2)
stem(0:N-1,angle(X_k),"filled");
grid on;