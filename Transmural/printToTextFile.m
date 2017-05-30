function [ fileName, pathName ] = printToTextFile( datapoints, dlm )
    fName = 'data_points.txt';
    [fileName,pathName] = uiputfile('\*.txt', 'Save data to .txt',fName);
    
    fid = fopen(strcat(pathName,fileName),'wt');

    h = waitbar(0,'Exporting to TXT');
    str_ = data_point.header(dlm);
    for i=1:length(datapoints)
        waitbar(i/length(datapoints))
        str_ = strcat(strcat(str_,'\n'), datapoints(i).print(dlm));
    end
    close(h)

    fprintf(fid, str_);
    fclose(fid);
end

