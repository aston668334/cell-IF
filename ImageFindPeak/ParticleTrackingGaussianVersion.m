clear;clc;clf; % clear用於清除workspace內的變數,clc用於清除command window中的指令.
TifFileList = dir('*.tif')';% 將同一個file內的tif檔建立成一個structure.
n = 10; % n= image number (***自行填入更改)
Punctanumberperframe = []; % 每張image中的puncta個數設為空矩陣

for j=1:n % n= image number

figure(1);
A = imread(TifFileList(j).name);
[ImgResult,PkTable] = DeconvFindPk (A,2,1,75); % 將image以Deconv.m做smoothing,並啟動做peak finding
imshow(A);

figure(2);
X = PkTable(:,1);
Y = PkTable(:,2);
plot(X,640-Y,'rs');
axis([0 640 0 640]);
length(X);


figure(3);  % 在image上點出peak位置
imshow(A);
axis on
hold on;
plot(X,Y,'rs');
end

Punctanumberperframe = [length(X);Punctanumberperframe];
sum(Punctanumberperframe)/n;
