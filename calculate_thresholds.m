function [ep_thresh, h_thresh, t_thresh] = calculate_thresholds(K, p_t)
    ep_thresh = 3 * (p_t / K(1, 1));
    h_thresh = 2 * 2 * 3 * (p_t / K(1, 1));
    t_thresh = 2 * 4 * 3 * (p_t / K(1, 1));
end