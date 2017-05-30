function [ outside ] = outsideGrid(xPoint,yPoint, xGrid, yGrid)
outside = 0;

minX = min(min(xGrid));
minY = min(min(yGrid));
maxX = max(max(xGrid));
maxY = max(max(yGrid));
if (xPoint < minX) || (xPoint > maxX)
    outside = 1;
end
if (yPoint < minY) || (yPoint > maxY)
    outside = 1;
end
end

