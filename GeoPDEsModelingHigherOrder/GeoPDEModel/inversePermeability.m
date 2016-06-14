% Copyright (c) 2015 Andreas Pels

function [ permeability ] = inversePermeability( x, y, patch, iel, npatch, nel_dir )
%INVERSEPERMEABILITY Return inverse permeability at positions 'x', 'y' for
%patch 'patch' and element 'iel'
%

persistent permStruct;
persistent loadedFile;

if (patch==1 && iel ==1)
    if (exist('permeabilityFileGeoPDEs.mat', 'file')==2)
        % File exists ==> Read from file
        permStruct=load('permeabilityFileGeoPDEs.mat');
        loadedFile=1;
    else
        permStruct.values=cell(npatch,1);
        loadedFile=0;
    end
end

if (loadedFile==0)
    % Read values from FEMM and save them in struct
    permStruct.values{patch}{iel}=readInversePermeabilityFEMM(x, y);
    permeability=permStruct.values{patch}{iel};
else
    % Read values from struct
    permeability=permStruct.values{patch}{iel};
end

if (patch==npatch && iel == nel_dir)
    if (loadedFile==1)
        % Do nothing
    else
        % Save file
        values=permStruct.values;
        save ('permeabilityFileGeoPDEs.mat', 'values');
    end
end

    
end

