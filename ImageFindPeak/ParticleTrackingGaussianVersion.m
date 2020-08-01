clear;clc;clf; % clear�Ω�M��workspace�����ܼ�,clc�Ω�M��command window�������O.
TifFileList = dir('*.tif')';% �N�P�@��file����tif�ɫإߦ��@��structure.
n = 10; % n= image number (***�ۦ��J���)
Punctanumberperframe = []; % �C�iimage����puncta�ӼƳ]���ůx�}

for j=1:n % n= image number

figure(1);
A = imread(TifFileList(j).name);
[ImgResult,PkTable] = DeconvFindPk (A,2,1,75); % �Nimage�HDeconv.m��smoothing,�ñҰʰ�peak finding
imshow(A);

figure(2);
X = PkTable(:,1);
Y = PkTable(:,2);
plot(X,640-Y,'rs');
axis([0 640 0 640]);
length(X);


figure(3);  % �bimage�W�I�Xpeak��m
imshow(A);
axis on
hold on;
plot(X,Y,'rs');
end

Punctanumberperframe = [length(X);Punctanumberperframe];
sum(Punctanumberperframe)/n;
