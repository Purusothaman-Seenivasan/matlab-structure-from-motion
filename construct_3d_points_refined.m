function [ref_X, match_D, match_p, img_D] = construct_3d_points_refined(K, img_names, init_pair, f_fs, ds, ep_thresh, h_thresh, Rs_abs)
    project_data = fileparts(mfilename('fullpath'));
    image_1 = imread(fullfile(project_data,img_names{init_pair(1)}));

    % Extract features and descriptors for initial pair
    f1 = f_fs{init_pair(1)};
    f2 = f_fs{init_pair(2)};
    d1 = ds{init_pair(1)};
    d2 = ds{init_pair(2)};

    % Match features between the two images
    [matches, ~] = vl_ubcmatch(d1, d2);
    x1 = [f1(1, matches(1, :)); f1(2, matches(1, :)); ones(1, size(f1(2, matches(1, :)), 2))];
    [x1n, x2n] = sift_points(K, f1, f2, d1, d2);

    % Estimate the initial 3D point reconstruction
    disp("Estimating for initial 3D point reconstruction");
    [R, T, X, inliers_idx] = estimate_R_parallel(x1n, x2n, ep_thresh, h_thresh);
    P2 = [R, T];
    P1 = [eye(3), zeros(3, 1)];

    % Refine the 3D points using an iterative process
    x1_nf = x1n(:, inliers_idx);
    x2_nf = x2n(:, inliers_idx);
    last_delta_X_n = 0;

    for i = 1:size(X, 2)
        mu = 0.01;
        while true
            [r, J] = LinearizeReprojErr(P1, P2, X(:, i), x1_nf(:, i), x2_nf(:, i));
            delta_X = ComputeUpdate(r, J, mu);
            [err, ~] = ComputeReprojectionError(P1, P2, X(:, i), x1_nf(:, i), x2_nf(:, i));
            [err_p, ~] = ComputeReprojectionError(P1, P2, X(:, i) + delta_X, x1_nf(:, i), x2_nf(:, i));

            if err_p < err
                X(:, i) = X(:, i) + delta_X;
                mu = mu / 10;
            else
                mu = mu * 10;
            end

            delta_delta_X = delta_X' * delta_X;
            if abs(last_delta_X_n - delta_delta_X) < 1e-10
                break;
            end

            last_delta_X_n = delta_delta_X;
        end
    end

    ref_X = Rs_abs{init_pair(1)}' * X(1:3, :);
    d1_matches = d1(:, matches(1, :));
    match_p = x1(:, inliers_idx);
    match_D = d1_matches(:, inliers_idx);
    img_D = image_1;
end
