%This code is made to replace FIJI in the SALS Data analysis code
%This program takes a stack of images and automatically registers them
clear all;

% Change the current folder to the folder of this m-file.
if(~isdeployed)
    cd(fileparts(which(mfilename)));
end

%Take user input
imageFiles = getImageFiles();

%Set intial transform
imagePrevious = imread(imageFiles{1});
imagePrevious = double(imagePrevious);
transforms = cell(1,length(imageFiles));
transforms{1} = [1 0 0 ; 0 1 0; 0 0 1];


%Rotate each image to the first one
for i = 2:length(imageFiles)
    imageNext = imread(imageFiles{i});
    imageNext = double(imageNext);
    %percOverlap = findOverlap(imagePrevious, imageNext);
    str = strcat( 'The alignment between section ', num2str(i-1), ...
        ' and section ', num2str(i));

    figure('Name', str);
    subplot(1,2,1);
    obj1 = imshowpair(imagePrevious, imageNext);
    title('\fontsize{18} Misaligned image');
        
    %Register it
    [optimizer, metric] = imregconfig('monomodal');
    optimizer.MaximumIterations = 500;
    tForm = imregtform(imageNext,imagePrevious,'rigid',optimizer,metric);
    tForm = tForm.T';
    [imageNext_New] = imregister(imageNext,imagePrevious, 'rigid', optimizer, metric);
    
    %Here is the new images
    %percOverlap2 = findOverlap(imagePrevious, imageNext_New);
  
    subplot(1,2,2);
    obj2 = imshowpair(imagePrevious,imageNext_New);
    title('\fontsize{18} Registered image');

    
    %Confirm with user that it is okay

        
    choice = getOkay();
    if isequal(choice, 'Not OK')
        data{1} = imagePrevious; data{2} = imageNext;
        [dataOut] = ManualRegistration(data);
        tForm = dataOut{1};
        imageNext_New = dataOut{2};
        
    end

    
    close all;
     
    %storeResults
    transforms{i} = tForm;
    imagePrevious = imageNext_New;
end

transforms = [{size(imageNext_New)} transforms];
saveData(transforms);

