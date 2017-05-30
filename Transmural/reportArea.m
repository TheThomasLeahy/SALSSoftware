function [ area ] = reportArea( xVals, distribution )

area = 0;
for i = 2:length(distribution)
    area = area + (1/2)*(distribution(i) + distribution(i-1))*(xVals(i)-xVals(i-1));
end

end

