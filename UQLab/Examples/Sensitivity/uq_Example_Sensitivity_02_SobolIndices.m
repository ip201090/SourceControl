%% SENSITIVITY ANALYSIS: COMPARISON OF SAMPLING- VS. PCE-BASED SOBOL' INDICES
% In this example, Sobol' sensitivity indices for the Borehole function
% (as described in http://www.sfu.ca/~ssurjano/borehole.html) will be
% calculated with standard sampling, as well as with Polynomial Chaos
% Expansion (PCE).

%% 1 - STARTUP OF THE FRAMEWORK
%  Clear variables from the workspace and reinitialize the UQLab framework
clearvars;
uqlab;
rng(100) % fix the random seed for repeatable results

%% 2 - COMPUTATIONAL MODEL
% The computational model is an analytical formula that is used to model
% the water flow through a borehole
% (http://www.sfu.ca/~ssurjano/borehole.html). 
% It is an 8-dimensional model.
%
% Create a model from the uq_borehole.m file
MOpts.mFile = 'uq_borehole';
myModel = uq_createModel(MOpts);

%% 3 - PROBABILISTIC INPUT MODEL
%  Create the 8-dimensional stochastic input model.
%  (Type "help uq_borehole" for a detailed explanation of the meaning of each variable)

IOpts.Marginals(1).Name = 'rw'; % Radius of the borehole (m)
IOpts.Marginals(1).Type = 'Gaussian';
IOpts.Marginals(1).Parameters = [0.10, 0.0161812];

IOpts.Marginals(2).Name = 'r';  % Radius of influence (m)
IOpts.Marginals(2).Type = 'Lognormal';
IOpts.Marginals(2).Parameters = [7.71, 1.0056];

IOpts.Marginals(3).Name = 'Tu'; % Transmissivity of the upper aquifer (m^2/yr)
IOpts.Marginals(3).Type = 'Uniform';
IOpts.Marginals(3).Parameters = [63070, 115600];

IOpts.Marginals(4).Name = 'Hu'; % Potentiometric head of the upper aquifer (m)

IOpts.Marginals(4).Type = 'Uniform';
IOpts.Marginals(4).Parameters = [990, 1110];

IOpts.Marginals(5).Name = 'Tl'; % Transmissivity of the lower aquifer (m^2/yr)
IOpts.Marginals(5).Type = 'Uniform';
IOpts.Marginals(5).Parameters = [63.1, 116];

IOpts.Marginals(6).Name = 'Hl'; % Potentiometric head of the lower aquifer (m)
IOpts.Marginals(6).Type = 'Uniform';
IOpts.Marginals(6).Parameters = [700, 820];

IOpts.Marginals(7).Name = 'L';  % Length of the borehole (m)
IOpts.Marginals(7).Type = 'Uniform';
IOpts.Marginals(7).Parameters = [1120, 1680];

IOpts.Marginals(8).Name = 'Kw'; % Hydraulic conductivity of the borehole (m/yr)
IOpts.Marginals(8).Type = 'Uniform';
IOpts.Marginals(8).Parameters = [9855, 12045];

%%
% Create and store the input object in UQLab
myInput = uq_createInput(IOpts);


%% 4 - SENSITIVITY ANALYSIS
% Sobol' indices will be calculated first with direct Monte-Carlo (MC)
% sampling of the model and subsequently through post-processing of the
% coefficients of its PCE approximation.


%% 4.1 - MC-based Sobol' indices
% Select the sensitivity tool in UQLab and specify Sobol analysis
SobolOpts.Type = 'uq_sensitivity';
SobolOpts.Method = 'Sobol';
%%
% Specify the maximum order of the Sobol' indices to be calculated
SobolOpts.Sobol.Order = 1;
%%
% Specify the Sample size of each variable. Note that the total cost will
% equal (M+2)*SampleSize.
SobolOpts.Sobol.SampleSize = 1e5;
%%
% Create and store the sensitivity analysis in UQLab
MCSobolAnalysis = uq_createAnalysis(SobolOpts);
%%
% Retrieve the analysis results for comparison
MCSobolResults = MCSobolAnalysis.Results;

%% 4.2 - Create a PCE of the full model
% select the metamodel tool in UQLab
PCEOpts.Type = 'uq_metamodel';
% choose the polynomial chaos expansions module
PCEOpts.MetaType = 'PCE';
% Specify the model that will be sampled to create the experimental design
% for PCE
PCEOpts.FullModel = myModel;
% Specify the maximum polynomial degree (default: sparse PCE expansion)
PCEOpts.Degree = 5;
%  Specify the size of the experimental design (total cost of the metamodel)
PCEOpts.ExpDesign.NSamples = 200;
%  Calculate and store the PCE in UQLab
myPCE = uq_createModel(PCEOpts);

%% 4.3 - Repeat the sensitivity analysis on the new model
% Note that the model does not need to be specified: the last created model
% will be used in the analysis. The sensitivity module recognizes
% PCE models and calculates the Sobol indices accordingly by
% post-processing its coefficients without sampling.
%
% The same options structure SobolOpts can be re-used to create a new
% analysis
PCESobolAnalysis = uq_createAnalysis(SobolOpts);
% Retrieve the results for comparison with the previous MC-based calculation
PCESobolResults = PCESobolAnalysis.Results;

%% 5 - COMPARISON OF THE RESULTS
%  Printout a report of the MC-based and PCE-based results:
uq_print(MCSobolAnalysis);
uq_print(PCESobolAnalysis);

%% 
%  Comparison plot between the indices: Total Sobol' indices
% Create a nice colormap
CMap = [0.9804    0.4863    0.0275; 0.1804    0.2471    0.9804];
uq_figure('filename','MC-PCE_TotalSobolComparison.fig', 'Position', [50 50 500 400])
uq_bar((1:8) -.25,MCSobolResults.Total, 0.5, 'facecolor', CMap(1,:),'edgecolor', 'none')
hold on
uq_bar(1.25:1:8.25,PCESobolResults.Total, 0.5,'edgecolor', 'none')
ylabel('Total Sobol'' indices')
ylim([0 1])
xlim([0 9])
set(gca, 'xtick', 1:length(IOpts.Marginals), 'xticklabel', PCESobolResults.VariableNames, 'fontsize',14);
xlabel('Variable name', 'fontsize', 14)
uq_legend({'MC-based (10^6 simulations)', ...
    sprintf('PCE-based (%d simulations)', myPCE.ExpDesign.NSamples)}, 'location', 'northeast', 'fontsize',14);
%% 
%  Comparison plot between the indices: First Order Sobol' indices
uq_figure('filename','MC-PCE_TotalSobolComparison.fig', 'Position', [50 50 500 400])
uq_bar((1:8) -.25,MCSobolResults.FirstOrder, 0.5, 'facecolor', CMap(1,:),'edgecolor', 'none')
hold on
uq_bar(1.25:1:8.25,PCESobolResults.FirstOrder, 0.5,'edgecolor', 'none')
ylabel('Total Sobol'' indices')
ylim([0 1])
xlim([0 9])
set(gca, 'xtick', 1:length(IOpts.Marginals), 'xticklabel', PCESobolResults.VariableNames, 'fontsize',14);
xlabel('Variable name', 'fontsize', 14)
uq_legend({'MC-based (10^6 simulations)', ...
    sprintf('PCE-based (%d simulations)', myPCE.ExpDesign.NSamples)}, 'location', 'northeast', 'fontsize',14);