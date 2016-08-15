%% UNCERTAINTY QUANTIFICATION OF THE STERN-GERLACH MAGNET
tic;
%% Initilization of UQLab
% clear variables;
% clc;
% close all;
uqlab
%% Setup of the UQ with gPC

% Creation of a Model
MOpts.mFile = 'SternGerlach';
MOpts.isVectorized = false;
myModel = uq_createModel(MOpts);

% Input Creation 

% Input Creation 
IOpts.Marginals(1).Name = 'x1';
IOpts.Marginals(1).Type = 'Uniform';
IOpts.Marginals(1).Parameters = [-3, -2];

IOpts.Marginals(2).Name = 'x4';
IOpts.Marginals(2).Type = 'Uniform';
IOpts.Marginals(2).Parameters = [-2, 2];

myInput = uq_createInput(IOpts);

% Setup of the PCE
MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Definition of the polynomials regarding their distribution
MetaOpts.PolyTypes = {'Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the Model
MetaOpts.FullModel = myModel;

%% Quadrature Evaluation 

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Full';

numbSamplesTotalQuad = zeros(1,3);
mean_total_quad = zeros(1,3);
sd_total_quad = zeros(1,3);
degree = zeros(1,3);
error_total_quad = zeros(1,3);

%Sweeping over the Polynomial Degree as this is the decisive variable for
%this method
for j = 1:3
    MetaOpts.Degree = j;
    PCE_Quadrature = uq_createModel(MetaOpts);
    numbSamplesTotalQuad(j) = PCE_Quadrature.ExpDesign.NSamples;
    mean_total_quad(j) = PCE_Quadrature.PCE.Moments.Mean;
    sd_total_quad(j) = sqrt(PCE_Quadrature.PCE.Moments.Var);
    
    if PCE_Quadrature.Error.normEmpError < 1e-20
        error_total_quad(j) = 0;
    else
        error_total_quad(j) = PCE_Quadrature.Error.normEmpError;
    end
    degree(j) = MetaOpts.Degree;
end

toc;

tic;
% Selection of the Sensitivity Tool: Sobol Indices
PCESobol.Type = 'uq_sensitivity';
PCESobol.Method = 'Sobol';

% Maximum Order of the Sobol Indices
PCESobol.Sobol.Order = 1;

% Specify the sample size of each variable. Note that the total cost will
% equal (M+2)*SampleSize for sampling-based Sobol' indices calculation.
%SobolOpts.Sobol.SampleSize = 10;

% Create and add the sensitivity analysis to UQLab
PCESobolAnalysisTotalQuadrature = uq_createAnalysis(PCESobol);
toc;
%% Representation of the Results
%  Printout a report of the results:
uq_print(PCESobolAnalysisTotalQuadrature);

% Create a graphical representation of the results
uq_display(PCESobolAnalysisTotalQuadrature);