function [] = saveData( transforms )
foldername = uigetdir('\*', 'Select the folder where want to save');
filename = strcat(foldername, '\transforms.mat');
save(filename,'transforms');
end

