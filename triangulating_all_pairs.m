function Xs = triangulating_all_pairs(K, img_names, f_fs, ds,Ps)
    Xs = cell(1, size(img_names, 2) - 1);
    
    for i = 1:size(img_names, 2) - 1
        f1 = f_fs{i};
        d1 = ds{i};
        f2 = f_fs{i + 1};
        d2 = ds{i + 1};
        [x1n,x2n] = sift_points(K,f1,f2,d1,d2);

        Xi = [];
        for j = 1:size(x1n, 2)
            X_ij = triangulate_3D_point_DLT(x1n(:, j), x2n(:, j), Ps{i}, Ps{i + 1});
            Xi = [Xi X_ij];
        end

        Xi = pflat(Xi);

        Xi_mean = mean(Xi')';
        Xi_dist = vecnorm(Xi - Xi_mean, 2, 1);
        threshold = 2 * quantile(Xi_dist, 0.90);
        Xi_inliners = Xi_dist <= threshold;
        Xi_inliners_idx = find(Xi_inliners > 0);
        Xi = Xi(:, Xi_inliners_idx);

        Xs{i} = Xi;
    end 
end
