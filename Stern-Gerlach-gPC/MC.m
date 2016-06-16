%% Monte-Carlo Simulation of the Stern-Gerlach Magnet
tic;
% Current Excitation
turns=65;
current=40;

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

% Amount of Samples
Nsamples = 1000000;
f = zeros(Nsamples,1);

% MC Evaluation
for j=1:Nsamples
    geometry.dispConvexX1= -3 + (-2-(-3))*rand(1);
    geometry.dispConvexY1= 1.66 + (2-1.66)*rand(1);
    geometry.dispConvexW1= 0.85;
    geometry.dispConvexX2= -5 + (-2-(-5))*rand(1);
    geometry.dispConvexY2= 2.5 + (4.5-2.5)*rand(1);
    geometry.dispConvexW2= 0.35 + (2.85-0.35)*rand(1);
    geometry.dispConcaveX1= 1.5 + (2.5-1.5)*rand(1);
    geometry.dispConcaveY1= 1.89 + (2.5-1.89)*rand(1);
    geometry.dispConcaveW1=0.87;
    geometry.dispConcaveX2= -2 + (2-(-2))*rand(1);
    geometry.dispConcaveY2= 4.5 + (5.5-4.5)*rand(1);
    geometry.dispConcaveW2= 0.37 + (2.87-0.37)*rand(1);
    
    file_data_id = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Stern-Gerlach-gPC\uncertainties.txt';
    fid = fopen(file_data_id,'a+');
    fprintf(fid,'%10f', geometry.dispConvexX1);
    fprintf(fid,'%10f', geometry.dispConvexY1);
    fprintf(fid,'%10f', geometry.dispConvexX2);
    fprintf(fid,'%10f', geometry.dispConvexY2);
    fprintf(fid,'%10f', geometry.dispConvexW2);
    fprintf(fid,'%10f', geometry.dispConcaveX1);
    fprintf(fid,'%10f', geometry.dispConcaveY1);
    fprintf(fid,'%10f', geometry.dispConcaveX2);
    fprintf(fid,'%10f', geometry.dispConcaveY2);
    fprintf(fid,'%10f\n', geometry.dispConcaveW2);
    fclose(fid);
    
    % Solve partial model in GeoPDEs
    [u, space, geometryGeoPDEs, gnum]=solve(15,15,0, current, 1, geometry);
    
    %% Calculation of he Average B-Field Gradient
    
    % Determination of the B-Field
    %[fieldValuesGeoPDEsExact, x, y]=sp_eval_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -0.5], [0 3.0], [20 20], 'gradient');
    
    averageGradientGeoPDEsExact=sp_int_phys_2d(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], 'hessian')./1.5;
    
    %% Calculation of the Homogeneity
    
    fieldHomogeneityGeoPDEsExact=calculateFieldHomogeneityExact(u(gnum{2}), space{2}, geometryGeoPDEs(2), [-1.5 -1], [0 3], averageGradientGeoPDEsExact);
    
    %% Setup of the Goal Function
    f(j) = goalFunction(averageGradientGeoPDEsExact,fieldHomogeneityGeoPDEsExact);
    file_results_id = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Stern-Gerlach-gPC\results.txt';
    fid_results = fopen(file_results_id,'a+');
    fprintf(fid_results,'%10f\n',f(j));
    fclose(fid_results);
end
toc;