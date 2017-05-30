function [xRange, yRange] = findRange(sliceData)

xMin = 0; xMax = 0;
yMin = 0; yMax = 0;

for i = 1:length(sliceData)
    if sliceData(i).x < xMin
        xMin = sliceData(i).x;
    end
    if sliceData(i).x > xMax
        xMax = sliceData(i).x;
    end
    if sliceData(i) < yMin
        yMin = sliceData(i).y;
    end
    if sliceData(i) > yMax
        yMax = sliceData(i).y
    end
end

xRange = xMax - xMin;
yRange = yMax - yMin;

end

