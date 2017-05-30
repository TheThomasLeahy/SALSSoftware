function [ newsection ] = interpolateScattered(sectionData, masterSectionData)

    fs_order = length(sectionData(1).an)*2;

    newsection = data_point.empty;
    
    % We can set data_points properties by name. These are the ones we are
    % interesting in interpolating.
    valuesToInterp = {'mean_odf', 'mean_odd', 'tissue_flag'};
    
    %% Algorithm for interpolating 
    % For each point in the registered section,
    % 1. Find the closet master grid coordinate (xm,ym) to it (this should be a 1:1
    % mapping 
    % 2. Find the four registered data points that xm,ym exists within
    % 3. Normalize those 4 points to (0,0),(0,1),(1,0),(1,1) 
    % 4. Find xm,ym position inside this new coordinate system (should be
    %       between 0 and 1
    % 5. Use the value you want to interpolate at those surroundings nodes
    %    as u1,u2,u3,u4 these will be at (0,0),(0,1),(1,0),(1,1)
    
    %%
    % Create the master grid (just X/Y pairs) taken from the master section
    % Note that this requires that the tissue points in the registered
    % section are not outside of the master grid which should be the case.
    % If this is an issue, which I doubt it will be, more XY points can be
    % generated.
    X = [masterSectionData(:).x; masterSectionData(:).y]';
    
    % For each data_point in this section
    for d_ind = 1:length(sectionData)    
        %% 1
        % Find the closet point on the grid to Xi
        % Here you can just throw the point away if it is outside of the master
        % grid.
        Xi = [sectionData(d_ind).x, sectionData(d_ind).y];
        k = dsearchn(X,Xi);
        xy = X(k,:);
        xm = xy(1);
        ym = xy(2);
        
        %% 2
        % Get the 4 registered section datapoints that the master 
        % coordinate exists within
        % You can take advantage of how the data is stored to help with
        % this. That is like so:
        %
        %  x0,y0  x1,y0  x1,y0 ...  xn, y0 
        %  x0,y1  x1,y1  ...   ...   ...
        %  ...     ...   ...   ...   ...
        %  x0,ym   ...   ...   ...   ...
        
        % data_point1 = 
        % data_point2 = 
        % data_point3 = 
        % data_point4 = 
        
        
        %% 3
        % Normalize those points to make up a 1x1 element with points
        % (0,0),(0,1),(1,0),(1,1)
        
        %% 4
        % Normalize xm and ym and get the normalized value of the master coordinate in the
        % coordinate system (inside (dp1.x, dp1.y) -> (0,0) 
        %                           (dp2.x, dp2.y) -> (0,1) 
        %                           (dp3.x, dp3.y) -> (1,0) 
        %                           (dp4.x, dp4.y) -> (1,1) 
        % x1 and x2 should be between 0 & 1
        % [x1, x2] = ...
        
        
        %% 5
        % Get the values of interest (an, bn, mean_odf, etc) at those points
        % u1 = get(data_point1, 'mean_odf');  
        % u2 = get(data_point2, 'value of interest');
        % u3 = get(data_point3, 'value of interest');
        % u4 = get(data_point4, 'value of interest');
        % Evalute u at the normalized coordinate from previous step
        % interpolated_value = (x1, x2, u1, u2, u3, u4);
        
        %%
        % Create the new data_point
        data_point_ = data_point;
        set(data_point_, 'x', xm);
        set(data_point_, 'y', ym);
        % set(data_point_, 'mean_odf', interpolated_value);

        newsection(d_ind) = data_point_;
    end
end



