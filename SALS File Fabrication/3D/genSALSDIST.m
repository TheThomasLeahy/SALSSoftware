function [outDist] = genSALSDIST(ypos,xpos,percX,percY,percZ)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tempDist=zeros(1,180);

a=65520;
b=90;
c=20;
d=0;

for i=1:180
    tempDist(i)=ceil(a*exp(-(i-b)^2/(2*c^2))+d);
end

fulldist=[tempDist tempDist];

%make simple linear patterns
%shift=round(((percY+percX+percZ)/3)*90);

%% 
% make crazy patterns

%%
shift = 0;
if shift==0
    shift=1;
end

part1=fulldist(1:shift);
part2=fulldist(shift+1:end);


outDist=[part2 part1];

end

