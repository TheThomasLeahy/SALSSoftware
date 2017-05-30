function [ nDist, minD, maxD, ar ] = NormalizeDist( Dist, radslist )
%NormalizeDist Returns normalized raw data distribution 
%   Detailed explanation goes here

minD=min(Dist);
maxD=max(Dist);
% 
% D=Dist-minD;
% D=double(D/maxD);

area=0;
temp=0;

for z=2:180
    temp=(0.5*(Dist(z)+Dist(z-1)))*(radslist(z)-(radslist(z-1)));
    area=area+temp;
end

nDist=Dist/area;

ar=area;

end

