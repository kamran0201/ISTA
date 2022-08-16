%Q2 part c
clear;
close all;
clc;
x=double(imread('../barbara256.png'));
rec_img=zeros([256,256],"double");
rec_idx=zeros([256,256],"double");
f1=@computephi_t;
for u=0:248
    for v=0:248
        patch=x(u+1:u+8,v+1:v+8);
        xi=reshape(patch,[],1);
        U=kron(f1(patch)',f1(patch)');
        phi=random('normal',0,1,[32,64]);
        phi_t=phi*U;
        y=phi*xi;
        theta=random('normal',0,1,[64,1]);
        theta0=zeros([64,1],"double");
        phi_t_t=transpose(phi_t);
        alpha=1./eigs(phi_t'*phi_t,1);
        for i=1:200
            theta0=theta;
            theta=wthresh(theta+alpha*phi_t_t*(y-phi_t*theta),'s',alpha/2);
        end
        x_rec=U*theta;
        for i=u+1:u+8
            for j=v+1:v+8
                rec_img(i,j)=rec_img(i,j)+x_rec((i-u)+8*(j-v-1),1);
                rec_idx(i,j)=rec_idx(i,j)+1;
            end
        end
    end
end
rmsetotal=norm(rec_img./rec_idx-x,2)/norm(x,2);
rec_img=uint8(rec_img./rec_idx);
imshow(rec_img);
fprintf('The total RMSE is %0.4f\n', rmsetotal);
function t = computephi_t(a)
    [t1,t2,t3,t4]=dwt2(a,'db1');
    t1=reshape(t1,[],1);
    t2=reshape(t2,[],1);
    t3=reshape(t3,[],1);
    t4=reshape(t4,[],1);
    t=cat(1,t1,t2,t3,t4);
    t=reshape(t,[8,8]);
end
