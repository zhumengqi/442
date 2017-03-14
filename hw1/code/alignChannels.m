function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));
m=size(im,1);n=size(im,2);

% Dummy implementation (replace this with your own)
predShift = zeros(2, 2);
imShift = im;
Red=im(:,:,1);Green=im(:,:,2);Blue=im(:,:,3);
max=sum(sum(Red.*Green));
for i=-maxShift(1):maxShift(1)    
    for j=-maxShift(2):maxShift(2)
       Greennew=circshift(Green,[i j]);
       Product=sum(sum(Red.*Greennew));
       if Product>max
           max=Product;
           predShift(1,1)=i;predShift(1,2)=j;
           imShift(:,:,2)=Greennew;
       end
    end    
end
max=sum(sum(Red.*Blue));
for i=-maxShift(1):maxShift(1)
    for j=-maxShift(2):maxShift(2)
       Bluenew=circshift(Blue,[i j]);
       Product=sum(sum(Red.*Bluenew));
       if Product>max
           max=Product;
           predShift(2,1)=i;predShift(2,2)=j;
           imShift(:,:,3)=Bluenew;
       end
    end
end
