function [ comp ] = calc4thComp( dist,rads,i,j,k,l)
%written by John G Lesicko
%calc4thComp Calculate components(i,j,k,l) of input distribution
%   dist: SALS distribution normalized by its area
%   rads: list of radians, domain [-pi/2 pi/2]
%   comp=i*j*k*l;
%   reverse (k,l),(i,j) accounts for Matlab's handling of higher order
%   tensors

            sum=0;
            tot=0;
            for x=2:180
                tot=(((dist(1,x)*trig(rads(x),k)*trig(rads(x),l)*trig(rads(x),i)*trig(rads(x),j))+(dist(1,x-1)*trig(rads(x-1),k)*trig(rads(x-1),l)*trig(rads(x-1),i)*trig(rads(x-1),j)))*0.5)*(rads(x)-rads(x-1));
                sum=sum+tot;
                
            end
            comp=sum;

end

