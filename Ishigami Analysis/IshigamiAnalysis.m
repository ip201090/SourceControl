%% Evaluation of the Ishigami Function using 3 uniformly distributed inputs

%% Deleting everything before running the code
clear variables;
clc;
close all;
%% Initializing UQLab
uqlab
clearvars

%% Creation of a Model
MOpts.mFile = 'uq_ishigami' ;
myModel = uq_createModel(MOpts);

%% Creating an Input
for i = 1:3
    IOpts.Marginals(i).Type = 'Uniform' ;
    IOpts.Marginals(i).Parameters = [-pi, pi] ;
end

myInput = uq_createInput(IOpts);

%% MC Analysis

range = 1:10000;
temp = length(range);
y_mean = zeros(1,temp);
y_std = zeros(1,temp);
errorMC = zeros(1,temp);

for k=1:10000
    X = uq_getSample(k,'MC',myInput);
    Y = uq_evalModel(X,myModel);
    y_mean(k) = mean(Y);
    y_std(k) = std(Y);
    errorMC(k) = y_std(k)/sqrt(k);
end
%% Setup of the PCE
MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% possible.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

%% Quadrature Calculation

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Full';

numbSamplesQuad = zeros(1,15);
mean_quad = zeros(1,15);
sd_quad = zeros(1,15);
degree = zeros(1,15);
error_quad = zeros(1,15);
%Sweeping over the Polynomial Degree as this is the decisive variable for
%this method
for k = 1:15
    MetaOpts.Degree = k;
    PCE_Quadrature = uq_createModel(MetaOpts);
    numbSamplesQuad(k) = PCE_Quadrature.ExpDesign.NSamples;
    mean_quad(k) = PCE_Quadrature.PCE.Moments.Mean;
    sd_quad(k) = sqrt(PCE_Quadrature.PCE.Moments.Var);
    
   % if PCE_Quadrature.Error.normEmpError < 1e-20
    %    error_quad(k) = 0;
    %else
        error_quad(k) = PCE_Quadrature.Error.normEmpError;
    %end
    degree(k) = k;
end

%% Resetup of the PCE

% This resetup is maybe needed in order to prevent some overriding or
% corrupt data ... 

clear MetaOpts;

MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% possible.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;


%% Least-Square Calculation

%Calculation of a OLS regression model by sweeping the polynomial degree
MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.Sampling = 'MC';

mean_ols = zeros(1,15);
sd_ols = zeros(1,15);
degreeOLS = zeros(1,15);
error_ols = zeros(1,15);
numbOLSSamp = zeros(1,15);

% Sweeping over the polynomial degree
for n=1:15
    MetaOpts.Degree = n;
    % Expressing the amount of samples in dependece on the polynomial
    % degree...the higher the polynomial degree, the more samples you need,
    % but unforutunately this relation is not linear
    numbOLSSamp (n) = 3*nchoosek(MetaOpts.Degree+3,MetaOpts.Degree);
    MetaOpts.ExpDesign.NSamples = numbOLSSamp(n);
    PCE_OLS = uq_createModel(MetaOpts);
    mean_ols(n) = PCE_OLS.PCE.Moments.Mean;
    sd_ols(n) = sqrt(PCE_OLS.PCE.Moments.Var);
    
    if PCE_OLS.Error.LOO < 1e-20
        error_ols(n) = 0;
    else
         error_ols(n) = PCE_OLS.Error.normEmpError;
    end
    degreeOLS(n) = n;
end
%% Resetup of the PCE

% This resetup is maybe needed in order to prevent some overriding or
% corrupt data ... 

clear MetaOpts;

MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% possible.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;


%% Sparse Quadrature Calculation

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Smolyak';

numbSamplesQuadSparse = zeros(1,15);
mean_quad_sparse = zeros(1,15);
sd_quad_sparse = zeros(1,15);
degreeSparse = zeros(1,15);
error_quad_sparse = zeros(1,15);

for k = 1:15
    MetaOpts.Degree = k;
    PCE_QuadratureSparse = uq_createModel(MetaOpts);
    numbSamplesQuadSparse(k) = PCE_QuadratureSparse.ExpDesign.NSamples;
    mean_quad_sparse(k) = PCE_QuadratureSparse.PCE.Moments.Mean;
    sd_quad_sparse(k) = sqrt(PCE_QuadratureSparse.PCE.Moments.Var);
    
    %if PCE_QuadratureSparse.Error.normEmpError < 1e-20
    %    error_quad_sparse(k) = 0;
    % else
        error_quad_sparse(k) = PCE_QuadratureSparse.Error.normEmpError;
    % end
    degreeSparse(k) = k;
end

%% Resetup of the PCE

% This resetup is maybe needed in order to prevent some overriding or
% corrupt data ... 

clear MetaOpts;

MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% possible.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;


%% LARS Calcultion

MetaOpts.Method = 'LARS';
MetaOpts.ExpDesign.Sampling = 'MC';

numbSamplesLARS = zeros(1,15);
mean_lars = zeros(1,15);
sd_lars = zeros(1,15);
degreeLARS = zeros(1,15);
error_lars = zeros(1,15);

for k =1:15
   MetaOpts.Degree = k;
   numbSamplesLARS(k) = ceil(0.505*nchoosek(MetaOpts.Degree+3,MetaOpts.Degree));
   MetaOpts.ExpDesign.NSamples = numbSamplesLARS(k);
   PCE_LARS = uq_createModel(MetaOpts);
   mean_lars(k) = PCE_LARS.PCE.Moments.Mean;
   sd_lars(k) = sqrt(PCE_LARS.PCE.Moments.Var);
   error_lars(k) = PCE_LARS.Error.normEmpError;
   degreeLARS(k) = k;
   
end

%% Histogram Plots for the Respective Methods

% Histogram plots for the outputs respectively. Depending on the MATLAB
% version that is used, the command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(Y);
    title('MC');
    drawnow
    
    figure;
    hist(PCE_Quadrature.ExpDesign.Y);
    title('Quadrature');
    drawnow
    
    figure;
    hist(PCE_OLS.ExpDesign.Y);
    title('LSR');
    drawnow
    
    figure;
    hist(PCE_QuadratureSparse.ExpDesign.Y);
    title('Sparse Quadrature Method');
    drawnow
    
    figure;
    hist(PCE_LARS.ExpDesign.Y);
    title('LARS');
    drawnow
    
% Matlab release 2016
elseif ver(1) == '9'
    
    figure; 
    histogram(Y,'FaceColor','b');
    drawnow
    
    figure;
     histogram(PCE_Quadrature.ExpDesign.Y,'FaceColor','r');
    drawnow
    
    figure;
    histogram(PCE_OLS.ExpDesign.Y,'FaceColor','g');
    drawnow
    
    figure;
    histogram(PCE_QuadratureSparse.ExpDesign.Y,'FaceColor','m');
    title('Sparse Quadrature Method');
    drawnow
    
    figure;
    histogram(PCE_LARS.ExpDesign.Y,'FaceColor','c');
    title('LARS');
    drawnow
    
end
%% Mean Plot for the Respective Methods

plotRange = 1:666.66:10000;
meanPlot = zeros(1,15);

meanPlot(1) = y_mean(54);
meanPlot(2) = y_mean(114);
meanPlot(3) = y_mean(187);
meanPlot(4) = y_mean(282);
meanPlot(5) = y_mean(413);
meanPlot(6) = y_mean(596);
meanPlot(7) = y_mean(855);
meanPlot(8) = y_mean(1218);
meanPlot(9) = y_mean(1720);
meanPlot(10) = y_mean(2401);
meanPlot(11) = y_mean(2235);
meanPlot(12) = y_mean(4539);
meanPlot(13) = y_mean(6117);
meanPlot(14) = y_mean(8140);
meanPlot(15) = y_mean(10000);

% Mean plot in dependency on the sample number
figure;
uq_plot(plotRange,meanPlot,'b',...
    numbSamplesQuad,mean_quad,'-ro',...
    numbOLSSamp,mean_ols,'-gd',...
    numbSamplesQuadSparse,mean_quad_sparse,'m',...
    numbSamplesLARS,mean_lars,'c');
xlim([0 2000]);
xlabel('Amount of Samples'),ylabel('Mean');
title('Mean Convergence in Dependence on the Sample Number');

% Mean plot in dependency on the polynomial degree
figure;
uq_plot(degree,mean_quad,'-ro',...
    degreeOLS,mean_ols,'-gd',...
    degreeSparse,mean_quad_sparse,'-mx',degreeLARS,mean_lars,'-c*');
xlabel('Polynomial Degree'),ylabel('Mean');
title('Mean Convergence in Dependence on the Polynomial Degree');
%% SD Plot for the Respective Methods
sdPlot = zeros(1,15);

sdPlot(1) = y_std(54);
sdPlot(2) = y_std(114);
sdPlot(3) = y_std(187);
sdPlot(4) = y_std(282);
sdPlot(5) = y_std(413);
sdPlot(6) = y_std(596);
sdPlot(7) = y_std(855);
sdPlot(8) = y_std(1218);
sdPlot(9) = y_std(1720);
sdPlot(10) = y_std(2401);
sdPlot(11) = y_std(2235);
sdPlot(12) = y_std(4539);
sdPlot(13) = y_std(6117);
sdPlot(14) = y_std(8140);
sdPlot(15) = y_std(10000);

% SD plot in dependency on the sample number
figure;
uq_plot(plotRange,sdPlot,'b',numbSamplesQuad,sd_quad,'-ro',...
    numbOLSSamp,sd_ols,'-gd',numbSamplesQuadSparse,sd_quad_sparse,'-mx',...
    numbSamplesLARS,sd_lars,'-c*');
xlim([0 2000]);
xlabel('Amount of Samples'),ylabel('SD');
title('SD Convergence in Dependence on the Sample Number');

% SD plot in dependency on the polynomial degree
figure;
uq_plot(degree,sd_quad,'-ro',...
    degreeOLS,sd_ols,'-gd', ...
    degreeSparse,sd_quad_sparse,'-mx',degreeLARS,sd_lars,'-c*');
xlabel('Polynomial Degree'),ylabel('SD');
title('SD Convergence in Dependence on the Polynomial Degree');
%% Error Plot for the Respective Methods

errorPlot = zeros(1,15);

errorPlot(1) = errorMC(54);
errorPlot(2) = errorMC(114);
errorPlot(3) = errorMC(187);
errorPlot(4) = errorMC(282);
errorPlot(5) = errorMC(413);
errorPlot(6) = errorMC(596);
errorPlot(7) = errorMC(855);
errorPlot(8) = errorMC(1218);
errorPlot(9) = errorMC(1720);
errorPlot(10) = errorMC(2401);
errorPlot(11) = errorMC(2235);
errorPlot(12) = errorMC(4539);
errorPlot(13) = errorMC(6117);
errorPlot(14) = errorMC(8140);
errorPlot(15) = errorMC(10000);

% Error plot in dependency on the sample number
figure;
uq_plot(plotRange,errorPlot,'b',numbSamplesQuad,error_quad,'-ro',...
    numbOLSSamp,error_ols,'-gd',...
    numbSamplesQuadSparse,error_quad_sparse,'-mx',...
    numbSamplesLARS,error_lars,'-c*');
xlim([0 10000]);
xlabel('Amount of Samples');ylabel('Error');
title('Error in Dependence on the Sample Number');
drawnow

ha2 = gca;
set(ha2,'yscale','log');

% Error plot in dependency on the polynomial degree
figure;
uq_plot(degree,error_quad,'-ro',degreeOLS,error_ols,'-gd',...
    degreeSparse,error_quad_sparse,'-mx',degreeLARS,error_lars,'-c*');
xlabel('Polynomial Degree');ylabel('Error');
title('Error in Dependence on the Polynomial Degree');

ha3 = gca;
set(ha3,'yscale','log');
