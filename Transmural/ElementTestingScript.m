% This script was made as a tester for the ThreeDElement Class
%It has also evolved to be used for testing myVTKWrite
clc; clear all; close all; 

%Set up the surrounding 8 nodes

data = data_point.empty;


%% Build the dataset
theta = 1:180;

x = [0 0.1 0 0.1 0 0.1 0 0.1];
y = [0 0 0.1 0.1 0 0 0.1 0.1];
z = [0 0 0 0 0.25 0.25 0.25 0.25];

%Make it a four element square
x = [x (x+0.2) x (x+0.2)];
y = [y y (y+0.2) (y+0.2)];
z = [z z z z];


for i = 1:length(x)
    %Set up data for this data point
    mu = rand*180;
    sigma = 7 + rand*5;
    normal = normpdf(theta, mu, sigma);
    thisData = [normal normal];
    data(i).intensity_data = thisData;
    %Analyze data for this data point
    data(i).x = x(i);
    data(i).y = y(i);
    data(i).z = z(i);
    data(i).Normalize;
    data(i).GenerateFourier(14);
    data(i).ComputeStats;
    data(i).GenerateTensors;
    data(i).tissue_flag = 1;
    data(i).ID = i-1;
end


%% Use ThreeDElement.m to do cell operations

h = waitbar(0, sprintf('Building 3D elements! (Round 1)'));
theseElements = ReturnElements(data,h);
close(h);

for i = 1:length(theseElements)
theseElements(i) = theseElements(i).CalculateMeanValues;
theseElements(i) = theseElements(i).CalculateGradients;
end



%% Graph this stuff

%Print to ParaView

%myVTKWrite(data, theseElements);








