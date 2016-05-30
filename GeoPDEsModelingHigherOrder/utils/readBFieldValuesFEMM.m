## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldValuesFEMM ] = readBFieldValuesFEMM( fieldValues )
%READBFIELDVALUESFEMM Read B-field values at given positions from FEMM
%   [fieldValues] = READBFIELDVALUESFEMM(X,Y) reads the permeability values at the
%   positions specified in X and Y. X, Y are matrices where each
%   corresponding element specifies the position as (x,y)-tupel(e.g.
%   (X(i,j),Y(i,j)) ). The matrix given back is filled with the B-field
%   values
%   values at the corresponding positions.


X=fieldValues.X*1000; % Use values in mm
Y=fieldValues.Y*1000; % Use values in mm

BX=zeros(size(X));
BY=zeros(size(X));
A=zeros(size(X));
BAbs=zeros(size(X));


for i=1:size(X,2)
    for j=1:size(X,1)
        
        if (X(j,i)>26.99999)
            string=sprintf('Warning: Rounding %f to 27', X(j,i));
            disp(string);
            X(j,i)=27;
        elseif (X(j,i)<-26.99999)
            string=sprintf('Warning: Rounding %f to -27', X(j,i));
            disp(string);
            X(j,i)=-27;
        elseif (Y(j,i)<-19.99999)
            string=sprintf('Warning: Rounding %f to -20', Y(j,i));
            disp(string);
            Y(j,i)=-20;
        elseif (Y(j,i)>19.99999)
            string=sprintf('Warning: Rounding %f to 20', Y(j,i));
            disp(string);
            Y(j,i)=20;
        end
        
        %disp(sprintf('%f, %f', X(j,i), Y(j,i)))
        
        if (Y(j,i)<0)
            temp=mo_getb(X(j,i), -Y(j,i)); 
            BX(j,i)=temp(1);
            BY(j,i)=-temp(2);
            A(j,i)=mo_geta(X(j,i), -Y(j,i));
            BAbs(j,i)=norm(temp);
        else
            temp=mo_getb(X(j,i), Y(j,i));
            BX(j,i)=temp(1);
            BY(j,i)=temp(2);
            A(j,i)=mo_geta(X(j,i), Y(j,i));
            BAbs(j,i)=norm(temp);
        end
        
        
    end
end

if(isempty(find(ismember(fieldnames(fieldValues),'stepWidthX'),1)))
    fieldValuesFEMM=struct('BX', BX, 'BY', BY, 'A', A, 'BAbs', BAbs, 'X', X./1000, 'Y', Y./1000);
else
    fieldValuesFEMM=struct('BX', BX, 'BY', BY, 'A', A, 'BAbs', BAbs, 'X', X./1000, 'Y', Y./1000, 'stepWidthX', fieldValues.stepWidthX, 'stepWidthY', fieldValues.stepWidthY);
end
end

