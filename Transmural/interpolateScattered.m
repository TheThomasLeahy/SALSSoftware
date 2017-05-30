function [ newsection ] = interpolateScattered(sectionData, masterSectionData)

    fs_order = length(sectionData(1).an)*2;

    newsection = data_point.empty;
    
    % We can set data_points properties by name. These are the ones we are
    % interesting in interpolating.
    valuesToInterp = {'mean_odf', 'mean_odd', 'tissue_flag'};
    
    %% Setup interpolant function for each property of data_points we want to interpolate
    interps = containers.Map;
    for v_index = 1:length(valuesToInterp)
        valueToInterp = valuesToInterp{v_index};
        f = zeros(1,length(sectionData));
        for j = 1:length(sectionData)
            f(j) = get(sectionData(j), valueToInterp);
        end
        % Store the interpolant function, we will use it later when we
        % figure out what points to evalute it at.
        interps(valueToInterp) = scatteredInterpolant([sectionData(:).x]', [sectionData(:).y]', f');
    end
    
    %% Loop through the master grid points, create a data_point at each new point and add interpolated values
    
    % Create the master grid (just X/Y pairs) taken from the master section
    % Note that this requires that the tissue points in the registered
    % section are not outside of the master grid which should be the case.
    % If this is an issue, which I doubt it will be, more XY points can be
    % generated.
    X = [masterSectionData(:).x; masterSectionData(:).y]';
    
    % For each data_point in this section
    for d_ind = 1:length(sectionData)      
        % Just a vector containing the points
        Xi = [sectionData(d_ind).x, sectionData(d_ind).y];

        % Find the closet point on the grid to Xi
        k = dsearchn(X,Xi);
        xy = X(k,:);
        x = xy(1);
        y = xy(2);
        
        % Create the new data_point
        data_point_ = data_point;
        set(data_point_, 'x', x);
        set(data_point_, 'y', y);

        % For each value that we want to interpolate
        for v_index = 1:length(valuesToInterp);
            valueToInterp = valuesToInterp{v_index};
            interpolant = interps(valueToInterp);
            interpolatedValue = interpolant(x, y);
            set(data_point_, valueToInterp, interpolatedValue);
        end

        newsection(d_ind) = data_point_;
    end
end



