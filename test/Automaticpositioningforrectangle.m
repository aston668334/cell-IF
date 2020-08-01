% IntQuantify
% intensity quantification after particle remove  
clear;clc;clf; % clear用於清除workspace內的變數,clc用於清除command window中的指令.
files=dir; % 將同一個file內的data建立成一個structure.
files=files(3:end); % 扣除struacture內前兩個data, 因為那是目錄.
Background=[];
Cytoplasm=[]; % 先製造一個空間存放cytoplasm的intensity.
Nucleus=[];  % 先製造一個空間存放nucleus的intensity.
IntOfR1=[];
IntOfR2=[];

%delcare variable
fig_size = [];
boundarys = [];
bg_sq_rgb = [100 187 86];       % background square RGB value
nu_sq_rgb = [255 247 246];      % nucleous square RGB value
%r1_sq_rgb = [112 195 190];
r1_sq_rgb = [120 200 195];      % cytoplasm square RGB value
bg_sq_rgb_m = [10  10  10 ];
nu_sq_rgb_m = [10  10  10 ];
r1_sq_rgb_m = [10  10  10 ];
bg_sq_rgb_up_limit = bg_sq_rgb  + bg_sq_rgb_m;
bg_sq_rgb_dn_limit = bg_sq_rgb  - bg_sq_rgb_m;
nu_sq_rgb_up_limit = nu_sq_rgb  + nu_sq_rgb_m;
nu_sq_rgb_dn_limit = nu_sq_rgb  - nu_sq_rgb_m;
r1_sq_rgb_up_limit = r1_sq_rgb  + r1_sq_rgb_m;
r1_sq_rgb_dn_limit = r1_sq_rgb  - r1_sq_rgb_m;

% read *.jpg image
A = imread(files(size(files,1)-1).name);
imshow(A);

% threshold the image
I = rgb2gray(A);
threshold = graythresh(I);
bw = im2bw(I,threshold);
imshow(bw)

% remove the noise
bw = bwareaopen(bw,200); % remove all object containing fewer than 200 pixels
se = strel('disk',2);
bw = imclose(bw,se);
bw = imfill(bw,'holes');
imshow(bw);

%find the boundarys
[B,L] = bwboundaries(bw,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]));
hold on;

offset = 0;
sq_num = zeros(length(B) ,7); % sq_num = [ bg_num nu_num r1_num x_min x_max y_min y_max]

for k = 1:length(B);
    boundary = B{k};
    fig_size_temp = size(B{k});
    fig_size = [fig_size ; fig_size_temp];
    figure(1);
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    boundarys = [boundarys;B{k}];
    C = min(boundary);
    sq_num(k, 4) = C(1);
    sq_num(k, 6) = C(2);
    C = max(boundary);
    sq_num(k, 5) = C(1);
    sq_num(k, 7) = C(2);
end

% determine the background square, nucleous square, cytoplasm square
for i = 1:length(B);
    for j = 1:fig_size(i,1);
        offset = offset + 1;
        x = boundarys(offset,1);
        y = boundarys(offset,2);
        if ( A(x,y,1) <= bg_sq_rgb_up_limit(1)  &&  A(x,y,1) >= bg_sq_rgb_dn_limit(1) ) ...
         && ( A(x,y,2) <= bg_sq_rgb_up_limit(2)  &&  A(x,y,2) >= bg_sq_rgb_dn_limit(2) ) ...
         && ( A(x,y,3) <= bg_sq_rgb_up_limit(3)  &&  A(x,y,3) >= bg_sq_rgb_dn_limit(3) ) 
          sq_num(i,1) = sq_num(i,1)+1;
          
        elseif ( A(x,y,1) <= nu_sq_rgb_up_limit(1)  &&  A(x,y,1) >= nu_sq_rgb_dn_limit(1) ) ...
         && ( A(x,y,2) <= nu_sq_rgb_up_limit(2)  &&  A(x,y,2) >= nu_sq_rgb_dn_limit(2) ) ...
         && ( A(x,y,3) <= nu_sq_rgb_up_limit(3)  &&  A(x,y,3) >= nu_sq_rgb_dn_limit(3) ) 
          sq_num(i,2) = sq_num(i,2)+1;
          
        elseif ( A(x,y,1) <= r1_sq_rgb_up_limit(1)  &&  A(x,y,1) >= r1_sq_rgb_dn_limit(1) ) ...
         && ( A(x,y,2) <= r1_sq_rgb_up_limit(2)  &&  A(x,y,2) >= r1_sq_rgb_dn_limit(2) ) ...
         && ( A(x,y,3) <= r1_sq_rgb_up_limit(3)  &&  A(x,y,3) >= r1_sq_rgb_dn_limit(3) ) 
          sq_num(i,3) = sq_num(i,3)+1;        
        end        
    end    
end

sq_num
sq_num_tmp = sq_num(:,1:3);
[c,I] = max(sq_num_tmp);
bg_x_min = sq_num(I(1),4);
bg_x_max = sq_num(I(1),5);
bg_y_min = sq_num(I(1),6);
bg_y_max = sq_num(I(1),7);

nu_x_min = sq_num(I(2),4);
nu_x_max = sq_num(I(2),5);
nu_y_min = sq_num(I(2),6);
nu_y_max = sq_num(I(2),7);

r1_x_min = sq_num(I(3),4);
r1_x_max = sq_num(I(3),5);
r1_y_min = sq_num(I(3),6);
r1_y_max = sq_num(I(3),7);

% find the r2 region
sq_num(I(3),3) = sq_num(I(3),3) - c(3);
[c,I] = max(sq_num);
r2_x_min = sq_num(I(3),4);
r2_x_max = sq_num(I(3),5);
r2_y_min = sq_num(I(3),6);
r2_y_max = sq_num(I(3),7);

for I=1:size(files,1)-2; % 製造迴圈,從第一張圖分析到最後一張圖
    Img=double(imread(files(I).name)); % 將原始8bit轉換成double, 並存給變數Img表示.
    % 計算Background
%    R=Img(394:479,51:86);
    R=Img(bg_x_min:bg_x_max,bg_y_min:bg_y_max);
    B=R(:);
    B1=B(B>0);
    M=mean(B1);
    Background=[Background;M];
    
    % 計算cytoplasm兩處(R1,R2)的平均數值 
    %R1=Img(114:173,120:177); % ROI intensity, 事先先選取較無spots的活動範圍(ROI)定出其Y,X[ex: Y=135:165,X=120:140]
    R1=Img(r1_x_min:r1_x_max,r1_y_min:r1_y_max);
    C1=R1(:); % 將matrix R1 轉成列向量並存給變數C1表示.
    I1=C1(C1>0); % 取出C1中非0的數值並存給變數I1表示.
    M1=mean(I1); % 計算I1中所有非O數值的平均並存給M1表示. 
    IntOfR1=[IntOfR1;M1];
    
    %R2=Img(374:426,323:386); % ROI intensity, 事先先選取較無spots的活動範圍(ROI)定出其Y,X[ex: Y=135:165,X=120:140]
    R2=Img(r2_x_min:r2_x_max,r2_y_min:r2_y_max);
    C2=R2(:); % 將matrix R2 轉成列向量並存給變數C2表示.
    I2=C2(C2>0); % 取出C2中非0的數值並存給變數I2表示.
    M2=mean(I2); % 計算I2中所有非O數值的平均並存給M2表示.   
    IntOfR2=[IntOfR2;M2];
    % 計算cytoplasm兩處(R1,R2)的平均數值再得一個平均數當作cytoplasm 的螢光強度
    MeanOfCytoplasm=(M1+M2)/2;
    Cytoplasm=[Cytoplasm;MeanOfCytoplasm]; %第一張至最後一張圖cytoplasm的intensities.
    IntOfCytoplasm=Cytoplasm-Background;
    
    % 計算nucleus的平均數值 
    %R3=Img(220:271,261:317); 
    R3=Img(nu_x_min:nu_x_max,nu_y_min:nu_y_max);
    N=R3(:); % 將matrix R3 轉成列向量.
    I3=N(N>0); % 取出N中非0的數值並存給變數I3表示.
    M3=mean(I3); % 計算I3中所有非O數值的平均並存給M3表示.
    Nucleus=[Nucleus;M3]; %第一張至最後一張圖nucleus的intensities.   
    IntOfNucleus=Nucleus-Background;
end
 IntOfTotal=IntOfCytoplasm+IntOfNucleus/1.949; % 整個細胞的螢光強度=Int. of cytoplasm+1/2 Int. of nucleus 
 NCratio=IntOfNucleus/IntOfCytoplasm;

 figure; 
 plot(IntOfTotal);
 title('Intensity of cell');
 grid;
 
 time = 90:90:4500;
 offset = IntOfTotal(2)- (0.0036921*time(1)-0.0000035906*time(1)^2+0.0000000018951*time(1)^3-0.00000000000045533*time(1)^4 ...
          +4.0577*10^(-17)*time(1)^5)*(IntOfTotal(1)-IntOfTotal(2))/148.89;
      
 for i=1:size(time,2) 
     auto_recover_intensity(i) = offset + (0.0036921*time(i)-0.0000035906*time(i)^2+0.0000000018951*time(i)^3-0.00000000000045533*time(i)^4 ...
          +4.0577*10^(-17)*time(i)^5)*(IntOfTotal(1)-IntOfTotal(2))/148.89;
 end
 real_intensity = IntOfTotal(2:end) - auto_recover_intensity';

 
 