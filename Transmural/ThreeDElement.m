classdef ThreeDElement < matlab.mixin.SetGet
    
    
    properties
        %the 8 bounding nodes
        nodes = data_point.empty;
        PrefDV;
        PrefDA
        NOI;
        Skew;
        Kurtosis;
        
        Region;
        
        
        %Calculated values
        dE1dX;
        dE2dY;
        dE3dZ;
        
        %PrefD mean should be a vector
        PrefDV_Mean;
        %NOI, Skew and Kurtosis means are scalars
        PrefDA_Mean;
        NOI_Mean;
        Skew_Mean;
        Kurtosis_Mean;
        
        %These are vector gradients
        PrefDV_Gradient;
        PrefDA_Gradient
        NOI_Gradient;
        
    end
    
    methods
        
        function obj = AssignNodes(obj, dataPoints)
            %Creates the element, assigning data points to nodes
            obj.nodes = dataPoints;
        end
        
        function obj = CalculateMeanValues(obj)
            for i = 1:8
                obj.PrefDV(i,1:2) = obj.nodes(i).PrefDVector;
                angles(i) = angle(obj.PrefDV(i,1) + 1i*obj.PrefDV(i,2));
            end
            mean1 = mean(obj.PrefDV);
            mean1a = angle(mean1(1) + 1i*mean1(2));
            mean1 = mean1./abs(mean1(1) + 1i*mean1(2));
            %mean2 = circ_axialmean(angles, ones(1,8));
            
            obj.PrefDV_Mean = mean1;
            obj.PrefDA_Mean = mean1a;
            
            %{
            % TEST FIG
            figure;
            compass(obj.PrefDV(:,1), obj.PrefDV(:,2),'r');
            hold on;
            compass(mean1(1),mean1(2),'g');
            %compass(cos(mean2),sin(mean2),'b');
            hold off;
            legend('Vectors', 'r', 'Preferred Direction','g');
            %}
            %{
            %Test Fig 2
            figure;
            for i =1:8
            if angle(obj.PrefDV(i,1) + 1i*obj.PrefDV(i,2))<0
                obj.PrefDV(i,1) = -obj.PrefDV(i,1);
                obj.PrefDV(i,2) = -obj.PrefDV(i,2);
            end
            end
            compass(obj.PrefDV(:,1), obj.PrefDV(:,2),'r');
            hold on;
            compass(mean1(1),mean1(2),'g');
            compass(cos(mean2),sin(mean2),'b');
            hold off;
            legend('Arrows','Mean1', 'Mean2');
            %}
            
            
            obj.PrefDA = [obj.nodes(:).PrefDAngle];
            %obj.PrefDA_Mean = mean(obj.PrefDA);
            
            obj.PrefDV_Mean = [cos(obj.PrefDA_Mean) sin(obj.PrefDA_Mean)];
            obj.PrefDA_Mean = obj.PrefDA_Mean*(180/pi);
            
            obj.NOI = [obj.nodes(:).oi_odf];
            obj.NOI_Mean = mean(obj.NOI);
            
            obj.Skew = [obj.nodes(:).skew_odf];
            obj.Skew_Mean = mean(obj.Skew);
            
            obj.Kurtosis = [obj.nodes(:).kurtosis_odf];
            obj.Kurtosis_Mean = mean(obj.Kurtosis);
        end
        
        function obj = CalculateGradients(obj)
            
            %% Set up Isoparametric coordinates
            %We want these defined as the center of the cell
            E1= 0.5; E2 = 0.5; E3 = 0.5;
            
            %Find derivatives for the isoparametric coordinates
            xVals = sort(unique([obj.nodes(:).x]));
            yVals = sort(unique([obj.nodes(:).y]));
            zVals = sort(unique([obj.nodes(:).z]));
            
            obj.dE1dX = 1/(xVals(2)-xVals(1));
            obj.dE2dY = 1/(yVals(2)-yVals(1));
            obj.dE3dZ = 1/(zVals(2)-zVals(1));
            
            %% Find Gradient for the Preferred Direction Vector
            
            PrefDV1 = [obj.PrefDV(:,1)];
            PrefDV2 = [obj.PrefDV(:,2)];
            
            %v1,E1
            E1_High = 0.51;
            E1_Low = 0.49;
            
            PrefA_E1_High = TrilinearInterpolation([E1_High, E2, E3], PrefDV1);
            PrefA_E1_Low = TrilinearInterpolation([E1_Low, E2, E3], PrefDV1);
            
            dPrefDV1dX1 = (PrefA_E1_High-PrefA_E1_Low)/obj.dE1dX;
            
            %v1,E2 Direction
            E2_High = 0.51;
            E2_Low = 0.49;
            
            PrefA_E2_High = TrilinearInterpolation([E1, E2_High, E3], PrefDV1);
            PrefA_E2_Low = TrilinearInterpolation([E1, E2_Low, E3], PrefDV1);
            
            dPrefDV1dX2 = (PrefA_E2_High-PrefA_E2_Low)/obj.dE2dY;
            
            %v1,e3 Direction
            E3_High = 0.51;
            E3_Low = 0.49;
            
            PrefA_E3_High = TrilinearInterpolation([E1, E2, E3_High], PrefDV1);
            PrefA_E3_Low = TrilinearInterpolation([E1, E2, E3_Low], PrefDV1);
            
            dPrefDV1dX3 = (PrefA_E3_High-PrefA_E3_Low)/obj.dE3dZ;
            
            %v2,E1
            PrefA_E1_High = TrilinearInterpolation([E1_High, E2, E3], PrefDV2);
            PrefA_E1_Low = TrilinearInterpolation([E1_Low, E2, E3], PrefDV2);
            
            dPrefDV2dX1 = (PrefA_E1_High-PrefA_E1_Low)/obj.dE1dX;
            
            %v2,E2 Direction
            PrefA_E2_High = TrilinearInterpolation([E1, E2_High, E3], PrefDV2);
            PrefA_E2_Low = TrilinearInterpolation([E1, E2_Low, E3], PrefDV2);
            
            dPrefDV2dX2 = (PrefA_E2_High-PrefA_E2_Low)/obj.dE2dY;
            
            %v2,e3 Direction
            PrefA_E3_High = TrilinearInterpolation([E1, E2, E3_High], PrefDV2);
            PrefA_E3_Low = TrilinearInterpolation([E1, E2, E3_Low], PrefDV2);
            
            dPrefDV2dX3 = (PrefA_E3_High-PrefA_E3_Low)/obj.dE3dZ;
            
            %Make Tensor
            obj.PrefDV_Gradient = [dPrefDV1dX1, dPrefDV1dX2, dPrefDV1dX3;...
                                   dPrefDV2dX1, dPrefDV2dX2, dPrefDV2dX3;...
                                   0            0            0          ];
            
            
            %% Find Gradient for NOI
            
            %E1 Direction
            E1_High = 0.51;
            E1_Low = 0.49;
            
            NOI_E1_High = TrilinearInterpolation([E1_High, E2, E3], obj.NOI');
            NOI_E1_Low = TrilinearInterpolation([E1_Low, E2, E3], obj.NOI');
            
            dNOIdX1 = (NOI_E1_High-NOI_E1_Low)/obj.dE1dX;
            
            %E1 Direction
            E2_High = 0.51;
            E2_Low = 0.49;
            
            NOI_E2_High = TrilinearInterpolation([E1, E2_High, E3], obj.NOI');
            NOI_E2_Low = TrilinearInterpolation([E1, E2_Low, E3], obj.NOI');
            
            dNOIdX2 = (NOI_E2_High-NOI_E2_Low)/obj.dE2dY;
            
            %E1 Direction
            E3_High = 0.51;
            E3_Low = 0.49;
            
            NOI_E3_High = TrilinearInterpolation([E1, E2, E3_High], obj.NOI');
            NOI_E3_Low = TrilinearInterpolation([E1, E2, E3_Low], obj.NOI');
            
            dNOIdX3 = (NOI_E3_High-NOI_E3_Low)/obj.dE3dZ;
            
            %Make Vector
            obj.NOI_Gradient = [dNOIdX1 dNOIdX2 dNOIdX3];
            
            
        end
        
    end
    
    methods(Static)
        
    end
    
end