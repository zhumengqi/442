function [new_img, num_inliers, inlier_position, T, xmin, ymin] = stitch_images_2(img1, img2)

	% Return a new complete image that stitches the two input images together
	% If the two images cannot be stitched together, return 0
    
    % 1. convert to double and grayscale
    DoubledImage = im2double(img1);imgray1 = rgb2gray(DoubledImage);
    DoubledImage = im2double(img2);imgray2 = rgb2gray(DoubledImage);
    % 5. select putative matches
    do_visualization = false;
    [x1, y1, x2, y2] = get_matches(imgray1, imgray2, do_visualization);
    % 6. run RANSAC to estimate a homography mapping and find the inlier
    % matches
    [T, num_inliers, avg_residual] = get_transform(x1, y1, x2, y2);
    A = [x1, y1]; B = [x2, y2]; N = size(x1,1);
    TransfB = (T*[A, ones(size(x1,1),1)]')';
    TransfB = TransfB./repmat(TransfB(:,3),[1 3]);
    distancetemp = (B(:,1)-TransfB(:,1)).^2 + (B(:,2)-TransfB(:,2)).^2;
    threshold = 100;
    mask = distancetemp<=threshold;
    if num_inliers == 0
        new_img = 0;
    end
    inlierA = A(mask,:);
    inlierB = B(mask,:);
    % 7. wrap one image (img1) onto the other (img2)
    tform =  maketform('projective', T');
    [imgleft,xdata,ydata] = imtransform(img1, tform);
    xmin = min(xdata(1),1); xmax = max(xdata(2), size(img2,2)); xdata = [xmin, xmax];
    ymin = min(ydata(1),1); ymax = max(ydata(2), size(img2,1)); ydata = [ymin, ymax];
    imgleft = imtransform(img1,tform,'XData',xdata,'Ydata',ydata);
    imgright = imtransform(img2,maketform('projective',eye(3)),'XData',xdata,'Ydata',ydata);
    new_img = im2double(imgleft) + im2double(imgright);
    new_img(im2double(imgleft)~=0 & im2double(imgright)~=0) = new_img(im2double(imgleft)~=0 & im2double(imgright)~=0)/2;
    inlier_position = [inlierB(:,1)+abs(xmin), inlierB(:,2)+abs(ymin)];
end