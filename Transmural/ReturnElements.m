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

xStep = min(diff(xUnique));
yStep = min(diff(yUnique));
zStep = min(diff(zUnique));

%Step = round([xStep yStep zStep],2);

xSize = round(xRange/xStep)+1;
ySize = round(yRange/yStep)+1;
zSize = round(zRange/zStep)+1;

totalSize = xSize*ySize*zSize;

bigArray = zeros(1,totalSize);

for i =1:length(DataPointCoords)
    %Find array point of the point
    thisPoint = [DataPointCoords(i,:)];
    xInd = round((thisPoint(1)-minX)/xStep);
    yInd = round((thisPoint(2)-minY)/yStep);
    zInd = round((thisPoint(3)-minZ)/zStep);
    %Find array value
    val = zInd*(xSize*ySize)+yInd*xSize+xInd+1;
    
    bigArray(val) = i;
end

for i = 1:length(DataPointCoords)
    if mod(i,25) ==0
    waitbar(i/(length(DataPointCoords)),h);
    end
    
    %Find array point of the point
    thisPoint = [DataPointCoords(i,:)];
    xInd = round((thisPoint(1)-minX)/xStep);
    yInd = round((thisPoint(2)-minY)/yStep);
    zInd = round((thisPoint(3)-minZ)/zStep);
    
    if (xInd+1) == xSize
        continue;
    end;
    
    if (yInd+1) == ySize
        continue;
    end;
    
    if (zInd+1) == zSize %%This is the top layer, there can't be anything bigger than this
        break;
    end
    
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
    second = bigArray(second);
    
    third = val + xSize;
    third = bigArray(third);
    
    fourth = val + xSize + 1;
    fourth = bigArray(fourth);
    
    fifth = val + (xSize*ySize);
    fifth = bigArray(fifth);

    sixth = val + (xSize*ySize) + 1;
    sixth = bigArray(sixth);
    
    seventh = val + (xSize*ySize) + xSize;
    seventh = bigArray(seventh);
    
    eigth = val + (xSize*ySize) + xSize + 1;
    eigth = bigArray(eigth);
    
    indices = [second third fourth fifth sixth seventh eigth];
    
    if(all(indices))
        %None are indices of zero, we found ourselves an element
        indices = [i indices];
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

