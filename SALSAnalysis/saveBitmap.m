        %%
function saveBitmap(this, src, event)

    newFileName = strrep(this.salsFile, '.txt', '-SALSA.txt');

    [fileName,pathName] = uiputfile('\*.txt', 'Save data to .txt',newFileName);
    fid = fopen(strcat(pathName,fileName),'wt');

    h = waitbar(0,'Exporting to TXT');
    str_ = data_point.header('\t');
    for i=1:length(this.data_points)
        waitbar(i/length(this.data_points))
        str_ = strcat(strcat(str_,'\n'), this.data_points(i).print('\t'));
    end
    close(h)

    fprintf(fid, str_);
    fclose(fid);

    set(this.Figure.outputPath,'String',pathName)
    h = msgbox('Bitmap File Save Completed');
end