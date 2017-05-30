clear all
clc

fID=fopen('tempArray.txt','r');
st = fread(fID,'*char')';
inpSize=sscanf(st,'%e',[2,1])';
fdata=sscanf(st,'%f',inf)';
origMat=fdata(3:end);

oiData=zeros(inpSize(1),inpSize(2));
count=1;
for i=1:+1:inpSize(2)
    oiData(1:inpSize(1),i)=origMat(count:count+inpSize(1)-1);
    count=count+inpSize(1);
end



testIem=IEM(oiData,1);
sizeC=size(testIem);
% sizeC=[20 20];
randCdata=round(rand(sizeC(1),sizeC(2))*100);
mult=(sizeC(1))*(sizeC(2));
pXdata=zeros(3,mult*2);
pYdata=zeros(3,mult*2);
pCdata=zeros(3,mult*2);
pXdata1=zeros(3,mult*2);
pYdata1=zeros(3,mult*2);
pCdata1=zeros(3,mult*2);

test1=ones(inpSize(1),inpSize(2));

sizeP=size(pXdata);
count=1;
yCount=0;
for i=1:+1:sizeC(2)-1
    for j=1:+1:sizeC(1)-1
        d=[i,j];
        [tempx,tempy]=makeMeshLocals(3,i,j);
        pXdata(:,count:count+1)=tempx;
        pYdata(:,count:count+1)=tempy;
        count=count+2;
    end
end
count1=1;

for k=1:+1:sizeC(2)-1
    for l=1:+1:sizeC(1)-1
        d1=[k l];
        [tempc]=makeColorLocals(3,k,l,testIem,[]);
        pCdata(:,count1:count1+1)=tempc;
        count1=count1+2;
    end
end
%%
count=1;
yCount=0;
for i=1:+1:sizeC(2)-1
    for j=1:+1:sizeC(1)-1
        d2=[i,j];
        [tempx,tempy]=makeMeshLocals(2,i,j);
        pXdata1(:,count:count+1)=tempx;
        pYdata1(:,count:count+1)=tempy;
        count=count+2;
    end
end
count1=1;

for k=1:+1:sizeC(2)-1
    for l=1:+1:sizeC(1)-1
        d3=[k l];
        [tempc]=makeColorLocals(2,k,l,testIem,[]);
        pCdata1(:,count1:count1+1)=tempc;
        count1=count1+2;
    end
end



%%
% xdataw = [0 0;
%           1 0;
%           1 1;];
% ydataw = [0 0;
%           1 1;
%           0 1;];
% cdata1 = [40 40;
%           30  10;
%           10 10];
% zdata=(3,mult*2);
zdata=round(rand(3,mult*2)*100);
zdatac=ones(3,mult*2);

LzData=zeros(3,mult*2);
LzData1=ones(3,mult*2);


figure(1);
set(figure(1),'Units','normalized','Position',[0 0 1 1]);
axis([1 sizeC(2) 1 sizeC(1)]);

hold on;
p=patch(pXdata,pYdata,LzData,pCdata,...
      'EdgeColor','none',...
      'FaceColor','interp',...
      'LineWidth',0.1,...
      'Marker','none','FaceAlpha',1.0);%/'EdgeAlpha',0.5);
p1=patch(pXdata1,pYdata1,pCdata1,...
      'EdgeColor','none',...
      'FaceColor','interp',...
      'LineWidth',0.1,...
      'Marker','none','FaceAlpha',0.5);%'EdgeAlpha',0.5);


hold off;

  
% figure(3);
% set(figure(3),'Units','normalized',]'Position',[0 0 1 1]);
% hold on
% axis([1 sizeC(2) 1 sizeC(1)]);
% fill(pXdata,pYdata,pCdata,'EdgeColor','none');
% hold off

figure(2);
imagesc([0 sizeC(2)],[sizeC(1) 0],testIem);