%Q2 part d
clear;
close all;
clc;
x=zeros([100,1],"double");
x(1:10)=random('normal',0,1,[10,1]);
z=conv(x,[1, 2, 3, 4, 3, 2, 1]/16,"same");
eta=random('normal',0,0.05*norm(x,2),[100,1]);
phi=zeros([100,100],"double");
q1=zeros([100,1],"double");
for i=1:100
    q1(i,i+min(7,100-i))=z;
    phi(i)=q1;
    q1=zeros([100,1],"double");
end
y=z+eta;
theta=random('normal',0,1,[100,1]);
theta0=zeros([100,1],"double");
alpha=1./eigs(phi'*phi,1);
for i=1:100
    theta0=theta;
    theta=wthresh(theta+alpha*transpose(phi)*(y-phi*theta),'s',alpha/2);
end
%the value of theta determined is the value of x reconstructed