%written by John G Lesicko

clc; clear all; close all;



htens4th=zeros(2,2,2,2);
fi='test3_180.txt';
test180Orig=dlmread(fi,'\n')';
minVal=min(test180Orig);
test180=test180Orig-minVal;
x=0;

del=eye(2);

dist=zeros(1,180);
betadist=zeros(1,180);
% rads=zeros(1,180);
degs=zeros(1,180);

rads=genRadsList(1,180);

mu=10;
ro=10;
tempRad=-(pi/2.0);
tempDeg=0;
area=0;
area2=0;
temp=0;
temp2=0;

betaAlpha=.9;
betaBeta=.5;

for tt=1:180
    dist(1,tt)=.1+5*(1/(ro*sqrt((2*pi))))*exp(-((tt-mu)^2)/(2*(ro)^2));
    
    if tempDeg==0;
    betadist(1,tt)=abs(((((0.1))^(betaBeta-1))*(0.1^(betaAlpha-1)))/(beta(betaBeta,betaAlpha)));
    else
    betadist(1,tt)=abs(((((tempDeg))^(betaBeta-1))*(tempDeg^(betaAlpha-1)))/(beta(betaBeta,betaAlpha)));

    end
%     rads(1,tt)=tempRad;
    degs(1,tt)=tempDeg;
    tempDeg=tempDeg+1;
%     tempRad=tempRad+(pi/(179.0));
    
end
origdist=dist;
% minVal=min(dist);
dist=dist-minVal;
dist=test180;
% dist=fliplr(dist)
betadist=betadist-min(betadist);

for z=2:180
    temp=(0.5*(dist(z)+dist(z-1)))*(rads(z)-(rads(z-1)));
    area=area+temp;
    temp2=(0.5*(betadist(z)+betadist(z-1)))*(rads(z)-(rads(z-1)))
    area2=area2+temp2;
end


% dist=dist/area;
[ndist,minDist,maxDist,are]=NormalizeDist(dist, rads);
origdist=origdist/area;
betadist=betadist/area2;

% figure(1);
% plot(degs,betadist(1,:));
% xlim([(-90) (90)]);
% ylim([0 1]);

aa=zeros(2,2,2,2);


[testh4,testh2,listuniqueH,B4,B2]=returnH(ndist,rads,del);
testh4

%     
% for i=1:2
%         
%     for j=1:2
%         
%         for k=1:2
%                 
%             for l=1:2
%                 aa(i,j,k,l)=calc4thComp(dist,rads,i,j,k,l);
%             end
%         end	
%     end    
% end
% aa(1,1,1,1)=calc4thComp(dist,rads,1,1,1,1);
% aa(2,1,1,1)=calc4thComp(dist,rads,2,1,1,1);
% aa(1,2,1,1)=calc4thComp(dist,rads,1,2,1,1);
% aa(2,2,1,1)=calc4thComp(dist,rads,2,2,1,1);
% aa(1,1,2,1)=calc4thComp(dist,rads,1,1,2,1);
% aa(2,1,2,1)=calc4thComp(dist,rads,2,1,2,1);
% aa(1,2,2,1)=calc4thComp(dist,rads,1,2,2,1);
% aa(2,2,2,1)=calc4thComp(dist,rads,2,2,2,1);
% aa(1,1,1,2)=calc4thComp(dist,rads,1,1,1,2);
% aa(2,1,1,2)=calc4thComp(dist,rads,2,1,1,2);
% aa(1,2,1,2)=calc4thComp(dist,rads,1,2,1,2);
% aa(2,2,1,2)=calc4thComp(dist,rads,2,2,1,2);
% aa(1,1,2,2)=calc4thComp(dist,rads,1,1,2,2);
% aa(2,1,2,2)=calc4thComp(dist,rads,2,1,2,2);
% aa(1,2,2,2)=calc4thComp(dist,rads,1,2,2,2);
% aa(2,2,2,2)=calc4thComp(dist,rads,2,2,2,2);


% a=[(aa(1,1,1,1)+aa(2,2,1,1)) (aa(1,1,1,2) + aa(2,2,1,2));
%     (aa(1,1,2,1) + aa(2,2,2,1)) (aa(1,1,2,2) + aa(2, 2, 2, 2))];

a=testh2;

[V,D]=eig(a);
HI = D(1,1);
HII = D(2,2);
bet = (1.0 - HI/HII)*100;
thetaII = atan(V(2,1)/ V(1,1))*(180/pi);
thetaI = atan(V(2,2)/ V(1,2))*(180/pi);


%% 0 _ 180
if thetaI<0
    thetaI=thetaI+180;
end
if thetaII<0
    thetaII=thetaII+180;
end
if thetaI>180
    thetaI=thetaI-180;
end
if thetaII>180
    thetaII=thetaII-180;
end
%%
[m,in]=max(dist);
% temp=thetaI;
% thetaI=thetaII;
% thetaII=temp;
% 
% test4=zeros(2,2,2,2);
% test4(1,1,1,1)=1;test4(2,1,1,1)=2;test4(1,2,1,1)=3;test4(2,2,1,1)=4;
% test4(1,1,2,1)=5;test4(2,1,2,1)=6;test4(1,2,2,1)=7;test4(2,2,2,1)=8;
% test4(1,1,1,2)=9;test4(2,1,1,2)=10;test4(1,2,1,2)=11;test4(2,2,1,2)=12;
% test4(1,1,2,2)=13;test4(2,1,2,2)=14;test4(1,2,2,2)=15;test4(2,2,2,2)=16;

testfor1=a(1,1)+a(2,2);
figure(1);

thetaI
thetaII




part1 = 1.0/pi;
part2=constructPart2(rads,B2,del);
part3=constructPart3(rads,B4,del);

reconstruct=(part1+part2+part3);

hold on;
plot(degs,ndist(1,:),'b*','MarkerSize',4,'LineWidth',.1);
plot(degs,origdist(1,:),'r*','MarkerSize',3);
plot(thetaI,[0:.1:max(ndist)],'-gs');
plot(thetaII,[0:.1:max(ndist)],'-rs');
plot(degs,reconstruct(1,:));
% xlim([-90 90]);

hold off;

figure(2);

hold on;
% plot(degs,(dist(1,:)*area)+minVal,'b*','MarkerSize',4,'LineWidth',.1);
plot(degs,test180Orig(1,:)*256 ,'r*','MarkerSize',4,'LineWidth',.1);
plot(degs,((reconstruct(1,:)*area)+minVal)*256,'b*','MarkerSize',4,'LineWidth',.1);
hold off;


rotAngle=15;
rotAnglerads=rotAngle*pi/180.0;
Q=[cosd(rotAngle) -sind(rotAngle); sind(rotAngle) cosd(rotAngle)]
Qt=Q'
testh2
testRotMatrix=Q*testh2*Qt

[Vrm,Drm]=eig(testRotMatrix);
HIrm = Drm(1,1);
HIIrm = Drm(2,2);
betrm = (1.0 - HIrm/HIIrm)*100;
thetaIIrm = atan(Vrm(2,1)/Vrm(1,1))*(180/pi);
thetaIrm = atan(Vrm(2,2)/Vrm(1,2))*(180/pi);


%% 0 _ 180
if thetaIrm<0
    thetaIrm=thetaIrm+180;
end
if thetaIIrm<0
    thetaIIrm=thetaIIrm+180;
end
if thetaIrm>180
    thetaIrm=thetaIrm-180;
end
if thetaIIrm>180
    thetaIIrm=thetaIIrm-180;
end

thetaI
thetaII
thetaIrm
thetaIIrm

Q*testh2(1,1)
