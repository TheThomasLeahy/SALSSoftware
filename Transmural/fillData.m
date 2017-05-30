function [ newSection ] = fillData(sectionData, X1, Y1)

newSection = data_point.empty;

x = 1;
y = 1;
for i = 1:size(X1,1)
    for j = 1:size(Y1,2)
        ind = intersect(find([sectionData(:).x] == X1(i,j)), find([sectionData(:).y] == Y1(i,j)));
        if ~isempty(ind)
            %We have this data
            newSection(x).x = sectionData(y).x;
            newSection(x).y = sectionData(y).y;
            newSection(x).tissue_flag = sectionData(y).tissue_flag;
            x = x + 1;
            y = y + 1;
        else
            %We dont have this data
            newSection(x).x = X1(i,j);
            newSection(x).y = Y1(i,j);
            newSection(x).tissue_flag = 0;
            x = x + 1;
        end
    end
end

end

