function [ data ] = loadData( filepath )

fileID = fopen(filepath);
st = fread(fileID,'*char')';

addpath('../Transmural');
data = parseSection(filepath);

fclose(fileID);
N=1;

%this.input_size=sscanf(st,'%e',[2,N])';
%data=sscanf(st,'%f',inf)';
%this.origMat=data(3:end);


end

