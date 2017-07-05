

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



