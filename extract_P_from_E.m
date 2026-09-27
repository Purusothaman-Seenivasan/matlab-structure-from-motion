function p2 = extract_P_from_E(E)

    [U, ~, V] = svd(E);
    W = [0 -1 0; 1 0 0; 0 0 1];

    if det(U * V') < 0
        V = -V;
    end

    R1 = U * W * V';
    R2 = U * W' * V';

    t = U(:, 3);

    p2 = {
        [R1,  t],
        [R1, -t],
        [R2,  t],
        [R2, -t]
    };
end
