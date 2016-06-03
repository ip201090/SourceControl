%% Copyright (C) 2015 Andreas Pels, Jacopo Corno

function [convexnrb, concavenrb] = createNURBSPatches_jack(knotRefinementHorizontal,knotRefinementVertical,optionalPlots, geometry)

warning('Not yet implemented: The changing of the control points with the geometry argument!');

% Geometric data
if (nargin==4)
    convexcirclecenter=geometry.centerConvex;
    convexcircleradius=geometry.rConvex;
    convexcirclearc=geometry.angleConvex;
    p5=geometry.point5;
    p4=geometry.point4;
    concavecircleradius=geometry.rConcave;
    concavecirclecenter=geometry.centerConcave;
    concavecirclearc=geometry.angleConcave;
    p1=geometry.point1;
    p2=geometry.point2;
    p3=geometry.point3;
    p6=[p4(1)-10, p4(2)];
    p7=[p3(1)+10, p3(2)];
    xDisplacement1=geometry.dispConvexX1;
    yDisplacement1=geometry.dispConvexY1;
    wDisplacement1=geometry.dispConvexW1;
    xDisplacement2=geometry.dispConvexX2;
    yDisplacement2=geometry.dispConvexY2;
    wDisplacement2=geometry.dispConvexW2;
    xDisplacement3=geometry.dispConcaveX1;
    yDisplacement3=geometry.dispConcaveY1;
    wDisplacement3=geometry.dispConcaveW1;
    xDisplacement4=geometry.dispConcaveX2;
    yDisplacement4=geometry.dispConcaveY2;
    wDisplacement4=geometry.dispConcaveW2;
else
    convexcirclecenter=-6;
    convexcircleradius=4;
    convexcirclearc=90;
    p5=[-6,4];
    p4=[-17,20];
    concavecircleradius=5;
    concavecirclecenter=-3;
    concavecirclearc=82.875;
    p1=[-2.38 4.96];
    p2=[-2.38 6.96];
    p3=[17,20];
    p6=[p4(1)-10, p4(2)];
    p7=[p3(1)+10, p3(2)];
    xDisplacement1=0;
    yDisplacement1=0;
    wDisplacement1=0;
    xDisplacement2=0;
    yDisplacement2=0;
    wDisplacement2=0;
    xDisplacement3=0;
    yDisplacement3=0;
    wDisplacement3=0;
    xDisplacement4=0;
    yDisplacement4=0;
    wDisplacement4=0;
end

%% CREATE THE MIDDLE (AIR GAP) PATCH

% Total length of concave pole 
ltot = concavecircleradius * deg2rad (concavecirclearc) + norm (p1 - p2) + norm (p2 - p3);
l1 = concavecircleradius * deg2rad (concavecirclearc) / ltot;
l2 = norm (p1 - p2) / ltot;
l3 = norm (p2 - p3) / ltot;

% Create concave pole tip
piece{1} = nrbkntins (nrbcirc (concavecircleradius, [concavecirclecenter 0], 0, deg2rad (concavecirclearc)), 0.5); % need one point more for optimization
piece{2} = nrbdegelev (nrbline (p1, p2), 1);
piece{3} = nrbkntins(nrbdegelev (nrbline (p2, p3), 1), 0.5);

% Collect control points
concavecoefs = [piece{1}.coefs, piece{2}.coefs(:,2:end), piece{3}.coefs(:,2:end)];

% Rescale knot vectors
piece{1}.knots = piece{1}.knots * l1;
piece{2}.knots = piece{2}.knots * l2 + l1;
piece{3}.knots = piece{3}.knots * l3 + l2 + l1;
concaveknots = [piece{1}.knots(:, 1:end-2) piece{2}.knots(:, 3:end-2) piece{3}.knots(:,3:end)];

% Create NURBS
concavenrb = nrbmak (concavecoefs, concaveknots);


% Create convex pole tip
yaux = concavenrb.coefs(2,6);
xaux = p4(1) + (p5(1) - p4(1)) / (p5(2) - p4(2)) * (concavenrb.coefs(2,6) - p4(2));
paux = [xaux yaux];
piece{1} = nrbkntins(nrbcirc (convexcircleradius, [convexcirclecenter 0], 0, deg2rad (convexcirclearc)), 0.5); % need one point more for optimization
piece{2} = nrbdegelev (nrbline (p5, paux), 1);
piece{3} = nrbkntins(nrbdegelev (nrbline (paux, p4), 1), 0.5);

% Collect control points
convexcoefs = [piece{1}.coefs, piece{2}.coefs(:,2:end), piece{3}.coefs(:,2:end)];

% Rescale knot vectors
piece{1}.knots = piece{1}.knots * l1;
piece{2}.knots = piece{2}.knots * l2 + l1;
piece{3}.knots = piece{3}.knots * l3 + l2 + l1;
convexknots = [piece{1}.knots(:, 1:end-2) piece{2}.knots(:, 3:end-2) piece{3}.knots(:,3:end)];

% Create NURBS
convexnrb = nrbmak (convexcoefs, convexknots);


% Create bottom and top lines
nrbBottomLine = nrbdegelev (nrbline ([p5(1)+convexcircleradius 0], [concavecirclecenter+concavecircleradius 0]), 1);
nrbTopLine    = nrbdegelev (nrbline (p4, p3), 1);

% Create nurbs patch
nurbsAirGapPatch = nrbcoons(nrbBottomLine, nrbTopLine, convexnrb, concavenrb);

%% CREATE LEFT POLE (CONVEX) PATCH
piece{1} = nrbdegelev (nrbline ([p6(1), 0], [p6(1), convexnrb.coefs(2,4)]), 1);
piece{2} = nrbdegelev (nrbline ([p6(1), convexnrb.coefs(2,4)], [p6(1), convexnrb.coefs(2,6)]), 1);
piece{3} = nrbdegelev (nrbline ([p6(1), convexnrb.coefs(2,6)], p6), 1);

% Collect control points
leftlinecoefs = [piece{1}.coefs, piece{2}.coefs(:,2:end), piece{3}.coefs(:,2:end)];

% Rescale knot vectors
piece{1}.knots = piece{1}.knots * l1;
piece{2}.knots = piece{2}.knots * l2 + l1;
piece{3}.knots = piece{3}.knots * l3 + l2 + l1;
leftlineknots  = [piece{1}.knots(:, 1:end-2) piece{2}.knots(:, 3:end-2) piece{3}.knots(:,3:end)];

% Create NURBS
nrbLeftLine = nrbmak (leftlinecoefs, leftlineknots);

% Create bottom and top lines
nrbBottomLine = nrbdegelev (nrbline ([p6(1) 0], [p5(1)+convexcircleradius 0]), 1);
nrbTopLine    = nrbdegelev (nrbline (p6, p4), 1);

% Create nurbs patch
nurbsLeftPolePatch = nrbcoons (nrbBottomLine, nrbTopLine, nrbLeftLine, convexnrb);
nurbsLeftPolePatch = nrbkntins (nurbsLeftPolePatch, {.5 []});

%% CREATE RIGHT POLE (CONCAVE) PATCH
piece{1} = nrbdegelev (nrbline ([p7(1), 0], [p7(1), concavenrb.coefs(2,4)]), 1);
piece{2} = nrbdegelev (nrbline ([p7(1), concavenrb.coefs(2,4)], [p7(1), concavenrb.coefs(2,6)]), 1);
piece{3} = nrbdegelev (nrbline ([p7(1), concavenrb.coefs(2,6)], p7), 1);

% Collect control points
rightlinecoefs = [piece{1}.coefs, piece{2}.coefs(:,2:end), piece{3}.coefs(:,2:end)];

% Rescale knot vectors
piece{1}.knots = piece{1}.knots * l1;
piece{2}.knots = piece{2}.knots * l2 + l1;
piece{3}.knots = piece{3}.knots * l3 + l2 + l1;
rightlineknots  = [piece{1}.knots(:, 1:end-2) piece{2}.knots(:, 3:end-2) piece{3}.knots(:,3:end)];

% Create NURBS
nrbRightLine = nrbmak (rightlinecoefs, rightlineknots);

% Create bottom and top lines
nrbBottomLine = nrbdegelev (nrbline ([concavecirclecenter+concavecircleradius 0], [p7(1) 0]), 1);
nrbTopLine    = nrbdegelev (nrbline (p3, p7), 1);

% Create nurbs patch
nurbsRightPolePatch = nrbcoons (nrbBottomLine, nrbTopLine, concavenrb, nrbRightLine);
nurbsRightPolePatch = nrbkntins (nurbsRightPolePatch, {.5 []});

%% REFINEMENT

% This way the elements are already more evenly distributed and further
% refinement is "nicer"

[~, ~, new_knots] = kntrefine (nurbsAirGapPatch.knots, [knotRefinementHorizontal knotRefinementVertical], [2 2], [1 1]);
nurbsAirGapPatch  = nrbkntins (nurbsAirGapPatch, new_knots);

[~, ~, new_knots] = kntrefine (nurbsLeftPolePatch.knots, [knotRefinementHorizontal knotRefinementVertical], [2 2], [1 1]);
nurbsLeftPolePatch  = nrbkntins (nurbsLeftPolePatch, new_knots);

[~, ~, new_knots] = kntrefine (nurbsRightPolePatch.knots, [knotRefinementHorizontal knotRefinementVertical], [2 2], [1 1]);
nurbsRightPolePatch  = nrbkntins (nurbsRightPolePatch, new_knots);

% nurbsAirGapPatch = nrbdegelev(nurbsAirGapPatch, [2 2]);
% nurbsLeftPolePatch = nrbdegelev(nurbsLeftPolePatch, [2 2]);
% nurbsRightPolePatch = nrbdegelev(nurbsRightPolePatch, [2 2]);

%% EXPORT DATA
task=getCurrentTask();
if (isempty(task))
    taskID=1;
else
    taskID=task.ID;
end
nurbsAirGapPatchName=sprintf('nurbsAirGapPatch%d.txt', taskID);
nurbsLeftPolePatchName=sprintf('nurbsLeftPolePatch%d.txt', taskID);
nurbsRightPolePatchName=sprintf('nurbsRightPolePatch%d.txt', taskID);
nrbexport(nurbsAirGapPatch, nurbsAirGapPatchName);
nrbexport(nurbsLeftPolePatch, nurbsLeftPolePatchName);
nrbexport(nurbsRightPolePatch, nurbsRightPolePatchName);

%% PLOTS

if (optionalPlots==1)
    
% CURVES AND CONTROL POINTS    
    %figure
%     subplot(2,1,1)
%     title('Pole curves and control points');
%     hold on
% 	nrbplot(convexnrb,100);
%     nrbplot(concavenrb,100);
	%subplot(2,1,2)
    
    figure
    hold on
	nrbctrlplot(convexnrb);
    nrbctrlplot(concavenrb);
    
% PATCH SHAPES  
   figure
   title('Multipatch');
   hold on
   nrbctrlplot(nurbsRightPolePatch);
   nrbctrlplot(nurbsAirGapPatch);
   nrbctrlplot(nurbsLeftPolePatch);
   view(2);
%    figure
%    title('Patches');
%    subplot(3,1,1)
%    nrbplot(nurbsLeftPolePatch,[20 20]);
%    view(2);
%    subplot(3,1,2)
%    nrbplot(nurbsAirGapPatch,[20 20]);
%    view(2);
%    subplot(3,1,3)
%    nrbplot(nurbsRightPolePatch,[20 20]);
%    view(2);
    
% KNOT MAP    
    figure
    %title('Mesh');
    hold on
    nrbkntplot(nurbsRightPolePatch);
    nrbkntplot(nurbsLeftPolePatch);
    nrbkntplot(nurbsAirGapPatch);
    
end
end

