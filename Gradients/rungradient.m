clc
clear

% in order to run 'gradient3d', you must have the data, xdim, ydim, and
% zdim - if this is a standalone gui, these are parameters that need to be
% extracted from the paraview/tecplot file. the data input can be one
% column (scalar inputs like OI, PD), three columns (vector inputs, like
% the results from the scalar gradient, or if you compute dPD/dx, dPD/dy,
% and dPD, dz. or the data can be nine columns (like 3D the structure tensor.)

%i'm thinking that instead of merely a script (here, with fake data), we'd
%have a gui that would either a) be standalone or b) be fully incorporated
%into the tsals gui and that we'd use real data (of course!).

%additionally, to write the tecplotdata, we are going to have to adjust the
%variables and variable names, and have it append the original tecplot file

xdim=8;
ydim=10;
zdim=5;

X=linspace(1,xdim,xdim);
Y=linspace(1,ydim,ydim);
Z=linspace(1,zdim,zdim);

%determine new z by a kronecker product of the current z and a one matrix
%with dimesnions specified by xdim and ydim (essentially creates a
%xdim*ydim*zdim length vector which has xdim*ydim repeats of each z value
%(400 long with 80 1's, 80 2's, etc.)
newZ=kron(Z,ones(1,xdim*ydim))';
%create a 1xzdim dimensional array composed of copies of the kronecker
%matrix of Y and a ones array with the dimesnions 1xxdim. (essentially
%creates a xdim*ydim*zdim length vector which has zdim repeats of each ydim
%value repeated xdim times (length of 400 with 1st 8 values at 1, second 8
%at 2, etc. and after 10 is reached it goes back to 1.
newY=repmat(kron(Y,ones(1,xdim)),[1 zdim])';
m=1;
for j=1:zdim
    for k=1:ydim
        for l=1:xdim
            newY2(m,1)=k;
            m=m+1;
        end
    end
end
% newYk=kron(Y,ones(1,xdim));
% newY2=newYk;
% for i=1:zdim-1
%     newY2=cat(2,newY2,newYk)
% end
%create a 1x(zdim*ydim) dimensional array composed of copies of X
%(essentially a xdim*ydim*zdim length vector with xdim vector repeated
%ydim*zdim times (400 length vector with 1 2 3 4 5 6 7 8 repeated 50 times

newX=repmat(X,[1 zdim*ydim])';

newX2 = zeros(xdim*ydim*zdim,1);
m=1;
for j=1:(ydim*zdim)
    for k=1:xdim
        newX2(m)=k;
        m=m+1;
    end
end

%update data (take newX.^3, newY^4, and newZ.^2 and sum them
%need to change this to actually evaluate OI n stuff
data=newX.^3 + newY.^4 + newZ.^2;

%set the data_out to be the values of the new data and headers_out to be
%the headers for the data which vary depending on if the output is a
%scalar, vector, or tensor.
[data_out, headers_out]=gradient3d(data,xdim,ydim,zdim);
[vec_data_out, vec_headers_out]=gradient3d(data_out,xdim,ydim,zdim);
[tens_data_out, tens_headers_out]=gradient3d(vec_data_out,xdim,ydim,zdim);

%specify new tecplot data from the new data
tecplotdata=[newX newY newZ data data_out vec_data_out tens_data_out];
%create new variable handles
variable=[{'X','Y','Z','TestData'},headers_out vec_headers_out tens_headers_out];
%create the filename
filename='TEST_holes.plt';



f=fopen(filename,'w');
fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"\n'));
fprintf(f,'ZONE I= %i, J= %i, K=%i, DATAPACKING=POINT \n',xdim,ydim,zdim);
dlmwrite (filename, tecplotdata, 'delimiter','\t','-append');  % All the sections are in the file with consecutive ID number
fclose(f);