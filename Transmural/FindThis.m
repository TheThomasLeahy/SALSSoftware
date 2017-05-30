%function [ index] = FindThis(DataPointsCoords, Point, index)
function [ index] = FindThis(DataPointsCoords, Point, Step, index)
%{
if i ==2
Point = Point + [Step(1) 0 0];
elseif i ==3
Point = Point + [0 Step(2) 0];
elseif i == 4
Point = Point + [Step(1) Step(2) 0];
elseif i == 5
Point = Point + [0 0 Step(3)];
elseif i == 6
Point = Point + [Step(1) 0 Step(3)];
elseif i == 7
Point = Point + [0 Step(2) Step(3)];
else
Point = Point + [Step(1) Step(2) Step(3)];
end
%}
Point = round((Point + Step),2);

%PointIndex= find(ismember(DataPointsCoords,Point,'rows'));

PointIndex = [];
for i = 1:size(DataPointsCoords)
    if isequal(DataPointsCoords(i,:),Point);
        PointIndex = i;
        break;
    end
end

if isempty(PointIndex)
    index = [];
    return;
else
    index = [index PointIndex];
end

end

