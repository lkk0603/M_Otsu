%% import Raman image('Raman_image') and wavenumber range matrix ('b'),firstly.
[mmm,nnn]=size(Raman_image);
[m,n]=size(Abs1); data=zeros(m,1);%Abs1 is Raman Spectral matrix
c=find(b==3042);d=find(b==2805);x1=[c:d];x0=[c,d];%定义特征峰范围
%% integral operation
for i=1:1:m
spi=Abs1(i,:);
y1=spi(1,c:d);
int1=trapz(x1,y1);
y0=[spi(1,c),spi(1,d)];
inti=int1;
data(i,1)=inti;
end  
int=reshape(data,mmm,nnn,1); 
int(int<0)=0;   
figure (1)%
imshow(int,[]);colormap(jet);colorbar('FontSize',12);caxis([0 1000000]);
%% M_Otsu
ymax=255;ymin=0;
xmax = max(max(int)); %求得InImg中的最大值
xmin = min(min(int)); %求得InImg中的最小值
B = round((ymax-ymin)*(int-xmin)/(xmax-xmin) + ymin);
% figure (4)%
imshow(B,[]);
[m,n]=size(int);
for i=1:m
    for j=1:n
        if B(i,j)~=0
            C(i,j)=ceil(B(i,j))-1;
        end
    end
end
count=zeros(256,1);
pcount=zeros(256,1);
for i=1:m
    for j=1:n
        pixel=C(i,j);
        count(pixel+1)=count(pixel+1)+1;
    end
end
dw=0;
for i=0:255
    pcount(i+1)=count(i+1)/(m*n);
    dw=dw+i*pcount(i+1);
end
Th=0;Thbest=0;
dfc=0;dfcmax=0;
while(Th>=0 && Th<=255)
    dp1=0;
    dw1=0;
    for i=0:Th
        dp1=dp1+pcount(i+1);
        dw1=dw1+i*pcount(i+1);
    end
    if dp1>0
        dw1=dw1/dp1;
    end
    dp2=0;
    dw2=0;
    for i=Th+1:255
        dp2=dp2+pcount(i+1);
        dw2=dw2+i*pcount(i+1);
    end
    if dp2>0
        dw2=dw2/dp2;
    end
    dfc=(dp1*+6.5)*(dw1-dw)^2+dp2*(dw2-dw)^2;%改修正系数，经典方法为0
    if dfc>=dfcmax
        dfcmax=dfc;
        Thbest=Th;
    end
    Th=Th+1;
end
T=Thbest;
%
R_fram=C;
R_fram(R_fram<=(T))=0;R_fram(R_fram>(T))=1;

R_frame=R_fram;
figure (1)%
imshow(R_frame,[]);colormap(jet);  