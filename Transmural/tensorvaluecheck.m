

tensor = rand(2,2,2,2,2,2,2,2);

for i = 1:2
    for j = 1:2
        for k = 1:2
            for l = 1:2
                for m = 1:2
                    for n = 1:2
                        for o = 1:2
                            for p = 1:2
                                index = [i j k l];
                                if getTensorValue(tensor, index) ~= getTensorValue2(tensor, index)
                                    disp(index);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
