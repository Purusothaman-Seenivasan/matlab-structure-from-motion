function Rs_abs = compute_absolute_rotations(K, img_names, f_fs, ds, ep_thresh, h_thresh)
    % Compute relative rotations
    Rs = compute_relative_rotations(K, img_names, f_fs, ds, ep_thresh, h_thresh);

    % Compute absolute rotations
    Rs_abs = calculate_absolute_rotations(Rs);
end