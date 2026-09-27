function [P2, X, P2s, Xs, bestCnt] = optimal_P2_and_X_from_E(E, x1n, x2n)
    % Determine the optimal P2 and 3D points X by performing the chirality check

    P1 = [eye(3), zeros(3, 1)];

    bestIdx = 1;
    bestCnt = 0;

    P2s = extract_P_from_E(E);

    nPts = size(x1n, 2);
    Xs = cell(1, 4);

    for Pi = 1:numel(P2s)
        Xmat = zeros(4, nPts);

        % Triangulate points for the current P2
        for i = 1:nPts
            Xmat(:, i) = triangulate_3D_point_DLT(x1n(:, i), x2n(:, i), P1, P2s{Pi});
        end

        Xmat = pflat(Xmat);
        Xs{Pi} = Xmat;

        x1Proj = P1 * Xmat;
        x2Proj = P2s{Pi} * Xmat;

        % Count points with positive depth
        posCnt = sum(x1Proj(3, :) > 0) + sum(x2Proj(3, :) > 0);

        % Update the best configuration if current is better
        if posCnt > bestCnt
            bestCnt = posCnt;
            bestIdx = Pi;
        end
    end

    % Select the best P2 and corresponding 3D points
    P2 = P2s{bestIdx};
    X = Xs{bestIdx};
end
