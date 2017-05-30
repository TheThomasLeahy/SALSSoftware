function [ data ] = evalGammaST( D, theta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    data = [];
 
    rads = theta*pi/180;
    
    for ang_ind = 1:length(theta) 
        
        rad = rads(ang_ind);
        
        sum = 0;
        
        for i = 1:length(D)
           
            tensor = D{i};
            
            tensor_rank = 2*i;
           
            indices = permn([1 2],tensor_rank);

            for j = 1:length(indices)
              
                full_tensor_index = indices(j,:);
                
                n_product = 1;
                for k=1:length(full_tensor_index)
                    sub_index = full_tensor_index(k);
                    n_product = n_product * normal(rad,sub_index);
                end
               
                sum = sum + getTensorValue(tensor, full_tensor_index) * n_product ;

            end
            
        end
        
        data(ang_ind) = (sum + 1)/(2*pi);
        
    end


end

