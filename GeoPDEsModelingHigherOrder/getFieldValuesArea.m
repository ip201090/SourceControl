% Copyright (c) 2015 Andreas Pels
%% Get field values from FEMM
function [fieldValues, stepWidth, coord] = getFieldValuesArea(upperLeftPoint, lowerRightPoint, numberSteps)

stepWidth.X=(lowerRightPoint(1)-upperLeftPoint(1))./numberSteps(1);
stepWidth.Y=(upperLeftPoint(2)-lowerRightPoint(2))./numberSteps(2);

coord.X=upperLeftPoint(1):stepWidth.X:lowerRightPoint(1);
coord.Y=lowerRightPoint(2):stepWidth.Y:upperLeftPoint(2);

fieldValues.Bx=zeros(numberSteps(2)+1, numberSteps(1)+1);
fieldValues.By=zeros(numberSteps(2)+1, numberSteps(1)+1);
fieldValues.A=zeros(numberSteps(2)+1, numberSteps(1)+1);
fieldValues.BAbs=zeros(numberSteps(2)+1, numberSteps(1)+1);
% HField=zeros(numberSteps(1)+1, numberSteps(2)+1, 2);

for i=1:numberSteps(1)+1
    for j=1:numberSteps(2)+1
        
        temp=mo_getb(coord.X(i), coord.Y(j));
        fieldValues.Bx(j, i)=temp(1);
        fieldValues.By(j, i)=temp(2);
        fieldValues.A(j, i)=mo_geta(coord.X(i), coord.Y(j));
        fieldValues.BAbs(j,i)=norm(temp);
    end
end

end