function [ foldername] = imageSaveFolder(  )

    % Get folder of the .M stack
    foldername = uigetdir('\*', 'Select the folder containing the .m stack');
    files = dir(foldername);

    [~, order] = sort({files(:).name});
    files = files(order);
    
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

    dl = '/';
    if ispc
        dl = '\';
    end
    
    %{
    %% Load 'em on in
    % cell array of structs
    SALSFiles = cell(length(theseFiles),1);
    for i = 1:length(theseFiles)
        %Load the .mat files
        fileID = strcat(foldername,dl,theseFiles(i).name);
        SALSFiles{i} = load(fileID, '-txt');
    end
    
    %}
    
    SALSFiles = theseFiles;
    
    
end

