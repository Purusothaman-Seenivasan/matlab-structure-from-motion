function H = estimate_H_DLT(xs, ys)
    M = zeros(2 * size(xs, 2), 9);
    for i = 1:size(xs, 2)
        x = xs(:, i);
        y = ys(:, i);
        M(2 * i - 1, :) = [x' 0 0 0 -y(1) * x'];
        M(2 * i, :) = [0 0 0 x' -y(2) * x'];
    end

    [~, ~, V] = svd(M);
    v = V(:, end);
    H = reshape(v, [3, 3])';
end
