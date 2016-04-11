function [ y ] = uq_rastrigin( x )
%
% y = Rastriginfun(x)
% input: 2 standard Gaussia variables
%x = transpose(x);
y_ = x.^2-5*cos(2*pi()*x);
y = 10-sum(y_,2);

end

