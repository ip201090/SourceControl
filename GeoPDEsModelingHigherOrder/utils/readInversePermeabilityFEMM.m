%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ inversePermeability ] = readInversePermeabilityFEMM( X, Y )
%READPERMEABILTYFEMM Read B-field values at given positions from FEMM
%   [fieldValues] = READPERMEABILITYFEMM(X,Y) reads the B-field values at the
%   positions specified in X and Y. X, Y are matrices where each
%   corresponding element specifies the position as (x,y)-tupel(e.g.
%   (X(i,j),Y(i,j)) ). The structure given back has three elements. Each
%   element is a matrix of the same size as X,Y and stores the B-field in
%   x-direction, in y-direction and the absolute value at the corresponding
%   positions


inversePermeability=zeros(size(X));
muO=4*pi*1e-7;

for i=1:size(X,2)
    for j=1:size(X,1)
        
        if (Y(j,i)<0)
            temp=mo_getmu(X(j,i), -Y(j,i)); % Use values in mm
            % Assuming permeability to be equal in both directions
            inversePermeability(j,i)=1./(temp(1)*muO);
        else
            temp=mo_getmu(X(j,i), Y(j,i)); % Use values in mm
            % Assuming permeability to be equal in both directions
            inversePermeability(j,i)=1./(temp(1)*muO);
        end
        
        
    end
end
end

