function [ value ] = getTensorValue( tensor, index )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



    value = -1;
    s = mat2str(index);
    s = strrep(s, ' ',',');
    s = strrep(s, '[','(');
    index_string = strrep(s, ']',')');
    s = strcat('value = tensor', index_string);     
    s = strcat(s, ';');
    eval(s);

    
    
end

