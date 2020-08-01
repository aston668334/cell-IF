% read *.oib file
clc;clear;
clf;
value_tmp = [];


OibFileList = dir('*.oib')';
fid = fopen(OibFileList(1).name);
F = fread(fid, '*uchar');
F = F';
cmp_str = [hex2dec('57') hex2dec('00') hex2dec('69') hex2dec('00') hex2dec('64') hex2dec('00') hex2dec('74') hex2dec('00') hex2dec('68') hex2dec('00') hex2dec('43')];
i = size(F');

while i <= size(F')
    temp = F(i-size(cmp_str')+1 : i);
    if ( temp == cmp_str )
        str = sprintf('%s',F(i-14:i+39))
        str_num = F(i-14:i+39);
        i = size(F') + 2 ; % escape while loop
    end
    i = i -1;
end

% save data to real_pixel_value
for i = 1 :size(str_num')
    if( (str_num(1,i) == 46) || ( str_num(1,i)>=48 && str_num(1,i) <= 57))
        value_tmp = [value_tmp;str_num(1,i)];
    end
end

value_str = sprintf('%s', value_tmp);
pixel_value = str2double(value_str)
fclose(fid);

% read image
figure(1);

TifFileList = dir('*.tif')';
A = imread(TifFileList(1).name); % read tif file
imshow(A);

figure(2);
[r,c]=find(A==0);
plot(c,512-r,'rs');
axis([0 512 0 512]);

figure(3);
[y,x]=find(A>0);
plot(x,512-y,'rs');
axis([0 512 0 512]);

% bleach_particle_area
bleach_particle_area = size(r)*pixel_value*pixel_value

% read second file
figure(4);
TifFileList = dir('*.tif')';
B = imread(TifFileList(2).name); % read tif file
imshow(B);

intensity = 0;
for i = 1:size(r,1)
   intensity = double(B(r(i,1),c(i,1))) + intensity;
end
intensity
AverageIntensity = intensity/size(r,1)


background = 0;
for i = 1:size(y,1)
   background = double(B(y(i,1),x(i,1))) + background;
end
AverageBackground = background/size(y,1)

AverageCellIntensity = AverageIntensity-AverageBackground



