function xyRegistration(this,src,event);
    [picFile, picFilePath] = uigetfile('*.tif','Select an Original (aka not Transformed) Fiji Picture')
    origPic= imread(fullfile(picFilePath,picFile));
    imagesize=size(origPic);
    XO=imagesize(1,2);
    YO=imagesize(1,1);
    NamesPicArray(1,:)=strsplit(picFile(1,1:(end-4)),'_');
    SourceSliceNum=char(NamesPicArray(1,1)); %Determine the slice number of the Source Pic

    %Read in xml files
    path =uigetdir('C:/','Please select the XML transforms folder'); 
    files = dir([path '/*.xml']);
    sourcefile=dir([path strcat('/*',SourceSliceNum,'*')]);
    for i=1:size(files)
        if isequal(files(i,:).name,sourcefile.name)
            SourceIndexNum=i;
        else              
            filelist(i,:)=char(files(i,:).name);
        end
    end
    filelist(SourceIndexNum,:)=[];
    sourcePicture=textread(strcat(path,'/',filelist(1,:)),'%s','delimiter','"'); %Grabs the transform from the picture that was used as the source for the transforms. Currently the default source is the first picture
    sourceTransform = str2num(char(sourcePicture(4,1))); %Grabs the correct transform
    for a=1:(size(filelist))
        Picture(a,:)=textread(strcat(path,'/',filelist(a,:)),'%s','delimiter','"');
    end
    Transform = [str2num(char(Picture(:,5))) str2num(char(Picture(:,12)))];
%             finalTransform = [Transform(:,1) Transform(:,2) Transform(:,3) Transform(:,4) Transform(:,5)]; %Final output is [theta tx ty]
    TransSize = size(Transform);
    SourceTransform = [zeros(1,TransSize(2))];
    finalTransform = cat(1,Transform(1:SourceIndexNum-1,:),SourceTransform,Transform(SourceIndexNum:end,:));

    % Read in analyzed SALS data
    path = uigetdir('C:/','Please select the Analyzed SALS data'); %
    files = dir([path '/*.txt']);
    Names=sort_nat({files(:).name});

    fid=fopen(char(fullfile(path,Names(1)))); %For Mac Users
%             fid=fopen(char(strcat(path,'\',Names(1))));
    st=fread(fid,'*char')';
    scansize=sscanf(st,'%e',[2,1])';
    x=scansize(2);
    y=scansize(1);
    teststring=st;
    splitTest=char(strsplit(teststring(1,:),'\n'));
    variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total number
    variable= variable(1,1:end-1);
    fclose(fid);


    for a = 1:length(files)
%                 filename=char(strcat(path,'\',Names(a)));
        filename=char(fullfile(path,Names(a)));
        fid=fopen(filename);
        st=fread(fid,'*char')';
        teststring=st;
        splitTest=char(strsplit(teststring(1,:),'\n'));
        variableArray=strjoin(cellstr(splitTest(3:end,:))');
        data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';

          for varCount = 1:length(variable)
              varData(a,varCount,:)=data(:,varCount);
         end
    end

    varData=permute(varData(:,:,:),[1 3 2]);
    maxX2=max(max(varData(:,:,2)));
    minX2=min(min(varData(:,:,2)));
    maxY2=max(max(varData(:,:,3)));
    minY2=min(min(varData(:,:,3)));

    X2=maxX2-minX2;
    Y2=maxY2-minY2;

    [L,W]=size(finalTransform);
 if isequal(W,5)

%             for i=1:length(finalTransform)
      for i=1:L
        theta=finalTransform(i,1);
        tx=finalTransform(i,2)*(X2)/XO;
        ty=finalTransform(i,3)*(Y2)/YO;
        angle=theta+0*pi/180;
        sc = cos(angle);
        ss = sin(angle);

        T1 = [  sc	-ss	0;
                ss  sc	0;
                ty	tx	1];

        angle=0;
        tx=finalTransform(i,4)*X2/XO;
        ty=finalTransform(i,5)*Y2/YO;
        sc = cos(angle);
        ss = sin(angle);

        T2 = [  sc	-ss	0;
                ss	sc	0;
                ty	tx	1];



        Tform1=maketform('affine',T1);
        Tform2=maketform('affine',T2);
        XY3=[abs(varData(i,:,3)-maxY2); abs(varData(i,:,2)); ones(1,length(varData))];
        XY4=T1'*XY3;
        XY5=T2'*XY4;
        Out2(:,:,i)=[varData(i,:,1)' (abs(varData(i,:,3)-maxY2))' varData(i,:,2)' XY5(1,:)' XY5(2,:)'];
        for k=4:length(variable)
            Out3(:,:,i)=[varData(i,:,k)'];
            Out6(:,k-4+1,i)=Out3(:,:,i);
        end    
    end
    Out2=[Out2 Out6];

%             sliceArray(1,:)=strsplit(filelist(1,:),'_'); %Split the string array using underscores, the title MUST begin with the slice number
    transfilepath=uigetdir('*/*','Please select an experimental output path');

     tempvar(1,:)=variable(4:end);
     variable(1,4)={'X2pos'}; %Add in the 2nd X variable to the variable list
     variable(1,5)={'Y2pos'}; %Add in the 2nd Y variable to the variable list
     variable(1,6:(5+length(tempvar)))={0};
     variable(1,6:(end))=tempvar(1,:);

    for i=1:length(files)
        SliceName=char(Names(1,i));
        NamesArray(i,:)=strsplit(SliceName(1,1:(end-4)),'_');

%                 transfile=char(strcat(strjoin(NamesArray(i,2:end),'_'),'_XYEdits.txt'));
        transfile=char(strcat(SliceName(1,1:end-4),'_XYEdits.txt'));
        transfull=fullfile(transfilepath,transfile);

        f=fopen(transfull,'w');

        fprintf(f,'%d\t %d\n',scansize(1),scansize(2));
        fprintf(f,strcat(strjoin(variable(1,1:end),'\t '),' \n'));
        dlmwrite (transfull, Out2(:,:,i),'precision', 8, 'delimiter','\t', '-append');

        fclose(f);
    end
     else
       error('The wrong transform was applied to the pictures. You need to select a rigid transformation');               
    end
    set(this.Tec.transText,'String',transfilepath);

end