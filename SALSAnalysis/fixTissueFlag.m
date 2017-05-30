function [ fixedData ] = fixTissueFlag(data_points, data)

%FixedData is where the new data will go
data_points = data_points(1:end-1);

%Let's set the tissue flags
x = 1;
for i = 1:size(data,1)
    for j = 1:size(data,2)
        if data(i,j) == -1;
            data_points(x).tissue_flag = 0;
        end
        x = x + 1;
    end
end

end

