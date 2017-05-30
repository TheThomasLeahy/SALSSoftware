function [ tval ] = trig( angle, m )

 n=[cosd(angle) sind(angle)];
 tval=n(1,m);

end

