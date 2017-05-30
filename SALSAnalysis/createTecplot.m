function createTecplot(this,src,event)
    stringSepName=get(this.Tec.sampName,'String');
    if isequal(stringSepName,'Input Sample Name')
        transPath =uigetdir('C:\','Select the folder containing the 3D SALS Files'); %Select the folder with the 3D SALS fles
        transFiles = dir([transPath '/*.txt']);
         filelist = sort_nat(cellstr(char(transFiles(1:end,:).name)));%Sort the list of file names from 1-n slicse
         sliceArray=strsplit(filelist{1},'_') %Split the string array using underscores, the title MUST begin with the slice number
         fid=fopen(fullfile(transPath,filelist{1}))
         string=fread(fid,'*char'); %Read the 2D slice data in as a string
         splitTest=char(strsplit(string(:,1)','\n'));
         rowcol=str2num(splitTest(1,:));
         rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3;
         variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total nnumber
         totalrow= rowcol(1,1)*rowcol(1,2);
         mm=1;
        for slice = 1:length(filelist) 
                 sliceArray2(slice,:)=strsplit(filelist{slice},'_') %Split the string array using underscores, the title MUST begin with the slice number
                 fid=fopen(fullfile(transPath,filelist{slice}));
                 string=fread(fid,'*char'); %Read the 2D slice data in as a string
                 variableArray=strsplit(string(rowcolString:end,1)','\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
                 variableArray=strjoin(variableArray(1,3:end));
                 data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';
                 zcoord = (str2double((sliceArray2(slice,1)))-1)*(str2double(sliceArray2(slice,3))*.001);      %  To get the section number
                 for ka=1:totalrow        %Counter in the total file from 1 to the lastrow
                        ALL(mm,1) = mm;
                        ALL(mm,2:3)=data(ka,2:3);
                        ALL(mm,4) = zcoord;
                        ALL(mm,5) = data(ka,4);
                        ALL(mm,6:(length(variable)+1))= data(ka,5:length(variable));
                        mm= mm+1;       
                  end 
        end
        button2 = questdlg('Is this your final Tecplot File?');
        if isequal(button2,'Yes')
        sections = length(filelist);

        variable(1,5:(end+1))=variable(4:end);
        variable(1,4)={'Zpos'}; %Add in the Z variable to the variable list

        [tranSALoutfile,tranSALoutfolder]=uiputfile('*.plt','Please select an output path for the Tecplot Reconstruction');
        f=fopen((strcat(tranSALoutfolder,tranSALoutfile)),'w'); %Need to write a variable output name
        fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n')
        fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
        fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(rowcol(1,1)),num2str(rowcol(1,2)),num2str(sections));
        dlmwrite ((fullfile(tranSALoutfolder,tranSALoutfile)), ALL, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
        set(this.Tec.transText,'String',fullfile(tranSALoutfolder,tranSALoutfile));

        else    
         [tranSALoutfile,tranSALoutfolder]=uiputfile('*.txt','Please select an output path for the Tecplot Reconstruction');
         dlmwrite ((strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt')), ALL,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
         disp ('Done, open the file in notepad and save it as "filename.plt"');   
         set(this.Tec.transText,'String',strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt'));

        end

    else
     separateString=strcat('/*',stringSepName,'*')
     transPath =uigetdir('C:\','Select the folder containing the 3D SALS Files'); %Select the folder with the 3D SALS fles
     transFiles = dir([transPath separateString])
     filelist = sort_nat(cellstr(char(transFiles(1:end,:).name)));%Sort the list of file names from 1-n slicse
     sliceArray=strsplit(filelist{1},'_') %Split the string array using underscores, the title MUST begin with the slice number
     fid=fopen(fullfile(transPath,filelist{1}))
     string=fread(fid,'*char'); %Read the 2D slice data in as a string
     splitTest=char(strsplit(string(:,1)','\n'));
     rowcol=str2num(splitTest(1,:));
     rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3;
     variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total nnumber
     totalrow= rowcol(1,1)*rowcol(1,2);
     mm=1;
    for slice = 1:length(filelist) 
             sliceArray2(slice,:)=strsplit(filelist{slice},'_') %Split the string array using underscores, the title MUST begin with the slice number
             fid=fopen(fullfile(transPath,filelist{slice}));
             string=fread(fid,'*char'); %Read the 2D slice data in as a string
             variableArray=strsplit(string(rowcolString:end,1)','\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
             variableArray=strjoin(variableArray(1,3:end));
             data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';
             zcoord = (str2double((sliceArray2(slice,1)))-1)*(str2double(sliceArray2(slice,3))*.001);      %  To get the section number
             for ka=1:totalrow        %Counter in the total file from 1 to the lastrow
                    ALL(mm,1) = mm;
                    ALL(mm,2:3)=data(ka,2:3);
                    ALL(mm,4) = zcoord;
                    ALL(mm,5) = data(ka,4);
                    ALL(mm,6:(length(variable)+1))= data(ka,5:length(variable));
                    mm= mm+1;       
              end 
    end
    button2 = questdlg('Is this your final Tecplot File?');
    if isequal(button2,'Yes')
    sections = length(filelist);

    variable(1,5:(end+1))=variable(4:end);
    variable(1,4)={'Zpos'}; %Add in the Z variable to the variable list

    [tranSALoutfile,tranSALoutfolder]=uiputfile('*.plt','Please select an output path for the Tecplot Reconstruction');
    f=fopen((strcat(tranSALoutfolder,tranSALoutfile)),'w'); %Need to write a variable output name
    fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n')
    fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
    fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(rowcol(1,1)),num2str(rowcol(1,2)),num2str(sections));
    dlmwrite ((fullfile(tranSALoutfolder,tranSALoutfile)), ALL, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
    set(this.Tec.transText,'String',fullfile(tranSALoutfolder,tranSALoutfile));

    else    
     [tranSALoutfile,tranSALoutfolder]=uiputfile('*.txt','Please select an output path for the Tecplot Reconstruction');
     dlmwrite ((strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt')), ALL,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
     disp ('Done, open the file in notepad and save it as "filename.plt"');   
     set(this.Tec.transText,'String',strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt'));

    end
  end
end