%% Sensitivity Analysis Using Sobol Indices 

%% Initilization of UQLab
uqlab;

%% Setup of the UQ Model

% Model Creation
MOpts.mFile = 'SternGerlach';
MOpts.isVectorized = false;
myModel = uq_createModel(MOpts);

% Input Creation
Iopts.Marginals(1).Name = 'x1';
IOpts.Marginals(1).Type = 'Uniform';
IOpts.Marginals(1).Parameters = [-3, -2];

IOpts.Marginals(2).Name = 'y1';
IOpts.Marginals(2).Type = 'Uniform';
IOpts.Marginals(2).Parameters = [1.66, 2];

IOpts.Marginals(3).Name = 'x2';
IOpts.Marginals(3).Type = 'Uniform';
IOpts.Marginals(3).Parameters = [-5, -2];

IOpts.Marginals(3).Name = 'y2';
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

%% Sensitivty Analysis with Sobol Indices

% Selection of the Sensitivity Tool: Sobol Indices
SobolOpts.Type = 'uq_sensitivity';
SobolOpts.Method = 'Sobol';

% Maximum Order of the Sobol Indices
SobolOpts.Sobol.Order = 1;

% Specify the sample size of each variable. Note that the total cost will
% equal (M+2)*SampleSize for sampling-based Sobol' indices calculation.
SobolOpts.Sobol.SampleSize = 10;

% Create and add the sensitivity analysis to UQLab
SobolAnalysis = uq_createAnalysis(SobolOpts);

%% Representation of the Results
%  Printout a report of the results:
uq_print(SobolAnalysis);

% Create a graphical representation of the results
uq_display(SobolAnalysis);