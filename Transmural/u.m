% u1,u2,u3,u4 value at the datapoitns - these are the values 
% at the datapoints that we want to interpolate
% u1 is bottom left, u2 is bottom right
%u3 is top left, u4 is top right
% x1,x2: normalized coordinates (value between 0 and 1)
%
function [v] = u(x1,x2,u00,u10,u01,u11) 
    S1 = (1-x1)*(1-x2);
    S2 = x1*(1-x2);
    S3 = (1-x1)*x2;
    S4 = x1*x2;
    
    v = S1*u00 + S2*u10 + S3*u01 + S4*u11; 
end

