function output = prepareData(imArray, ambientImage)
% PREPAREDATA prepares the images for photometric stereo
%   OUTPUT = PREPAREDATA(IMARRAY, AMBIENTIMAGE)
%
%   Input:
%       IMARRAY - [h w n] image array
%       AMBIENTIMAGE - [h w] image 
%
%   Output:
%       OUTPUT - [h w n] image, suitably processed
%
% Author: Subhransu Maji
%

% Implement this %
% Step 1. Subtract the ambientImage from each image in imArray
% Step 2. Make sure no pixel is less than zero
% Step 3. Rescale the values in imarray to be between 0 and 1

[h,w,n]=size(imArray);
lightImage=imArray-repmat(ambientImage,[1 1 n]);
lightImage=lightImage.*(lightImage>0);
output=zeros(h,w,n);
lightmax=repmat(max(max(lightImage)),[h w 1]);
output=lightImage./lightmax;


%normalize forloop version
% for i=1:n
%     output(:,:,i)=lightImage(:,:,i)/max(max(lightImage(:,:,i)));
% end
% output=lightImage/255;

