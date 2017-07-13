classdef data_point < matlab.mixin.SetGet
    %DATAPOINT Data_point class for use with SALSA and TransmuralSALS
    %   Object representation of a data point in a SALS scan. The number of
    %   data points in a scan is m x n where m and n are the grid dimensions 
    %   of a SALS scan. All angle quantaties are in radians. 
    %
    %   data_point treats the odf and odd as starting from 1 and extending
    %   to 2*pi so that the first value in the odf array
    %   corresponds to the 1° angle and the last to the 360° angle
    
    properties
        % SALSA ONLY
        intensity_data  % Raw intensity data
        odd             % Orientation Distribution Data
        odf             % Orientation Distribution Function
        
        ID
        x
        y
        z
        an
        bn
        D
        
        tissue_flag = 1     % 1 if this data point is within the tissue geometry
                            % 0 if it is not
        
        % STATS, computed on symmetric half of the ODF
        corr_coeff
        mean_odd
        mean_odf
        oi_odd
        oi_odf
        sd_odf
        sd_odd
        skew_odd
        skew_odf
        kurtosis_odd
        kurtosis_odf
        
        %CircularStatistics
        PrefDVector
        PrefDAngle
        

        
        theta = pi/180:pi/180:2*pi;
    end
    
    methods
        function obj = Normalize(obj)
            % circshift to account for intensity and fiber distribution
            % being orthogonal
            fiber_direction_intensity = circshift(obj.intensity_data', 90)';
           
            area = 0;
            for i = 2:length(fiber_direction_intensity)
                area = area + (1/2)*(fiber_direction_intensity(i) + fiber_direction_intensity(i-1))*(obj.theta(i)-obj.theta(i-1));
            end
            %ODD (Orientation Distribution Data) is the normalized data
            obj.odd = fiber_direction_intensity/area;
        end
        
        function obj = GenerateFourier(obj, fs_order)
            %Allocate space for an and bn
            obj.an = [];
            obj.bn = [];
            %Calculate even order fourier coefficients
            for n = 2:2:(fs_order)
               obj.an = [obj.an compute_an(n, obj.odd, obj.theta)];
               obj.bn = [obj.bn compute_bn(n, obj.odd, obj.theta)];
            end
            %ODF is the Fourier Series representation of the data
            obj.odf = evalFourierRad(obj.an, obj.bn, 1, obj.theta);
            %Compute correlation coefficient to check the fit of the data
            obj.corr_coeff = compute_corr_coeff(obj.odd, obj.odf);
        end
        
        function obj = ComputeCoefficientsFromTensors(obj)
            an_ = [];
            bn_ = [];
            for i = 1:length(obj.D)
                b = 0; a = 0;
                rank = i * 2;
                tensor = obj.D{i};
                tensor_ind = ones(1,rank);
                
                a = getTensorValue2(tensor, tensor_ind);
                
                tensor_ind(end) = 2; % one 2 term gives bn
                
                b = getTensorValue2(tensor, tensor_ind);
                
                an_ = [an_ a]; 
                bn_ = [bn_ b]; 
            end
            obj.an = an_;
            obj.bn = bn_;
        end
        
        function new = copy(this)
            % Instantiate new object of the same class.
            new = feval(class(this));
 
            % Copy all non-hidden properties.
            p = properties(this);
            for i = 1:length(p)
                new.(p{i}) = this.(p{i});
            end
         end
        
        function new_obj = ApplyTransformation(obj, T)
            % Applies a transformation to the input obj's tensors
            % stored in D as well as to the X and Y coordinates. 
            %
            % Transformation matrix, T, should be of the following form:
            %             T1 = [R(1)    R(3)    tx;
            %                   R(2)    R(4)    -ty;
            %                   0       0       1];
            %
            % Where R is the rotation matrix, composed of 
            % cosines and sins of the rotation angle
            new_obj = copy(obj);

            x_y_mm = [new_obj.x; new_obj.y; 1];
            x_y_prime = T * x_y_mm;  % vector post-tranformation

            new_obj.x = x_y_prime(1);
            new_obj.y = x_y_prime(2);
                   
            R = [T(1,1) T(1,2); T(2,1) T(2,2)];
            
            rot_angle_rad = acos(T(1,1)); % could be acos(R(1))...etc
            new_obj.mean_odf = new_obj.mean_odf + rot_angle_rad;
            new_obj.mean_odd = new_obj.mean_odd + rot_angle_rad;
            
            for i = 1:length(new_obj.D)
               rank = i*2;
               new_obj.D{i} = rotateTensor(new_obj.D{i}, rank, R);
            end
            
            new_obj = new_obj.ComputeCoefficientsFromTensors;
        end
        
        function [theta1, theta2] = ComputeSymAngles(obj)
            D_ij = [obj.an(1) obj.bn(1);
                    obj.bn(1) -obj.an(1)]; 
            [v, d] = eig(D_ij);
            theta1 = atan(v(2, 2) / v(2, 1));
            theta2 = atan(v(1, 2) / v(1, 1));
        end
        
        function obj = GenerateTensors(obj)
            %% Generate Tensors            
            ranks = 2:2:(length(obj.an)*2);
            obj.D = cell(1,length(ranks));
            for r = 1:length(ranks);
                rank = ranks(r);
                aVal = obj.an(rank/2);
                bVal = obj.bn(rank/2);
                tensor = [];

                indices = permn([1 2], rank);
                for i = 1:length(indices)
                   index = indices(i,:);
                   k = sum(index ==2);
                   if mod(k,2) == 0
                        val = ((-1)^(k/2))*aVal;
                    else
                        val = ((-1)^((k-1)/2))*bVal;
                   end

                   tensor = setTensorValue2(tensor, index, val);
                end
                obj.D{r} = tensor;
            end
            return 
        end
        
        function obj = ComputeStats(obj)
            % Convenience function for computing mean, oi, sd
            %disp('ODF');
            obj = obj.ComputeStatsODF;
            obj = obj.ComputeStatsCirc;
            %disp('ODD')
            obj = obj.ComputeStatsODD;
        end
        
        function obj = ComputeStatsCirc(obj)
            %Find PrefDAngle
            weights = abs(obj.odf);
            doubleAngles = 2.*obj.theta;
            xVect = mean(weights.*cos(doubleAngles));
            yVect = mean(weights.*sin(doubleAngles));
            obj.PrefDAngle = atan2(yVect, xVect) / 2;

            %Compute this into a normalized Vector
            xVect = cos(obj.PrefDAngle);
            yVect = sin(obj.PrefDAngle);
            obj.PrefDVector = [xVect yVect];
        end
        
        function obj = ComputeStatsODF(obj)
            [thetaI, thetaII] = obj.ComputeSymAngles();
            
            interval = pi/180;
            halftheta = thetaII:interval:thetaII + pi - pi/180;
            odf_FS_fit = evalFourierRad(obj.an, obj.bn, 2,  halftheta);
            
            %Correct for negatives
            [~,index] = max(odf_FS_fit);
            
            flag = 0;
            for i = 1:index
                if odf_FS_fit(i) < 0
                    flag = i;
                end
            end
            odf_FS_fit = [zeros(1,flag) odf_FS_fit(1,flag+1: end)];
            
            flag = 181;
            for i = 180:-1:index
                if odf_FS_fit(i) < 0
                    flag = i;
                    break;
                end
            end
            
            odf_FS_fit = [odf_FS_fit(1,1:flag-1) zeros(1,181-flag)];
            
            %Renormalize
            area = 0;
            for i = 2:length(odf_FS_fit)
                area = area + (1/2)*(odf_FS_fit(i) + odf_FS_fit(i-1))*(halftheta(i)-halftheta(i-1));
            end
            %ODD (Orientation Distribution Data) is the normalized data
            odf_FS_fit = odf_FS_fit/area;
            
            mean = compute_mean(odf_FS_fit, halftheta);
            [oi, sd] = compute_orientation_index(mean, odf_FS_fit, halftheta);
            obj.mean_odf = mean;
            obj.oi_odf = oi;
            obj.sd_odf = sd;
            
            [thirdMoment, thirdMoment1] = thisMoment(halftheta,mean,odf_FS_fit,3);
            %skewMine = thirdMoment/(obj.sd_odf^3);
            skewMine1 = thirdMoment1/(obj.sd_odf^3);
            
            [fourthMoment, fourthMoment1] = thisMoment(halftheta,mean,odf_FS_fit,4);
            %kurtosis = fourthMoment/(obj.sd_odf^4);
            kurtosis1 = fourthMoment1/(obj.sd_odf^4);
                        
            obj.skew_odf = skewMine1;
            obj.kurtosis_odf = kurtosis1;
            obj.kurtosis_odf = obj.kurtosis_odf/3;
                        
        end
        
        function obj = ComputeStatsODD(obj)            
            [piSegment, piSegmentRange] = obj.GetODDPiSegment();
            mean = compute_mean(piSegment, piSegmentRange);
            [oi, sd] = compute_orientation_index(mean, piSegment, piSegmentRange);
            obj.mean_odd = mean;
            obj.oi_odd = oi;
            obj.sd_odd = sd;
            
            obj.skew_odd = 1;%skewness(piSegment);
            obj.kurtosis_odd = 1;%kurtosis(piSegment);
            
        end

        function [piSegment, piSegmentRange] = GetODFPiSegment(obj) 
            [thetaI, thetaII] = obj.ComputeSymAngles;
            symmetry_angle_deg = round(thetaII * 180/pi);
            piSegmentRange = (symmetry_angle_deg*pi/180):pi/180:(symmetry_angle_deg*pi/180 + pi - pi/180);

            symmetry_angle_deg = round(thetaII * 180/pi);
            if symmetry_angle_deg > 180
                symmetry_angle_deg = symmetry_angle_deg - 180;
            end
            if symmetry_angle_deg <= 0
                symmetry_angle_deg = symmetry_angle_deg + 180;
            end
            
            segmentRangeDegree = symmetry_angle_deg:1:(symmetry_angle_deg+179);
            piSegment = obj.odf(segmentRangeDegree)*2; % must be multiplied by two in order to still be a PDF
        end
        
        function [piSegment, piSegmentRange] = GetODDPiSegment(obj) 
            [thetaI, thetaII] = obj.ComputeSymAngles;
            symmetry_angle_deg = round(thetaII * 180/pi);
            piSegmentRange = (symmetry_angle_deg*pi/180):pi/180:(symmetry_angle_deg*pi/180 + pi - pi/180);

            symmetry_angle_deg = round(thetaII * 180/pi);
            if symmetry_angle_deg > 180
                symmetry_angle_deg = symmetry_angle_deg - 180;
            end
            if symmetry_angle_deg <= 0
                symmetry_angle_deg = symmetry_angle_deg + 180;
            end
            
            segmentRangeDegree = symmetry_angle_deg:1:(symmetry_angle_deg+179);
            piSegment = obj.odd(segmentRangeDegree) * 2;% must be multiplied by two in order to still be a PDF
        end
        
        function [str_] = print(obj, dlm) 
            c = {num2str(obj.x),
                num2str(obj.y),
            num2str(obj.mean_odf),
            num2str(obj.mean_odd),
            num2str(obj.oi_odf),
            num2str(obj.oi_odd),
            num2str(obj.sd_odf),
            num2str(obj.sd_odd),
            num2str(obj.corr_coeff),
            num2str(obj.skew_odd),
            num2str(obj.skew_odf),
            num2str(obj.kurtosis_odd),
            num2str(obj.kurtosis_odf),
            strrep(strrep(mat2str(obj.an'),']',''),'[',''), 
            strrep(strrep(mat2str(obj.bn'),']',''),'[',''),
            num2str(obj.z)};
            str_ = strjoin(c, dlm);
        end
                
        function new_data_point = ApplyTransformation2(obj, T)
            % Note that this method should use the tensors in obj.D to
            % apply a trasformation described by a second order tensor Q as
            % in the documentation. However, until I figure out how to do
            % this, this implementation, which applies the transform to the 
            % raw intensity data will do.
            %
            %             T1 = [R(1)    R(3)    tx;
            %                   R(2)    R(4)    -ty;
            %                   0       0       1];
            new_data_point = obj;
            
            XY = [new_data_point.x; new_data_point.y; 1];
            XY_Prime = T*XY;
            
            new_data_point.x = XY_Prime(1);
            new_data_point.y = XY_Prime(2);
            
            %% We shift the data and recompute the coefficients and the tensors...
            rot_angle_deg = acos(T(1,1))*180/pi; % could be acos(R(1))...etc
            new_data_point.odd = circshift(new_data_point.odd', round(rot_angle_deg))';
            new_data_point = new_data_point.GenerateFourier(length(obj.an) + length(obj.bn));
            
            
            new_data_point = new_data_point.ComputeStats;         
            % or
            %rot_angle_rad = acos(T(1,1)); % could be acos(R(1))...etc
            %new_data_point.mean_odf = obj.mean_odf + rot_angle_rad;
            %new_data_point.mean_odd = obj.mean_odd + rot_angle_rad;        
        end
    end    
    
    methods (Static)
        function [header] = header(dlm) 
            header = 'x.y.PrefD(ODF).PrefD(ODD).OI(ODF).OI(ODD).SD(ODF).SD(ODD).Corr_coeff.Skew(ODD).Skew(ODF).Kurtosis(ODD).Kurtosis(ODF).an.bn.z';
            header = strrep(header, '.', dlm);        
        end
        
        function [header] = headerTecplot(dlm) 
            header = 'VARIABLES = "x", "y", "PrefD(ODF)", "PrefD(ODD)", "OI(ODF)", "OI(ODD)", "SD(ODF)", "SD(ODD)", "Corr_coeff", "Skew(ODD)","Skew(ODF)", "Kurtosis(ODD)","Kurtosis(ODF)", "an", "bn", "z"\n';
            header = strcat(header, 'ZONE DATAPACKING=POINT');
            header = strrep(header, '.', dlm);        
        end
        
        function [obj] = parse(str,dlm)
            obj = data_point;
            vals = strsplit(str,dlm);
            [obj.x, obj.y, obj.mean_odf, obj.mean_odd, obj.oi_odf, obj.oi_odd, obj.sd_odf, obj.sd_odd, obj.corr_coeff, obj.skew_odd,obj.skew_odf, obj.kurtosis_odd,obj.kurtosis_odf, an, bn] = strsplit(str_,dlm);
            obj.an = str2num(an)';
            obj.bn = str2num(bn)';
        end
        
        function [tissue_only] = GetOnlyTissuePoints(data_points)
           tissue_only = data_point.empty;
           for i=1:length(data_points)
              dp = data_points(i);
              if dp.tissue_flag == 1
                 tissue_only = [tissue_only dp];
              end
           end
        end
    end
end

