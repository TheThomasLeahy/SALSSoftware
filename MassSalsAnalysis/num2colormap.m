function RGB_values = num2colormap(data,map,limits)
%RGB_values = num2colormap(data,map,limits)
%
%Given a vector or array "data", num2colormap returns RGB_values on a 256
%color scale similar to those that would be used to construct the figure
%output of "image(data)" given a specific colormap.
%
%Type HELP GRAPH3D to see a number of useful colormaps.
%
%Written by david.c.godlove@vanderbilt.edu and john.haitas@vanderbilt.edu
%
%
% INPUT:
%     data       = vector or array of numbers
% 
% OPTIONAL INPUT:
%     map        = string denoting a built in colormap (default = 'jet')
%     limits     = vector containing min and max values for scale.  (for 
%                   example [-100 100]. default behavior is to auto scale.)
%
% OUTPUT:
%     RGB_values = uint8 data suitable for creating an image
%
% See also colormap, graph3d, rgb2hsv, and image

if nargin < 2, map = 'jet'; end

%get rgb_data from selected map
eval(sprintf('map = %s(256);',map))
map = uint8(round(map * 255));

%scale data to 0-255 and change to uint8
if nargin < 3
    data = data - min(min(data));
    data = data ./ max(max(data));
else
    data = data - limits(1);
    limits(2) = limits(2) - limits(1);
    data = data ./ limits(2);
end
data = data * 255;
data = uint8(round(data));

%get red green and blue info from lookup tables
red   = intlut(data,map(:,1));
green = intlut(data,map(:,2));
blue  = intlut(data,map(:,3));

%combine into RGB data
RGB_values(:,:,1) = red;
RGB_values(:,:,2) = green;
RGB_values(:,:,3) = blue;