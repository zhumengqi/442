function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object
Fx=-surfaceNormals(:,:,1)./surfaceNormals(:,:,3);
Fy=-surfaceNormals(:,:,2)./surfaceNormals(:,:,3);
[h,w]=size(Fx);
switch method
    case 'column'
        temp3=repmat(cumsum(Fy(:,1),1),[1 w]);
        temp4=cumsum(Fx,2);
        heightMap=temp3+temp4;  
    case 'row'
        temp1=repmat(cumsum(Fx(1,:),2),[h 1]);
        temp2=cumsum(Fy,1);
        heightMap=temp1+temp2;   
    case 'average'
        temp1=repmat(cumsum(Fx(1,:)),[h 1]);
        temp2=cumsum(Fy,1);
        temp3=repmat(cumsum(Fy(:,1)),[1 w]);
        temp4=cumsum(Fx,2);
        heightMap=0.5*(temp1+temp2+temp3+temp4); 
    case 'random'
        heightMap=zeros(h,w); kk=100;
        for time=1:kk
        heightMaptemp=zeros(h,w);
        heightMaptemp(:,1)=cumsum(Fy(:,1),1);
        heightMaptemp(1,:)=cumsum(Fx(1,:),2);
        for i=2:h
            for j=2:w
                A=[zeros(1,i-1) ones(1,j-1)];B=randperm(size(A,2));C=A(1,B);
                currentPosition=ones(1,2);
                for k=1:i+j-2
                    if C(k)==0
                        heightMaptemp(i,j)=heightMaptemp(i,j)+Fy(currentPosition(1)+1,currentPosition(2));
                        currentPosition(1)=currentPosition(1)+1;
                    else
                        heightMaptemp(i,j)=heightMaptemp(i,j)+Fx(currentPosition(1),currentPosition(2)+1);
                        currentPosition(2)=currentPosition(2)+1;
                    end
                end
            end
        end
        heightMap=heightMap+heightMaptemp;
        end
        heightMap=(1/kk)*heightMap;
end

