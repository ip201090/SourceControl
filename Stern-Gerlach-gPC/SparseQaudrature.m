%% UNCERTAINTY QUANTIFICATION OF THE STERN-GERLACH MAGNET
tic;
%% Initilization of UQLab
% clear variables;
% clc;
% close all;
uqlab

%% Setup of the UQ with gPC

% Creation of a Model
MOpts.mFile = 'SternGerlach' ;
MOpts.isVectorized = false;
myModel = uq_createModel(MOpts);

% Input Creation 
IOpts.Marginals(1).Name = 'x1';
IOpts.Marginals(1).Type = 'Uniform';
IOpts.Marginals(1).Parameters = [-3, -2];

IOpts.Marginals(2).Name = 'y1';
IOpts.Marginals(2).Type = 'Uniform';
IOpts.Marginals(2).Parameters = [1.66, 2];

IOpts.Marginals(3).Name = 'x2';
IOpts.Marginals(3).Type = 'Uniform';
IOpts.Marginals(3).Parameters = [-5, -2];

IOpts.Marginals(4).Name = 'y2';
IOpts.Marginals(4).Type = 'Uniform';
IOpts.Marginals(4).Parameters = [2.5, 4.5];

IOpts.Marginals(5).Name = 'w2';
IOpts.Marginals(5).Type = 'Uniform';
IOpts.Marginals(5).Parameters = [0.35, 2.85];

IOpts.Marginals(6).Name = 'x3';
IOpts.Marginals(6).Type = 'Uniform';
IOpts.Marginals(6).Parameters = [1.5, 2.5];

IOpts.Marginals(7).Name = 'y3';
IOpts.Marginals(7).Type = 'Uniform';
IOpts.Marginals(7).Parameters = [1.89, 2.5];

IOpts.Marginals(8).Name = 'x4';
IOpts.Marginals(8).Type = 'Uniform';
IOpts.Marginals(8).Parameters = [-2, 2];

IOpts.Marginals(9).Name = 'y4';
IOpts.Marginals(9).Type = 'Uniform';
IOpts.Marginals(9).Parameters = [4, 5];

IOpts.Marginals(10).Name = 'w4';
IOpts.Marginals(10).Type = 'Uniform';
IOpts.Marginals(10).Parameters = [0.37, 2.87];

myInput = uq_createInput(IOpts);

% Setup of the PCE
MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Definition of the polynomials regarding their distribution
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre','Legendre'...
    'Legendre','Legendre','Legendre','Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the Model
MetaOpts.FullModel = myModel;

%% Quadrature Evaluation 

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Smolyak';

numbSamplesQuad = zeros(1,3);
mean_quad = zeros(1,3);
sd_quad = zeros(1,3);
degree = zeros(1,3);
error_quad = zeros(1,3);

%Sweeping over the Polynomial Degree as this is the decisive variable for
%this method
for j = 1:3
    MetaOpts.Degree = j;
    PCE_Quadrature = uq_createModel(MetaOpts);
    numbSamplesQuad(j) = PCE_Quadrature.ExpDesign.NSamples;
    mean_quad(j) = PCE_Quadrature.PCE.Moments.Mean;
    sd_quad(j) = sqrt(PCE_Quadrature.PCE.Moments.Var);
    
    if PCE_Quadrature.Error.normEmpError < 1e-20
        error_quad(j) = 0;
    else
        error_quad(j) = PCE_Quadrature.Error.normEmpError;
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
PCESobolAnalysisQuadrature = uq_createAnalysis(PCESobol);
toc;
%% Representation of the Results
%  Printout a report of the results:
uq_print(PCESobolAnalysisQuadrature);

% Create a graphical representation of the results
uq_display(PCESobolAnalysisQuadrature);