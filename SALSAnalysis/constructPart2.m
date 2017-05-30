function [ part2 ] = constructPart2(rads,B2,Kron2)
%constructPart2 Summary of this function goes here
%   Detailed explanation goes here

part=zeros(1,180);

for x=1:180
     sum=0;
     tot=0;
     for i=1:2
         for j=1:2
%              tot=B2(i,j)*calc2ndf(rads(x),Kron2,i,j);

% 
%  / Testing stuff for reconstruction accuracy positivity..... : )
             tot=abs(B2(i,j)*calc2ndf(rads(x),Kron2,i,j));
             
             
             sum=sum+tot;
         end
     end
     part(1,x)=sum;
end
part2=(4.0/pi)*part;
end

