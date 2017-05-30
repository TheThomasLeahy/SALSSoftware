function [xUnique,yUnique, xNum, yNum] = findXPYP(sliceData)

xMasterGrid = [sliceData(:).x];
yMasterGrid = [sliceData(:).y];
xUnique = sort(unique(xMasterGrid));
yUnique = sort(unique(yMasterGrid));
xNum = length(xUnique);
yNum = length(xUnique);

end

