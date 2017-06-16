function [files] = getImageFiles()

% Get folder
foldername = uigetdir('\*', 'Select the folder containing the stack of binary images!');
files = dir(foldername);

%Doctor files (get rid of '.', '..', and '.DS_Store'
x = 1;
for i = 1:length(files)
    if files(i).bytes ~= 0
        if ~strcmp(files(i).name, '.DS_Store')
            theseFiles{x} = strcat(foldername,'/',files(i).name);
            x = x + 1;
        end
    end
end
files = theseFiles;

files = sort_nat(files);
end

