function [ percentOverlap ] = findOverlap(regImage, masterImage)

regImage_Bin = imbinarize(regImage);
regImage_Bin(1,:) = 0;
regImage_Bin(:,1) = 0;
regImage_Bin(size(regImage_Bin,1),:) = 0;
regImage_Bin(:,size(regImage_Bin,2)) = 0;
regImage_Despeckle = bwareaopen(regImage_Bin,1000);
regImage_Filled = imfill(regImage_Despeckle,'holes');

masterImage_Bin = imbinarize(masterImage);
masterImage_Bin(1,:) = 0;
masterImage_Bin(:,1) = 0;
masterImage_Bin(size(masterImage_Bin,1),:) = 0;
masterImage_Bin(:,size(masterImage_Bin,2)) = 0;
masterImage_Despeckle = bwareaopen(masterImage_Bin,1000);
masterImage_Filled = imfill(masterImage_Despeckle,'holes');

total = 0; match = 0;
for i = 1:size(regImage_Filled,1)
    for j = 1:size(regImage_Filled,2)
        if(regImage_Filled(i,j) == 1)
            total = total + 1;
            if(masterImage_Filled(i,j) == 1)
                match = match + 1;
            end
        end
    end
end

percentOverlap = (match/total) * 100;

end

