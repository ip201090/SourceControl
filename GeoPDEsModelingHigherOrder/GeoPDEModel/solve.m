## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [u, space, geometry, gnum]=solve(knotRefinementHorizontal,knotRefinementVertical,optionalPlots, current, boundaryCondition, geometry)

%close all;
warning('The parameter boundaryCondition is obsolete and will be removed soon.')

if (nargin==6)
    createNURBSPatches_jack_opt(knotRefinementHorizontal,knotRefinementVertical,optionalPlots, geometry);
else
    createNURBSPatches_jack_opt(knotRefinementHorizontal,knotRefinementVertical,optionalPlots);
end
load3patchmultipatchinfo;
multiPatchAddress=createMultipatch(multiPatchStruct);
%[u, space, geometry, gnum]=TestNURBSLaplaceSolverMPNonIso(multiPatchAddress);
[u, space, geometry, gnum, msh]=solveGeoPDEsFieldCircuitCoupling(multiPatchAddress, current);

end