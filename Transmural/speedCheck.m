Point = [3, 4.1,0];
Step = [0.11,0.11,0.2];

top = 10000;

tic
j = waitbar(0,'Check slow');
for i = 1:top
    waitbar(i/top,j)
    %PointIndex= find(ismember(DataPointsCoords,Point,'rows'));
end
close(j);
toc

tic
j = waitbar(0,'Check fast');
for i = 1:top
    if mod(i,25) == 0
    waitbar(i/top,j);
    end
    %{
    index = [];
    for x = 1:size(DataPointsCoords,1)
        if(DataPointsCoords(x,:) == Point)
            index = x;
            break;
        end
    end
    %}
end
close(j);
toc



