function [R, T, best_X, inliers_idx] = estimate_R_parallel(x1, x2, e_threshold, h_threshold)
    alpha = 0.9;
    epsilon_e = 0.1;
    epsilon_h = 0.1;
    sam_num_e = 8;
    sam_num_h = 4;

    T_e = find_T(alpha,epsilon_e, sam_num_e);
    T_h = find_T(alpha,epsilon_h, sam_num_h);

    itr_e = 0;
    itr_h = 0;

    n = size(x1, 2);

    flag = 0;

    while itr_e <= T_e || itr_h <= T_h

        if itr_e <= T_e
            itr_e = itr_e + 1;
            rand_indices = randperm(n, sam_num_e);

            [~, ~, ~, ~, E_n] = estimate_F_DLT(x1(:, rand_indices), x2(:, rand_indices));
            bE_n = enforce_essential(E_n);

            errors_e = 1/2 * (compute_epipolar_errors(bE_n', x2, x1).^2 + compute_epipolar_errors(bE_n, x1, x2).^2) ;

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
                flag = 0;
            end
        end

        if itr_h <= T_h
            itr_h = itr_h + 1;
            rand_indices = randperm(n, sam_num_h);
            H = estimate_H_DLT(x1(:, rand_indices), x2(:, rand_indices));
            y_h = pflat(H * x1);
            delta_v = y_h - x2;
            delta_v = delta_v.^2;
            errors = delta_v(1, :) + delta_v(2, :);

            inliners_h = errors < h_threshold^2;
            temp_inl_h = find(inliners_h > 0);

            inl_num_h = size(temp_inl_h, 2);

            n_epsilon_h = inl_num_h / n;
            if n_epsilon_h > epsilon_h
                [R1, t1, R2, t2] = homography_to_RT(H, x1, x2);
                E1 = skew_m(t1) * R1;
                E1 = enforce_essential(E1);
                [P2_1, ~, ~, ~, count_1] = optimal_P2_and_X_from_E(E1, x1(:, temp_inl_h), x2(:, temp_inl_h));

                E2 = skew_m(t2) * R2;
                E2 = enforce_essential(E2);
                [P2_2, ~, ~, ~, count_2] = optimal_P2_and_X_from_E(E2, x1(:, temp_inl_h), x2(:, temp_inl_h));

                best_h_E = E1;
                best_h_P = P2_1;
                if count_2 > count_1
                    best_h_E = E2;
                    best_h_P = P2_2;
                end

                R = best_h_P(:, 1:3);
                T = best_h_P(:, 4);

                errors_e_h = (compute_epipolar_errors(best_h_E', x2, x1).^2 + compute_epipolar_errors(best_h_E, x1, x2).^2) / 2;

                inliners_e_h = errors_e_h < e_threshold^2;

                temp_inl_e_h = find(inliners_e_h > 0);

                inl_num_e_h = size(temp_inl_e_h, 2);

                n_epsilon_e_h = inl_num_e_h / n;

                if n_epsilon_e_h > epsilon_e
                    epsilon_e = n_epsilon_e_h;
                    best_E = best_h_E;
                    inliers_idx = temp_inl_e_h;
                    T_e = find_T(alpha,epsilon_e, sam_num_e);
                    itr_e = 0;
                    [P2, best_X, ~, ~, ~] = optimal_P2_and_X_from_E(best_E, x1(:, inliers_idx), x2(:, inliers_idx));
                    R = P2(:, 1:3);
                    T = P2(:, 4);
                    flag = 1;
                end

                epsilon_h = n_epsilon_h;
                
                T_h = find_T(alpha,epsilon_h, sam_num_h);
                itr_h = 0;
            end
        end
    end
    if flag == 1
        fprintf("R estimated from Homography \n");
    else
        fprintf("R estimated from 8 point method\n");
    end
end
