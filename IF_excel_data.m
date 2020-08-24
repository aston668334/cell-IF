clear;clc;close all; % clear用於清除workspace內的變數,clc用於清除command window中的指令.

[file,path] = uigetfile({'*.csv','IF_csv';'*.*','else file'},'select first photo');
%[mask_file,mask_path] = uigetfile({'*.tif';'*.*'},'select mask photo';
TifFileList = dir([path,'*.csv'])';% 將同一個file內的tif檔建立成一個structure.
n =length(TifFileList); % n= image number (***自行填入更改)

Intensityovertime=[]; % 整張image的all mito intensity 隨時間的變化

%%
for j=1:n % n= image number
    
data_table = TifFileList;    
 

A = readtable([TifFileList(j).folder,'\',TifFileList(j).name]); 

z = size(A.Mean(A.Mean < 110 & A.Max < 130 & A.Ch == 2));

Intensityovertime=[Intensityovertime;z];

end



Intensityovertime_cell = num2cell(Intensityovertime);
[data_table.intensity] = Intensityovertime_cell{:};

writetable(struct2table(data_table),[TifFileList(j).folder,'\summary.xlsx'])
 