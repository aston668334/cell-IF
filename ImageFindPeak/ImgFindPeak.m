function [PkTable] = ImgFindPeak(varargin)
%% This file find all peaks in a single image, using PeakDetOneD function
% input:       Img, Delta(optional), BorderSize(optional)
% output:      PKTable
%%


Img = double(varargin{1,1});

if size(varargin,2)<2  % 如果沒有輸入delta值的話，就把整張圖的(最亮值減最暗值/10)當作delta
    Delta = (max(max(Img))-min(min(Img)))/10;
else
    Delta = varargin{1,2};
end

if size(varargin,2)<3  %如果沒有輸入邊界值的話，邊界值就當作0
    BorderSize = 0;
else
    BorderSize = varargin{1,3};
end

% find peaks         ##peak detection:  http://billauer.co.il/peakdet.html
Xsize = size(Img,2);
Ysize = size(Img,1);
[X,Y] = meshgrid(1:Xsize,1:Ysize);  
X_Y = cat(3,X,Y);
ImgData = cat(3,X_Y,Img);%  combine X-axis, Y-axis & ImgData 把XY座標和亮度值結合成一個三維矩陣
clear X; clear Y;


% scan row by row
PkTable = [];
for ScanYpos = 2:Ysize-1     
    maxtab = PeakDetOneD(ImgData(ScanYpos,:,3), Delta, X_Y(1,:,1));
    % If peak found in this row compare Pk intensity with adjacent row
      maxtab2 = [];
    if size(maxtab,1) ~= 0         
      for PkName = 1:size(maxtab,1)
          if(maxtab(PkName,2)>ImgData(ScanYpos+1,maxtab(PkName,1),3))...  % compare
              && (maxtab(PkName,2)>ImgData(ScanYpos-1,maxtab(PkName,1),3))
            maxtab2 = [maxtab2;maxtab(PkName,1),ScanYpos,maxtab(PkName,2)];
          end
      end
    end
    PkTable = [PkTable;maxtab2];
end
clear ImgData X_Y Xsize Ysize maxtab maxtab2 PkName ScanYpos


% exclude border peaks
if BorderSize ~= 0
    PkTable2 = [];
    for i = 1:size(PkTable,1)
        if PkTable(i,1)>BorderSize && PkTable(i,2)>BorderSize...
                 &&PkTable(i,1)<size(Img,2)-BorderSize...
                 &&PkTable(i,2)<size(Img,1)-BorderSize
             PkTable2 = [PkTable2;PkTable(i,:)];
        end
    end
    PkTable = PkTable2;
end
end