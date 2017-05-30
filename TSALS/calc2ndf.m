function [ f2 ] = calc2ndf( radangle,d,i,j )
%written by John G Lesicko
%calc2ndb Calculate components f(i,j) for recreating original
%distribution from Kronecker Delta (identity), angle weighted
%   a: 2nd order tensor, calculated from aa
%   d: 2D Kronecker
% 
%             sum=0;
%             tot=0;
%             for x=1:180
%                 tot=(trig(rads(x),i)*trig(rads(x),j))-(0.5*d(i,j));
%                 sum=sum+tot;
%             end
%             
%             f2=sum;
            

        f2=(trig(radangle,i)*trig(radangle,j))-(0.5*d(i,j));
                


end
