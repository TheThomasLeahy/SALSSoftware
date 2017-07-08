function [ b2 ] = calc2ndb( a,d,i,j )
%written by John G Lesicko
%calc2ndb Calculate components b(i,j) for recreating original
%distribution from Kronecker Delta (identity), tensor weighted
%   a: 2nd order tensor, calculated from aa
%   d: 2D Kronecker

b2=a(i,j)-(1/2.0)*d(i,j);

end

