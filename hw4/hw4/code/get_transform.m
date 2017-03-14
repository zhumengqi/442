function [T, num_inliers, avg_residual] = get_transform(x1, y1, x2, y2)

	% Do RANSAC to determine the best transformation between the matched coordinates
	% provided by (x1,y1,x2,y2).

	% Return the transformation, the number of inliers, and average residual
    
    % 6. run RANSAC to estimate a homography mapping
    M1 = [x1, y1]; M2 = [x2, y2];
    N=size(x1,1);
    M=4; 
    n=20000;    % iteration times
    threshold = 10;    % threshold between inliers and outliers
    num_inliers = 0;
    avg_residual = 0;
    T=zeros(3,3);
    for i = 1:n
        sdindx = randperm(N,M);
        A = [x1(sdindx), y1(sdindx)];
        B = [x2(sdindx), y2(sdindx)];
        H = get_transMatrix(A,B);
        TransM2 = (H*[x1, y1, ones(N,1)]')';
        TransM2 = TransM2./repmat(TransM2(:,3),[1 3]);
        distancetemp = (x2-TransM2(:,1)).^2 + (y2-TransM2(:,2)).^2;
        mask = distancetemp<=threshold;
        residualtemp = mask.*distancetemp;
        num_inlierstemp = sum(mask);
        avg_residualtemp = sum(residualtemp)/num_inlierstemp;
        if num_inlierstemp > num_inliers
            inlierM1 = M1(mask,:);
            inlierM2 = M2(mask,:);
            T = get_transMatrix(inlierM1, inlierM2);
            num_inliers = num_inlierstemp;
            avg_residual = avg_residualtemp^0.5;
        end        
    end
    

end
