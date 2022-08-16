%Q2 part d
clear;
close all;
clc;
x=double(imread('../barbara256.png'));
y=x+random('normal',0,4,size(x));
rec_img=zeros([256,256],"double");
rec_idx=zeros([256,256],"double");
for u=0:248
    for v=0:248
        patch=x(u+1:u+8,v+1:v+8);
        xi=reshape(patch,[],1);
        y=xi+random('normal',0,4,size(xi));
        U=kron(dctmtx(8)',dctmtx(8)');
        theta=random('normal',0,1,[64,1]);
        theta0=zeros([64,1],"double");
        for i=1:10
            theta0=theta;
            theta=wthresh(theta+0.001*transpose(U)*(y-U*theta),'s',0.005);
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