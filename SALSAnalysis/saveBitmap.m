        %%
function saveBitmap(this, src, event)

    newFileName = strrep(this.salsFile, '.txt', '-SALSA.txt');

    [fileName,pathName] = uiputfile('\*.txt', 'Save data to .txt',newFileName);
    fid = fopen(strcat(pathName,fileName),'wt');

    h = waitbar(0,'Exporting to TXT');
    
    fprintf(fid, data_point.header('\t'));
    for d = 1:length(this.data_points)
        waitbar(d/length(this.data_points))
        mDataPoint = this.data_points(d);
        fprintf(fid, '\n');
        fprintf(fid, mDataPoint.print('\t'));
    end
        
    close(h);

    fclose(fid);

    set(this.Figure.outputPath,'String',pathName)
    h = msgbox('Bitmap File Save Completed');
end