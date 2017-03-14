function new_img = stitch_multiple_images(imgs)

	% Given a set of images in any order, stitch them together into a final panorama
	% Example call: stitch_multiple_images({img1, img2, img3})
    img1 = imgs{1};
    img2 = imgs{2};
    img3 = imgs{3};
    imgray1 = rgb2gray(im2double(img1));
    imgray2 = rgb2gray(im2double(img2));
    imgray3 = rgb2gray(im2double(img3));
    % decide which two images should be stitched together
    do_visualization = false;
    [x1, y1, x2, y2] = get_matches(imgray1, imgray2, do_visualization);
    [~, num_inliers12, avg_residual12] = get_transform(x1, y1, x2, y2);
    [x1, y1, x3, y3] = get_matches(imgray1, imgray3, do_visualization);
    [~, num_inliers13, avg_residual13] = get_transform(x1, y1, x3, y3);
    [x2, y2, x3, y3] = get_matches(imgray2, imgray3, do_visualization);
    [~, num_inliers23, avg_residual23] = get_transform(x2, y2, x3, y3);
    if (num_inliers23 < num_inliers12 && num_inliers23 < num_inliers13)
        % situation 1: 2,3 cannot be stitched together
        [img31, num_inliers, inlier_position31, ~, ~, ~] = stitch_images_2(img3, img1); 
        [img312, num_inliers, inlier_position12, T, xmin, ymin] = stitch_images_2(img31, img2);
        new_inlier_position31 = (T*[inlier_position31, ones(size(inlier_position31,1),1)]')';
        new_inlier_position31 = new_inlier_position31./repmat(new_inlier_position31(:,3),[1 3]);
        new_inlier_position31 = [new_inlier_position31(:,1)+abs(xmin), new_inlier_position31(:,2)+abs(ymin)];        
        new_img = img312;
        imshow(img312); figure();
        imshow(img312); hold on; 
        scatter(new_inlier_position31(:,1),new_inlier_position31(:,2),'ro'); hold on;
        scatter(inlier_position12(:,1),inlier_position12(:,2),'go'); hold on;
        title('situation 1: 2,3 are not stitched together');
        
    elseif (num_inliers13 < num_inliers12 && num_inliers13 < num_inliers23)
        % situation 2: 1,3 are not be stitched together
        [img12, num_inliers, inlier_position12, ~, ~, ~] = stitch_images_2(img1, img2);
        [img123, num_inliers, inlier_position23, T, xmin, ymin] = stitch_images_2(img12, img3);
        new_inlier_position12 = (T*[inlier_position12, ones(size(inlier_position12,1),1)]')';
        new_inlier_position12 = new_inlier_position12./repmat(new_inlier_position12(:,3),[1 3]);
        new_inlier_position12 = [new_inlier_position12(:,1)+abs(xmin), new_inlier_position12(:,2)+abs(ymin)];
        new_img = img123;
        imshow(img123); figure();
        imshow(img123); hold on; 
        scatter(new_inlier_position12(:,1),new_inlier_position12(:,2),'ro'); hold on;
        scatter(inlier_position23(:,1),inlier_position23(:,2),'go'); hold on;
        title('situation 2: 1,3 are not stitched together');
    else
        % situation 3: 1,2 cannot be stitched together
        [img13, num_inliers, inlier_position13] = stitch_images_2(img1, img3);
        [img132, num_inliers, inlier_position32, T, xmin, ymin] = stitch_images_2(img13, img2);
        new_inlier_position13 = (T*[inlier_position13, ones(size(inlier_position13,1),1)]')';
        new_inlier_position13 = new_inlier_position13./repmat(new_inlier_position13(:,3),[1 3]);
        new_inlier_position13 = [new_inlier_position13(:,1)+abs(xmin), new_inlier_position13(:,2)+abs(ymin)];
        new_img = img132;
        imshow(img132); figure();
        imshow(img132); hold on; 
        scatter(new_inlier_position13(:,1), new_inlier_position13(:,2),'ro'); hold on;
        scatter(inlier_position32(:,1),inlier_position32(:,2),'go'); hold on;
        title('situation 3: 1,2 are not stitched together');
    end
    
end