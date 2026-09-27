function [M,U,S,V,F] = estimate_F_DLT(x1s,x2s)
    M=zeros(size(x1s,2),9);
    for i=1:size(x1s,2)
        M(i,:) = reshape((x2s(:,i)*x1s(:,i)')',[1,9]);
    end 
    [U,S,V] = svd(M);
    F = reshape(V(:,end),[3,3])';
end