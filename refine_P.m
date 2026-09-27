function [Pb, T] = refine_P(P, xn, X)
    R = P(:, 1:3);
    t = P(:, 4);
    mu = 0.01;

    diff = xn - pflat([R t] * X);
    rb = reshape(diff(1:2, :), [], 1);

    while true
        diff = xn - pflat([R t] * X);
        r = reshape(diff(1:2, :), [], 1);

        J = [];
        for i = 1:size(xn, 2)
            J = [J;
                (-P(3, :) * X(:, i) * [1 0 0] + P(1, :) * X(:, i) * [0 0 1]) / (P(3, :) * X(:, i)).^2; ...
                (-P(3, :) * X(:, i) * [0 1 0] + P(2, :) * X(:, i) * [0 0 1]) / (P(3, :) * X(:, i)).^2; ...
            ];
        end

        delta_T = -inv((J' * J + mu * eye(size(J, 2)))) * J' * r;
        
        
        err = r' * r;
        diff = xn - pflat([R (t + delta_T)] * X);
        rp = reshape(diff(1:2, :), [], 1);
        err_p = rp' * rp;

        if err_p < err
            t = t + delta_T;
            mu = mu / 10;
        else
            mu = mu * 10;
        end

        if norm(delta_T) < 1e-10
            break
        end
    end

    Pb = [R t];
    T = t;

    diff = xn - pflat([R t] * X);
    ra = reshape(diff(1:2, :), [], 1);
end
