clear;clc;clf; % clear用於清除workspace內的變數,clc用於清除command window中的指令.
TifFileList = dir('*.tif')';% 將同一個file內的tif檔建立成一個structure.
n= 9; % n= image number (***自行填入更改)
Intensityovertime=[]; % 整張image的all mito intensity 隨時間的變化


for j=1:n % n= image number
    
% read image
figure(1);
A = imread(TifFileList(j).name); % read tif file, n= image number
imshow(A);

figure(2);
[r,c]=find(A==0);
plot(c,512-r,'rs');
axis([0 512 0 512]);

% read second file
figure(3);
B = imread(TifFileList(j+n).name); % read tif file
imshow(B);

intensity = 0;
  for i = 1:size(r,1)
   intensity = [double(B(r(i,1),c(i,1)))-95] + intensity;
  end  
  
Intensityovertime=[Intensityovertime;intensity]; %第一張至最後一張圖的intensity
end


 