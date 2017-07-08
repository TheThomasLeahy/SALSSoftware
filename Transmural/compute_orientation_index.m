function [ oi, sd ] = compute_orientation_index(mean, data, theta_interval )


%var = compute_var(data, theta_interval, mean);
%syms X
%sdMax = double(sqrt((1/pi) * int(X^2, X, -pi/2, pi/2)));

%sdMax = (1/3*pi)*((max(theta_interval)^3)-(min(theta_interval)^3));

var =  sum(data.*(theta_interval-mean).^2);
sd = sqrt(var);

%Compute Max SD
sdMaxData = ones(1,length(theta_interval));
area = 0;
for i = 2:length(sdMaxData)
    area = area + (1/2)*(sdMaxData(i) + sdMaxData(i-1))*(theta_interval(i)-theta_interval(i-1));
end
%ODD (Orientation Distribution Data) is the normalized data
sdMaxData = sdMaxData/area;

meanSDMAX = compute_mean(sdMaxData, theta_interval);


varMax =  sum(sdMaxData.*(theta_interval-mean).^2);
sdMax2 = sqrt(varMax);

%{
    %% Weird bonus oi?
    
    thetabonus = linspace((-pi/2), (pi/2), 181);
    int = sum(thetabonus.^2) * (1/pi);
    int = sqrt(int);
    
    otherint = (1/3)*(((pi/2)^3) - ((-pi/2)^3));
    otherint = sqrt((1/pi)*otherint);
    
    bonusoi1 = 100*(1-(sd/int));
    bonusoi2 = 100*(1-(sd/otherint));
    oi = bonusoi2;
%}

%oi = 100*(1-sd/sdMax);
oi = 100*(1-sd/sdMax2);


%% Dr. Sacks OI
var = compute_var(data, theta_interval, mean);
sd = sqrt(var);

otherint = (1/3)*(((pi/2)^3) - ((-pi/2)^3));
otherint = sqrt((1/pi)*otherint);

sacksOI = 100*(1-sd/otherint);

%disp(['My OI is ' num2str(oi)]);
%disp(['Sacks OI is ' num2str(sacksOI)]);

oi= sacksOI;

end