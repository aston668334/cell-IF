clear;clc;clf; % clear用於清除workspace內的變數,clc用於清除command window中的指令.
[file,path] = uigetfile('*.tif');
TifFileList = dir([path,'*.tif'])';% 將同一個file內的tif檔建立成一個structure.
n =length(TifFileList); % n= image number (***自行填入更改)

Intensityovertime=[]; % 整張image的all mito intensity 隨時間的變化


for j=1:n % n= image number
    
data_table = TifFileList;    
 
% read image
%figure(1);
A = imread([TifFileList(j).folder,'\',TifFileList(j).name]); % read tif file, n= image number
imshow(A);
[m,n] = size(A);

mask_cell = ones(m,n);

% figure(2);
% [r,c]=find(A==0);
% plot(c,512-r,'rs');
% axis([0 512 0 512]);

% read second file
% figure(3);
% B = imread(TifFileList(j+n).name); % read tif file
% imshow(B);

after_mask_image = (double(A)- 95*ones(m,n)).*mask_cell;

intensity = 0;

intensity = sum(sum(after_mask_image));

%   for i = 1:size(r,1)
%    intensity = [double(B(r(i,1),c(i,1)))-95] + intensity;
%   end  
  
Intensityovertime=[Intensityovertime;intensity]; %第一張至最後一張圖的intensity



end
Intensityovertime_cell = num2cell(Intensityovertime);
[data_table.intensity] = Intensityovertime_cell{:};

writetable(struct2table(data_table),[TifFileList(j).folder,'\summary.xlsx'])
 