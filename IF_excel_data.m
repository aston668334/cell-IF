clear;clc;close all; % clear�Ω�M��workspace�����ܼ�,clc�Ω�M��command window�������O.

[file,path] = uigetfile({'*.csv','IF_csv';'*.*','else file'},'select first photo');
%[mask_file,mask_path] = uigetfile({'*.tif';'*.*'},'select mask photo';
TifFileList = dir([path,'*.csv'])';% �N�P�@��file����tif�ɫإߦ��@��structure.
n =length(TifFileList); % n= image number (***�ۦ��J���)

Intensityovertime=[]; % ��iimage��all mito intensity �H�ɶ����ܤ�

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
 