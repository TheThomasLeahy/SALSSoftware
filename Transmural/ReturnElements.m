function [ Elements, indices ] = ReturnElements( DataPoints,h )

%Elements = ThreeDElement;
ElementIndices = [];

xVals = round([DataPoints(:).x],2); 
yVals = round([DataPoints(:).y],2);
zVals = round([DataPoints(:).z],2);
DataPointCoords = [xVals' yVals' zVals'];

maxX = max(xVals); maxY = max(yVals); maxZ = max(zVals);
minX = min(xVals); minY = min(yVals); minZ = min(zVals);

xRange = max(xVals)-min(xVals); 
yRange = max(yVals)-min(yVals);
zRange = max(zVals)-min(zVals);

xUnique = sort(unique(xVals));
yUnique = sort(unique(yVals));
zUnique = sort(unique(zVals));
xStep = xUnique(2)-xUnique(1);
yStep = yUnique(2)-yUnique(1);
zStep = zUnique(2)-zUnique(1);
Step = round([xStep yStep zStep],2);

xSize = length(xUnique);
ySize = length(yUnique);
zSize = length(zUnique);

totalSize = xSize*ySize*zSize;

bigArray = zeros(1,totalSize);

x = 1;
for i = 1:zSize
    for j = 1:ySize
        for k = 1:xSize
            Point = [xUnique(k) yUnique(j) zUnique(i)];
            Index = 0;
            for q = 1:length(DataPointsCoords)
                if isequal(DataPointsCoords(q,:),Point);
                    Index = q;
                    break;
                end
            end
            bigArray(x) = Index;
            x = x+1;
        end
    end
end

for i = 1:length(DataPointCoords)
    if mod(i,25) == 0
    waitbar(i/(length(DataPointCoords)),h);
    end
    
    %Find array point of the point
    thisPoint = [DataPointCoords(i,:)];
    xInd = round((thisPoint(1)-xMin)/xStep);
    yInd = round((thisPoint(2)-yMin)/yStep);
    zInd = round((thisPoint(3)-zMin)/zStep);
    
    val = zInd*(xSize*ySize)+yInd*xSize+xInd+1;
    %Calculate points for the outside points
    %First Point is 0,0,0
    %Second is 1,0,0
    %Third is 0,1,0
    %1,1,0
    %0,0,1
    %1,0,1
    %0,1,1
    %1,1,1
    second = val + 1;
    if ~isequal(bigArray(second),0)
        second = bigArray(second);
    end
    third = val + xSize;
    if ~isequal(bigArray(third),0)
        third = bigArray(third);
    end
    fourth = val + xSize + 1;
    if ~isequal(bigArray(fourth),0)
        fourth = bigArray(fourth);
    end
    fifth = val + (xSize*ySize);
    if ~isequal(bigArray(fifth),0)
        fifth = bigArray(fifth);
    end
    sixth = fifth + 1;
    if ~isequal(bigArray(sixth),0)
        sixth = bigArray(sixth);
    end
    seventh = sixth + xSize-1;
    if ~isequal(bigArray(seventh),0)
        seventh = bigArray(seventh);
    end
    eigth = seventh + 1;
    if ~isequal(bigArray(eigth),0)
        eigth = bigArray(eigth);
    end
    
    
    
    
end


%{
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

%}
end

