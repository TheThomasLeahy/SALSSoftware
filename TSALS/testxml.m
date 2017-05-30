xmlfilepath=uigetdir(pwd,'*.xml');
xmlfiles = dir([xmlfilepath '/*.xml']);
for fnum=1:length(xmlfiles)
    f=strcat(xmlfilepath,'/',xmlfiles(fnum).name);
    TransformData=textread(f,'%s','delimiter','"');
    size2 = size(TransformData);
    if (size2(1)==14)
        Transform = [str2num(char(TransformData(5,:))) str2num(char(TransformData(12,:)))];
        R = [Transform(:,3) Transform(:,1) Transform(:,2) Transform(:,4) Transform(:,5)] %Final output is [theta tx ty]
    else
        Transform = [str2num(char(TransformData(4,:)))];
        testFind=fnum
    end
end
