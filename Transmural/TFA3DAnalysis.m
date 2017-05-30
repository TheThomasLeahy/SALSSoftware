function [ AllDataPoints, Elements ] = TFA3DAnalysis( Data )

%% Put Data in one long array, eliminate non-tissue and index it
tic
AllDataPoints = [];
for i = 1:length(Data)
    AllDataPoints = [AllDataPoints Data{i}];
end

newData = data_point;
x = 1;
for i = 1:length(AllDataPoints)
    if (AllDataPoints(i).tissue_flag == 1)
        newData(x) = AllDataPoints(i);
        x = x+1;
    end
end
AllDataPoints = newData;

for i = 1:length(AllDataPoints)
    %ID each point. Do minus 1 to handle 0-indexed Paraview.
    AllDataPoints(i).ID = i-1;
end

%% Find and Create Elements,  remove spurrious data

h = waitbar(0, sprintf('Building 3D elements! (Round 1)'));
    
[~, indices] = ReturnElements(AllDataPoints,h);

close(h);

AllDataPoints = removeSpurrious(AllDataPoints, indices);

h = waitbar(0, sprintf('Building 3D elements! (Round 2)'));
    
[Elements,~] = ReturnElements(AllDataPoints,h);

close(h);

%% Do Element Analysis

for i = 1:length(Elements)
Elements(i) = Elements(i).CalculateMeanValues;
Elements(i) = Elements(i).CalculateGradients;
end

toc
end

