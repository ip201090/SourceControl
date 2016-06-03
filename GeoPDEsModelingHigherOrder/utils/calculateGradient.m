%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldValues ] = calculateGradient( fieldValues )
BFieldAbs=fieldValues.BAbs(:,:);
[fieldValues.BGradX, fieldValues.BGradY]=gradient(BFieldAbs, fieldValues.stepWidthX, fieldValues.stepWidthY);
fieldValues.BGradAbs=sqrt(fieldValues.BGradX.^2+fieldValues.BGradY.^2);
end

