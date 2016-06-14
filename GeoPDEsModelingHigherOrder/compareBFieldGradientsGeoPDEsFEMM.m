% Copyright (c) 2015 Andreas Pels

% Compare the B-field gradients and other quantities for the original model
% between GeoPDEs and FEMM.

clear all;
close all;
%clc;

global HandleToFEMM;

rng shuffle;

turns=65;
current=40;
meshSize=0.8;
stepSizeFieldValues=meshSize;
folderName='.\\FEMMFilesSmall';
lengthFromOuterLimit=100;

% Calculate values for original model
createRabiTypeSternGerlachFEMM('strong', turns, current, meshSize, folderName, 'AccuracyVectorPotential_simulation0', lengthFromOuterLimit);
% addpath C:\femm42\mfiles\
% openfemm();
%opendocument('FEMMFindOptimalMeshSize\simulation5.fem')

%mi_analyze();
mi_loadsolution();

% Points for strong type magnet
strongRabi.rConvex=4;
strongRabi.rConcave=5;
strongRabi.centerConvex=[-6, 0.00];
strongRabi.centerConcave=[-3, 0];

strongRabi.point4=[-17, 20];
strongRabi.point3=[17, 20];
strongRabi.point2=[-2.38, 6.96];
strongRabi.point5=[-6, 4];
strongRabi.point1=[-2.38, 4.96];
strongRabi.poleTipPeak=[strongRabi.centerConvex(1)+strongRabi.rConvex, 0.00];
strongRabi.point6=[strongRabi.point4(1)-10, strongRabi.point4(2)];
strongRabi.point7=[strongRabi.point3(1)+10, strongRabi.point3(2)];

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

% B-fields
% Read and plot B-field values from FEMM and GeoPDEs in the complete middle patch (old method, not high accuracy)
B_color_vector = [0 1.2];

fieldValues=readBFieldValuesGeoPDEs(u, space, geometryGeoPDEs, gnum, [150 150], 2);
figure;
surf(fieldValues.X, fieldValues.Y, fieldValues.BAbs, 'EdgeColor', 'none','FaceColor','interp');
xlabel('X');
ylabel('Y');
title('B-field GeoPDEs')
caxis(B_color_vector);
view(2);

fieldValuesFEMM=readBFieldValuesFEMM(fieldValues);
figure;
surf(fieldValuesFEMM.X, fieldValuesFEMM.Y, fieldValuesFEMM.BAbs, 'EdgeColor', 'none','FaceColor','interp');
xlabel('X');
ylabel('Y');
title('B-field FEMM')
caxis(B_color_vector);
view(2);

figure;
surf(fieldValuesFEMM.X, fieldValuesFEMM.Y, abs((fieldValuesFEMM.BAbs-fieldValues.BAbs)./fieldValuesFEMM.BAbs)*100, 'EdgeColor', 'none','FaceColor','interp');
xlabel('X');
ylabel('Y');
title('Relative error of B-field values between FEMM and GeoPDEs in %')
caxis([0 2]);
view(2);



%%
viewAngle=[80,18];

% Set coordinates to read field values
HOrderGrad=1;
rangeX=[-1.5./1000 -1./1000];
rangeY=[0./1000 3.0./1000];
npnts=[20, 20];

if HOrderGrad==1
    % Optional argument given and is one
    % Calculate step width
    widthX=(rangeX(2)-rangeX(1))./(npnts(1)-1);
    widthY=(rangeY(2)-rangeY(1))./(npnts(2)-1);
    
    % Calculate new ranges and create according vectors
    rangeXNew=[rangeX(1)-2*widthX, rangeX(2)+2*widthX];
    rangeYNew=[rangeY(1)-2*widthY, rangeY(2)+2*widthY];
    xi=linspace(rangeXNew(1), rangeXNew(2), npnts(1)+4);
    yi=linspace(rangeYNew(1), rangeYNew(2), npnts(2)+4);
else
    % No optional argument given
    xi=linspace(rangeX(1), rangeX(2), npnts(1));
    yi=linspace(rangeY(1), rangeY(2), npnts(2));
    
end

[XI,YI]=meshgrid(xi, yi);

fieldValuesInt.X=XI;
fieldValuesInt.Y=YI;
fieldValuesInt.stepWidthX=xi(2)-xi(1);
fieldValuesInt.stepWidthY=yi(2)-yi(1);

% Read and plot B-Field values from FEMM and GeoPDEs in the beam area ("exact", error tolerance 10^-7)
[fieldValuesGeoPDEsExact, x, y]=sp_eval_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -0.5], [0 3.0], [20 20], 'gradient');
figure;
surf(x, y, fieldValuesGeoPDEsExact);
%surf(fieldValuesInt.X, fieldValuesInt.Y, fieldValuesInt.BAbs);
title('GeoPDEs Exact');
xlabel('x[m]');
ylabel('y[m]');
zlabel('B-Field[T]');
colorbar;
view(viewAngle);
setFormatQuadratic();
savePlot('GeoPDEsBField');

% Read and plot FEMM results
fieldValuesFEMM=readBFieldValuesFEMM(fieldValuesInt);
figure;
surf(fieldValuesFEMM.X, fieldValuesFEMM.Y, fieldValuesFEMM.BAbs);
title('FEMM');
xlabel('x[m]');
ylabel('y[m]');
zlabel('B-Field[T]');
colorbar;
view(viewAngle);
setFormatQuadratic();
savePlot('FEMMBField');


%% Gradients
% Calculate gradients using higher order (not exact)
fieldValuesGradFEMM=calculateGradientHOrder(fieldValuesFEMM);
figure;
surf(fieldValuesGradFEMM.X, fieldValuesGradFEMM.Y, fieldValuesGradFEMM.BGradX);
title('FEMM');
xlabel('x[m]');
ylabel('y[m]');
zlabel('B-Field gradient (x-direction)[T/m]');
colorbar;
view(viewAngle);
setFormatQuadratic();
savePlot('FEMMBFieldGradient');

% Old method
% figure;
% fieldValuesGradGeoPDEs=calculateGradientHOrder(fieldValuesInt);
% surf(fieldValuesGradGeoPDEs.X, fieldValuesGradGeoPDEs.Y, fieldValuesGradGeoPDEs.BGradX);
% title('GeoPDEs');
% xlabel('x[m]');
% ylabel('y[m]');
% zlabel('B-Field gradient x-direction[T/m]');
% colorbar;
% view(viewAngle);
% setFormatQuadratic();
% savePlot('GeoPDEsBFieldGradient');

% Extract "exact" (error tolerance 10^-7) gradient from GeoPDEs (new method)
tic;
figure;
[fieldValuesGradGeoPDEsExact, x, y]=sp_eval_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], [10 10],'hessian');
surf(x,y, fieldValuesGradGeoPDEsExact);
title('GeoPDEs Exact');
xlabel('x[m]');
ylabel('y[m]');
zlabel('B-Field gradient x-direction[T/m]');
colorbar;
view(viewAngle);
setFormatQuadratic();
savePlot('GeoPDEsBFieldGradientExact');
toc;


% Calculate figures of merit: Average gradient, Homogeneity, relative error
% of these quantities betwenn FEMM and GeoPDEs
tic;
averageGradientGeoPDEsExact=sp_int_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], 'hessian')./1.5
toc;

tic;
fieldHomogeneityGeoPDEsExact=calculateFieldHomogeneityExact(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], averageGradientGeoPDEsExact)
toc;

averageGradientFEMM=calculateAverageMagneticFieldGradient(fieldValuesGradFEMM)
fieldHomogeneityFEMM=calculateFieldHomogeneity(fieldValuesGradFEMM, averageGradientFEMM)

relErrorGradient=(averageGradientGeoPDEsExact-averageGradientFEMM)./averageGradientFEMM
relErrorHomogeneity=(fieldHomogeneityGeoPDEsExact-fieldHomogeneityFEMM)./fieldHomogeneityFEMM


