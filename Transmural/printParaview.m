function [] = printParaview(data)

[filename, pathname] = uiputfile('*.vtk', 'Where do you want to save the .vtk?');
fileID = [pathname filename];

x = [];
y = [];
z = [];
oi = [];
tissueFlag = [];
for i = 1:length(data)
    dataArray = data{i};
    for j = 1:length(dataArray)
        x = [x dataArray(j).x];
        y = [y dataArray(j).y];
        z = [z (i-1)];
        tissueFlag = [tissueFlag dataArray(j).tissue_flag];
        oi = [oi rand];
    end
end

vtkwrite(fileID, 'structured_grid',x,y,z,'scalars', ...
    'TissueFlag', tissueFlag, 'OI', oi);

end

