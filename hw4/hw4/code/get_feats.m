function [feats, x, y] = get_feats(img)
    
	% Return an N x M matrix of features, along with the corresponding x,y
	% locations of the detected features.

	% N and M both depend on what method of feature detection you choose to use.
	% N = number of features found
	% M = feature vector length
    
    % 2. detect feature points in both images
    sigma = 3;
    thresh = 0.01;
    radius = 3;
    disp = 0;
    [~,y,x] = harris(img, sigma, thresh, radius, disp);
    % 3. form feature descriptors (SIFT descriptor)
    circles = [x,y,radius*ones(size(x))];
    enlarge_factor = 1.5;
    feats = find_sift(img, circles, enlarge_factor);
    

end
