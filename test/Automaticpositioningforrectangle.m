% IntQuantify
% intensity quantification after particle remove  
clear;clc;clf; % clear�Ω�M��workspace�����ܼ�,clc�Ω�M��command window�������O.
files=dir; % �N�P�@��file����data�إߦ��@��structure.
files=files(3:end); % ����struacture���e���data, �]�����O�ؿ�.
Background=[];
Cytoplasm=[]; % ���s�y�@�ӪŶ��s��cytoplasm��intensity.
Nucleus=[];  % ���s�y�@�ӪŶ��s��nucleus��intensity.
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

for I=1:size(files,1)-2; % �s�y�j��,�q�Ĥ@�i�Ϥ��R��̫�@�i��
    Img=double(imread(files(I).name)); % �N��l8bit�ഫ��double, �æs���ܼ�Img���.
    % �p��Background
%    R=Img(394:479,51:86);
    R=Img(bg_x_min:bg_x_max,bg_y_min:bg_y_max);
    B=R(:);
    B1=B(B>0);
    M=mean(B1);
    Background=[Background;M];
    
    % �p��cytoplasm��B(R1,R2)�������ƭ� 
    %R1=Img(114:173,120:177); % ROI intensity, �ƥ���������Lspots�����ʽd��(ROI)�w�X��Y,X[ex: Y=135:165,X=120:140]
    R1=Img(r1_x_min:r1_x_max,r1_y_min:r1_y_max);
    C1=R1(:); % �Nmatrix R1 �ন�C�V�q�æs���ܼ�C1���.
    I1=C1(C1>0); % ���XC1���D0���ƭȨæs���ܼ�I1���.
    M1=mean(I1); % �p��I1���Ҧ��DO�ƭȪ������æs��M1���. 
    IntOfR1=[IntOfR1;M1];
    
    %R2=Img(374:426,323:386); % ROI intensity, �ƥ���������Lspots�����ʽd��(ROI)�w�X��Y,X[ex: Y=135:165,X=120:140]
    R2=Img(r2_x_min:r2_x_max,r2_y_min:r2_y_max);
    C2=R2(:); % �Nmatrix R2 �ন�C�V�q�æs���ܼ�C2���.
    I2=C2(C2>0); % ���XC2���D0���ƭȨæs���ܼ�I2���.
    M2=mean(I2); % �p��I2���Ҧ��DO�ƭȪ������æs��M2���.   
    IntOfR2=[IntOfR2;M2];
    % �p��cytoplasm��B(R1,R2)�������ƭȦA�o�@�ӥ����Ʒ�@cytoplasm ���å��j��
    MeanOfCytoplasm=(M1+M2)/2;
    Cytoplasm=[Cytoplasm;MeanOfCytoplasm]; %�Ĥ@�i�̫ܳ�@�i��cytoplasm��intensities.
    IntOfCytoplasm=Cytoplasm-Background;
    
    % �p��nucleus�������ƭ� 
    %R3=Img(220:271,261:317); 
    R3=Img(nu_x_min:nu_x_max,nu_y_min:nu_y_max);
    N=R3(:); % �Nmatrix R3 �ন�C�V�q.
    I3=N(N>0); % ���XN���D0���ƭȨæs���ܼ�I3���.
    M3=mean(I3); % �p��I3���Ҧ��DO�ƭȪ������æs��M3���.
    Nucleus=[Nucleus;M3]; %�Ĥ@�i�̫ܳ�@�i��nucleus��intensities.   
    IntOfNucleus=Nucleus-Background;
end
 IntOfTotal=IntOfCytoplasm+IntOfNucleus/1.949; % ��ӲӭM���å��j��=Int. of cytoplasm+1/2 Int. of nucleus 
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

 
 