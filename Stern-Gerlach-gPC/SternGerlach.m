function f = SternGerlach(X)
%% Setup of the Parameters

% Current Excitation
turns=65;
current=40;

% Mesh
meshSize=0.8;
stepSizeFieldValues=meshSize;
lengthFromOuterLimit=100;


% Geometry
geometry.rConvex=4;

geometry.rConcave=5;

geometry.centerConvex=[-6, 0.00];
geometry.centerConcave=[-3, 0];

geometry.point4=[-17, 20];
geometry.point3=[17, 20];
geometry.point2=[-2.38, 6.96];

% Calculate point5 and point1
geometry.angleConvex=90;
geometry.point5=[geometry.centerConvex(1)+cosd(geometry.angleConvex)*geometry.rConvex, sind(geometry.angleConvex)*geometry.rConvex];

geometry.angleConcave=82.8750;
geometry.point1=[geometry.centerConcave(1)+cosd(geometry.angleConcave)*geometry.rConcave, sind(geometry.angleConcave)*geometry.rConcave];

% Set x coordinate of point2 the same as that of point1
geometry.point2=[geometry.point1(1), 6.96];

% Set displacements of the control points
% ==> Experiment a little bit. You can find more information in the paper
% ****************** THESE ARE THE UNCERTAINTIES **********************

switch size(X,2)
    
    case 2
        geometry.dispConvexX1=X(1);
        geometry.dispConvexY1=1.83;
        geometry.dispConvexW1=0.85;
        geometry.dispConvexX2=-3.5;
        geometry.dispConvexY2=3.5;
        geometry.dispConvexW2=1.6;
        geometry.dispConcaveX1=2;
        geometry.dispConcaveY1=2.2;
        geometry.dispConcaveW1=0.87;
        geometry.dispConcaveX2=X(2);
        geometry.dispConcaveY2=4.75;
        geometry.dispConcaveW2=1.62;

    case 10
        geometry.dispConvexX1=X(1);
        geometry.dispConvexY1=X(2);
        geometry.dispConvexW1=0.85;
        geometry.dispConvexX2=X(3);
        geometry.dispConvexY2=X(4);
        geometry.dispConvexW2=X(5);
        geometry.dispConcaveX1=X(6);
        geometry.dispConcaveY1=X(7);
        geometry.dispConcaveW1=0.87;
        geometry.dispConcaveX2=X(8);
        geometry.dispConcaveY2=X(9);
        geometry.dispConcaveW2=X(10);

end

% geometry.dispConvexX1=-3;
% geometry.dispConvexY1=2;
% geometry.dispConvexW1=0.85;
% geometry.dispConvexX2=-5;
% geometry.dispConvexY2=3;
% geometry.dispConvexW2=1;
% geometry.dispConcaveX1=2;
% geometry.dispConcaveY1=2.5;
% geometry.dispConcaveW1=0.87;
% geometry.dispConcaveX2=2;
% geometry.dispConcaveY2=5.5;
% geometry.dispConcaveW2=2.5;

% Solve partial model in GeoPDEs

[u, space, geometryGeoPDEs, gnum]=solve(15,15,0, current, 1, geometry);


%% Calculation of he Average B-Field Gradient

% Determination of the B-Field
%[fieldValuesGeoPDEsExact, x, y]=sp_eval_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -0.5], [0 3.0], [20 20], 'gradient');


averageGradientGeoPDEsExact=sp_int_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], 'hessian')./1.5;


%% Calculation of the Homogeneity


fieldHomogeneityGeoPDEsExact=calculateFieldHomogeneityExact(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], averageGradientGeoPDEsExact);


%% Setup of the Goal Function
f = goalFunction(averageGradientGeoPDEsExact,fieldHomogeneityGeoPDEsExact);

end