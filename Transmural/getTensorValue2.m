function [ value ] = getTensorValue2( tensor, index )


subCell = num2cell(index);
value = tensor(subCell{:});


end

