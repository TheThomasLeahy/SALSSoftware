function [ tensor ] = setTensorValue2(tensor, index, value )

subCell = num2cell(index);
tensor(subCell{:}) = value;

end

