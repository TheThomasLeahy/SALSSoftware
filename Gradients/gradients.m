%Gradient Program
%Object Oriented Matlab Code by Kristen Feaver w/ GUI by Steven LaBelle

%Create class for Gradient
classdef gradients <handle

    %Create properties for the class
    properties (Access = private)
        %GUI stuff
        Figure

        
        %File location stuff
        tecplotFile
        tecplotFilePath
        
        %output location stuff
        outputPath
        outputFile
        output
        
        %input tecplot variables
        Node
        Xpos
        Ypos
        Zpos
        Bit
        OI
        BL
        MaxI
        PrefD
        Skew
        Kurtosis
        H1111
        H2211
        H1112
        H2212
        H1122
        H2222
        Xn
        Yn
        H1n
        H2n
        H3n
        H4n
        H5n
        H6n
        PrefD3
        
        %gradients variables
        xdim
        ydim
        zdim
        data
        data_out
        vec_data_out
        vec_headers_out
        headers_out
        tens_data_out
        tens_headers_out
        

    end
    methods
        
        function this = gradients
            
            %create objects for the figure
            
            this.Figure = guihandles(gradients_GUI);
          
            set(this.Figure.uipanel,'closerequestfcn', @(src,event) Close_fcn(this,src,event));
            
            set(this.Figure.closeProgram, 'callback', @(src,event) Close_fcn(this,src,event));
            
            set(this.Figure.fileIn, 'callback', @(src, event) Open_File(this, src, event));
            
            set(this.Figure.RunAnalysis, 'callback', @(src, event) rungradients(this, src, event));
            
            set(this.Figure.fileOut, 'callback', @(src, event) setOutputPath(this, src, event));
            
      
        end
    end
    
    methods (Access=private)
        
        %% Class deconstructor - handles the cleaning up of the class &
        %figure. Either the class or the figure can initiate the closing
        %condition, this function makes sure both are cleaned up
        function delete(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infinite loop with the following delete command
            set(this.Figure.uipanel,  'closerequestfcn', '');
            %delete the figure
            delete(this.Figure.uipanel);
            %clear out the pointer to the figure - prevents memory leaks
            this.Figure = [];
        end
        
        %% function - Close_fcn
        %
        %this is the closerequestfcn of the figure. All it does here is
        %call the class delete function (presented above)
        function this = Close_fcn(this, src, event)        
            
            delete(this);
        end
        
%         function regClick(this,src,event)
%            F=get(gca,'CurrentPoint')
%         end
        
        %% Function- Open_File
        %
        %this is the text file loader of the application
        %can be called twice, but only after the first call is completed
        %opens the file, pulls the data, separates first line, and throws
        %to app properties origMat and input_size;
        function this = Open_File(this,src,event)
            [this.tecplotFile, this.tecplotFilePath]=uigetfile('\*.plt','Pick a Tecplot File to Analyze');
            if isequal(this.tecplotFile,0)
                set(this.Figure.fileChosen,'String','No File Selected');
                set(gcf, 'Pointer', 'arrow')
                drawnow;    
            else
%                 filename = strcat(this.tecplotFilePath,this.tecplotFile);
%                 if nargin<=2
%                     startRow = 3;
%                     endRow = inf;
%                 end
                set(this.Figure.fileChosen,'String',strcat(this.tecplotFilePath,this.tecplotFile));
%                 [Node,Xpos,Ypos,Zpos,Bit,OI,BL,MaxI,PrefD,Skew,Kurtosis,H1111,H2211,H1112,H2212,H1122,H2222,Xn,Yn,H1n,H2n,H3n,H4n,H5n,H6n] = importfile(nargin);  
                fid=fopen(strcat(this.tecplotFilePath,this.tecplotFile),'r');
                delimiter = '\t';
                formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';               
                % This call is based on the structure of the file used to generate this
                % code. If an error occurs for a different file, try regenerating the code
                % from the Import Tool.
                startRow = 3; endRow = inf;
                dataArray = textscan(fid, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
                for block=2:length(startRow)
                    frewind(fid);
                    dataArrayBlock = textscan(fid, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
                    for col=1:length(dataArray)
                        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
                    end
                end
                
                fclose(fid)

                this.Node = dataArray{:, 1};
                this.Xpos = dataArray{:, 2};
                this.Ypos = dataArray{:, 3};
                this.Zpos = dataArray{:, 4};
                this.Bit = dataArray{:, 5};
                this.OI = dataArray{:, 6};
                this.BL = dataArray{:, 7};
                this.MaxI = dataArray{:, 8};
                this.PrefD = dataArray{:, 9};
                this.Skew = dataArray{:, 10};
                this.Kurtosis = dataArray{:, 11};
                this.H1111 = dataArray{:, 12};
                this.H2211 = dataArray{:, 13};
                this.H1112 = dataArray{:, 14};
                this.H2212 = dataArray{:, 15};
                this.H1122 = dataArray{:, 16};
                this.H2222 = dataArray{:, 17};
                this.Xn = dataArray{:, 18};
                this.Yn = dataArray{:, 19};
                this.H1n = dataArray{:, 20};
                this.H2n = dataArray{:, 21};
                this.H3n = dataArray{:, 22};
                this.H4n = dataArray{:, 23};
                this.H5n = dataArray{:, 24};
                this.H6n = dataArray{:, 25};
            end
        end
        
        %% setOutputPath
        %  Sets the output pathway
        
        function setOutputPath(this,src,event)
            this.outputPath=uigetdir('Please select an output path');
            if isequal(this.outputPath,0)
                set(this.Figure.fileOChosen,'String','No Path Selected');
                setOutputPath(this,src,event);
            else
                this.outputFile='gradientout-.plt';
%                 this.outputFile=strcat('gradientout-',this.tecplotFile)
%                 this.outputFile=get(this.Figure.outputFile,'String');
                if isequal(this.outputFile,'Output File Name')
                    set(this.Figure.fileOChosen,'String','No File Selected');
                else
                    this.output=strcat(this.outputPath,'/','gradients.',this.tecplotFile);
                    set(this.Figure.fileOChosen,'String',this.output);
                end
            end
        end
                        
        %% Function - run gradients
        function rungradients(this, src, event)

            %obtain dimensions
            this.headers_out = [];
            this.data_out = [];
            this.vec_data_out = [];
            this.tens_data_out = [];
            this.vec_headers_out = [];
            this.tens_headers_out = [];
            xystep = max(diff(this.Xpos));
            zstep = max(diff(this.Zpos));
            xmin = min(this.Xpos);
            xmax = max(this.Xpos);
            ymin = min(this.Ypos);
            ymax = max(this.Ypos);
            zmin = min(this.Zpos);
            zmax = max(this.Zpos);    
            this.xdim = round((xmax - xmin)/xystep)+1;
            this.ydim = round((ymax - ymin)/xystep)+1;
            this.zdim = round((zmax - zmin)/zstep)+1;

            %If OI selected
            if get(this.Figure.OICheck,'Value');      
                set(this.Figure.status,'String','Finding OI');
                pause(.25);
                [this.data_out, this.headers_out]=gradient3d(this.OI,this.xdim,this.ydim,this.zdim);
            end
            %If PD selected
            if get(this.Figure.PDCheck,'Value');
                set(this.Figure.status,'String','Finding PD');
                pause(.25);
                this.PrefD3 = [cos(this.PrefD), sin(this.PrefD), zeros(length(this.PrefD),1)];
                [this.vec_data_out, this.vec_headers_out]=gradient3d(this.PrefD3,this.xdim,this.ydim,this.zdim);
            end
            %If H selected
            if get(this.Figure.HCheck,'Value');
                set(this.Figure.status,'String','Finding H');
                pause(.25);
                [this.tens_data_out, this.tens_headers_out]=gradient3d(this.vec_data_out,this.xdim,this.ydim,this.zdim);
            end
            
            gradientsOutput(this);
        end
                        
        %% - Function: gradientsOutput
        %output the desired values into a tecplot file
            
        function gradientsOutput(this)
            set(this.Figure.status,'String','Writing to File');
            pause(.25);
            variable=[{'Node#','Xpos','Ypos','Zpos','Bit','OI','BL','MaxI','PrefD','Skew','Kurtosis','H1111','H2211','H1112','H2212','H1122','H2222','Xn','Yn','H1n','H2n','H3n','H4n','H5n','H6n'},this.headers_out this.vec_headers_out this.tens_headers_out];
            tecplotdata = [this.Node this.Xpos this.Ypos this.Zpos this.Bit this.OI this.BL this.MaxI this.PrefD this.Skew this.Kurtosis this.H1111 this.H2211 this.H1112 this.H2212 this.H1122 this.H2222 this.Xn this.Yn this.H1n this.H2n this.H3n this.H4n this.H5n this.H6n this.data_out this.vec_data_out this.tens_data_out];
            
            %create the filename
            filename=this.output;
            f=fopen(filename,'w');
            fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
            fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"'))%\n'));
            fprintf(f,'ZONE I= %i, J= %i, K=%i, DATAPACKING=POINT \n',this.ydim,this.xdim,this.zdim);
            dlmwrite (filename, tecplotdata, 'delimiter','\t','-append');  % All the sections are in the file with consecutive ID number
            fclose(f);   
            set(this.Figure.status,'String','Ready');
            msgbox('~*~Gradient File Save Completed~*~');
            
        end
    end

end