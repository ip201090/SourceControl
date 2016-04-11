%% SENSITIVITY ANALYSIS: SOBOL' INDICES OF A HIGH DIMENSIONAL FUNCTION
% In this example, first and second order Sobol' sensitivity indices for a
% high dimensional (M = 100) non-linear analytical function are calculated
% by means of polynomial chaos expansion.
% 
% PLEASE NOTE: THIS EXAMPLE RUNS A VERY HIGH DIMENSIONAL ANALYSIS, IT CAN
% TAKE UP TO 2-3 MINUTES TO COMPLETE

%% 1 - STARTUP OF THE FRAMEWORK
% Clear variables from the workspace and reinitialize the UQLab framework
clearvars;
uqlab;

%% 2 - COMPUTATIONAL MODEL
% The high dimensional example presented is a non-linear arbitrary
% dimensional function (with input dimension M >= 55) defined as:
%
% $$ Y = 3 - \frac{5}{M} \sum_{k = 1}^{M} k x_k +
% \frac{1}{M}\sum_{k = 1}^{M} k x_k^3  + 
% \ln\left(\frac{1}{3M}\sum_{k = 1}^{M} k  (x_k^2 + x_k^4)\right) 
% + x_1 x_2^2  + x_2 x_4 - x_3 x_5 + x_{50} + x_{50}x_{54}^2 $$
% 
% When all the input variables are identically distributed, the sensitivity
% pattern of this function has an overall non-linearly increasing trend
% with the variable number. In addition, it presents distinct peaks for
% variables $x_1$ - $x_5$, $x_{50}$ and $x_{54}$. Finally, four 2-terms
% interaction peaks are expected: $x_1 x_2$, $x_2 x_4$, $x_3 x_5$ and
% $x_{50} x_{54}$. 
% By construction, the two interaction terms $x_1 x_2$ and $x_{50},x_{54}$
% are expected to have identical sensitivity indices. Likewise for the two
% terms $x_2 x_4$ and $x_{3} x_{5}$.
%% 
% This function is available in the
% Examples\SimpleTestFunctions\uq_many_inputs_model.m file
% 

%% 
% Create and add to UQLab a model based on this function
MOpts.mFile = 'uq_many_inputs_model';
myModel = uq_createModel(MOpts);

%% 3 - PROBABILISTIC INPUT MODEL
%  Create a stochastic input model with 100 input variables uniformly
%  distributed as follows: 
%
% $$ X_i \sim \mathcal{U}(1,2) \quad \forall i \neq 20,\quad X_{20} \sim \mathcal{U}(1,3) $$
%%
% Create the input marginals
M = 100;
for ii = 1:M
    % Marginal type of the iith variable:
    inputOpts.Marginals(ii).Type = 'Uniform';
    if ii == 20
        inputOpts.Marginals(ii).Parameters = [1 3];
    else
        inputOpts.Marginals(ii).Parameters = [1 2];
    end
end
%%
% Create the input model and add it to UQLab
myInput = uq_createInput(inputOpts);

%% 4 - SENSITIVITY ANALYSIS
% Due to the dimensionality of the model, Sobol' indices are directly
% calculated with polynomial chaos expansion

%% 4.1 - Create a PCE of the full model
% Select the metamodel tool in UQLab and the Polynomial Chaos Expansion
% module.
PCEOpts.Type = 'uq_metamodel';
PCEOpts.MetaType = 'PCE';
%%
% Specify the model to create an experimental design
PCEOpts.FullModel = myModel;
%%
% Specify degree-adaptive PCE (default: sparse PCE expansion)
PCEOpts.Degree = 1:4;
%%
% Specify the experimental design size (actual cost of the metamodel)
PCEOpts.ExpDesign.NSamples = 1200;
%%
% Specify Latin Hypercube Sampling to create the experimental design
PCEOpts.ExpDesign.Sampling = 'LHS';
%%
% Specify the truncation parameters: q = 0.7, maximum interaction = 2
PCEOpts.TruncOptions.qNorm = 0.7;
PCEOpts.TruncOptions.MaxInteraction = 2;
%%
% Display a warning: the example takes some time to execute (~1 minute)
fprintf('THIS WILL TAKE SOME TIME: %d-dimensional model!\n', M)

%% 
% Create and add the PCE metamodel to UQLab
myPCE = uq_createModel(PCEOpts);

%% 4.2 - Sensitivity analysis of the PCE metamodel
% The sensitivity module automatically calculates the sensitivity indices
% from the PCE coefficients if the current model is a PCE
%%
% Specify the sensitivity module and Sobol' indices
SobolOpts.Type = 'uq_sensitivity';
SobolOpts.Method = 'Sobol';
%%
% Set the maximum Sobol' index order to 2
SobolOpts.Sobol.Order = 2;
%%
% Create and add the sensitivity analysis to UQLab
PCESobolAnalysis = uq_createAnalysis(SobolOpts);


%% 5 - RESULTS VISUALIZATION
%  Graphically display the calculated Sobol' indices
uq_display(PCESobolAnalysis);
