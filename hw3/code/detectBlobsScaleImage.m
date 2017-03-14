function blobs = detectBlobsScaleImage(im)
% clc,clear,close all;
% load im
% DETECTBLOBS detects blobs in an image
%   BLOBS = DETECTBLOBSCALEIMAGE(IM, PARAM) detects multi-scale blobs in IM.
%   The method uses the Laplacian of Gaussian filter to find blobs across
%   scale space. This version of the code scales the image and keeps the
%   filter same for speed. 
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

% basic parameters setting
DoubledImage = im2double(im);
imgray = rgb2gray(DoubledImage); 
[h,w] = size(imgray); 
sigma = 1.5; k=1/1.15; invk=1.15; n=16;

% create filter of fixed size
filter_halfsize=ceil(3*sigma); filter_size=1+2*filter_halfsize;    
Log_filter = fspecial('log',filter_size, sigma);

% create image of different(shrinked) size
imagerepo =cell(n,1); imagecache = imgray; imagerepo{1} = imagecache;
for i=2:n
    imagerepo{i}= imresize(imagecache, k^(i-1), 'lanczos2');
end

% compute Laplacian response for image(of different size)
Laplacian_response_repo = cell(n,1); 
scaleSpacetemp = cell(n,1); maxSpacetemp = cell(n,1); maxSpacetemp2=cell(n,1);
recovered_scaleSpacetemp = zeros(h,w,n);
% recovered_maxscaleSpacetemp = zeros(h,w,n);

for i=1:n
    Laplacian_response_repo{i} = conv2(imagerepo{i}, Log_filter, 'same');
    scaleSpacetemp{i} = abs(Laplacian_response_repo{i}); 
    maxSpacetemp{i} = ordfilt2(scaleSpacetemp{i},9,true(3)); 
    scaleSpacetemp{i}(scaleSpacetemp{i}~=maxSpacetemp{i})=0;
    recovered_scaleSpacetemp(:,:,i) = imresize(scaleSpacetemp{i}, [h w], 'lanczos2');
  
end
% compute score, blob position, etc.
[maxSpace,level] = max(recovered_scaleSpacetemp,[],3);
search_radius = ceil(sigma*invk^(n-1));
temp1=ordfilt2(maxSpace, search_radius^2, true(search_radius));
maxSpace(maxSpace~=temp1)=0;
[ii, jj, val] = find(maxSpace);
idx = sub2ind([h, w], ii, jj);
radius = sqrt(2)*sigma*invk.^(level(idx)-1);
blobs = [jj, ii, radius, val];



% Dummy - returns a blob at the center of the image
% blobs = round([size(im,2)*0.5 size(im,1)*0.5 0.25*min(size(im,1), size(im,2)) 1]);