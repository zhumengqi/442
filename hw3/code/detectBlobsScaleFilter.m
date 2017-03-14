function blobs = detectBlobsScaleFilter(im)
% clc,clear,close all;
% load im
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSSCALEFILTER(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the filter and keeps the
%   image same which is slow for big filters.
% 
% Input:
%   IM - input image
%
% Ouput:
%   BLOBS - n x 4 array with blob in each row in (x, y, radius, score)
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2014
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 3: Blob detector
DoubledImage = im2double(im);
imgray = rgb2gray(DoubledImage); 
[h,w] = size(imgray); 
k=1.15;
sigmazero = 1.5; sigma = sigmazero/k;  n=16;
scaleSpacetemp = zeros(h, w, n); maxscalespacetemp = zeros(h,w,n);
for i= 1:n
    sigma = sigma*k; 
    if n<6
    csigma=2*ceil(1.4*sigma)+1;
    else
        if n<9
            csigma=2*ceil(sigma)+1;
        else
            csigma=2*ceil(0.8*sigma)+1;
        end
    
    end
    filter_halfsize=ceil(3*sigma); filter_size=1+2*filter_halfsize; 
    Log_filter = fspecial('log',filter_size, sigma);
    tempSpace = imfilter(imgray, Log_filter, 'same', 'replicate', 'corr')* sigma^2;
    temp1=abs(tempSpace);
    temp2=ordfilt2(temp1, csigma^2, true(csigma)); maxscalespacetemp(:,:,i)=temp2;
    temp1(temp1~=temp2)=0;
    scaleSpacetemp(:,:,i) = temp1;
end
[maxSpace,level] = max(scaleSpacetemp,[],3); temp2=max(maxscalespacetemp,[],3);
search_radius = ceil(sigma/k);
temp1=ordfilt2(maxSpace, search_radius^2, true(search_radius));
maxSpace(maxSpace~=temp2)=0;
[ii, jj, val] = find(maxSpace);
idx = sub2ind([h, w], ii, jj);
radius = sqrt(2)*sigmazero*k.^(level(idx)-1);
blobs = [jj, ii, radius, val];
    


