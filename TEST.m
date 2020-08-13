clear;clc;close all; % clear�Ω�M��workspace�����ܼ�,clc�Ω�M��command window�������O.

for i = 1:4

    [file,path] = uigetfile({'*.tif','cell photo';'*.*','else file'},'select first photo');
    TifFileList = dir([path,'*.tif'])';% �N�P�@��file����tif�ɫإߦ��@��structure.
    n =length(TifFileList); % n= image number (***�ۦ��J���)

    Intensityovertime=[]; % ��iimage��all mito intensity �H�ɶ����ܤ�

    for j=1:n % n= image number

        data_table = TifFileList;    

        A = imread([TifFileList(j).folder,'\',TifFileList(j).name]); % read tif file, n= image number

        [m,n] = size(A);

        mask_cell = ones(m,n);

        after_mask_image = (double(A)- 95*ones(m,n)).*mask_cell;

        intensity = 0;

        intensity = sum(sum(after_mask_image));

        Intensityovertime=[Intensityovertime;intensity]; %�Ĥ@�i�̫ܳ�@�i�Ϫ�intensity

    end
    Intensityovertime_cell = num2cell(Intensityovertime);
    [data_table.intensity] = Intensityovertime_cell{:};
    data = struct2table(data_table)
end

%%

[file,path] = uigetfile({'*.xlsx','execel file';'*.*','else file'},'select cytosol 1 ');

cytosol_1 = readtable([path,file]);

[file,path] = uigetfile({'*.xlsx','execel file';'*.*','else file'},'select cytosol 2 ');

cytosol_2 = readtable([path,file]);

[file,path] = uigetfile({'*.xlsx','execel file';'*.*','else file'},'select nuclear   ');

nuclear = readtable([path,file]);

[file,path] = uigetfile({'*.xlsx','execel file';'*.*','else file'},'select before damge   ');

before_damage = readtable([path,file]);
%%
before_damage_name = before_damage.name;

for i = 1:length(before_damage_name)
    if ~isempty(strfind(before_damage_name{i},'cytosol_1_TFEB'))
        cytosol_1_TFEB = table2array( before_damage(i,7));
    end
    if ~isempty(strfind(before_damage_name{i},'cytosol_1_fusion red'))
        cytosol_1_fusionred = table2array( before_damage(i,7));
    end
    if ~isempty(strfind(before_damage_name{i},'cytosol_2_TFEB'))
        cytosol_2_TFEB = table2array( before_damage(i,7));
    end
    if ~isempty(strfind(before_damage_name{i},'cytosol_2_fusion red'))
        cytosol_2_fusionred = table2array( before_damage(i,7));
    end
    if ~isempty(strfind(before_damage_name{i},'nuclear_TFEB'))
        nuclear_TFEB = table2array( before_damage(i,7));
    end
    if ~isempty(strfind(before_damage_name{i},'nuclear_fusion red'))
        nuclear_fusionred = table2array( before_damage(i,7));
    end

end


%%

cyt_1_name = cytosol_1.name;
cyt_1_fusionred_index = strfind(cyt_1_name,'c002');
cyt_1_TFEB_index = strfind(cyt_1_name,'c003');
    
cyt_2_name = cytosol_2.name;
cyt_2_fusionred_index = strfind(cyt_2_name,'c002');
cyt_2_TFEB_index = strfind(cyt_2_name,'c003');

nuclear_name = nuclear.name;
nuclear_fusionred_index = strfind(nuclear_name,'c002');
nuclear_TFEB_index = strfind(nuclear_name,'c003');

cyt_1_fusionred_intensity = [];
cyt_1_TFEB_intensity = [];
cyt_2_fusionred_intensity = [];
cyt_2_TFEB_intensity = [];
nuclear_fusionred_intensity = [];
nuclear_TFEB_intensity = [];

for i = 1:length(cyt_1_name)
    
    if ~isempty(cyt_1_fusionred_index{i})
       cyt_1_fusionred_intensity = [cyt_1_fusionred_intensity,table2array(cytosol_1(i,7))];
    end
    if ~isempty(cyt_1_TFEB_index{i})
       cyt_1_TFEB_intensity = [cyt_1_TFEB_intensity,table2array(cytosol_1(i,7))];
    end
    if ~isempty(cyt_2_fusionred_index{i})
       cyt_2_fusionred_intensity = [cyt_2_fusionred_intensity,table2array(cytosol_2(i,7))];
    end
    if ~isempty(cyt_2_TFEB_index{i})
       cyt_2_TFEB_intensity = [cyt_2_TFEB_intensity,table2array(cytosol_2(i,7))];
    end
    if ~isempty(nuclear_fusionred_index{i})
       nuclear_fusionred_intensity = [nuclear_fusionred_intensity,table2array(nuclear(i,7))];
    end
    if ~isempty(nuclear_TFEB_index{i})
       nuclear_TFEB_intensity = [nuclear_TFEB_intensity,table2array(nuclear(i,7))];
    end
end

%%
time = 0:60:3600;

cytosol_1_blank = cytosol_1_TFEB/cytosol_1_fusionred;
cytosol_2_blank = cytosol_2_TFEB/cytosol_2_fusionred;
nuclear_blank = nuclear_TFEB/nuclear_fusionred;

cytosol_1_afterdamage_TFEB_fusionred_ratio = (cyt_1_TFEB_intensity./cyt_1_fusionred_intensity)/cytosol_1_blank;
cytosol_2_afterdamage_TFEB_fusionred_ratio = (cyt_2_TFEB_intensity./cyt_2_fusionred_intensity)/cyrl_2_blank;
nuclear_afterdamage_TFEB_fusionred_ratio = (nuclear_TFEB_intensity./nuclear_fusionred_intensity)/nuclear_blank;

cytosol_afterdamage_TFEB_fusionred_ratio_adv = (cytosol_1_afterdamage_TFEB_fusionred_ratio+cytosol_2_afterdamage_TFEB_fusionred_ratio)/2;

%%

cytosol_1_final = [-60,cytosol_1_TFEB,cytosol_1_fusionred;
                    time.',cyt_1_TFEB_intensity.',cyt_1_fusionred_intensity.'];
cytosol_1_final = [num2cell(cytosol_1_final),['���H-60����';num2cell(cytosol_1_afterdamage_TFEB_fusionred_ratio.')]];
cytosol_1_table = cell2table(cytosol_1_final,'VariableNames',{'times' 'TFEB' 'fusion red' 'TFEB/fusion red ratio'});

cytosol_2_final = [-60,cytosol_2_TFEB,cytosol_2_fusionred;
                    time.',cyt_2_TFEB_intensity.',cyt_2_fusionred_intensity.'];
cytosol_2_final = [num2cell(cytosol_2_final),['���H-60����';num2cell(cytosol_2_afterdamage_TFEB_fusionred_ratio.')]];
cytosol_2_table = cell2table(cytosol_2_final,'VariableNames',{'times' 'TFEB' 'fusion red' 'TFEB/fusion red ratio'});

nuclear_final   = [-60,nuclear_TFEB,nuclear_fusionred;
                    time.',nuclear_TFEB_intensity.',nuclear_fusionred_intensity.'];
nuclear_final = [num2cell(nuclear_final),['���H-60����';num2cell(nuclear_afterdamage_TFEB_fusionred_ratio.')]];
nuclear_table = cell2table(nuclear_final,'VariableNames',{'times' 'TFEB' 'fusion red' 'TFEB/fusion red ratio'});

filename = ['D:\data\TFEB summary\summary_',path(22:27),'_after damage_1.xlsx'];
writetable(cytosol_1_table,filename,'Sheet','cytosol_1')
writetable(cytosol_2_table,filename,'Sheet','cytosol_2')
writetable(nuclear_table,filename,'Sheet','nuclear')