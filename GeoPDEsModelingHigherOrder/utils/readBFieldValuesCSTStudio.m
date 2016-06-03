%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [fieldValuesInt]=readBFieldValuesCSTStudio(filename, rangeX, rangeY, npnts,  HOrderGrad)

fid=fopen(filename);
fgetl(fid)
fgetl(fid)

[A, count]=fscanf(fid, '%f %f %f %f %f %f %f', [7,inf]);

z=[A(3,:)];
indices=find(z==100);

x=[A(1,indices),A(1,indices)];
y=[A(2,indices),-A(2,indices)];
Bx=[A(4,indices),A(4,indices)];
By=[A(5,indices),-A(5,indices)];
BAbs=sqrt(Bx.^2+By.^2);

fieldValues=struct('X', x./1000, 'Y', y./1000, 'BX', Bx, 'BY', By, 'BAbs', BAbs, 'A', zeros(size(BAbs)));

fclose(fid);

fieldValuesInt=interpolateFieldValues(fieldValues,rangeX, rangeY, npnts, HOrderGrad);

end