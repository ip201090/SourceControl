% Copyright (c) 2015 Andreas Pels

function [ averageField ] = calculateAverageMagneticField( fieldValues )
%CALCULATEAVERAGEMAGNETICFIELD Calculate average value of magnetic flux
%density
%   Detailed explanation goes here

N=size(fieldValues.BAbs, 1)*size(fieldValues.BAbs, 2);
averageField=sum(sum(fieldValues.BAbs))./(N);
end

