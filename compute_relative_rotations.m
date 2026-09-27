function Rs = compute_relative_rotations(K, img_names, f_fs, ds, ep_thresh, h_thresh)
    num_images = numel(img_names);
    Rs = cell(1, num_images);
    Rs{1} = eye(3); % Initial rotation is identity

    for i = 1:num_images - 1
        f1 = f_fs{i};
        f2 = f_fs{i + 1};
        d1 = ds{i};
        d2 = ds{i + 1};

        [x1_n, x2_n] = sift_points(K, f1, f2, d1, d2);
        [R, ~, ~, ~] = estimate_R_parallel(x1_n, x2_n, ep_thresh, h_thresh);
        Rs{i + 1} = R;
    end
end