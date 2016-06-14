% Copyright (c) 2015 Andreas Pels

function [ fieldHomogeneity ] = calculateFieldHomogeneity( fieldGradient, averageFieldGradient )
%CALCULATEFIELDHOMOGENEITY Calculates the field homogeneity in the given
%area in x-direction
%   [ fieldHomogeneity ] = CALCULATEFIELDHOMOGENEITY( fieldGradient, averageFieldGradient )
%   calculates the field homogeneity to the B-field gradients given
%   in 'fieldGradient' and the average field gradient given in 'averageFieldGradient'. 
%   It uses the simple rectangle method to approximate integrals. 

N=size(fieldGradient.BGradX, 1)*size(fieldGradient.BGradX, 2);
fieldHomogeneity=sqrt(sum(sum((fieldGradient.BGradX./averageFieldGradient-1).^2))./(N));
end

