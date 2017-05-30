%% Function- Load transmural txt files that were previously thresholded and identify the data present in them
function loadtrans(this,src,event)
    %Load in transmural txt file previously created for this SALS file
    [this.transFile, this.transFilePath]=uigetfile('\*.txt','Pick the corresponding transmural txt file');
%             fid=fopen(strcat(this.transFilePath,this.transFile),'a+');
    this.transsizes = dlmread(strcat(this.transFilePath,this.transFile),'\t',[0 0 0 1]);
    this.transbitmap=dlmread(strcat(this.transFilePath,this.transFile),'\t',2,0);

    %Apply the bit values from the transmural txt file to threshold the data
    t=1;
    this.tempBitmapTArray=zeros(this.transsizes(1,1),this.transsizes(1,2));
    for j=1:this.input_size(1,2)
        for i=1:this.input_size(1,1)
            this.tempBitmapTArray(i,j) = this.transbitmap(t,4);  %Create an array of the bits
            t=t+1;
        end
    end
    this.forThresh = this.tempBitmapTArray;  %Overwrite threshold array
    this.tval=1;
    fillAxes(this,this.currentColor,this.tval,1,1,1,0);  %Redraw thresholded image

    %Identify which data types (OI,Max Intensity, etc.) are in the data file and fill in check boxes
    fid=fopen(strcat(this.transFilePath,this.transFile));
    ftext=fread(fid,'*char')';
    newStr=strsplit(ftext,'\n');
%             numchar = length(cell2mat(newStr(1,2)))
    findOI = strfind(newStr(1,2), 'OI');
    if isempty(cell2mat(findOI)) == 1
        set(this.Figure.OIinFile,'Value',0)
    else
        set(this.Figure.OIinFile,'Value',1)
    end
    findBaseline = strfind(newStr(1,2), 'BL');
    if isempty(cell2mat(findBaseline)) == 1
        set(this.Figure.baselineInFile,'Value',0)
    else
        set(this.Figure.baselineInFile,'Value',1)
    end
    findMaxI = strfind(newStr(1,2), 'MaxI');
    if isempty(cell2mat(findMaxI)) == 1
        set(this.Figure.maxiInFile,'Value',0)
    else
        set(this.Figure.maxiInFile,'Value',1)
    end
    findPrefD = strfind(newStr(1,2), 'PrefD');
    if isempty(cell2mat(findPrefD)) == 1
        set(this.Figure.prefdInFile,'Value',0)
    else
        set(this.Figure.prefdInFile,'Value',1)
    end
    findSkew = strfind(newStr(1,2), 'Skew');
    if isempty(cell2mat(findSkew)) == 1
        set(this.Figure.skewInFile,'Value',0)
    else
        set(this.Figure.skewInFile,'Value',1)
    end
    findKurtosis = strfind(newStr(1,2), 'Kurtosis');
    if isempty(cell2mat(findKurtosis)) == 1
        set(this.Figure.kurtosisInFile,'Value',0)
    else
        set(this.Figure.kurtosisInFile,'Value',1)
    end
    findcoeff = strfind(newStr(1,2), 'Coeff');
    if isempty(cell2mat(findcoeff)) == 1
        set(this.Figure.coeffInFile, 'Value',0)
    else
        set(this.Figure.coeffInFile,'Value',1);
    end
    findTensor = strfind(newStr(1,2), 'Tensor');
    if isempty(cell2mat(findTensor)) == 1
        set(this.Figure.tensorInFile,'Value',0)
    else
        set(this.Figure.tensorInFile,'Value',1)
    end
end