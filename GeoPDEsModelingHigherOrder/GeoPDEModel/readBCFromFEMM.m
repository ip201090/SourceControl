## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [BCondition] = readBCFromFEMM(x, y, bnd_side, max_side)
% readBCFromFEMM returns the values for the Dirichlet boundary condition
% needed by GeoPDEs at the position given by x, y.

persistent BCStruct;
persistent loadedFile;

if (bnd_side==1)
    if (exist('BCReadFromFEMM.mat', 'file')==2)
        % File exists ==> Read from file
        BCStruct=load('BCReadFromFEMM.mat');
        loadedFile=1;
    else
        BCStruct.values=cell(max_side,1);
        loadedFile=0;
    end
end

if (loadedFile==0)
    % Read values from FEMM and save them in struct
    aValues=zeros(size(x));
    for i=1:size(x,1)
        for j=1:size(x,2)
            aValues(i,j)=mo_geta(x(i,j), y(i,j));
        end
    end
    
    
    BCStruct.values{bnd_side}=aValues;
    BCondition=BCStruct.values{bnd_side};
else
    % Read values from struct
    BCondition=BCStruct.values{bnd_side};
end

if (bnd_side == max_side)
    if (loadedFile==1)
        % Do nothing
    else
        % Read flux and save file
        mo_addcontour(-27,20);
        mo_addcontour(-27,0);
        [flux]=mo_lineintegral(0);
        
        save('BCReadFluxFromFEMM.mat', 'flux');
        
        % Save file
        values=BCStruct.values;
        save ('BCReadFromFEMM.mat', 'values');
    end
end



end