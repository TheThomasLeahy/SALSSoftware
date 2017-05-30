function [ tensor ] = setTensorValue(tensor, index, value )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    coder.extrinsic('mat2str');
    coder.extrinsic('strcat');
    coder.extrinsic('eval');

    s = mat2str(index);
    s = strrep(s, ' ',',');
    s = strrep(s, '[','(');
    index_string = strrep(s, ']',')');
    tensor_string = strcat('tensor',index_string);
    s = strcat(tensor_string, ' = value;');
    eval(s);
end

