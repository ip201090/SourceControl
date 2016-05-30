## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ averageFieldGradient ] = calculateAverageMagneticFieldGradient( fieldGradient )
%CALCULATEAVERAGEMAGNETICFIELDGRADIENT calculates the average magnetic
%field gradient in x-direction
%   [ averageFieldGradient ] = CALCULATEAVERAGEMAGNETICFIELDGRADIENT(
%   fieldGradient ) calculates the average magnetic field gradient
%   according to the values given in 'fieldGradient'area=abs((coord.X(end)-coord.X(1))*(coord.Y(end)-coord.Y(1)));
N=size(fieldGradient.BGradX, 1)*size(fieldGradient.BGradX, 2);
averageFieldGradient=sum(sum(fieldGradient.BGradX))./(N);
end

