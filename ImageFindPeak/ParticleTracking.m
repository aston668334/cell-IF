clear;clc;close all;
[file,path] = uigetfile('*.tif');
TifFileList = dir([path,'*.tif'])';% �N�P�@��file����tif�ɫإߦ��@��structure.
n =length(TifFileList);
Punctanumberperframe = []; % �C�iimage����puncta�ӼƳ]���ůx�}



for j=1:n % n= image number

figure(1);
A = imread([TifFileList(j).folder,'\',TifFileList(j).name]);
Asmooth = Deconv(A,4,2);
[x,y] = size(A);
imshow(A);

figure(2);
PkTable = ImgFindPeak(Asmooth,200,5); % �bImgFindPeak����JDelta���p��
X = PkTable(:,1);
Y = PkTable(:,2);
plot(X,y-Y,'rs');
axis([0 x 0 y]);
length(X);


figure(3);  % �bimage�W�I�Xpeak��m
imshow(A);
axis on
hold on;
plot(X,Y,'rs');
end

Punctanumberperframe = [length(X);Punctanumberperframe];
sum(Punctanumberperframe)/n;
