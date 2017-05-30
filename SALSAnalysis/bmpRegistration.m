function bmpRegistration(this,src,event);
    [picFile, picFilePath] = uigetfile('*.tif','Select an Original (aka not Transformed) Fiji Picture')
    origPic= imread(fullfile(picFilePath,picFile)); %Read in pic to determine pixel size for later comparison
    imagesize=size(origPic);
    X=imagesize(1,2);
    Y=imagesize(1,1);
    NamesArray(1,:)=strsplit(picFile(1,1:(end-4)),'_'); %Separate the picture name file to obtain section number
%             SourceSliceNum=str2num(char(NamesArray(1,1))); %Determine the slice number of the Source Pic
    SourceSliceNum=char(NamesArray(1,1)); %The first part of the name must be section number. Determine the slice number of the Source Pic

    %Read in xml files
    path =uigetdir('C:/','Please select the XML transforms folder'); 
    files = dir([path '/*.xml']); %Grabs all the xml files in the selected folder
    sourcefile=dir([path strcat('/*',SourceSliceNum,'*')]); %Determines the xml slice that is the same section as source picture
    for i=1:size(files)
        if isequal(files(i,:).name,sourcefile.name)
            SourceIndexNum=i;   %Grabs index number of the source file
        else              
            filelist(i,:)=char(files(i,:).name); %Creates character array of list of files that does not include source file
        end
    end
    filelist(SourceIndexNum,:)=[]; %Clear a space in the filelist for the source picture
%             sourcePicture=textread(strcat(path,'/',filelist(1,:)),'%s','delimiter','"'); %Grabs the transform from the picture that was used as the source for the transforms. Currently the default source is the first picture
%             sourceTransform = str2num(char(sourcePicture(4,1))); %Grabs the correct transform
    for a=1:(size(filelist))
        Picture(a,:)=textread(strcat(path,'/',filelist(a,:)),'%s','delimiter','"');
    end
    Transform = [str2num(char(Picture(:,5))) str2num(char(Picture(:,12)))];
%             finalTransform = [Transform(:,1) Transform(:,2) Transform(:,3) Transform(:,4) Transform(:,5)]; %Final output is [theta tx ty]
    TransSize = size(Transform);
    SourceTransform = [zeros(1,TransSize(2))]; %Creates a zero array for later insertion into the source pictures place in the transform array
    finalTransform = cat(1,Transform(1:SourceIndexNum-1,:),SourceTransform,Transform(SourceIndexNum:end,:)); %Inserts the zeroed matrix into the transform list

    %Bitmap reader
    path = uigetdir('C:/','Please select the Transmural SALS file folder'); %
    files = dir([path '/*.txt']);


    fid=fopen(strcat(path,'/',files(1).name)); %Read in the first file to obtain row and column information
    ftext=fread(fid,'*char')'; %Read in as character string
    teststring=strsplit(ftext,'\t'); %Split the string based on tab
    teststring=ftext;
    splitTest=char(strsplit(teststring(1,:),'\n')); %Split the string based on rows
    rowcol=str2num(splitTest(1,:)); %Choose first row 
    rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3; %Determine the length of the row/col line
    variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total number
    variable=variable(1,1:end-1);
%             totalrow= rowcol(1,1)*rowcol(1,2);
    x=rowcol(1,2);
    y=rowcol(1,1);

%             variableArray=strsplit(ftext(1,rowcolString:end),'\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
%             variableArray=strjoin(cell(variableArray(1,3:end)));

    Names=sort_nat({files(:).name});
    for a=1:(length(Names))
        fid=fopen(strcat(path,'/',Names{a}));
        variableftext=fread(fid,'*char')';
        variableArray=strsplit(variableftext(1,rowcolString:end),'\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
        variableArray=strjoin(cell(variableArray(1,3:end)));
        mydata =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';

        fclose(fid);

        for var=1:length(variable)
            flipped = (flipud(reshape(mydata(:,var),y,x))); %Reshapes the data so that it is in Bitmap Format
            BitArray(:,:,a,var)=flipped; %Takes reshaped data for all the slices and combines them 

        end
%                 BitArray2=BitArray(:,:,:,4:end);
    end

    exp=1;  %expansion factor

    [L,W]=size(finalTransform);
 if isequal(W,5) %Checks to make sure that the Rigid Transformation was selected
    for i=1:L
    %for i=1:2
    %Create a for loop made up of conditional statements. Ie have it cycle through
    %each of the headers and if the header is present then have it create the
    %variables
        theta=finalTransform(i,1);
        tx=finalTransform(i,2)*x/X*exp;
        ty=finalTransform(i,3)*y/Y*exp;
        angle=theta;
        sc = cos(angle);
        ss = sin(angle);

        T1 = [  sc   -ss  0;
                ss    sc  0;
                ty    tx  1];

        angle=0;
        tx=finalTransform(i,4)*x/X*exp;
        ty=finalTransform(i,5)*y/Y*exp;
        sc = cos(angle);
        ss = sin(angle);

        T2 = [  sc   -ss  0;
                ss    sc  0;
                ty    tx  1];


        Tform1=maketform('affine',T1);
        Tform2=maketform('affine',T2);
        R=makeresampler('cubic','fill');

        for variablecount=4:length(variable) %Calcs the kron for each of the variables
             KronArray2(:,:,i,variablecount-3)=kron(BitArray(:,:,i,variablecount),ones(exp,exp)); %Apply kronecker delta expansion, in case we need to increase the number of points

            if isequal(char(variable(:,variablecount)),' PrefD')
                JArray2(:,:,i,variablecount-3)=tformarray(KronArray2(:,:,i,variablecount-3),Tform1,R,[1 2],[1 2],[y*exp x*exp],[],[])+theta;  
                JArray1(:,:,i,variablecount-3)=tformarray(JArray2(:,:,i,variablecount-3),Tform2,R,[1 2],[1 2],[y*exp x*exp],[],[]+theta);  
                flipped=flipud(reshape(JArray1(:,end:-1:1,i,variablecount-3),x*y,1));
                JReformat(:,variablecount-3,i)=flipped(:,1);
            else
                JArray2(:,:,i,variablecount-3)=tformarray(KronArray2(:,:,i,variablecount-3),Tform1,R,[1 2],[1 2],[y*exp x*exp],[],[]);  
                JArray1(:,:,i,variablecount-3)=tformarray(JArray2(:,:,i,variablecount-3),Tform2,R,[1 2],[1 2],[y*exp x*exp],[],[]);  
                flipped=flipud(reshape(JArray1(:,end:-1:1,i,variablecount-3),x*y,1));
                JReformat(:,variablecount-3,i)=flipped(:,1);
            end

        end

    end
    NewerBit(:,:,1)=[reshape(flipud(BitArray(:,:,1,1)),x*y,1) reshape(flipud(BitArray(:,:,1,2)),x*y,1) flipud(reshape(BitArray(end:-1:1,:,1,3),x*y,1))]; %Obtains original Node, X, and Y info from slices
    NewestBit=repmat(NewerBit,[1 1 length(Names)]); %Replicates Node,X,Y info for each slice
    Array=cat(2,NewestBit,JReformat); %Join the Node,X,Y with the Variable info
    transfilepath2=uigetdir('*/','Please select an output path');
    for i=1:length(Names)
        SliceName=char(Names(1,i));
        NamesArray1(i,:)=strsplit(SliceName(1,1:(end-4)),'_');
%                 NamesArray(i,:)=strsplit(SliceName(1,1:(end-4)),'_');
        transfile=char(strcat(SliceName(1,1:end-4),'_BMPReg.txt'));
%                 transfile=char(strcat(strjoin(NamesArray(i,2:end),'_'),'_BMPReg.txt'));
        transfull=fullfile(transfilepath2,transfile);

        f=fopen(transfull,'w');

        fprintf(f,'%d\t %d\n',y,x);
        fprintf(f,strcat(strjoin(variable(1,1:end),'\t '),' \n')); %Creates variable string
        dlmwrite (transfull, Array(:,:,i),'precision', 8, 'delimiter','\t', '-append');


        fclose(f);
    end
    else
       error('The wrong transform was applied to the pictures. You need to select a rigid transformation');               
    end

   set(this.Tec.transText,'String',fullfile(transfilepath2,transfile));
end