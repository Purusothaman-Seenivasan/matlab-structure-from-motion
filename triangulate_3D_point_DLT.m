function X = triangulate_3D_point_DLT(x1, x2, P1, P2)
    M = [
        P1(1, :) - x1(1) * P1(3, :); ...
        P1(2, :) - x1(2) * P1(3, :); ...
        P2(1, :) - x2(1) * P2(3, :); ...
        P2(2, :) - x2(2) * P2(3, :);
    ];

    [U, S, V] = svd(M);
    X = V(:, end);
end
