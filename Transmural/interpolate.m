function [ newsection, xMasterGrid, yMasterGrid ] = interpolate(sectionData, xMasterGrid, yMasterGrid, xStepSize, yStepSize)

%% Interpolate the XY point to the master grid
newsection = data_point.empty;

%Find x,y points of this section
%[xPoints,yPoints] = findXPYP(sectionData);

%Find this sections coordinates
sectionCoordinates = [[sectionData(:).x]' [sectionData(:).y]'];

%Expand MasterGrid to encompass this section
[xMasterGrid, yMasterGrid] = expandGrid( sectionCoordinates, xMasterGrid, yMasterGrid, xStepSize, yStepSize);

x = 1;
masterTissueFlag = zeros(size(xMasterGrid));
for i = 1:size(xMasterGrid,1)
    for j = 1:size(xMasterGrid,2)
        indices = findNearest(xMasterGrid(i,j), yMasterGrid(i,j), sectionCoordinates);
        if isempty(indices)
            %Is this point outside the grid - Auto assume it is not tissue
            masterTissueFlag(i,j) = 0;
        else
            %For points within this sections grid, do the interpolation
            upLeft = [sectionCoordinates(indices(1,1),:) 0];
            upRight = [sectionCoordinates(indices(1,2),:) 0];
            downLeft = [sectionCoordinates(indices(2,1),:) 0];
            downRight = [sectionCoordinates(indices(2,2),:) 0];
            %Normalied coordinates
            % CORRECT THIS TO BE ACCURATE ISOPARAMETRIC COORDINATES
           
            Point = [xMasterGrid(i,j) yMasterGrid(i,j) 0];
            
            
            x1_new = norm(cross(upLeft-downLeft,Point-downLeft))/norm(upLeft-downLeft);
            x2_new = norm(cross(downRight-downLeft,Point-downLeft))/norm(downRight-downLeft);
            
            x1_Max = sqrt(((downRight(1)-downLeft(1))^2)+((downRight(2)-downLeft(2))^2));
            x2_Max = sqrt(((upLeft(1)-downLeft(1))^2)+((upLeft(2)-downLeft(2))^2));
            
            x1 = x1_new/x1_Max;
            x2 = x2_new/x2_Max;
            
            %x1 = abs(xMasterGrid(i,j)-downLeft(1))/abs(downRight(1)-downLeft(1));
            %x2 = abs(yMasterGrid(i,j)-downLeft(2))/abs(upLeft(2)-downLeft(1));
            
            if(isnan(x1))
                x1 = 0;
            end
            if(isnan(x2))
                x2 = 0;
            end
            %U1 is bottom left
            u1 = sectionData(indices(2,1)).tissue_flag;
            %U2 is bottom right
            u2 = sectionData(indices(2,2)).tissue_flag;
            %top left
            u3 = sectionData(indices(1,1)).tissue_flag;
            %top right
            u4 = sectionData(indices(1,2)).tissue_flag;
            %interpolate
            masterTissueFlag(i,j) = round(u(x1,x2,u1,u2,u3,u4));
            if(isnan(masterTissueFlag(i,j)))
                masterTissueFlag(i,j) = 0;
            end
            if(masterTissueFlag(i,j) == 1)
                %This spot is tissue. Find its data
                newsection(x).x = xMasterGrid(i,j);
                newsection(x).y = yMasterGrid(i,j);
                newsection(x).z = sectionData(1).z;
                
                %U1 is bottom left
                u1 = sectionData(indices(2,1)).PrefDAngle;
                %U2 is bottom right
                u2 = sectionData(indices(2,2)).PrefDAngle;
                %top left
                u3 = sectionData(indices(1,1)).PrefDAngle;
                %top right
                u4 = sectionData(indices(1,2)).PrefDAngle;
                
                PrefDAngle = u(x1,x2,u1,u2,u3,u4);
                
                r(1) = PrefDAngle - sectionData(indices(2,1)).PrefDAngle;
                r(2) = PrefDAngle - sectionData(indices(2,2)).PrefDAngle;
                r(3) = PrefDAngle - sectionData(indices(1,1)).PrefDAngle;
                r(4) = PrefDAngle - sectionData(indices(1,2)).PrefDAngle;
                
                for k = 1:length(r)
                    rotationMatrix{k} = [cos(r(k)) sin(r(k)) 0; -sin(r(k)) cos(r(k)) 0; 0 0 0];
                end
                
                data1 = sectionData(indices(2,1)).ApplyTransformation2(rotationMatrix{1});
                data2 = sectionData(indices(2,2)).ApplyTransformation2(rotationMatrix{2});
                data3 = sectionData(indices(1,1)).ApplyTransformation2(rotationMatrix{3});
                data4 = sectionData(indices(1,2)).ApplyTransformation2(rotationMatrix{4});
                
                for k = 1:length(sectionData(indices(2,1)).an)
                    u1 = data1.an(k);
                    u2 = data2.an(k);
                    u3 = data3.an(k);
                    u4 = data4.an(k);
                    newsection(x).an(k) = u(x1,x2,u1,u2,u3,u4);
                end
                
                for k = 1:length(sectionData(indices(2,1)).bn)
                    u1 = data1.bn(k);
                    u2 = data2.bn(k);
                    u3 = data3.bn(k);
                    u4 = data4.bn(k);
                    newsection(x).bn(k) = u(x1,x2,u1,u2,u3,u4);
                end
                
                newsection(x).odf = evalFourierRad(newsection(x).an, newsection(x).bn, 1, newsection(x).theta);
                newsection(x).ComputeStatsCirc;
                newsection(x).ComputeStatsODF;
                
                x = x + 1;
            end
        end
    end
    
end

