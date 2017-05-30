

%% Fix OI Calc
h = waitbar(0,'fixin the old gal up');


for i = 1:length(ElementData)
    waitbar(i/length(ElementData),h);
    for x = 1:8
        ElementData(i).nodes(x) = ElementData(i).nodes(x).ComputeStatsODF;
    end
    ElementData(i) = ElementData(i).CalculateMeanValues;
    ElementData(i) = ElementData(i).CalculateGradients;
end


%{
for i =1 :length(PointData)
        waitbar(i/length(PointData),h);
    PointData(i) = PointData(i).ComputeStatsODF;
end
%}

