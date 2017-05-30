function [ part3 ] = constructPart3(rads,B4,Kron2)
%constructPart2 Summary of this function goes here
%   Detailed explanation goes here

part=zeros(1,180);

for x=1:180
     sum=0;
     tot=0;
     for i=1:2
         for j=1:2
             for k=1:2
                 for l=1:2
                     tot=B4(i,j,k,l)*calc4thf(rads(x),Kron2,i,j,k,l);

%                      modify this one ->
%                      tot=B4(i,j,k,l)*calc4thf(rads(x),Kron2,i,j,k,l);

                     sum=sum+tot;
                 end
             end
         end
     end
     part(1,x)=sum;
end
part3=(16.0/pi)*part;
end

