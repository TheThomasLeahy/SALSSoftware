x=5;
y=5;
stepsize=1;
zstep=1;
z=2;

[salsFile,salsFolder]=uiputfile('.txt','Please name 3D SALS File Set:');
[pathstr,name,ext] = fileparts(salsFile);
salsFile=name;

if ismac
    filename=strcat(salsFolder,salsFile);
else
    filename=strcat(salsFolder,'\',salsFile);
end

zpos=0.0;

for k=1:z
    
    zfilename=strcat(filename,'_',num2str(k),'.txt');
    
    fid=fopen(zfilename,'w+');
    
    fprintf(fid,'%i %i\n',[y,x]);
    
    
    xpos=0.0;
    ypos=0.0;
    percY=1-((y-3)/(y-2));
    percX=0;
    percZ=(k-1)/(z-1);
    IntDecay=ones(1,400);
    htens=ones(1,5);
    
    for i=0:1:x-1
        fprintf(fid,'%1.5f %1.5f\n',[ypos,xpos]);
        percX=((i)/(x));
        dist=genSALSDIST(ypos,xpos,percY,percX,percZ);
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
            
            
            dist=genSALSDIST(ypos,xpos,percY,percX,percZ);
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
    zpos=zpos+zstep;
    
end

helpdlg('Done, yo!','Set Fabrication Complete...');


