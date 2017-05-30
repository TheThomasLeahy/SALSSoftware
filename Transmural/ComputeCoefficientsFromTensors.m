function coeffs = ComputeCoefficientsFromTensors(D)
    coeffs = [];    
    for i = 1:length(D)
        b = 0; a = 0;
        rank = i * 2;
        tensor = D{i};
        tensor_ind = ones(1,rank);

        s = mat2str(tensor_ind);
        s = strrep(s, ' ',',');
        s = strrep(s, '[','');
        s = strrep(s, ']','');
        s = strcat('a = tensor(',s);
        s = strcat(s, ');');
        eval(s);

        tensor_ind(end) = 2; % one 2 term gives bn

        s = mat2str(tensor_ind);
        s = strrep(s, ' ',',');
        s = strrep(s, '[','');
        s = strrep(s, ']','');
        s = strcat('b = tensor(',s);
        s = strcat(s, ');');
        eval(s);

        coeffs = [coeffs a b];
    end
end
