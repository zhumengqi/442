function [x1, y1, x2, y2] = get_matches(img1, img2, do_visualization)

	% Return matched x,y locations across the two images. The point defined by (x1,y1) in
	% img1 should correspond to the point defined by (x2,y2) in img2.
    
    % 3. form feature descriptors (SIFT descriptor)
    [feats1, x1, y1] = get_feats(img1);
    [feats2, x2, y2] = get_feats(img2);
    
    % 4. compute distances between every descriptor
    Distance = dist2(feats1, feats2);
    
    % 5. select putative matches
    threshold = 200;    
    [Y,I] = sort(Distance(:));
%     [i,j] = find(Distance<=Y(threshold));
    I = I(1:threshold,1);
    [i, j] = ind2sub(size(Distance),I);
    x1=x1(i);
    y1=y1(i);
    x2=x2(j);
    y2=y2(j); 

	if do_visualization 
		% You must implement this.
		% Display a single figure with the two input images side-by-side.
		% Visualize the features your method has found with some way of showing
		% the corresponding matches.
        img = [img1, img2];
        imshow(img);
        hold on;
        scatter(x1,y1,'x');
        scatter(x2+size(img1,2),y2,'x');
        
	end

end

