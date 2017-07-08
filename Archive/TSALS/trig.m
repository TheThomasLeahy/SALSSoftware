function [ tval ] = trig( angle, m )
% Written by John G Lesicko
% trig: Simple trig function selector
% Input
%   angle: input angle in rads
%   m: selector (1,2)
% Output
%   tval: selected trig fuction(Sine, Cosine) of input angle

 n=[cos(angle) sin(angle)];
 tval=n(1,m);

end

