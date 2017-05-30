    function [ oi, sd ] = compute_orientation_index(mean, data, theta )


    %var = compute_var(data, theta, mean);
    %syms X
    %sdMax = double(sqrt((1/pi) * int(X^2, X, -pi/2, pi/2)));

    %sdMax = (1/3*pi)*((max(theta)^3)-(min(theta)^3));


    var =  sum(data.*(theta-mean).^2);
    sd = sqrt(var);

    %Compute Max SD
    sdMaxData = ones(1,length(theta));
    area = 0;
    for i = 2:length(sdMaxData)
        area = area + (1/2)*(sdMaxData(i) + sdMaxData(i-1))*(theta(i)-theta(i-1));
    end
    %ODD (Orientation Distribution Data) is the normalized data
    sdMaxData = sdMaxData/area;

    varMax =  sum(sdMaxData.*(theta-mean).^2);
    sdMax2 = sqrt(varMax);

    %oi = 100*(1-sd/sdMax);
    oi = 100*(1-sd/sdMax2);
    end