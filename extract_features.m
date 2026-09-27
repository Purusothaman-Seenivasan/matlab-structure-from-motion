function [f_fs, ds] = extract_features(img_names)
    f_fs = cell(1, numel(img_names));
    ds = cell(1, numel(img_names));
    project_data = fileparts(mfilename('fullpath'));

    for i = 1:numel(img_names)
        img_i = imread(fullfile(project_data, img_names{i})); 

        
        [f, d] = vl_sift(single(rgb2gray(img_i)), 'PeakThresh', 1);
        f_fs{i} = f;
        ds{i} = d;
    end
end
