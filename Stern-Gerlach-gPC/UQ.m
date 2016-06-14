 %% Workflow Script for the Analysis of the Stern-Gerlach Magnet Using gPC
 
%     - Use solve.m to obtain geometry parameter (and others) that are
%     needed for the next function
%     - readBFieldValuesGeoPDEs / readBFieldGradientXGeoPDEs
%     - calculateGradient/calculateGradientHOrder
%     - calculateAverageMagneticFieldGradient
%     - calculateFieldHomogeneity/calculateFieldHomogeneityExact
%     - Setup function (maybe you will have to code the function yourself
%     - Setup gPC with UQLab


%% Setup of the Parameters

% Current Excitation 
turns=65;
current=40;

% Mesh
meshSize=0.8;
stepSizeFieldValues=meshSize;
%folderName='.\\FEMMFilesSmall';
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
geometry.dispConvexX1=0;
geometry.dispConvexY1=0;
geometry.dispConvexW1=0;
geometry.dispConvexX2=0;
geometry.dispConvexY2=0;
geometry.dispConvexW2=0;
geometry.dispConcaveX1=0;
geometry.dispConcaveY1=0;
geometry.dispConcaveW1=0;
geometry.dispConcaveX2=0;
geometry.dispConcaveY2=0;
geometry.dispConcaveW2=0;

% Solve partial model in GeoPDEs
tic;
[u, space, geometryGeoPDEs, gnum]=solve(15,15,0, current, 1, geometry);
toc;

%% Determination of the B-Filed

%fieldValues=readBFieldValuesGeoPDEs(u, space, geometryGeoPDEs, gnum, [150 150], 2);

%% Determination of the B-Field's Gradient

[fieldValuesGeoPDEsExact, x, y]=sp_eval_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -0.5], [0 3.0], [20 20], 'gradient');

%% Calculation of he Average B-Field Gradient

tic;
averageGradientGeoPDEsExact=sp_int_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], 'hessian')./1.5;
toc;

%% Calculation of the Homogeneity

tic;
fieldHomogeneityGeoPDEsExact=calculateFieldHomogeneityExact(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], averageGradientGeoPDEsExact)
toc;

%% Setup of the Goal Function

%% Setup of the UQ with gPC