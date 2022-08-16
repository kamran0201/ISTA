%Q2 part b
clear;
close all;
clc;
x=double(imread('../barbara256.png'));
rec_img=zeros([256,256],"double");
rec_idx=zeros([256,256],"double");
for u=0:248
    for v=0:248
        patch=x(u+1:u+8,v+1:v+8);
        xi=reshape(patch,[],1);
        U=kron(dctmtx(8)',dctmtx(8)');
        phi=random('normal',0,1,[32,64]);
        phi_t=phi*U;
        y=phi*xi;
        theta=random('normal',0,1,[64,1]);
        theta0=zeros([64,1],"double");
        for i=1:10
            theta0=theta;
            theta=wthresh(theta+0.01*transpose(phi_t)*(y-phi_t*theta),'s',0.005);
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