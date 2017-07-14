clc
clear

xdim=20;
ydim=20;
zdim=20;
[X,Y,Z]=meshgrid(1:1:xdim,1:1:ydim,1:1:zdim); %make 3D grid
newX=reshape(X,[xdim*ydim*zdim,1]);
newY=reshape(Y,[xdim*ydim*zdim,1]);
newZ=reshape(Z,[xdim*ydim*zdim,1]);


data= X.^3 + Y.^4 + Z.^2;   %function for made up data.

% weird random made up data set
% c = 5.0;
% t = linspace(1,10*pi,20);
% data=X.*repmat(sin(t/(2*c)).*cos(t),[20,1,20]) + Y.*repmat(sin(t/(2*c)).*sin(t),[20,1,20]) + Z.*repmat(cos(t/(2*c)),[20,1,20]);

%holes
data(3:4,2:3,4:6)=0;
data(5:9,4:6,1:3)=0;

data=reshape(data,[xdim*ydim*zdim,1]); %for inputting columnar data




%test 1: scalar
[data_out, headers_out]=gradient3d(data,xdim,ydim,zdim);

%test 2: vector
[vec_data_out, vec_headers_out]=gradient3d(data_out,xdim,ydim,zdim);

%test 3: tensor
[tens_data_out, tens_headers_out]=gradient3d(vec_data_out,xdim,ydim,zdim);


%%

%tecplotdata write
tecplotdata=[newX newY newZ data data_out vec_data_out tens_data_out];
variable=[{'X','Y','Z','Data'},headers_out vec_headers_out tens_headers_out];

f=fopen('tecplotdata_full_holes.plt','w');
fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"\n'));
fprintf(f,'ZONE I= %i, J= %i, K=%i, DATAPACKING=POINT \n',xdim,ydim,zdim);
dlmwrite ('tecplotdata_full_holes.plt', tecplotdata, 'delimiter','\t','-append');  % All the sections are in the file with consecutive ID number
fclose(f);