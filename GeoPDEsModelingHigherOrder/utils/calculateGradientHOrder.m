%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldValuesNew ] = calculateGradientHOrder( fieldValues )
%CALCULATEGRADIENTHORDER Calculate gradient approximation with fourth order
%error using 5 values lying next to each other. 
%   [fieldValuesNew] = CALCULATEGRADIENTHORDER(fieldValues) calculates the
%   gradient of the B-field values given by fieldValues. The return value
%   is a structure with the fields 'X', 'Y', 'BGradX', 'BGradY', 'BGradAbs'. To be able to
%   calculate the gradient at all positions, the function
%   interpolateFieldValues(...) should be used with optional argument
%   'HOrderGrad' set to 1.

% Calculate step width
hX=fieldValues.stepWidthX;
hY=fieldValues.stepWidthY;

% Calculate the gradient in y-direction
B=fieldValues.BAbs;
sizeY=size(B,1);
sizeX=size(B,2);
Grad= diag(ones(sizeY,1), 0)+diag(-8*ones(sizeY-1,1),1)+diag(zeros(sizeY-2,1),2)+diag(8*ones(sizeY-3,1),3)+diag(-ones(sizeY-4,1),4);
Grad=Grad(1:sizeY-4, :)./(12*hY);

fieldValuesNew.BGradY=Grad*B(:,3:end-2);

% Calculate the gradient in x-direction
Grad= diag(ones(sizeX,1), 0)+diag(-8*ones(sizeX-1,1),1)+diag(zeros(sizeX-2,1),2)+diag(8*ones(sizeX-3,1),3)+diag(-ones(sizeX-4,1),4);
Grad=Grad(1:sizeX-4, :)./(12*hX);

fieldValuesNew.BGradX=(Grad*B(3:end-2,:)')';

% [BGradX, BGradY]=gradient(fieldValues.BAbs, hX, hY);
% 
% fieldValuesNew.BGradX=BGradX;
% fieldValuesNew.BGradY=BGradY;

% Calculate absolute value
fieldValuesNew.BGradAbs=sqrt(fieldValuesNew.BGradX.^2+fieldValuesNew.BGradY.^2);

fieldValuesNew.X=fieldValues.X(3:end-2,3:end-2);
fieldValuesNew.Y=fieldValues.Y(3:end-2,3:end-2);
fieldValuesNew.BX=fieldValues.BX(3:end-2,3:end-2);
fieldValuesNew.BY=fieldValues.BY(3:end-2,3:end-2);
fieldValuesNew.BAbs=fieldValues.BAbs(3:end-2,3:end-2);
fieldValuesNew.A=fieldValues.A(3:end-2,3:end-2);

% fieldValuesNew.X=fieldValues.X;
% fieldValuesNew.Y=fieldValues.Y;
% fieldValuesNew.BX=fieldValues.BX;
% fieldValuesNew.BY=fieldValues.BY;
% fieldValuesNew.BAbs=fieldValues.BAbs;
% fieldValuesNew.A=fieldValues.A;

end

