## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ xResult ] = newton( fun, x0, AbsTol)

xOld=x0;
lambda=1.0;
absError=10000;
%relError=10000;
%numberOfIterations=0;
while absError>abs(AbsTol)% && relError>RelTol
    [funValue, jacMatrix, ~]=fun(xOld);
    
    step=(jacMatrix\funValue);
    xNew=xOld-lambda*step;
    
    while (xNew(1)<0 || xNew(1)>1 || xNew(2)<0 || xNew(2)>1) && lambda>1/256
        lambda=lambda/2;
        xNew=xOld-lambda*step;
    end
    lambda=1.0;
    xOld=xNew;
    
    absError=norm(funValue);
    %relError=relError;
    %numberOfIterations=numberOfIterations+1;
end

% if (numberOfIterations>5)
%     warning(sprintf('Number of iterations: %d', numberOfIterations));
% end
%disp(sprintf('Number of iterations: %d', numberOfIterations));
xResult=xNew;


end

