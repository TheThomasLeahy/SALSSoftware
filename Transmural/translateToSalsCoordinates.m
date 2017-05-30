function [ sliceData ] = translateToSalsCoordinates(sliceData, yRange)

for i = 1:length(sliceData)
    sliceData(i).y = (-1)*sliceData(i).y;
    sliceData(i).y = sliceData(i).y+yRange;
    
end


end

