function [Ps, Xs, xs] = compute_camera(K, img_names, ref_X, f_fs, ds, match_D, match_p, t_thresh, Rs_abs)

    numImages = size(img_names, 2);

    Ps = cell(1, numImages);
    xs = cell(1, numImages);
    Xs = cell(1, numImages);

    invK = inv(K);

    for i = 1:numImages

        fi = f_fs{i};
        di = ds{i};

        [matches, ~] = vl_ubcmatch(di, match_D);

        xi = [fi(1, matches(1, :)); fi(2, matches(1, :)); ones(1, size(fi(2, matches(1, :)), 2))];
        xm = match_p(:, matches(2, :));

        xi = invK * xi;

        Xi = ref_X(:, matches(2, :));

        [Ps{i}, inliers_t_idx] = estimate_T_robust_2p_new(xi, Xi, K, Rs_abs{i}, t_thresh);

        Xs{i} = Xi(:, inliers_t_idx);
        xs{i} = xi(:, inliers_t_idx);

    end

end
