function [ fileName, pathName ] = printToTecPlot( sections,dlm )
    fName = 'data_points.plt';
    [fileName,pathName] = uiputfile('\*.plt', 'Save data to .plt',fName);
    
    fid = fopen(strcat(pathName,fileName),'wt');

    str_ = data_point.headerTecplot(dlm);
    for s = 1:length(sections)
        datapoints = sections(s);
        for i=1:length(datapoints)
            str_ = strcat(strcat(str_,'\n'), datapoints(i).print(dlm));
        end
    end
    fprintf(fid, str_);
    fclose(fid);
end
