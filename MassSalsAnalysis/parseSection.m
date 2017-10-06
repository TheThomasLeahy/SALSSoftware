function [ data_points, size] = parseSection(filename)
     orig_data = dlmread(filename);
    
     n = orig_data(1);
     m = orig_data(1,2);
    
     size = [n m];
     
     data_points = data_point.empty;
     row = 0;
     prevY = -Inf;
     j = 1;
     for i = 2:4:(n*m)*4+1
     %for i = 2:2:(n*m)*2+1
      
        x = orig_data(i, 1);
        y = orig_data(i, 2);
        
        intensity_data = orig_data(i+1,1:360);
        
        data_point_obj = data_point;
        data_point_obj.x = x;
        data_point_obj.y = y;
        data_point_obj.intensity_data = intensity_data;
        
        if (prevY ~= y)
            row = row + 1;
        end
        
        index = -Inf;
        if mod(row, 2) == 0
            index = row*n - mod(j-1,n);
        else 
            index = j;
        end
        
        data_points(index) = data_point_obj;
            
        prevY = y;
        j = j+1;
     end
end
