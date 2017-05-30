x=2;
y=2;
stepsize=.1;

[salsFile,salsFolder]=uiputfile('.txt','Please create SALS File:');

if ismac
    
    filename=strcat(salsFolder,salsFile);
    
else
    filename=strcat(salsFolder,'\',salsFile);
end


filename=strcat(salsFolder,salsFile);

fid=fopen(filename,'w+');

fprintf(fid,'%i %i\n',[y,x]);


xpos=0.0;
ypos=0.0;
% percY=1-((y-3)/(y-2));
percY=0;
percX=0;
IntDecay=ones(1,400);
htens=ones(1,5);

for i=0:1:x-1
    fprintf(fid,'%1.5f %1.5f\n',[ypos,xpos]);
    percX=((i)/(x));
    dist=genSALSDIST(ypos,xpos,percY,percX);
    fprintf(fid,'%i ',dist);
    fprintf(fid,'\n');
    fprintf(fid,'%i ',IntDecay);
    fprintf(fid,'\n');
    fprintf(fid,'%3.2f ',htens);
    fprintf(fid,'\n');

    for j=0:1:y-2
       
        if mod(i+1,2)==0
            ypos=abs(ypos-stepsize);
            percY=((j+1)/(y-2));
        else
            ypos=abs(ypos+stepsize);
            percY=1-((j)/(y-2));
        end
        fprintf(fid,'%1.5f %1.5f\n',[ypos,xpos]);

        
        dist=genSALSDIST(ypos,xpos,percY,percX);
        fprintf(fid,'%i ',dist);
        fprintf(fid,'\n');
        fprintf(fid,'%i ',IntDecay);
        fprintf(fid,'\n');
        fprintf(fid,'%3.2f ',htens);
        fprintf(fid,'\n');
        
    
    end
 
    xpos=xpos+stepsize;

end

fclose(fid);

helpdlg('Done, yo!','Set Fabrication Complete...');



