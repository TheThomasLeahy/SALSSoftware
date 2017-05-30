function [ indices ] = findNearest(xPoint, yPoint, sectionCoordinates)
indices = [];
%if not surrounded by 4 nice coordinates, return an empty array
xArray = sectionCoordinates(:,1);
yArray = sectionCoordinates(:,2);

%% Find upper point to the left
upLeft = intersect(find(xArray <= xPoint), find(yArray >=yPoint));
if isempty(upLeft)
    return;
end
dist = sqrt(((xArray(upLeft(1))-abs(xPoint))^2) + ((yArray(upLeft(1))-yPoint)^2));
index = upLeft(1);
if length(upLeft) ~= 1
    for i = 2:length(upLeft);
        dist2 = sqrt(((xArray(upLeft(i))-xPoint)^2) + ((yArray(upLeft(i))-yPoint)^2));
        if dist2 < dist
            index = upLeft(i);
            dist = dist2;
        end
    end
end
upLeft = index;

%% Find upper point to the right
upRight = intersect(find(xArray >= xPoint), find(yArray >=yPoint));
if isempty(upRight)
    return;
end
dist = sqrt(((xArray(upRight(1))-xPoint)^2) + ((yArray(upRight(1))-yPoint)^2));
index = upRight(1);
if length(upRight) ~= 1
    for i = 2:length(upRight);
        dist2 = sqrt(((xArray(upRight(i))-xPoint)^2) + ((yArray(upRight(i))-yPoint)^2));
        if dist2 < dist
            index = upRight(i);
            dist = dist2;
        end
    end
end
upRight = index;

%% Find lower point to the left
downLeft = intersect(find(xArray <= xPoint), find(yArray <=yPoint));
if isempty(downLeft)
    return;
end
dist = sqrt(((xArray(downLeft(1))-xPoint)^2) + ((yArray(downLeft(1))-yPoint)^2));
index = downLeft(1);
if length(downLeft) ~= 1
    for i = 2:length(downLeft);
        dist2 = sqrt(((xArray(downLeft(i))-xPoint)^2) + ((yArray(downLeft(i))-yPoint)^2));
        if dist2 < dist
            index = downLeft(i);
            dist = dist2;
        end
    end
end
downLeft = index;

%% Find lower point to the right
downRight = intersect(find(xArray >= xPoint), find(yArray <=yPoint));
if isempty(downRight)
    return;
end
dist = sqrt(((xArray(downRight(1))-xPoint)^2) + ((yArray(downRight(1))-yPoint)^2));
index = downRight(1);
if length(downRight) ~= 1
    for i = 2:length(downRight);
        dist2 = sqrt(((xArray(downRight(i))-xPoint)^2) + ((yArray(downRight(i))-yPoint)^2));
        if dist2 < dist
            index = downRight(i);
            dist = dist2;
        end
    end
end
downRight = index;

%% Put the points in a nice array and return

indices = [upLeft upRight; downLeft downRight];
    



end

