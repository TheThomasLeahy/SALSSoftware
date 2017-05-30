
data = loadMFiles();


    thisSlice = data{i};
    names = fieldnames(thisSlice);
    sliceData = eval(strcat('thisSlice.',names{1}));



%{
format long;
[FileName,PathName] = uigetfile('Select the MATLAB code file');
FileName = [PathName FileName];
data = importdata(FileName);

i = 2;
while i < length(data)
    uncorrdata(i,1) = round(data(i,1),2);
    uncorrdata(i,2) = round(data(i,2),2);
    i = i + 384;
end


i = 2;
while i < length(data)
    corrdata(i,1) = round(data(i,1),2);
    corrdata(i,2) = round(data(i,2),2);
    i = i + 384;
end

uncorrX = sort(unique(uncorrdata(:,1)));
uncorrY = sort(unique(uncorrdata(:,2)));
corrX = sort(unique(corrdata(:,1)));
corrY = sort(unique(corrdata(:,2)));

