function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this
end

%--------------------------------------------------------------------------
%                          Baseline demosaicing algorithm. 
%                          The algorithm replaces missing values with the
%                          mean of each color channel.
%--------------------------------------------------------------------------
function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
mosim = demosaicBaseline(im);
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
RedChannel = zeros(imageHeight, imageWidth);
RedChannel(1:2:end,1:2:end) = mosim(1:2:end,1:2:end,1); RedO=RedChannel;
RedChannel = RedChannel+circshift(RedChannel,[1,0])+circshift(RedChannel,[0,1])+circshift(RedChannel,[1,1]);
RedChannel(:,1)=RedO(:,1)+circshift(RedO(:,1),[1,0]);
RedChannel(1,:)=RedO(1,:)+circshift(RedO(1,:),[0,1]);
if mod(imageHeight,2)==1
    RedChannel(end,:)=RedO(end,:)+circshift(RedO(end,:),[0,1]);
end
if mod(imageWidth,2)==1
    RedChannel(:,end)=RedO(:,end)+circshift(RedO(:,end),[1,0]);
end
mosim(:,:,1) = RedChannel;

% Blue channel (even rows and colums);

BlueChannel = zeros(imageHeight, imageWidth);
BlueChannel(2:2:end,2:2:end) = mosim(2:2:end,2:2:end,3); BlueO=BlueChannel;
BlueChannel = BlueChannel+circshift(BlueChannel,[-1,0])+circshift(BlueChannel,[0,-1])+circshift(BlueChannel,[-1,-1]);
BlueChannel(:,end)=BlueO(:,end)+circshift(BlueO(:,end),[-1,0]);
BlueChannel(end,:)=BlueO(end,:)+circshift(BlueO(end,:),[0,-1]);
if mod(imageHeight,2)==1
    BlueChannel(end,:)=BlueChannel(end-1,:);
end
if mod(imageWidth,2)==1
    BlueChannel(:,end)=BlueChannel(:,end-1);
end
mosim(:,:,3) = BlueChannel;

    
% Green channel (remaining places)
GreenO1=zeros(imageHeight, imageWidth); GreenO2=zeros(imageHeight, imageWidth);
GreenO1(2:2:end,1:2:end)=mosim(2:2:end,1:2:end,2); GreenO2(1:2:end,2:2:end)=mosim(1:2:end,2:2:end,2);
GreenChannel=GreenO1+GreenO2;
GreenChannel=GreenChannel+circshift(GreenChannel,[0,1]);
mosim(:,:,2)=GreenChannel;

%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
mosim = demosaicBaseline(im);
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
RedO=zeros(imageHeight, imageWidth); RedO(1:2:end,1:2:end)=mosim(1:2:end,1:2:end,1);
RedT=circshift(RedO,[1,0]); RedB=circshift(RedO,[-1,0]);
RedBT=0.5*(RedT+RedB);
RedL=circshift(RedO,[0,1]); RedR=circshift(RedO,[0,-1]);
RedLR=0.5*(RedL+RedR);
RedCenter=0.25*(circshift(RedO,[1,1])+circshift(RedO,[-1,1])+circshift(RedO,[1,-1])+circshift(RedO,[-1,1]));
RedChannel=RedO+RedBT+RedLR+RedCenter;
RedChannel(:,1)=RedO(:,1)+circshift(RedO(:,1),[1,0]); RedChannel(:,end)=RedO(:,end)+circshift(RedO(:,end),[1,0]);
RedChannel(1,:)=RedO(1,:)+circshift(RedO(1,:),[0,1]); RedChannel(end,1)=RedO(end,1)+circshift(RedO(end,1),[0,1]);
mosim(:,:,1)=RedChannel;

% Blue channel
BlueO=zeros(imageHeight, imageWidth); BlueO(2:2:end,2:2:end)=mosim(2:2:end,2:2:end,3);
BlueT=circshift(BlueO,[1,0]); BlueB=circshift(BlueO,[-1,0]);
BlueBT=0.5*(BlueT+BlueB);
BlueL=circshift(BlueO,[0,1]); BlueR=circshift(BlueO,[0,-1]);
BlueLR=0.5*(BlueL+BlueR);
BlueCenter=0.25*(circshift(BlueO,[1,1])+circshift(BlueO,[-1,-1])+circshift(BlueO,[-1,1])+circshift(BlueO,[1,-1]));
BlueChannel=BlueO+BlueBT+BlueLR+BlueCenter;
BlueChannel(:,1)=BlueO(:,2)+0.5*(circshift(BlueO(:,2),[-1,0])+circshift(BlueO(:,2),[1,0])); 
BlueChannel(1,:)=BlueO(2,:)+0.5*(circshift(BlueO(2,:),[0,-1])+circshift(BlueO(2,:),[0,1])); 

mosim(:,:,3)=BlueChannel;

% Green channel
GreenO1=zeros(imageHeight, imageWidth); GreenO2=zeros(imageHeight, imageWidth);
GreenO1(2:2:end,1:2:end)=mosim(2:2:end,1:2:end,2); GreenO2(1:2:end,2:2:end)=mosim(1:2:end,2:2:end,2); GreenO=GreenO1+GreenO2;
GreenChannel1=0.25*(circshift(GreenO,[1,0])+circshift(GreenO,[-1,0])+circshift(GreenO,[0,1])+circshift(GreenO,[0,-1]));
GreenChannel=GreenChannel1+GreenO;
GreenChannel(:,1)=GreenO1(:,1)+1/3*(circshift(GreenO1(:,1),[1,0])+circshift(GreenO1(:,1),[-1,0])+GreenO2(:,2));
GreenChannel(1,:)=GreenO2(1,:)+1/3*(circshift(GreenO2(1,:),[0,1])+circshift(GreenO2(1,:),[0,-1])+GreenO1(2,:));
mosim(:,:,2)=GreenChannel;



%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
mosim = demosaicBaseline(im);
[imageHeight, imageWidth] = size(im);

% Red channel ;
RedO=zeros(imageHeight, imageWidth); RedO(1:2:end,1:2:end)=mosim(1:2:end,1:2:end,1);
RedT=circshift(RedO,[1,0]); RedB=circshift(RedO,[-1,0]);
RedBT=0.5*(RedT+RedB);
RedL=circshift(RedO,[0,1]); RedR=circshift(RedO,[0,-1]);
RedLR=0.5*(RedL+RedR);
RedCenter=0.25*(circshift(RedO,[1,1])+circshift(RedO,[-1,1])+circshift(RedO,[1,-1])+circshift(RedO,[-1,1]));
RedChannel=RedO+RedBT+RedLR+RedCenter;
RedChannel(:,1)=RedO(:,1)+circshift(RedO(:,1),[1,0]); RedChannel(:,end)=RedO(:,end)+circshift(RedO(:,end),[1,0]);
RedChannel(1,:)=RedO(1,:)+circshift(RedO(1,:),[0,1]); RedChannel(end,1)=RedO(end,1)+circshift(RedO(end,1),[0,1]);
mosim(:,:,1)=RedChannel;

% Blue channel
BlueO=zeros(imageHeight, imageWidth); BlueO(2:2:end,2:2:end)=mosim(2:2:end,2:2:end,3);
BlueT=circshift(BlueO,[1,0]); BlueB=circshift(BlueO,[-1,0]);
BlueBT=0.5*(BlueT+BlueB);
BlueL=circshift(BlueO,[0,1]); BlueR=circshift(BlueO,[0,-1]);
BlueLR=0.5*(BlueL+BlueR);
BlueCenter=0.25*(circshift(BlueO,[1,1])+circshift(BlueO,[-1,-1])+circshift(BlueO,[-1,1])+circshift(BlueO,[1,-1]));
BlueChannel=BlueO+BlueBT+BlueLR+BlueCenter;
BlueChannel(:,1)=BlueO(:,2)+0.5*(circshift(BlueO(:,2),[-1,0])+circshift(BlueO(:,2),[1,0])); 
BlueChannel(1,:)=BlueO(2,:)+0.5*(circshift(BlueO(2,:),[0,-1])+circshift(BlueO(2,:),[0,1])); 

mosim(:,:,3)=BlueChannel;

% Green Channel

GreenO1=zeros(imageHeight, imageWidth); GreenO2=zeros(imageHeight, imageWidth);
GreenO1(2:2:end,1:2:end)=mosim(2:2:end,1:2:end,2); GreenO2(1:2:end,2:2:end)=mosim(1:2:end,2:2:end,2); GreenO=GreenO1+GreenO2;
GreenOO=GreenO;

for i=2:2:imageHeight-1
    for j=2:2:imageWidth-1
        GreenO(i,j)=0.5*(GreenO(i-1,j)+GreenO(i+1,j));
        if abs(GreenO(i-1,j)+GreenO(i+1,j))>abs(GreenO(i,j-1)+GreenO(i,j+1))
            GreenO(i,j)=0.5*(GreenO(i,j-1)+GreenO(i,j+1));
        end
    end
end
for i=3:2:imageHeight-1
    for j=3:2:imageWidth-1
        GreenO(i,j)=0.5*(GreenO(i-1,j)+GreenO(i+1,j));
        if abs(GreenO(i-1,j)+GreenO(i+1,j))>abs(GreenO(i,j-1)+GreenO(i,j+1))
            GreenO(i,j)=0.5*(GreenO(i,j-1)+GreenO(i,j+1));
        end
    end
end
GreenO(:,1)=GreenO1(:,1)+1/3*(circshift(GreenO1(:,1),[1,0])+circshift(GreenO1(:,1),[-1,0])+GreenO2(:,2));
GreenO(1,:)=GreenO2(1,:)+1/3*(circshift(GreenO2(1,:),[0,1])+circshift(GreenO2(1,:),[0,-1])+GreenO1(2,:));
GreenO(end,:)=GreenOO(end,:)+(1/3)*(2*circshift(GreenOO(end,:),[0,1])+GreenOO(end-1,:));
GreenO(:,end)=GreenOO(:,end)+(1/3)*(2*circshift(GreenOO(:,end),[0,1])+GreenOO(:,end-1));
mosim(:,:,2)=GreenO;
