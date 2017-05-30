function [ newData ] = removeSpurrious(DataPoints, indices)

%Remove non-element data

newData = data_point;
for i = 1:length(indices)
    newData(i) = DataPoints(indices(i));
end

%Reindex data
for i = 1:length(newData)
    newData(i).ID = i-1;
end

end

