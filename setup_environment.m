function setup_environment()
    if exist('vl_sift', 'file') == 0
        vlfeat_root = getenv('VLFEAT_ROOT');
        if isempty(vlfeat_root)
            error(['VLFeat was not found. Add VLFeat to the MATLAB path or set ' ...
                   'the VLFEAT_ROOT environment variable.']);
        end

        setup_script = fullfile(vlfeat_root, 'toolbox', 'vl_setup.m');
        if exist(setup_script, 'file') == 0
            error('VLFeat setup script not found at: %s', setup_script);
        end
        run(setup_script);
    end
    rng(42);
end
