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

figure(1);
set(figure(1),'Units','normalized','Position',[0 0 1 1]);

origCdata=round(rand(inpSize(1),inpSize(2))*100);

testIem=IEM(oiData,1);
sizeC=size(testIem);

% sizeC=[2 2]
axis([1 sizeC(2) 1 sizeC(1)]);
mult=(sizeC(1))*(sizeC(2));
pXdata=zeros(3,mult*4);
pYdata=zeros(3,mult*4);
pCdata=zeros(3,mult*4);
intMap=InterpColour(testIem);
test1=ones(sizeC(1),sizeC(2));
test1int=InterpColour(test1);
sizeP=size(pXdata);
count=1;
yCount=0;
for i=1:+1:sizeC(2)-1
    for j=1:+1:sizeC(1)-1
        d=[i,j];
        [tempx,tempy]=makeMeshLocals(1,i,j);
        pXdata(:,count:count+3)=tempx;
        pYdata(:,count:count+3)=tempy;
        count=count+4;
    end
end
count1=1;

for k=1:+1:sizeC(2)-1
    for l=1:+1:sizeC(1)-1
        d1=[k l];
        [tempc]=makeColorLocals(1,k,l,testIem,intMap);
        pCdata(:,count1:count1+3)=tempc;
        count1=count1+4;
    end
end



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
zdata=round(rand(3,mult*4)*100);
zdatac=ones(3,mult*4);
zdatatest=[]
p=patch(pXdata,pYdata,pCdata,...
      'EdgeColor','interp',...
      'FaceColor','interp',...
      'LineWidth',0.1,...
      'Marker','none');
  set(p,'CDataMapping','scaled');
  
figure(2);
imagesc([0 inpSize(2)],[inpSize(2) 0],oiData);