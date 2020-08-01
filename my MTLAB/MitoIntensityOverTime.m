clear;clc;clf; % clear�Ω�M��workspace�����ܼ�,clc�Ω�M��command window�������O.
[file,path] = uigetfile('*.tif');
TifFileList = dir([path,'*.tif'])';% �N�P�@��file����tif�ɫإߦ��@��structure.
n =length(TifFileList); % n= image number (***�ۦ��J���)

Intensityovertime=[]; % ��iimage��all mito intensity �H�ɶ����ܤ�


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
  
Intensityovertime=[Intensityovertime;intensity]; %�Ĥ@�i�̫ܳ�@�i�Ϫ�intensity



end
Intensityovertime_cell = num2cell(Intensityovertime);
[data_table.intensity] = Intensityovertime_cell{:};

writetable(struct2table(data_table),[TifFileList(j).folder,'\summary.xlsx'])
 