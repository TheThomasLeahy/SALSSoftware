

% Test #1: One element
% For 0,0,0, points are    
% 0,0,1  0,1,1  0,1,0   1,0,1   1,1,0  1,1,1, 1,0,0
X = [0 0 1 1];
Y = [0 1 1 0];
Z = [0 1];
X_check = [];
Y_check = [];
Z_check = [];
for j = 1:length(Z)
    data = [];
    for i = 1:length(X)
        dp = data_point;
        dp.x = X(i);
        dp.y = Y(i);
        dp.z = Z(j);
        X_check = [X_check X(i)];
        Y_check = [Y_check Y(i)];
        Z_check = [Z_check Z(j)];
        dp.tissue_flag = 1;
        dp.PrefDVector = [1,1];
        data = [data dp];   
    end
    allData{j} = data;
end

figure
scatter3(X_check,Y_check,Z_check);

[PointData, ElementData] = TFA3DAnalysis(allData);
assert(lengthElementData == 1);


% Test #1: Two elements, disconnected
% For 0,0,0, points are    
% 0,0,1  0,1,1  0,1,0   1,0,1   1,1,0  1,1,1, 1,0,0
X = [0 0 1 1 3 3 4 4];
Y = [0 1 1 0 3 4 3 4];
Z = [0 1];
X_check = [];
Y_check = [];
Z_check = [];
for j = 1:length(Z)
    data = [];
    for i = 1:length(X)
        dp = data_point;
        dp.x = X(i);
        dp.y = Y(i);
        dp.z = Z(j);
        X_check = [X_check X(i)];
        Y_check = [Y_check Y(i)];
        Z_check = [Z_check Z(j)];
        dp.tissue_flag = 1;
        data = [data dp];
    end
    allData{j} = data;
end

figure
scatter3(X_check,Y_check,Z_check);

[PointData, ElementData] = TFA3DAnalysis(allData);
assert(lengthElementData == 1);