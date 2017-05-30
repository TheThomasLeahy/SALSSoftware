function [ moment,moment1 ] = thisMoment( x,mean,pdf,order )

moment = 0;
for i = 1:length(pdf)
    moment = moment+((x(i)-mean)^order)*pdf(i);
end

moment1 = 0;
for i =2:length(pdf)
    moment1 = moment1 + (1/2) * (pdf(i)*(x(i) - mean)^order + pdf(i-1)*(x(i-1) - mean)^order)*(x(i)-x(i-1));
end

end

