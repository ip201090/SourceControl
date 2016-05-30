## Copyright (C) 2015 Andreas Pels, Jacopo Corno

function [convexnrb, concavenrb] = createNURBSPatches_jack_opt(knotRefinementHorizontal,knotRefinementVertical,optionalPlots, geometry)

%warning('Not yet implemented: The changing of the control points with the geometry argument!');

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
piece{1} = nrbkntins (nrbcirc (concavecircleradius, [concavecirclecenter 0], 0, deg2rad (concavecirclearc)), .5); % need one point more for optimization
piece{2} = nrbdegelev (nrbline (p1, p2), 1);
piece{3} = nrbkntins (nrbdegelev (nrbline (p2, p3), 1), .5);

% Collect control points
concavecoefs = [piece{1}.coefs, piece{2}.coefs(:,2:end), piece{3}.coefs(:,2:end)];

% Rescale knot vectors
piece{1}.knots = piece{1}.knots * l1;
piece{2}.knots = piece{2}.knots * l2 + l1;
piece{3}.knots = piece{3}.knots * l3 + l2 + l1;
concaveknots = [piece{1}.knots(:, 1:end-2) piece{2}.knots(:, 3:end-2) piece{3}.knots(:,3:end)];

% Create NURBS
concavenrb = nrbmak (concavecoefs, concaveknots);

% Compensate point for weight introduction
concavenrb.coefs(:,2)=concavenrb.coefs(:,2)+[xDisplacement3;yDisplacement3;0;wDisplacement3];
concavenrb.coefs(1:3,2)=concavenrb.coefs(1:3,2)*(concavenrb.coefs(4,2))/(concavenrb.coefs(4,2)-wDisplacement3);

concavenrb.coefs(:,1)=[concavenrb.coefs(1,2) 0 0 concavenrb.coefs(4,2)]';

% Compensate point for weight introduction
concavenrb.coefs(:,3)=concavenrb.coefs(:,3)+[xDisplacement4;yDisplacement4;0;wDisplacement4];
concavenrb.coefs(1:3,3)=concavenrb.coefs(1:3,3)*(concavenrb.coefs(4,3))/(concavenrb.coefs(4,3)-wDisplacement4);

% Create convex pole tip
yaux = concavenrb.coefs(2,6);
xaux = p4(1) + (p5(1) - p4(1)) / (p5(2) - p4(2)) * (concavenrb.coefs(2,6) - p4(2));
paux = [xaux yaux];
piece{1} = nrbkntins (nrbcirc (convexcircleradius, [convexcirclecenter 0], 0, deg2rad (convexcirclearc)), .5); % need one point more for optimization
piece{2} = nrbdegelev (nrbline (p5, paux), 1);
piece{3} = nrbkntins (nrbdegelev (nrbline (paux, p4), 1), .5);

% Collect control points
convexcoefs = [piece{1}.coefs, piece{2}.coefs(:,2:end), piece{3}.coefs(:,2:end)];

% Rescale knot vectors
piece{1}.knots = piece{1}.knots * l1;
piece{2}.knots = piece{2}.knots * l2 + l1;
piece{3}.knots = piece{3}.knots * l3 + l2 + l1;
convexknots = [piece{1}.knots(:, 1:end-2) piece{2}.knots(:, 3:end-2) piece{3}.knots(:,3:end)];

% Create NURBS
convexnrb = nrbmak (convexcoefs, convexknots);
 
% Compensate point for weight introduction
convexnrb.coefs(:,2)=convexnrb.coefs(:,2)+[xDisplacement1;yDisplacement1;0;wDisplacement1];
convexnrb.coefs(1:3,2)=convexnrb.coefs(1:3,2)*(convexnrb.coefs(4,2))/(convexnrb.coefs(4,2)-wDisplacement1);

convexnrb.coefs(:,1)=[convexnrb.coefs(1,2) 0 0 convexnrb.coefs(4,2)]';

% Compensate point for weight introduction
convexnrb.coefs(:,3)=(convexnrb.coefs(:,3)+[xDisplacement2;yDisplacement2;0;wDisplacement2]);
convexnrb.coefs(1:3,3)=convexnrb.coefs(1:3,3)*(convexnrb.coefs(4,3))/(convexnrb.coefs(4,3)-wDisplacement2);

% Create bottom and top lines
nrbBottomLine = nrbdegelev (nrbline ([p5(1)+convexcircleradius 0], [concavecirclecenter+concavecircleradius 0]), 1);
nrbTopLine    = nrbdegelev (nrbline (p4, p3), 1);

% Create nurbs patch
nurbsAirGapPatch = nrbcoons(nrbBottomLine, nrbTopLine, convexnrb, concavenrb);

% Set iternal control points to be as obtained by Winslow optimization
[~, ~, new_knots] = kntrefine (nurbsAirGapPatch.knots, [1 0], [2 2], [1 1]); % Winslow optimization was run on this refinement
nurbsAirGapPatch  = nrbkntins (nurbsAirGapPatch, new_knots);

% nurbsAirGapPatch.coefs(:,2,2) = [-1.531583374564610; 1.743522373095812; 0; 0.981464420590451];
% nurbsAirGapPatch.coefs(:,3,2) = [ 0.476149667953995; 1.697891339945761; 0; 0.904801489842368];
% nurbsAirGapPatch.coefs(:,2,3) = [-3.289180407764240; 3.602389549159161; 0; 0.885838662129611];
% nurbsAirGapPatch.coefs(:,3,3) = [-1.505735117537997; 3.906968057248957; 0; 0.999652055246629];


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

% Set iternal control points to be as obtained by Winslow optimization
[~, ~, new_knots] = kntrefine (nurbsLeftPolePatch.knots, [1 0], [2 2], [1 1]); % Winslow optimization was run on this refinement
nurbsLeftPolePatch  = nrbkntins (nurbsLeftPolePatch, new_knots);

nurbsLeftPolePatch.coefs(:,2,2) = [-21.752250898282298; 0.922669730546341; 0; 0.914640007280873];
nurbsLeftPolePatch.coefs(:,3,2) = [-15.643406427703425; 0.958861980712653; 0; 0.860055463418503];
nurbsLeftPolePatch.coefs(:,4,2) = [-11.248001557999622; 0.929373000068500; 0; 0.918715390294435];
nurbsLeftPolePatch.coefs(:,5,2) = [ -5.605603529519312; 1.009719498881132; 0; 0.919764809496826];
nurbsLeftPolePatch.coefs(:,2,3) = [-22.083654359493408; 2.761977521654934; 0; 0.916028392374940];
nurbsLeftPolePatch.coefs(:,3,3) = [-16.361006628550232; 2.476441007745162; 0; 0.872350675047243];
nurbsLeftPolePatch.coefs(:,4,3) = [-11.650369138231286; 2.743387929693391; 0; 0.866803575831399];
nurbsLeftPolePatch.coefs(:,5,3) = [ -7.850263953443478; 2.377157465767015; 0; 0.992684048746573];


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

% Set iternal control points to be as obtained by Winslow optimization
[~, ~, new_knots] = kntrefine (nurbsRightPolePatch.knots, [1 0], [2 2], [1 1]); % Winslow optimization was run on this refinement
nurbsRightPolePatch  = nrbkntins (nurbsRightPolePatch, new_knots);

nurbsRightPolePatch.coefs(:,2,2) = [ 3.206429860307161; 0.886932238879014; 0; 0.802556411863030];
nurbsRightPolePatch.coefs(:,3,2) = [ 9.203153195763518; 1.236739186250256; 0; 0.851574918511274];
nurbsRightPolePatch.coefs(:,4,2) = [13.855535208533313; 1.083420361029440; 0; 0.802031506065722];
nurbsRightPolePatch.coefs(:,5,2) = [19.912463855241441; 1.146454744347994; 0; 0.847612502195546];
nurbsRightPolePatch.coefs(:,2,3) = [ 2.566093464658261; 3.151091664248682; 0; 0.858528841306617];
nurbsRightPolePatch.coefs(:,3,3) = [ 7.668094309958191; 2.943086249779894; 0; 0.814611174718346];
nurbsRightPolePatch.coefs(:,4,3) = [13.530529977423587; 2.908759120867495; 0; 0.812679602032901];
nurbsRightPolePatch.coefs(:,5,3) = [19.523030003381184; 3.046481458437155; 0; 0.842925362237329];

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

