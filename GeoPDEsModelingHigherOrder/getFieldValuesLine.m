% Copyright (c) 2015 Andreas Pels
function [fieldValues, stepWidth, coord] = getFieldValuesLine(startPoint, endPoint, numberSteps)

stepWidth=norm(endPoint-startPoint)./numberSteps;

coord=zeros(numberSteps+1, 2);
normDirectionVector=(endPoint-startPoint)/norm(endPoint-startPoint);
coord(:,:)=(startPoint'*ones(1, numberSteps+1)+normDirectionVector'*[0:numberSteps]*stepWidth)';

fieldValues.Bx=zeros(numberSteps+1,1);
fieldValues.By=zeros(numberSteps+1, 1);
fieldValues.A=zeros(numberSteps+1, 1);

for i=1:numberSteps+1
        
        temp=mo_getb(coord(i,1), coord(i,2));
        fieldValues.Bx(i, 1)=temp(1);
        fieldValues.By(i, 1)=temp(2);
        fieldValues.A(i, 1)=mo_geta(coord(i,1), coord(i,2));       
end
end