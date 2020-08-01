clear;clc;clf; % clear�Ω�M��workspace�����ܼ�,clc�Ω�M��command window�������O.
TifFileList = dir('*.tif')';% �N�P�@��file����tif�ɫإߦ��@��structure.
n= 9; % n= image number (***�ۦ��J���)
Intensityovertime=[]; % ��iimage��all mito intensity �H�ɶ����ܤ�


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
  
Intensityovertime=[Intensityovertime;intensity]; %�Ĥ@�i�̫ܳ�@�i�Ϫ�intensity
end


 