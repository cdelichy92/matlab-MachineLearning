%Cyprien de Lichy

clear all; close all; clc;

N=16;

rng(2015);

A = double(imread('mandrill-small.tiff'));
imshow(uint8(round(A)));

index1 = datasample(1:128, N,'Replace',false);
index2 = datasample(1:128, N,'Replace',false);

C=zeros(3,N);

for c=1:N
    C(:,c)=reshape(A(index1(c),index2(c),:),[3,1]);
end

Cinit=C

B=zeros(128,128);

iter=0;

hasNotConverged=true;

while hasNotConverged
    
    hasNotConverged=false;
    
    sumColors=zeros(3,N);
    count=zeros(1,N);

    for i=1:128
        for j=1:128
            
            normC=zeros(1,N);
            
            for c=1:N
                normC(c)=norm(reshape(A(i,j,:),[3,1])-C(:,c));
            end
            
            minC=min(normC);
            centroid=find(normC==minC);
            
            if B(i,j)~=centroid
                B(i,j) = centroid(1);
                hasNotConverged=true;
            end
            
            sumColors(:,centroid(1))=sumColors(:,centroid(1))+reshape(A(i,j,:),[3,1]);
            count(centroid(1))=count(centroid(1))+1;
        end
    end

    for c=1:N
        if count(c)~=0
            C(:,c)=round(sumColors(:,c)/count(c));
        end
    end
    
    iter=iter+1
   
end

%Compress the image using the centroid colors
Alarge = double(imread('mandrill-large.tiff'));

for i=1:512
        for j=1:512
            
            normC=zeros(1,N);
            
            for c=1:N
                normC(c)=norm(reshape(Alarge(i,j,:),[3,1])-C(:,c));
            end
            
            minC=min(normC);
            centroid=find(normC==minC);
            
            Alarge(i,j,1)=C(1,centroid(1));
            Alarge(i,j,2)=C(2,centroid(1));
            Alarge(i,j,3)=C(3,centroid(1));
        end
end

figure(2);
imshow(uint8(round(Alarge)));

%Display the centroid colors
Alarge2 = double(imread('mandrill-large.tiff'));

for i=1:512
        for j=1:512
            Alarge2(i,j,1)=C(1,floor((j-1)/32)+1);
            Alarge2(i,j,2)=C(2,floor((j-1)/32)+1);
            Alarge2(i,j,3)=C(3,floor((j-1)/32)+1);
        end
end

figure(3);
imshow(uint8(round(Alarge2)));