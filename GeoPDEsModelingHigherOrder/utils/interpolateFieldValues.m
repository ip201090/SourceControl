% Copyright (c) 2015 Andreas Pels

function [ fieldValuesNew ] = interpolateFieldValues( fieldValues, rangeX, rangeY, npnts, HOrderGrad )
%INTERPOLATEFIELDVALUES Interpolate field values at given positions. 
%   [fieldValuesNew] = INTERPOLATEFIELDVALUES(fieldValues, rangeX, rangeY, npnts, HOrderGrad)
%   interpolates the field values given by 'fieldValues'. 
%   The argument 'rangeX' defines the left and right boundary (x-direction) of the
%   interpolation area (e.g. [0, 0.5]) whereas rangeY is the same in y-direction.
%   'npnts' defines the number of points in both directions, e.g. [10, 10].
%   The additional argument 'HOrderGrad' specifies if the output values
%   shall be used with the function calculateGradientHOrder(fieldValues).
%   If this is the case, there will be field values returned which slightly
%   extend over the range given by 'rangeX' and 'rangeY'.

if nargin==5 && HOrderGrad==1
    % Optional argument given and is one
    % Calculate step width
    widthX=(rangeX(2)-rangeX(1))./(npnts(1)-1);
    widthY=(rangeY(2)-rangeY(1))./(npnts(2)-1);
    
    % Calculate new ranges and create according vectors
    rangeXNew=[rangeX(1)-2*widthX, rangeX(2)+2*widthX];
    rangeYNew=[rangeY(1)-2*widthY, rangeY(2)+2*widthY];
    xi=linspace(rangeXNew(1), rangeXNew(2), npnts(1)+4);
    yi=linspace(rangeYNew(1), rangeYNew(2), npnts(2)+4);
else
    % No optional argument given
    xi=linspace(rangeX(1), rangeX(2), npnts(1));
    yi=linspace(rangeY(1), rangeY(2), npnts(2));
    
end

[XI,YI]=meshgrid(xi, yi);

% Do the interpolation of the data
BX=TriScatteredInterp(fieldValues.X(:), fieldValues.Y(:), fieldValues.BX(:));
fieldValuesNew.BX=BX(XI,YI);
BY=TriScatteredInterp(fieldValues.X(:), fieldValues.Y(:), fieldValues.BY(:));
fieldValuesNew.BY=BY(XI,YI);
fieldValuesNew.BAbs=sqrt((fieldValuesNew.BX).^2+(fieldValuesNew.BY).^2);
A=TriScatteredInterp(fieldValues.X(:), fieldValues.Y(:), fieldValues.A(:));
fieldValuesNew.A=A(XI,YI);
fieldValuesNew.X=XI;
fieldValuesNew.Y=YI;
fieldValuesNew.stepWidthX=xi(2)-xi(1);
fieldValuesNew.stepWidthY=yi(2)-yi(1);

end

