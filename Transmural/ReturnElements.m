function [ Elements, indices ] = ReturnElements( DataPoints,h )

%Elements = ThreeDElement;
ElementIndices = [];

xVals = [DataPoints(:).x]; 
yVals = [DataPoints(:).y];
zVals = [DataPoints(:).z];
DataPointCoords = round([xVals' yVals' zVals'],2);

xUnique = sort(unique(xVals));
yUnique = sort(unique(yVals));
zUnique = sort(unique(zVals));
xStep = xUnique(2)-xUnique(1);
yStep = yUnique(2)-yUnique(1);
zStep = zUnique(2)-zUnique(1);
Step = round([xStep yStep zStep],2);

BinArray = [0 0 0; 1 0 0;0 1 0; 1 1 0; 0 0 1; 1 0 1;0 1 1; 1 1 1];
    
StepArray = repmat(Step,[8,1]).*BinArray;

StepArray = round(StepArray,2);
%First Point is 0,0,0
%Second is 1,0,0
%Third is 0,1,0
%1,1,0
%0,0,1
%1,0,1
%0,1,1
%1,1,1

for i = 1:length(DataPointCoords)
    if mod(i,25) == 0
    waitbar(i/(length(DataPointCoords)),h);
    end
    %Is this the bottom left point of an element?
    %If so, make the element
    
    Point = DataPointCoords(i,:);
    indices = CheckForElement(Point, i, DataPointCoords, StepArray);
    if ~isempty(indices)
        %We found an element here
        if isempty(ElementIndices)
            ElementIndices = indices;
        else
            ElementIndices = [ElementIndices; indices];
        end
    end
    
end

for i = 1:size(ElementIndices,1)
    thisData = DataPoints(ElementIndices(i,:));
    Elements(i) = ThreeDElement;
    Elements(i) = Elements(i).AssignNodes(thisData);
end

indices = unique(ElementIndices);

end

