## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldValues ] = readBFieldGradientXGeoPDEs( u, space, geometry, gnum, resolution, patch )
%READBFIELDGRADIENTXGEOPDES Reads B-field gradient in x-direction from
%GeoPDEs
%   [fieldValues] = READBFIELDGRADIENTXGEOPDES(u, space, geometry, gnum, resolution, patch) reads B-field and
%   magnetic voltage values from GeoPDEs.
%   'resolution' is a vector specifying the resolution in x- and in 
%   y-direction. The resolution determines in how many equally spaced points 
%   the parametric domain is split. 
%   The argument 'patch' is an integer number refering to the patch from which the
%   data should be read. 
%   'u', 'space', 'geometry' and gnum are variables given by GeoPDEs defining 
%   the DOFs, the space, the geometry and the global numbering of DOFs, respectively.
%   The return value 'fieldValues' is a structure containing the B-field
%   gradient in x-direction. The values are given as
%   matrices with size 'resolution(1)' x 'resolution(2)'. Furthermore two matrices
%   X and Y are given denoting the positions at which the values were read
%   (e.g. position of a value (X(i,j),Y(i,j))). These matrices have the
%   same size as the matrices storing the B-field gradient.

% Read B-field gradient
[eu, F]=sp_eval(u(gnum{patch}), space{patch}, geometry(patch), resolution, 'hessian');
euHess=eu.euHess;
euGrad=eu.euGrad;

[X, Y]  = deal(squeeze(F(1,:,:)), squeeze(F(2,:,:)));

fieldValues.BX(:,:)=euGrad(2,:,:)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
fieldValues.BY(:,:)=-euGrad(1,:,:)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
fieldValues.BAbs(:,:)=sqrt(fieldValues.BX.^2+fieldValues.BY.^2);

fieldValues.BGradX(:,:)=1./fieldValues.BAbs(:,:).*(fieldValues.BY(:,:).*(-squeeze(euHess(1,1,:,:)*1e6))+fieldValues.BX(:,:).*squeeze(euHess(1,2,:,:)*1e6)); % Transformation to Wb/m^3 from Wb/mm^3; 1e6 only because A is in standard units and is derived after mm. 

fieldValues.X(:,:)=X./1000; % Transformation to m from mm
fieldValues.Y=Y./1000; % Transformation to m from mm 





end

