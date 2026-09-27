function T = find_T(alpha, epsilon, sample_point_num)
    T = ceil(log10(1 - alpha) / log10(1 - epsilon^sample_point_num));
end
