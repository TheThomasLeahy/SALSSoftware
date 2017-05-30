function [ xExpand, yExpand ] = expandGrid( sectionCoordinates, xExpand, yExpand, x_StepSize, y_StepSize )

while min(xExpand(:,1)) > min(sectionCoordinates(:,1))
    %Expand in -x direction
    xAdd = repmat(xExpand(1,1)-x_StepSize,[1,size(xExpand,2)]);
    xExpand = [xAdd; xExpand];
    yExpand = [yExpand(1,:); yExpand];
end
while max(xExpand(:,1)) < max(sectionCoordinates(:,1))
    %Expand in +x direction
    xAdd = repmat(xExpand(size(xExpand,1),1)+x_StepSize,[1,size(xExpand,2)]);
    xExpand = [xExpand; xAdd];
    yExpand = [yExpand(1,:); yExpand];
end
while min(yExpand(1,:)) > min(sectionCoordinates(:,2))
    %Expand in -y direction
    yAdd = repmat(yExpand(1,1)-y_StepSize,[size(yExpand,1),1]);
    yExpand = [yAdd yExpand];
    xExpand = [xExpand(:,1) xExpand];
end
while max(yExpand(1,:)) < max(sectionCoordinates(:,2))
    %Expand in +y direction
    yAdd = repmat(yExpand(1, size(xExpand,2))+y_StepSize,[size(yExpand,1),1]);
    yExpand = [yExpand yAdd ];
    xExpand = [xExpand(:,1) xExpand];
end


end

