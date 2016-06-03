%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [convexnrb, concavenrb] = createNURBSPatchesSpecial(knotRefinementHorizontal,knotRefinementVertical,optionalPlots, vector, vector2)

% Knot vectors
lowermostKnot=0.9;
additionalKnotsVertical=sort([0.25 0.65 vector]);%[0.1 0.25 0.4 0.65 0.85 0.98];
additionalKnotsHorizontal=vector2;
verticalBaseKnotVector=[0 0 0 0.5 0.5 0.8 0.8 1 1 1];
horizontalBaseKnotVector=[0 0 0 1 1 1];
[knots,zeta,verticalKnotVector]=kntrefine(sort([lowermostKnot additionalKnotsVertical verticalBaseKnotVector]),knotRefinementVertical,2,1);
[knots,zeta,horizontalKnotVector]=kntrefine(horizontalBaseKnotVector,knotRefinementHorizontal,2,1);

[~,~,horizontalKnotVectorAirGap]=kntrefine(sort([horizontalBaseKnotVector additionalKnotsHorizontal]),knotRefinementHorizontal,2,1);

% Geometric data
% if (nargin==4)
%     convexcirclecenter=geometry.centerConvex;
%     convexcircleradius=geometry.rConvex;
%     convexcirclearc=geometry.angleConvex;
%     p5=geometry.point5;
%     p4=geometry.point4;
%     concavecircleradius=geometry.rConcave;
%     concavecirclecenter=geometry.centerConcave;
%     concavecirclearc=geometry.angleConcave;
%     p1=geometry.point1;
%     p2=geometry.point2;
%     p3=geometry.point3;
%     p6=[p4(1)-10, p4(2)];
%     p7=[p3(1)+10, p3(2)];
%     xDisplacement1=geometry.dispConvexX1;
%     yDisplacement1=geometry.dispConvexY1;
%     wDisplacement1=geometry.dispConvexW1;
%     xDisplacement2=geometry.dispConvexX2;
%     yDisplacement2=geometry.dispConvexY2;
%     wDisplacement2=geometry.dispConvexW2;
%     xDisplacement3=geometry.dispConcaveX1;
%     yDisplacement3=geometry.dispConcaveY1;
%     wDisplacement3=geometry.dispConcaveW1;
%     xDisplacement4=geometry.dispConcaveX2;
%     yDisplacement4=geometry.dispConcaveY2;
%     wDisplacement4=geometry.dispConcaveW2;
% else
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
% end

%% CREATE THE MIDDLE (AIR GAP) PATCH

% Create convex pole tip nurbs

coef5=[p4 0 1];
coef7=[p5 0 1];
coef6=(coef5+coef7)/2;
coefaux1=(coef5+coef6)/2;
coefaux2=(coef6+coef7)/2;
arc=nrbcirc(convexcircleradius,[convexcirclecenter 0],0,convexcirclearc*2*pi/360);
coef9=arc.coefs(:,1)';
coef8=arc.coefs(:,2)';
convexcoefs=[coef5' coefaux1' coef6' coefaux2' coef7' coef8' coef9'];
convexknots=verticalBaseKnotVector;
convexnrb=nrbmak(convexcoefs, convexknots);
convexnrb=nrbkntins(convexnrb,lowermostKnot);

% Compensate point for weight introduction
convexnrb.coefs(:,7)=convexnrb.coefs(:,7)+[xDisplacement1;yDisplacement1;0;wDisplacement1];
convexnrb.coefs(1:3,7)=convexnrb.coefs(1:3,7)*(convexnrb.coefs(4,7))/(convexnrb.coefs(4,7)-wDisplacement1);

convexnrb.coefs(:,8)=[convexnrb.coefs(1,7) 0 0 convexnrb.coefs(4,7)]';

% Compensate point for weight introduction
convexnrb.coefs(:,6)=(convexnrb.coefs(:,6)+[xDisplacement2;yDisplacement2;0;wDisplacement2]);
convexnrb.coefs(1:3,6)=convexnrb.coefs(1:3,6)*(convexnrb.coefs(4,6))/(convexnrb.coefs(4,6)-wDisplacement2);

convexnrb=nrbkntins(convexnrb,additionalKnotsVertical);
convexnrb=nrbkntins(convexnrb,verticalKnotVector);

% Create concave pole tip nurbs

coef5=[p3 0 1];
coef7=[p2 0 1];
coef6=(coef5+coef7)/2;
coef9=[p1 0 1];
coef8=(coef7+coef9)/2;
arc=nrbcirc(concavecircleradius,[concavecirclecenter 0],0,concavecirclearc*2*pi/360);
coef10=arc.coefs(:,2)';
coef11=arc.coefs(:,1)';
concavecoefs=[coef5' coef6' coef7' coef8' coef9' coef10' coef11'];
concaveknots=verticalBaseKnotVector;
concavenrb=nrbmak(concavecoefs,concaveknots);
concavenrb=nrbkntins(concavenrb,lowermostKnot);

% Compensate point for weight introduction
concavenrb.coefs(:,7)=concavenrb.coefs(:,7)+[xDisplacement3;yDisplacement3;0;wDisplacement3];
concavenrb.coefs(1:3,7)=concavenrb.coefs(1:3,7)+concavenrb.coefs(1:3,7)*wDisplacement3;

concavenrb.coefs(:,8)=[concavenrb.coefs(1,7) 0 0 concavenrb.coefs(4,7)]';

% Compensate point for weight introduction
concavenrb.coefs(:,6)=concavenrb.coefs(:,6)+[xDisplacement4;yDisplacement4;0;wDisplacement4];
concavenrb.coefs(1:3,6)=concavenrb.coefs(1:3,6)+concavenrb.coefs(1:3,6)*wDisplacement4;

concavenrb=nrbkntins(concavenrb, additionalKnotsVertical);
concavenrb=nrbkntins(concavenrb,verticalKnotVector);
 
% Create bottom and top line
nrbBottomLine=nrbline(coef9(1:2), coef11(1:2));
nrbTopLine=nrbline(p4, p3);
nrbBottomLine=nrbdegelev(nrbBottomLine,1);
nrbTopLine=nrbdegelev(nrbTopLine,1);

nrbBottomLine=nrbkntins(nrbBottomLine,additionalKnotsHorizontal);
nrbBottomLine=nrbkntins(nrbBottomLine,horizontalKnotVectorAirGap);

nrbTopLine=nrbkntins(nrbTopLine,additionalKnotsHorizontal);
nrbTopLine=nrbkntins(nrbTopLine,horizontalKnotVectorAirGap);


% Create nurbs patch
nurbsAirGapPatch=nrbcoons(nrbBottomLine, nrbTopLine, convexnrb, concavenrb);

%% CREATE LEFT POLE (CONVEX) PATCH

% Create lines
nrbBottomLine=nrbline([p6(1), 0], coef9(1:2));
nrbTopLine=nrbline(p6, p3);
nrbBottomLine=nrbdegelev(nrbBottomLine,1);
nrbTopLine=nrbdegelev(nrbTopLine,1);
nrbBottomLine=nrbkntins(nrbBottomLine,horizontalKnotVector);
nrbTopLine=nrbkntins(nrbTopLine,horizontalKnotVector);
nrbLeftLine=nrbline(p6, [p6(1), 0]);
nrbLeftLine=nrbdegelev(nrbLeftLine, 1);
nrbLeftLine=nrbkntins(nrbLeftLine,verticalBaseKnotVector(4:length(verticalBaseKnotVector)-3));
nrbLeftLine=nrbkntins(nrbLeftLine,lowermostKnot);
nrbLeftLine=nrbkntins(nrbLeftLine,additionalKnotsVertical);
nrbLeftLine=nrbkntins(nrbLeftLine,verticalKnotVector);

% Create nurbs patch
nurbsLeftPolePatch=nrbcoons(nrbBottomLine, nrbTopLine, nrbLeftLine, convexnrb);

%% CREATE RIGHT POLE (CONCAVE) PATCH

% Create lines
nrbBottomLine=nrbline(coef11(1:2), [p7(1), 0]);
nrbTopLine=nrbline(p3, p7);
nrbBottomLine=nrbdegelev(nrbBottomLine,1);
nrbTopLine=nrbdegelev(nrbTopLine,1);
nrbBottomLine=nrbkntins(nrbBottomLine,horizontalKnotVector);
nrbTopLine=nrbkntins(nrbTopLine,horizontalKnotVector);
nrbRightLine=nrbline(p7, [p7(1), 0]);
nrbRightLine=nrbdegelev(nrbRightLine, 1);
nrbRightLine=nrbkntins(nrbRightLine,verticalBaseKnotVector(4:length(verticalBaseKnotVector)-3));
nrbRightLine=nrbkntins(nrbRightLine,lowermostKnot);
nrbRightLine=nrbkntins(nrbRightLine, additionalKnotsVertical);
nrbRightLine=nrbkntins(nrbRightLine,verticalKnotVector);


% Create nurbs patch
nurbsRightPolePatch=nrbcoons(nrbBottomLine, nrbTopLine, concavenrb, nrbRightLine);

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
    figure
    subplot(2,1,1)
    title('Pole curves and control points');
    hold on
	nrbplot(convexnrb,100);
    nrbplot(concavenrb,100);
	subplot(2,1,2)
    hold on
	nrbctrlplot(convexnrb);
    nrbctrlplot(concavenrb);
    
% PATCH SHAPES  
%    figure
%    title('Multipatch');
%    hold on
%    nrbplot(nurbsRightPolePatch,[20 20]);
%    nrbplot(nurbsAirGapPatch,[20 20]);
%    nrbplot(nurbsLeftPolePatch,[20 20]);
%    view(2);
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
    title('Mesh');
    hold on
    nrbkntplot(nurbsRightPolePatch);
    nrbkntplot(nurbsLeftPolePatch);
    nrbkntplot(nurbsAirGapPatch);
    
end
end

