        function addTecplotDataSet(this,src,event);
            [exFile, exFilePath]=uigetfile('\*.txt','Choose the SALSA file of the first slice in this data set');
            path =uigetdir(exFilePath,'Select the Folder with the SALS Subset Files You Wish To Add Together');
            separateString='/*slicenumbers*';                 %This is the string that will be used to separate out the 3D files from the rest
            files = dir([path separateString]);
            filelist = sort_nat(cellstr(char(files(1:end,:).name)));%Sort the list of file names from 1-n slices
                fid=fopen(fullfile(exFilePath,exFile));
                string=fread(fid,'*char'); %Read the 2D slice data in as a string
                splitTest=char(strsplit(string(:,1)','\n'));
                rowcol=str2num(splitTest(1,:));
                rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3;
                variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total nnumber
                totalrow= rowcol(1,1)*rowcol(1,2);

            mm=1;
            newdata=[];
    %         sliceArray=strsplit(filelist{1},'_') %Split the string array using underscores, the title MUST begin with the slice number
            K=0;
            for slice = 1:length(filelist);
                     sliceArray(slice,:)=strsplit(filelist{slice},'_') %Split the string array using underscores, the title MUST begin with the slice number
                     data =dlmread(fullfile(path,filelist{slice}));
                     data(:,1)= data(:,1)+((slice-1).*length(data)); %Renumbers the nodes depending on the slice number
                     newdata=[newdata; data];
                     tempK=str2num(char(sliceArray(slice,3)))-str2num(char(sliceArray(slice,2)))+1;
                     K=K+tempK;
            end
                variable(1,5:(end+1))=variable(4:end);
                variable(1,4)={'Zpos'}; %Add in the Z variable to the variable list


%Mac Version            
%             f=fopen((strcat(path,'/',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')),'w'); %Need to write a variable output name
%             dlmwrite((strcat(path,'/',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')), newdata,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
%             set(this.Tec.transText,'String',strcat(path,'/',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt'));
            
            f=fopen((strcat(path,'\',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')),'w'); %Need to write a variable output name
            fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
            fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
            fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(rowcol(1,1)),num2str(rowcol(1,2)),num2str(K));
            dlmwrite((strcat(path,'\',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')), newdata,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
            set(this.Tec.transText,'String',strcat(path,'\',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt'));

        end