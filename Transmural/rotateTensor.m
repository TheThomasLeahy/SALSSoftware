function tensor = rotateTensor(D_orig, tensor_rank, Q)
    indices = permn([1 2],tensor_rank);
    tensor = [];
    for i = 1:length(indices)
        
        sum_ = 0;
       
        tensor_indexR = indices(i,:); % EX: [1, 1, 1, 1; 1,1,1,2; 1,1,2,1....2,2,2,2]
       
        for j = 1:length(indices)
           
            tensor_indexO = indices(j,:);
            
            Q_prod = 1;

            for k = 1:tensor_rank
                indi = tensor_indexR(k);
                indj = tensor_indexO(k);
                
                Q_prod = Q_prod * Q(indi, indj);
            end
            
            
            %Get
            sum_ = sum_ + Q_prod*getTensorValue2(D_orig,tensor_indexO);
            
            %{
            s = mat2str(tensor_indexO);
            s = strrep(s, ' ',',');
            s = strrep(s, '[','(');
            index_string = strrep(s, ']',')');
            s = strcat('sum_ = sum_ + Q_prod * D_orig', index_string);               
            s = strcat(s, ';');
            eval(s);
            %}
        end
    
        
        %Set
        
        tensor = setTensorValue2(tensor, tensor_indexR, sum_);
        
        %{
        s = mat2str(tensor_indexR);
        s = strrep(s, ' ',',');
        s = strrep(s, '[','(');
        index_string = strrep(s, ']',')');
        tensor_string = strcat('tensor',index_string);
        s = strcat(tensor_string, ' = sum_;');
        eval(s);
        %}
    end
       
    
end
