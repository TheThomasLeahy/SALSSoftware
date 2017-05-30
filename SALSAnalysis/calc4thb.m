function [ delta ] = calc4thb( aa, a, d, i, j, k, l )
%written by John G Lesicko
%calc4thb Calculate components b(i,j,k,l) for recreating original
%distribution from Kronecker Delta (identity), non-angle wieghted
%   aa: 4th Order Tensor, calculated from dist
%   a: l2nd order tensor, calculated from aa
%   delta=i*j*k*l;
%   reverse (k,l),(i,j) accounts for Matlab's handling of higher order
%   tensors

delta=aa(i,j,k,l)-((1.0/6.0)*(d(i,j)*a(k,l) + d(i,k)*a(j,l) + d(i,l)*a(j,k) + d(j,k)*a(i,l)+d(j,l)*a(i,k)+d(k,l)*a(i,j)))...
    +((1.0/24.0)*(d(i,j)*d(k,l) + d(i,k)*d(j,l) + d(i,l)*d(j,k)));
end

