## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ utReturn, vtReturn ] = inv_map_2d( nrb, p, t )    
% Check dimensions of vector p
if (isequal(size(p),[2 1]) && isequal(size(t),[2 1]))
    % Set parametric starting point to the parametric middle of the surface
    ut0=t(1);
    vt0=t(2);
    
    
    %tic;
    %options = optimset('Jacobian','on', 'Display', 'off');
    parametricSolution=newton(@nrbnewton, [ut0; vt0], 1e-5);
    
    %parametricSolution=fsolve(@nrbnewton, [ut0; vt0], options);
    
    utReturn=parametricSolution(1);
    vtReturn=parametricSolution(2);
    %toc;
    
else
    error('Dimension mismatch: Vector p is too large/too small. Size should be 2x1 or 1x2');
end

% Create nested function to be used with fsolve
    function [targetDeviation, jacMatrix, relErr] = nrbnewton (parametricPosition)
        
%         if (parametricPosition(1)<0 || parametricPosition(1)>1)
%             parametricPosition(1)=0.5;
%         end
%         if (parametricPosition(2)<0 || parametricPosition(2)>1)
%             parametricPosition(2)=0.5;
%         end
        % Find first derivative representation of the NURBS
        deriv=nrbderiv(nrb);
        
        % Evaluate first derivatives at point {utOld, vtOld}
        ut=parametricPosition(1);
        vt=parametricPosition(2);
        %[pnt]=nrbeval(nrb, {ut,vt});
        [pnt, jac]=nrbdeval(nrb, deriv, {ut, vt});
        
        % Current function value
        targetDeviation=pnt(1:2)-p;
        
        % Calculate relative error between current point and target point
        relErr=norm(targetDeviation)./norm(p);
        
        %lambdaFactor=1./0.8;
        jacMatrix=[jac{1}(1:2,1), jac{2}(1:2,1)];
        %cond(jacMatrix)
    end


end

