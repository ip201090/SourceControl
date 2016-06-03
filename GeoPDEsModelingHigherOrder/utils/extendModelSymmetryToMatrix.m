%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldValuesNew ] = extendModelSymmetryToMatrix( fieldValues )
%EXTENDMODELSYMMETRYTOMATRIX The function uses the model symmetry at y=0
%and extends the matrices accordingly 

Y=[fieldValues.Y, -fliplr(fieldValues.Y(:,1:end-1))];
X=[fieldValues.X, fliplr(fieldValues.X(:,1:end-1))];
BX=[fieldValues.BX, fliplr(fieldValues.BX(:,1:end-1))];
BY=[fieldValues.BY, -fliplr(fieldValues.BY(:,1:end-1))];
BAbs(:,:)=sqrt(BX.^2+BY.^2);
A=[fieldValues.A, fliplr(fieldValues.A(:,1:end-1))];

fieldValuesNew=struct('X', X, 'Y', Y, 'BX', BX, 'BY', BY, 'BAbs', BAbs, 'A', A);

end

