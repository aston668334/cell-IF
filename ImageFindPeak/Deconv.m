function [ImgResult] = Deconv (Img,n,FltSigma)
%% The file deconvolute image with filter and find peaks in a image
% input:           Img     :    Image to be analyzed
%                  n       :    (size of filter)*(1/2)
%                  FltSigma:    Sigma of filter 
% output:          ImgResult  : image after deconvolution
%%
Img = double(Img);
Xsize = size(Img,2);
Ysize = size(Img,1);

%  Generate Kxy = exp()/Sum  - 1/(2n+1)^2
[X,Y] = meshgrid(-n:n,-n:n);
Z = exp((-X.^2-Y.^2)/(2.*FltSigma.^2));clear X Y FltSigma
k = sum(Z); k = sum(k.');
Kxy = (Z./k)-(2*n+1)^(-2);
clear Z k
% Deconvolute Image with Filter Kxy
ImgResult = Img;
for Xpos = n+1:Xsize-n
    ConvSquLine = Img(:,Xpos-n:Xpos+n);
    for Ypos = n+1:Ysize-n
        ConvSqu = ConvSquLine(Ypos-n:Ypos+n,:);
        ImgDivalue = sum(sum(ConvSqu.*Kxy).');
        ConvSquLine(Ypos,n+1) = ImgDivalue;
    end
    ImgResult(:,Xpos) = ConvSquLine(:,n+1);
end
ImgResult = (ImgResult-min(min(ImgResult)))/max(max(ImgResult))*(max(max(Img))-(min(min(Img))));
end