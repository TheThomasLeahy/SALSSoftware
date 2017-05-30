classdef TSALS <handle
    %written by John G Lesicko
    %TSALS: Serial SALS Analysis program for Transmural applications
    %   Loads stack SALS Files and A-SALS Files 
    %   Generates 4th order H values and appends to SALSA Files
    
    properties (Access = private)

        Figure
        
        salsfilepath
        salsfiles
        
        tsalsfilepath
        tsalsfiles
        
        xmlfilepath
        xmlfiles
        
        fileoutpath
        numFiles
        
        sectionThickness;
        input_size
        
        imagesize

        savedVariablesPath
    end
    %% CONTRUCTOR METHODS
    methods
        
        function this = TSALS
     
            this.Figure = guihandles(TSALS_GUI);
            
            set(this.Figure.mainFig,'Units','normalized','OuterPosition',[.1,.1,.7,.7]);
            
            set(this.Figure.mainFig,'closerequestfcn',@(src,event) Close_fcn(this,src,event));
            
            set(this.Figure.close,'callback', @(src,event) Close_fcn(this,src,event));
            
            set(this.Figure.salspath,'callback', @(src,event) GetPath(this,src,event, 1));
            
            set(this.Figure.tsalspath,'callback',@(src,event) GetPath(this,src,event, 2));
            
            set(this.Figure.xmlpath,'callback', @(src, event) GetPath(this,src,event,3));
            
            set(this.Figure.run,'callback',@(src,event) prepSerialAnalysis(this,src,event));
        end


    end
    
    %% STATIC METHODS
    methods(Static)
          %% genRadsList
          %generates values in radians between 0 and 180 degrees
          function [radsList] = genRadsList(mintheta,maxtheta)
             
              
            if nargin<2
                mintheta=-90;
                maxtheta=90;
            end

            temp=zeros(1,180);
            temprad=mintheta*(pi/180.0);
            inc=pi/179.0;
            for i=1:180
                temp(1,i)=temprad;
                temprad=temprad+inc;

            end

            radsList=temp;
          end   
        
          %% NormalizeDist
          function [ nDist] = NormalizeDist( Dist, radslist )

            area=0;
            temp=0;

            for z=2:180
                temp=(0.5*(Dist(z)+Dist(z-1)))*(radslist(z)-(radslist(z-1)));
                area=area+temp;
            end

            nDist=Dist/area;
          end
          function [Hvals] = returnH( dist, radslist, Kron2)
            htens4=zeros(2,2,2,2);
            for i=1:2
                for j=1:2
                    for k=1:2
                        for l=1:2
                            htens4(i,j,k,l)=calc4thComp(dist,radslist,i,j,k,l);
                        end
                    end	
                end    
            end
            Hvals=[htens4(1,1,1,1) htens4(2,2,1,1) htens4(1,1,1,2) htens4(2,2,1,2) htens4(1,1,2,2) htens4(2,2,2,2)];

          end
    end
    
    %% CLASS SPECIFIC METHODS
    methods (Access=private)
        %% Class deconstructor - handles the cleaning up of the class &
        %figure. Either the class or the figure can initiate the closing
        %condition, this function makes sure both are cleaned up
        function delete(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infinite loop with the following delete command
            set(this.Figure.mainFig,  'closerequestfcn', '');
            %delete the figure
            delete(this.Figure.mainFig);
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
        
        
        %% function GetPath
        function GetPath(this, src, event, caller)
            
                caller_path = uigetdir();
                if isequal(caller_path,0) ;
                    return;
                else
                    if caller==1
                            set(this.Figure.salspathdisp,'String',caller_path);
                            this.salsfilepath=caller_path;
                    elseif caller==2
                            set(this.Figure.tsalspathdisp,'String',caller_path);
                            this.tsalsfilepath=caller_path;
                    elseif caller ==3
                            set(this.Figure.xmlpathdisp,'String',caller_path);
                            this.xmlfilepath=caller_path;
                    end

                    load_Content(this, caller_path, caller);
                
                end
        end

        function load_Content(this, caller_path, caller)

            baseFolderName = {};
            temp_folder = caller_path;

            fprintf(1, 'Getting list of content in folder: %s\n', temp_folder);

            folder_content = dir(temp_folder);

            %remove hidden files
            folder_content = folder_content(arrayfun(@(x) ~strcmp(x.name(1),'.'),folder_content));
            counter = 2;
            for Index = 1:length(folder_content)
                tempFolderName = folder_content(Index).name;
                [folder2, name, extension] = fileparts(tempFolderName);
                switch lower(extension)
                    case {'.txt'}
                        baseFolderName = [baseFolderName tempFolderName];
                        content_case = 1;
                        counter = counter + 1;
                    otherwise
                        baseFolderName = [baseFolderName tempFolderName];
                        content_case = 2;
                end
            end

            if counter == length(folder_content)
                image_name = tempFolderName;
            else
                image_name = [];
            end

            if content_case == 2;
                baseFolderName = fliplr(baseFolderName);
                temp_1 = baseFolderName(length(baseFolderName));
                temp_2 = baseFolderName(length(baseFolderName)-1);
                baseFolderName(length(baseFolderName)) = '';
                baseFolderName(length(baseFolderName)) = '';
                baseFolderName = [temp_1 temp_2 baseFolderName];
                baseFolderName = sort_nat(cellstr(baseFolderName));
            else
            end

            if caller==1
                    set(this.Figure.salsfilelist,'string', baseFolderName, 'value', 1);
                    this.salsfiles=baseFolderName;
            elseif caller==2
                    set(this.Figure.tsalslist,'string', baseFolderName,'Value', 1);
                    this.tsalsfiles=baseFolderName;
            elseif caller==3   
                    set(this.Figure.xmlfilelist,'string', baseFolderName,'Value',1);
                    this.xmlfiles=baseFolderName;
            end

            temp = strsplit(caller_path,'\');
            temp = temp(length(temp));
            
        end
        
        
        %% Get XML file, for use in 
        
        function getXML(this, src, event)
            
            str = 'kdjfhakdsjfhtransform="matrix(1.0,0.0,0.0,1.0,0.0,0.0)"';
            exp = 'transform="matrix([0123456789.,]+)"';
            matind = re4gexp(str, exp);
            disp(matind);
            
        end
        
        %% Prep Serial Analysis
        %# get ready for 4th order cereal analysis
        function prepSerialAnalysis(this,src,event)
            %make sure all sals files are the same size
            if (length(this.salsfiles)~=length(this.tsalsfiles)) || length(this.salsfiles)==0
                        errordlg('Number of SALS files does not match number of threshold files', 'Folder length mismatch, yo!');
                        return;
            else
                %get number of files, directory, loads image,run serial
                %analysis
                this.numFiles=length(this.salsfiles);
                write_path = uigetdir('C:\', 'Choose where you want to store your data');
                if isequal(write_path,0);
                    return;
                else
                    this.fileoutpath=write_path;
                    set(this.Figure.outpath,'string',write_path);
                end
                
                [picFile, picFilePath] = uigetfile('*.tif','Select an Original (aka not Transformed) Fiji Picture')
                if isequal(picFilePath,0);
                    return;
                else
                    origPic= imread(fullfile(picFilePath,picFile));
                    this.imagesize=size(origPic);
                end
                runSerialAnalysis(this,src,event);
            end
        end
        
        %% Run Serial Analysis
        %# do all the things
        function runSerialAnalysis(this,src,event)
            %Start a stopwatch timer
            tic
            
            %create a vector from 0-180 degrees (0 to pi) in ~ 1 degree
            %increments
            radsList= TSALS.genRadsList( 0,180);
            %create a 2x2 identity matrix
            KronDel=eye(2);
            %create 1x360 matrix
            ndist=zeros(1,360);
            %create 1x6 matrix
            listuniqueH=zeros(1,6);
            %create allData variable
            allData=[];
            zbitmap=[];
            %create adg variable
            adg=0;
            %generate waitbar, set at 0%
            wait_bar = waitbar(0,'Please wait...');
            
            maxI = 0;
            maxJ = 0;
            for fnum=1:this.numFiles
                strfile_sals=fullfile(this.salsfilepath,(this.salsfiles{fnum}));
                %opens the file specified in the last step for reading
                sals_fid=fopen(strfile_sals,'r');
                %read in the values as characters
                st = fread(sals_fid,'*char')';
                fclose(sals_fid);
                i_j = sscanf(st,'%e',[2,1])';
                if (i_j(1) > maxI)
                    maxI = i_j(1);
                end
                if (i_j(2) > maxJ)
                    maxJ = i_j(2);
                end
            end
            
            % initialize planar average array
            avgPD_array = zeros(1,this.numFiles);
            
            for fnum=1:this.numFiles
                %update the waitbar on percent completion
                per=(fnum-1)/this.numFiles;
                waitbar(per,wait_bar,strcat(num2str(per*100),'% Complete'));
                
                %this.salsfiles{fnum} gets the name of the current file
                %then fullfile concatenates the name with the folder path
                strfile_sals=fullfile(this.salsfilepath,(this.salsfiles{fnum}));
                %opens the file specified in the last step for reading
                sals_fid=fopen(strfile_sals,'r');
                %read in the values as characters
                st = fread(sals_fid,'*char')';
                %closes the current file
                fclose(sals_fid);
                N=1;
                %reads the values indicating the dimensions of the scan
                this.input_size=sscanf(st,'%e',[2,N])';
                %creates a matrix for the data
                data=sscanf(st,'%f',inf)';
                %removes dimension values (first two entries)
                origMat=data(3:end);

                %get filename for current transmural file
                strfile_tsals=fullfile(this.tsalsfilepath,(this.tsalsfiles{fnum}));
                %open transmural file
                tsals_fid=fopen(strfile_tsals,'r');
               
                %Sets section thickness (mm) if this is the first file read
                if fnum == 1
                    this.sectionThickness = strsplit(strfile_tsals,'_');
                    this.sectionThickness = strsplit(cell2mat(this.sectionThickness(length(this.sectionThickness))),'.');
                    this.sectionThickness = sym(this.sectionThickness(1));
                    this.sectionThickness = (str2num(char(this.sectionThickness)))/1000;
                end
                
                %read in data
                ftext=fread(tsals_fid,'*char')';
                %split into different columns
                splitTest=char(strsplit(ftext(1,:),'\n'));
                %read in transmural dimensions (should be same as SALS)
                disp(strfile_tsals)
                transsizes = dlmread(strfile_tsals,'\t',[0 0 0 1]);
                %read in transmural headers (keeps same column names as 
                transheaders=splitTest(2,:);
                %get only the data and make tab delimited matrix.
                transbitmap= dlmread(strfile_tsals,'\t',2,0);
                transbitmap(:,11)=[];
                %# Start SALS File Data Analysis
                %find x and y coordinates
                y=this.input_size(1,1); x=this.input_size(1,2);
                %calculate number of nodes
                TE=y*x;
                %allocate memory for raw data
                pos=zeros(TE,2); % create matrix TE long and 2 wide
                rawInt=zeros(TE,360); %create matrix TE long and 360 wide
                HVALS=zeros(y,x,6); %create 3D matrix y long x wide 6 thick
                %6 so there is room for both the 4th and 2nd order tensor
                %values


                %parse input data string
                for d=1:(TE)
                   pos(d,:)=origMat((1+((d-1)*767)):(2+((d-1)*767))); %fill position matrix. 767 is space from one location to the next in the file
                   rawInt(d,:)=origMat((3+((d-1)*767)):362+((d-1)*767)); %fill raw intensity matrix                
                end
                
                count=0;
                i=1; %counter for x
                j=1; %counter for y
                for Ti=1:TE %TE is the area of the matrix (number of nodes)
                    %load the distribution for the full 360 degrees
                    %avg the intensity between 1st and 2nd values
                   dist=(rawInt(Ti,1:180)+rawInt(Ti,181:360))/2.0; 
                   [ndist]=TSALS.NormalizeDist(dist, radsList); % normalize intensity
                   [listuniqueH] = returnHTSALS(ndist ,radsList, KronDel); %Tensor values for this point?
                   HVALS(j,i,:)=listuniqueH; %Update tensor 3D matrix
                    if j>=y
                       j=1;
                       i=i+1;
                       count=count+y;
                    else j=j+1;
                    end
                end
                            % flip data of down-columns
                for k = 2:2:x
                    for t=1:6
                        HVALS(:,k,t)=flipud(reshape(HVALS(:,k,t),y,1)); %flipud flips the matrix upside down
                    end

                end
%%                 

                [fullbitmap,fullheaders] = appendHVALS(this,this.input_size, TE,transheaders,transbitmap,HVALS);
                
                % Creating a transform array (R) for the file and adding the transformed x, y and tensor values to the bitmap
                TransformData =textread(strcat(this.xmlfilepath,'/',this.xmlfiles{fnum}),'%s','delimiter','"');

                xmldatasize = size(TransformData);
                if (xmldatasize(1)==14)
                    Transform = [str2num(char(TransformData(5,:))) str2num(char(TransformData(12,:)))];
                    R = [Transform(:,1) Transform(:,2) Transform(:,3) Transform(:,4) Transform(:,5)]; %Final output is [theta tx ty]
                elseif (xmldatasize(1)==5)
                    Transform = [str2num(char(TransformData(4,:)))];
                    R=Transform;
                elseif (xmldatasize(1)==10)
                    split = char(TransformData{9});
                    split = strsplit(split,'('); 
                    split = char(split{2}); %convert to char the cell of interest
                    split = strsplit(split,')'); %split string to remove )
                    split = char(split{1}); %convert to char the cell of interest
                    split = strsplit(split,','); %separate by ,
                    R = str2num(char(split))';
                end
                
%%              Call to datareg.m here
                [regbitmap,regHeaders] = dataRegistration(this.imagesize,fullbitmap,R,this.input_size, [maxI maxJ]);
                
%%              File saving
                transfile=strcat(this.tsalsfiles{fnum},'_TSALS','.txt');
                transfull=fullfile(this.fileoutpath,transfile);
                f=fopen(transfull,'w');
                fprintf(f,'%d\t %d\n',transsizes);
                headerstr = strcat(fullheaders,regHeaders,'\n');
                    % Format String for data with extra reg check values
                formatstr = '%d\t %2.2f\t %2.2f\t %d\t %1.3f\t %d\t %d\t %2.2f\t %3.3f\t %3.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.2f\t %2.2f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f\t %2.3f \n';
                fprintf(f,headerstr);
                fprintf(f, formatstr, regbitmap);
                zbitmap(1,1:size(regbitmap,2)) = this.sectionThickness*fnum;
                regbitmap = [regbitmap(1:3,:)' zbitmap' regbitmap(4:end,:)'];
                allData = [allData; regbitmap];
                adg = size(allData);
                fclose(f);
                
                avgPD = mean(allData(:,9))-90;
                avgPD_array(fnum) = avgPD;
                
                
            end
            
            % save planar average
            
            transfile=strcat(this.tsalsfiles{fnum},'_PAVG','.txt');
            transfull=fullfile(this.fileoutpath,transfile);
            g=fopen(transfull,'w');
            
            slices = (1:this.numFiles);
            fprintf(g,'%5s\t %5s \n','Slice','PrefD');
            fprintf(g,'%d\t %3.3f \n',[slices;avgPD_array]);
            fclose(g);

            endadg=size(allData);
            waitbar(100,wait_bar,'Writing TecPlot File');
            nodes = 1:1:length(allData);
            allData(:,1) = nodes';
            myZeros = zeros(size(allData,1), 8);
            allData = [allData myZeros];
            toc
            writeTSALSTec(this,allData,fullheaders);
            writeParaViewFile(this, allData);
            close(wait_bar);
            disp('duh duh duh done');
            
        end
        
%%        
        function setGlobalVariables(this,src,event)
                    this.radsList= TSALS.genRadsList( 0,180);
                    this.KronDel=eye(2);
        end
        
        %%     Appending the tensors to the transbitmap
        function [fullbitmap,fullheaders] = appendHVALS(this, sizexy, totalnodes,transheaders,transbitmap,HVALS)
                fullheaders = strcat(transheaders,'\tH1111\tH2211\tH1112\tH2212\tH1122\tH2222\t');
                t=1;
                s=size(transbitmap);
                fullbitmap=zeros((s(2)+6),totalnodes);
                s2=size(fullbitmap);
                hvalsOUT = zeros(6,totalnodes);
                forOutTensor1 = zeros(totalnodes,1);
                forOutTensor2 = zeros(totalnodes,1);
                forOutTensor3 = zeros(totalnodes,1);
                forOutTensor4 = zeros(totalnodes,1);
                forOutTensor5 = zeros(totalnodes,1);
                forOutTensor6 = zeros(totalnodes,1);
                for j=1:sizexy(1,2)
                    for i=1:sizexy(1,1)
                        forOutTensor1(t,1) = HVALS(i,j,1); 
                        forOutTensor2(t,1) = HVALS(i,j,2); 
                        forOutTensor3(t,1) = HVALS(i,j,3); 
                        forOutTensor4(t,1) = HVALS(i,j,4); %Create column of Tensors to append
                        forOutTensor5(t,1) = HVALS(i,j,5);
                        forOutTensor6(t,1) = HVALS(i,j,6);
                        t=t+1;
                    end
                end 
                hvalsOUT(1,:)=forOutTensor1;
                hvalsOUT(2,:)=forOutTensor2;
                hvalsOUT(3,:)=forOutTensor3;
                hvalsOUT(4,:)=forOutTensor4;
                hvalsOUT(5,:)=forOutTensor5;
                hvalsOUT(6,:)=forOutTensor6;
                
                fullbitmap(1:s(2),:)=transbitmap';
                fullbitmap(s(2)+1:end,:)=hvalsOUT;


        end
        %%
        function writeTSALSTec(this,allData,fullheaders)
            
                allData = [allData(:,2:4) allData(:,1) allData(:,5:end)];
                
                allData = allData(:, 1:9);
                
                variable={'Xpos','Ypos','Zpos', 'Node#', 'Bit','OI','BL','MaxI','PrefD'};
                [tranSALoutfile,tranSALoutfolder]=uiputfile('*.plt','Please select an output path for the Tecplot Reconstruction');
                if isequal(tranSALoutfolder,0)
                    tranSALoutfolder = this.fileoutpath;
                    tranSALoutfile = 'yourTecplotfile.plt';
                end
                f=fopen((strcat(tranSALoutfolder,'/',tranSALoutfile)),'w'); %Need to write a variable output name
                fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
                fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
                fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(this.input_size(1,1)),num2str(this.input_size(1,2)),num2str(this.numFiles));
                dlmwrite ((strcat(tranSALoutfolder,'/',tranSALoutfile)), allData, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
        end
        
        %% 
        function writeParaViewFile(this, allData)
            allData = [allData(:,2:4) allData(:,1) allData(:,5:end)];
            allData = allData(:, 1:9);
            headerLabels={'Xpos','Ypos','Zpos', 'Node#', 'Bit','OI','BL','MaxI','PrefD\'};
            [paraviewFile,paraviewFolder]=uiputfile('*.csv','Provide Paraview File Output Path');
            if isequal(paraviewFolder,0)
                    paraviewFolder = this.fileoutpath;
                    paraviewFile = 'paraview.csv';
            end
            f=fopen((strcat(paraviewFolder,'/',paraviewFile)),'w'); %Need to write a variable output name
            fprintf(f,strcat(strjoin(headerLabels(1,1:end),', ')),'\n'); % write header
            dlmwrite ((strcat(paraviewFolder,'/',paraviewFile)), allData, 'delimiter',',', '-append');  % All the sections are in the file with consecutive ID number
            fclose(f);
        end
   end

end