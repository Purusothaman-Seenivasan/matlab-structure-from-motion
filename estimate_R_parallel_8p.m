function [R, T, best_X, inliers_idx] = estimate_R_parallel_8p(x1, x2, e_threshold, h_threshold)
    alpha = 0.9;
    epsilon_e = 0.1;
    sam_num_e = 8;

    T_e = find_T(alpha,epsilon_e, sam_num_e);

    itr_e = 0;

    n = size(x1, 2);

    while itr_e <= T_e
        itr_e = itr_e + 1;
        rand_indices = randperm(n, sam_num_e);

        [~, ~, ~, ~, E_n] = estimate_F_DLT(x1(:, rand_indices), x2(:, rand_indices));
        bE_n = enforce_essential(E_n);

        errors_e = 1/2 * (compute_epipolar_errors(bE_n', x2, x1).^2 + compute_epipolar_errors(bE_n, x1, x2).^2);

        inliners_e = errors_e < e_threshold^2;

        temp_inl_e = find(inliners_e > 0);

        inl_num_e = size(temp_inl_e, 2);

        n_epsilon_e = inl_num_e / n;

        if n_epsilon_e > epsilon_e
            epsilon_e = n_epsilon_e;
            best_E = bE_n;
            inliers_idx = temp_inl_e;
            T_e = find_T(alpha,epsilon_e, sam_num_e);
            itr_e = 0;
            [P2, best_X, ~, ~, ~] = optimal_P2_and_X_from_E(best_E, x1(:, inliers_idx), x2(:, inliers_idx));

            R = P2(:, 1:3);
            T = P2(:, 4);
        end
    end

    fprintf("R estimated from 8 point method\n");
end
