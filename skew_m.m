function skew_matrix = skew_m(t)
    skew_matrix = [0, -t(3), t(2); t(3), 0, -t(1); -t(2), t(1), 0];
end