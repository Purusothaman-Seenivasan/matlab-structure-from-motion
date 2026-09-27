function [x1n,x2n] = sift_points(K,f1,f2,d1,d2)
    [matches,~] = vl_ubcmatch(d1,d2);
    x1 = [f1(1,matches(1,:)); f1(2,matches(1,:)); ones(1,size(f1(2,matches(1,:)),2))];
    x2 = [f2(1, matches(2, :)); f2(2, matches(2, :)); ones(1, size(f2(2,matches(2, :)), 2))];

    x1n  = inv(K)*x1;
    x2n  = inv(K)*x2;

end
 