function H = get_transMatrix(A,B)
    n = size(A,1);
    A = [A, ones(n,1)];
    B = [B, ones(n,1)];
    AA = zeros(2*n,9);
    i = 1:n;
    AA(2*i,1:3) = A;
    AA(2*i-1,4:6) = A;
    AA(2*i,7:9) = -repmat(B(:,1),[1 3]).*A;
    AA(2*i-1,7:9) = -repmat(B(:,2),[1 3]).*A;
    [~,~,V] = svd(AA); x=V(:,end);
    H = reshape(x,[3,3]);
    H=H';
end


