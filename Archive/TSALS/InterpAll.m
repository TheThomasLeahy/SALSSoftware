function [out] = InterpAll(data,imagesize,inputsize,stacks)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Xi=imagesize(1,2); %not needed
Yi=imagesize(1,1); %not needed
N=inputsize(1,1);
M=inputsize(1,2);
    
Node=data(:,1);
Xpos=data(:,2);
Ypos=data(:,3);
Bit=data(:,4);
OI=data(:,5);
BL=data(:,6);
MaxI=data(:,7);
PD=data(:,8);
Skew=data(:,9);
Kurt=data(:,10);

xrot=data(:,17);
yrot=data(:,18);

%Hrot=zeros(N*M,2,2,2,2);
Hrot(:,1,1,1,1)=data(:,19);

Hrot(:,2,2,1,1)=data(:,20);
Hrot(:,2,1,2,1)=data(:,20);
Hrot(:,1,2,2,1)=data(:,20);
Hrot(:,1,1,2,2)=data(:,23);
Hrot(:,2,1,1,2)=data(:,20);
Hrot(:,1,2,1,2)=data(:,20);

Hrot(:,1,1,1,2)=data(:,21);
Hrot(:,1,2,1,1)=data(:,21);
Hrot(:,2,1,1,1)=data(:,21);
Hrot(:,1,1,2,1)=data(:,21);

Hrot(:,2,2,1,2)=data(:,22);
Hrot(:,1,2,2,2)=data(:,22);
Hrot(:,2,2,2,1)=data(:,22);
Hrot(:,2,1,2,2)=data(:,22);

Hrot(:,2,2,2,2)=data(:,24);


%remove 0-bit values for nice edges
ind=find(Bit==0);
Bit(ind)=nan;
OI(ind)=nan;
BL(ind)=nan;
MaxI(ind)=nan;
PD(ind)=nan;
Skew(ind)=nan;
Kurt(ind)=nan;
Hrot(ind,:,:,:,:)=nan;

%Create the surface
%FNode=scatteredInterpolant(Xpos,Ypos,Node);
Fbit=scatteredInterpolant(Xpos,Ypos,Bit);
FOI=scatteredInterpolant(Xpos,Ypos,OI);
FBL=scatteredInterpolant(Xpos,Ypos,BL);
FMaxI=scatteredInterpolant(Xpos,Ypos,MaxI);
FPD=scatteredInterpolant(Xpos,Ypos,PD);
FSkew=scatteredInterpolant(Xpos,Ypos,Skew);
FKurt=scatteredInterpolant(Xpos,Ypos,Kurt);

FHrot1111=scatteredInterpolant(Xpos,Ypos,Hrot(:,1,1,1,1));
FHrot2211=scatteredInterpolant(Xpos,Ypos,Hrot(:,2,2,1,1));
FHrot1112=scatteredInterpolant(Xpos,Ypos,Hrot(:,1,1,1,2));
FHrot2212=scatteredInterpolant(Xpos,Ypos,Hrot(:,2,2,1,2));
FHrot2222=scatteredInterpolant(Xpos,Ypos,Hrot(:,2,2,2,2));
FHrot1122=scatteredInterpolant(Xpos,Ypos,Hrot(:,1,1,2,2));

NEWx=linspace(min(Xpos),max(Xpos),N)';  
NEWy=linspace(min(Ypos),max(Ypos),M)';  

x=repmat(NEWx,M*slices,1);
y=repmat(kron(NEWy,ones(N,1)),slices,1);


%Evaluate the surface at x,y
%myFNode=FNode(x,y);
myFbit=Fbit(x,y);
myFOI=FOI(x,y);
myFBL=FBL(x,y);
myFMaxI=FMaxI(x,y);
myFPD=FPD(x,y);
myFSkew=FSkew(x,y);
myFKurt=FKurt(x,y);

myFHrot1111=FHrot1111(x,y);
myFHrot2211=FHrot2211(x,y);
myFHrot1112=FHrot1112(x,y);
myFHrot2212=FHrot2212(x,y);
myFHrot2222=FHrot2222(x,y);
myFHrot1122=FHrot1122(x,y);

%out(:,:)=[Node, myFNode, x, y, myFbit, myFOI, myFBL, myFMaxI, myFPD, myFSkew, myFKurt, myFH1111, myFH2211, myFH1112, myFH2212, myFH2222, myFH1122, myFHrot1111, myFHrot2211, myFHrot1112, myFHrot2212, myFHrot2222, myFHrot1122];
out(:,:)=[Node, x, y, myFbit, myFOI, myFBL, myFMaxI, myFPD, myFSkew, myFKurt, myFHrot1111, myFHrot2211, myFHrot1112, myFHrot2212, myFHrot2222, myFHrot1122];

ind=find(isnan(out));
out(ind)=0;

%transfilepath=uigetdir('*/*','Please select an output path for interpolated data');
%transfilepath='\\austin.utexas.edu\disk\engrstu\bme\krf687\Documents\MATLAB\TensorInterp';
%transfilepath='\\tsclient\Disk0\Users\Feavster\Desktop';
transfile='Interpolated_Data.plt';
transfull=fullfile(transfilepath,transfile);
f=fopen(transfull,'w');

%Need to add spots for all the data...
% fprintf(f,'%s\n %s\n','TITLE= "FE-Volume_Brick_Data" ','VARIABLES =" Node#", "Xpos", "Ypos", "Zpos", "Bit", "OI", "PrefD", "sBit", "sOI", "sPrefD"ZONE I= 82, J= 98, K=9, DATAPACKING=POINT ');
% fprintf(f,'%s\n %s\n','TITLE= "FE-Volume_Brick_Data" ','VARIABLES =" Node#", "NewNode", "Xpos", "Ypos", "Bit", "OI", "BL", "MaxI", "PrefD", "Skew", "Kurt", "H1111", "H2211", "H1112", "H2212", "H2222", "H1122", "H1111rot", "H2211rot", "H1112rot", "H2212rot", "H2222rot", "H1122rot"ZONE I= 82, J= 98, K=1, DATAPACKING=POINT ');
% fprintf(f,'%d\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\n',out(:,:)');
fprintf(f,strcat('%s\n %s\n','TITLE= "FE-Volume_Brick_Data" ','VARIABLES =" Node#", "Xpos", "Ypos", "Bit", "OI", "BL", "MaxI", "PrefD", "Skew", "Kurt", "H1111rot", "H2211rot", "H1112rot", "H2212rot", "H2222rot", "H1122rot"ZONE I=',num2str(N),', J= ',num2str(M),', K=,',num2str(stacks),', DATAPACKING=POINT '));
fprintf(f,'%d\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\t %2.4f\n',out(:,:)');

fclose(f);

end

