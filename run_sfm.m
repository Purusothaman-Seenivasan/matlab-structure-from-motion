function run_sfm(id)

    clc;

    setup_environment();

    % Load dataset information
    [K, img_names, init_pair, p_t] = get_dataset_info(id);

    % Set thresholds
    [ep_thresh, h_thresh, t_thresh] = calculate_thresholds(K, p_t);

    % Extract features for each image
    [f_fs, ds] = extract_features(img_names);

    %% Calculate Absolute Rotations
    Rs_abs = compute_absolute_rotations(K, img_names, f_fs, ds, ep_thresh, h_thresh);

    %% Refine 3D Points
    [ref_X, match_D, match_p, ~] = construct_3d_points_refined(K, img_names, init_pair, f_fs, ds, ep_thresh, h_thresh, Rs_abs);

    %% Compute Cameras
    [Ps,Xs,xs] = compute_camera(K, img_names, ref_X, f_fs, ds, match_D, match_p, t_thresh, Rs_abs);

    %% Refine camera centers
   
    for i = 1:size(Ps, 2)
            [P, ~] = refine_P(Ps{i}, xs{i}, [Xs{i}; ones(1, size(Xs{i}, 2))]);
            Ps{i} = P;
    end

    %% Triangulate for all pairs
 
    Xs = triangulating_all_pairs(K, img_names, f_fs, ds,Ps);
    
    %% Plotting
    
    figure
    for i=1: size(Xs,2)
        plot3(Xs{i}(1,:),Xs{i}(2,:),Xs{i}(3,:),'.', 'MarkerSize',3);
        hold on
    end 
    
    plotcams(Ps);
    hold off 
    axis equal
    
end