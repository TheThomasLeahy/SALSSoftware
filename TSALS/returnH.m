function [ H4, H2, Hvals, B4,B2] = returnH( dist, radslist, Kron2 )
%written by John G Lesicko
%returnH : computes Fourth and Second order structure tensors for a given
%SALS distribution
%   Distributions should be normalized to the area under the dist
%   

htens4=zeros(2,2,2,2);
btens4=zeros(2,2,2,2);
% ftens4=zeros(2,2,2,2);

btens2=zeros(2,2);
% ftens2=zeros(2,2);


for i=1:2
        
    for j=1:2
        
        for k=1:2
                
            for l=1:2
                htens4(i,j,k,l)=calc4thComp(dist,radslist,i,j,k,l);
            end
        end	
    end    
end

htens2=[(htens4(1,1,1,1)+htens4(2,2,1,1)) (htens4(1,1,1,2) + htens4(2,2,1,2));
    (htens4(1,1,2,1) + htens4(2,2,2,1)) (htens4(1,1,2,2) + htens4(2, 2, 2, 2))];

H4=htens4;
H2=htens2;

for i=1:2
        
    for j=1:2
        
        for k=1:2
                
            for l=1:2
                btens4(i,j,k,l)=calc4thb(htens4,htens2,Kron2,i,j,k,l);
%                 ftens4(i,j,k,l)=calc4thf(radslist,Kron2,i,j,k,l);
            end
        end	
        
        btens2(i,j)=calc2ndb(htens2,Kron2,i,j);
%         ftens2(i,j)=calc2ndf(radslist,Kron2,i,j);
    end    
end

B4=btens4;
% F4=ftens4;
B2=btens2;
% F2=ftens2;
Hvals=[htens4(1,1,1,1) htens4(2,2,1,1) htens4(1,1,1,2) htens4(2,2,1,2) htens4(1,1,2,2) htens4(2,2,2,2)];

end

