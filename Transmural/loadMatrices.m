function [ transformMatrices, imageSize ] = loadMatrices()

%% Load the xml file
[File, FilePath]=uigetfile('/*.mat','Pick an .mat project file to Analyze');
fileID = strcat(FilePath,File);
data = load(fileID);

name = fieldnames(data);
str = strcat('data.', name);
str = char(str);
data = eval(str);

imageSize = data{1};
transformMatrices = data(2:end);

end

