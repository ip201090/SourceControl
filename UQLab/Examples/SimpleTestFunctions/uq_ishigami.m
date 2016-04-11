function Y = uq_ishigami(X,P)
% Simple version of the ishigami function. X is is a sample of N of column vectors

switch nargin
    case 1
        a = 7;
        b = 0.1 ;
    case 2 
        a = P(1);
        b = P(2);
    otherwise    
        error('Number of input arguments not accepted!');
end

Y(:,1) = sin(X(:,1)) + a*(sin(X(:,2)).^2) + b*(X(:,3).^4).* sin(X(:,1));
