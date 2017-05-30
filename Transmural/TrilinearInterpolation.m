function [ InterpolatedValue ] = TrilinearInterpolation( X, Values )
%E1 is x
%E2 is y
%E3 is z

    S(1) = (1-X(1))*(1-X(2))*(1-X(3));
    S(2) = X(1)*(1-X(2))*(1-X(3));
    S(3) = (1-X(1))*X(2)*(1-X(3));
    S(4) = X(1)*X(2)*(1-X(3));
    S(5) = (1-X(1))*(1-X(2))*X(3);
    S(6) = X(1)*(1-X(2))*X(3);
    S(7) = (1-X(1))*X(2)*X(3);
    S(8) = X(1)*X(2)*X(3);
    
    InterpolatedValue = sum(Values.*S);

end

