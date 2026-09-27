function Rs_abs = calculate_absolute_rotations(Rs)
    num_rotations = numel(Rs);
    Rs_abs = cell(1, num_rotations);
    Rs_abs{1} = eye(3); % Initial absolute rotation is identity

    for i = 2:num_rotations
        Rs_abs{i} = Rs{i} * Rs_abs{i - 1};
    end
end