function [ m ] = loadSALSAstack(  )

    % Get folder of the .M stack
    foldername = uigetfile('\*.txt', 'Select the first file in the stack');
    files = dir(foldername);

    %Doctor files (get rid of '.', '..', and '.DS_Store'
    x = 1;
    for i = 1:length(files)
        if files(i).bytes ~= 0
            if ~strcmp(files(i).name, '.DS_Store')
                theseFiles(x) = files(i);
                x = x + 1;
            end
        end
    end
    files = sort(theseFiles);

    %% Load 'em on in
    % cell array of structs
    m = cell(length(files),1);
    for i = 1:length(files)
        %Load the .m files
        fileID = strcat(foldername,'\',files(i).name);
        m{i} = load(fileID, '-mat');
    end
end

