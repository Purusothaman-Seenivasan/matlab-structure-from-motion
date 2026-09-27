function [best_P, inliers_idx] = estimate_T_robust_2p_new(xn, X, K, R, err_th)
    alpha = 0.99;
    eps = 0.1;
    sample_num = 2;

    T = find_T(alpha, eps, sample_num);

    iter_cnt = 0;
    real_iter_cnt = 0;

    best_P = [];
    inliers_idx = [];

    while iter_cnt <= T
        iter_cnt = iter_cnt + 1;
        real_iter_cnt = real_iter_cnt + 1;

        rand_idx = randperm(size(xn, 2), sample_num);

        t = estimate_T_DLT(R, xn(:, rand_idx), X(:, rand_idx));
        P = [R t];
        y_h = pflat(P * [X; ones(1, size(X, 2))]);

        delta = y_h - xn;
        delta = delta.^2;
        errs = delta(1, :) + delta(2, :);

        inliers = errs < err_th^2;
        temp_inliers_idx = find(inliers > 0);

        inlier_count = numel(temp_inliers_idx);

        n_eps = inlier_count / size(xn, 2);
        if n_eps > eps
            eps = n_eps;
            best_P = P;
            inliers_idx = temp_inliers_idx;
            T = find_T(alpha, eps, sample_num);
            iter_cnt = 0;
        end
    end

    if isempty(best_P)
        best_P = [R zeros(3, 1)]; % Default: No translation if no inliers
    end
end
