## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldValues ] = readBFieldValuesGeoPDEs( u, space, geometry, gnum, resolution, patch )
%READBFIELDVALUESGEOPDES Reads B-field values from
%GeoPDEs
%   [fieldValues] = READBFIELDVALUESGEOPDES(u, space, geometry, gnum, resolution, patch) reads B-field and
%   magnetic voltage values from GeoPDEs.
%   'resolution' is a vector specifying the resolution in x- and in 
%   y-direction. The resolution determines in how many equally spaced points 
%   the parametric domain is split. 
%   The argument 'patch' is an integer number refering to the patch from which the
%   data should be read. 
%   'u', 'space', 'geometry' and gnum are variables given by GeoPDEs defining 
%   the DOFs, the space, the geometry and the global numbering of DOFs, respectively.
%   The return value 'fieldValues' is a structure containing the B-field
%   values in x- and y-direction as well as the absolute value (denoted
%   by BX, BY, BAbs respectively). These are given as
%   matrices with size 'resoultion(1)' x 'resolution(2)'. Furthermore
%   a field storing the magnetic voltage A is given as well as two matrices
%   X and Y denoting the positions at which the values were read
%   (e.g. position of a value (X(i,j),Y(i,j))). These matrices have the
%   same size as the matrices storing the B-Field.

% Read magnetic voltage
[eu, ~]=sp_eval(u(gnum{patch}), space{patch}, geometry(patch), resolution, 'value');

fieldValues.A=eu;


% Read B-field
[eu, F]=sp_eval(u(gnum{patch}), space{patch}, geometry(patch), resolution, 'gradient');
[X, Y]  = deal(squeeze(F(1,:,:)), squeeze(F(2,:,:)));

fieldValues.BX(:,:)=eu(2,:,:)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
fieldValues.BY(:,:)=-eu(1,:,:)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
fieldValues.BAbs(:,:)=sqrt(fieldValues.BX.^2+fieldValues.BY.^2);
fieldValues.X(:,:)=X./1000; % Transformation to m from mm
fieldValues.Y=Y./1000; % Transformation to m from mm 





end

