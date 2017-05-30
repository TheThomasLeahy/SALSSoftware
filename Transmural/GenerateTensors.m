function D = GenerateTensors(an, bn)
    ranks = 2:2:(length(an)*2);
    D = cell(1,length(ranks));
    for r = 1:length(ranks);
        rank = ranks(r);
        aVal = an(rank/2);
        bVal = bn(rank/2);
        tensor = [];

        indices = permn([1 2], rank);
        for i = 1:length(indices)
           index = indices(i,:);
           k = sum(index ==2);
           if mod(k,2) == 0
                val = ((-1)^(k/2))*aVal;
            else
                val = ((-1)^((k-1)/2))*bVal;
           end
           s = mat2str(index);
           s = strrep(s, ' ',',');
           s = strrep(s, '[','');
           s = strrep(s, ']','');
           s = strcat('tensor(',s);
           s = strcat(s, ') = val;');
           eval(s);
        end
        D{r} = tensor;
    end
end
