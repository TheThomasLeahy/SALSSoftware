    
files = loadMFiles();
specimen_sum = 0;
specimensd = 0;
for i = 1:length(files)
    Section = files{i}.Section;
    thisSection = [];
    thisSectionSd = [];
    for i = 1:length(Section)
        dp = Section(i);
        if (dp.tissue_flag == 1)
             thisSection = [thisSection  mean(dp.oi_odd)];
             thisSectionSd = [thisSectionSd mean(dp.sd_odd)];
        end
    end
    specimensd = specimensd + mean(thisSectionSd);
    specimen_sum = specimen_sum + mean(thisSection);
end
specimensd/length(files)
specimen_sum/length(files)
