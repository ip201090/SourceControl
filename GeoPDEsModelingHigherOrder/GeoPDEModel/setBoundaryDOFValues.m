## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ boundaryDOFValues ] = setBoundaryDOFValues( geometry, x, percentualValue )
%SETBOUNDARYDOFVALUES Find the values for the boundary DOFs assuming first
%order Nedelec functions as basis functions for the spaces
%

values=[];
for i = 1:size(geometry,2)
    coord=nrbeval(geometry(i).nurbs, {[unique(geometry(i).nurbs.knots{1})], [0]});
    %boundaryDOFs=space{i}.boundary(3).dofs;
      
    values=[values,interp1(x,percentualValue,coord(1,:))];
end

boundaryDOFValues=values;

end

