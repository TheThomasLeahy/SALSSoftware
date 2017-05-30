function [ indices ] = CheckForElement( Point, index, DataPointsCoords, StepArray )

indices = [];

%First Point is 0,0,0
%Second is 1,0,0
%Third is 0,1,0
%1,1,0
%0,0,1
%1,0,1
%0,1,1
%1,1,1

%First is the point we are given
%{
Second = Point + [Step(1) 0 0];
Third = Point + [0 Step(2) 0];
Fourth = Point + [Step(1) Step(2) 0];
Fifth = Point + [0 0 Step(3)];
Sixth = Point + [Step(1) 0 Step(3)];
Seventh = Point + [0 Step(2) Step(3)];
Eighth = Point + [Step(1) Step(2) Step(3)];

Points = [Point; Second; Third; Fourth; Fifth; Sixth; Seventh; Eighth];
Points = round(Points, 2);
%}
 

for i = 2:8
    index = FindThis(DataPointsCoords, Point, StepArray(i,:), index);
    
    %index = FindThis(DataPointsCoords, Point, i, Step, index);
    
    if isempty(index)
        return
    end
end

indices = index;
end

