clear;clc;close all;
[file,path] = uigetfile('*.tif');
TifFileList = dir([path,'*.tif'])';% 將同一個file內的tif檔建立成一個structure.
n =length(TifFileList);
Punctanumberperframe = []; % 每張image中的puncta個數設為空矩陣



for j=1:n % n= image number

figure(1);
A = imread([TifFileList(j).folder,'\',TifFileList(j).name]);
Asmooth = Deconv(A,4,2);
[x,y] = size(A);
imshow(A);

figure(2);
PkTable = ImgFindPeak(Asmooth,200,5); % 在ImgFindPeak中輸入Delta做計算
X = PkTable(:,1);
Y = PkTable(:,2);
plot(X,y-Y,'rs');
axis([0 x 0 y]);
length(X);


figure(3);  % 在image上點出peak位置
imshow(A);
axis on
hold on;
plot(X,Y,'rs');
end

Punctanumberperframe = [length(X);Punctanumberperframe];
sum(Punctanumberperframe)/n;
