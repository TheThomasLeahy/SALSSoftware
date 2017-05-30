function [ radsList ] = genRadsList(mintheta , maxtheta)
%written by John G Lesicko
%genRadsList creates a 1D array of radians with range: [mintheta maxtheta]
%   Detailed explanation goes here

if nargin<2
    mintheta=-90;
    maxtheta=90;
end

temp=zeros(1,180);
temprad=mintheta*(pi/180.0);
inc=pi/179.0;
for i=1:180
    temp(1,i)=temprad;
    temprad=temprad+inc;
    
end

radsList=temp;