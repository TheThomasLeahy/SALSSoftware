

%% Fix OI Calc
h = waitbar(0,'fixin the old gal up');


zVals = [PointData(:).z];
maxZ = max(zVals); minZ = min(zVals);
zDist = maxZ-minZ;

for i = 1:length(ElementData)
    waitbar(i/length(ElementData),h);
    
    zVal = mean([ElementData(i).nodes(1).z ElementData(i).nodes(8).z])*10;
    if (zVal < (zDist*0.2))
        ElementData(i).Region = 1;
       
    elseif ( zVal <(zDist*0.4))
        ElementData(i).Region = 2;
        
    elseif (zVal < (zDist*0.6))
        ElementData(i).Region = 3;
        
    elseif (zVal < (zDist*0.8))
        ElementData(i).Region = 4;
        
    else
        ElementData(i).Region = 5;
        
    end
end
    
    
    %{
    for x = 1:8
        ElementData(i).nodes(x) = ElementData(i).nodes(x).ComputeStatsODF;
    end
    ElementData(i) = ElementData(i).CalculateMeanValues;
    ElementData(i) = ElementData(i).CalculateGradients;
    %}



%{
for i =1 :length(PointData)
    waitbar(i/length(PointData),h);
    PointData(i).z = PointData(i).z*10;
end
%}

