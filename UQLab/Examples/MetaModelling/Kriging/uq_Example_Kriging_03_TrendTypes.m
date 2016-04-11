%% KRIGING METAMODELLING: TREND TYPES
% This example showcases how to perform Kriging for a 
% simple 1D function, using various trend types. 

%% 1 - CLEAR THE WORKSPACE AND INITIALIZE THE UQLAB FRAMEWORK 
clearvars
uqlab

rng(100) % Set the random seed

%% 2 - PROBABILISTIC INPUT MODEL
% To generate an experimental design for the Kriging surrogate a random
% sample from a 1D uniform distribution is generated:
%
% $X \in \mathcal{U}(0, 15)$

%%
% Specify the distribution of the input variable:
Input.Marginals.Type = 'Uniform' ;
Input.Marginals.Parameters = [0, 15] ;

%%
% Create and add an input object to UQLab:
myInput = uq_createInput(Input);

%% 3 - COMPUTATIONAL MODEL
% The computational model is a simple analytical function defined as:
%
% $$Y(X) = X \sin(X) $$

%%
% The model can be specified directly as a string in UQLab
modelopts.mString = 'X*sin(X)' ;
myModel = uq_createModel(modelopts);

%% 4 - GENERATION OF THE EXPERIMENTAL DESIGN AND MODEL RESPONSE
% The experimental design and the model responses are calculated 
% and are later used for creating the Kriging metamodel.
%
% Generate 10 samples using Sobol sequence sampling
X = uq_getSample(10, 'Sobol');
%%
% Evaluate the corresponding model responses
Y = uq_evalModel(X);

%% 5 - KRIGING METAMODELS
%% 5.1 - Ordinary Kriging
% Select the metamodelling tool and the Kriging module:
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'Kriging';
%%
% Use the previously generated experimental design
metaopts.ExpDesign.X = X;
metaopts.ExpDesign.Y = Y;

%%
% Perform ordinary kriging (constant trend)
metaopts.Trend.Type = 'ordinary' ;

%%
% The correlation family is set to Matern 3/2
metaopts.Corr.Family = 'matern-3_2';

%%
% Use cross-validation to estimate the hyperparameters
metaopts.EstimMethod = 'CV';

%%
% Use hybrid genetic algorithm-based optimization (final BFGS step)
metaopts.Optim.Method = 'HGA';

%% 
% Set the maximum number of generations, convergence tolerance and population size
metaopts.Optim.MaxIter = 100;
metaopts.Optim.Tol = 1e-6;
metaopts.Optim.HGA.nPop = 40;

%%
% Create the metamodel object and add it to UQLab
myKriging_Ordinary = uq_createModel(metaopts);

%% 5.2 - Polynomial Trend
% A second Kriging metamodel is produced using a 3rd degree
% polynomial as a trend (the other options remain as before)
metaopts.Trend.Type = 'polynomial';
metaopts.Trend.Degree = 3;

%%
% Create the metamodel object and add it to UQLab
myKriging_Linear = uq_createModel(metaopts);

%% 5.3 - Custom Trend
% A third Kriging metamodel is produced with a custom functional
% basis in the trend
metaopts.Trend.Type = 'custom';
metaopts.Trend.CustomF = @(X)  X.^2 + sqrt(abs(X)) ;

%%
% It is advised to remove fields from the options that are
% not relevant to the metamodel to be created. For example
% the .Trend.Degree option is not relevant here
metaopts.Trend.Degree = [];

%%
% Create the metamodel object and add it to UQLab
myKriging_Quadratic = uq_createModel(metaopts);


%% 6 - VALIDATION OF THE METAMODELS
%% 
% Create a validation sample of size 1000
X_val = linspace(0, 15, 1000)';
Y_val = uq_evalModel(X_val, myModel);

%%
% Evaluate the corresponding responses for each of the three generated
% Kriging metamodels. For each metamodel, the mean and the variance of the
% Kriging predictor are  calculated
[Ymu_ordinary, Yvar_ordinary] = uq_evalModel(X_val, myKriging_Ordinary);
[Ymu_polynomial, Yvar_polynomial] = uq_evalModel(X_val, myKriging_Linear);
[Ymu_custom, Yvar_custom] = uq_evalModel(X_val, myKriging_Quadratic);

%%
% Produce comparative plots of the Kriging predictors and the true
% model. Also compare the predictor variances

%%
% * Kriging predictor mean
uq_figure('Position', [50 50 500 400])
hold on
myColors = uq_cmap(4);
uq_plot(X_val, Y_val, 'k', 'Color', myColors(1,:))
uq_plot(X_val, Ymu_ordinary, 'Color', myColors(2,:))
uq_plot(X_val, Ymu_polynomial, 'Color', myColors(3,:))
uq_plot(X_val, Ymu_custom, 'Color', myColors(4,:))
uq_plot(X, Y, 'ko','MarkerFaceColor','k')
hold off
set(gca, 'fontsize', 14, 'box', 'on')
axis([0 15 -15 30])
xlabel('$$X$$','interpreter','latex')
ylabel('$$\mu_{\hat{Y}}(x)$$','interpreter','latex')
legend({'True model', 'Ordinary Kriging', '3rd deg. polynomial trend',...
    'Custom trend', 'Observations'},'Location','NorthWest',...
    'fontsize',14)
%%
% * Kriging predictor variance
uq_figure('Position', [50 50 500 400])
hold on  
uq_plot(X_val, zeros(size(X_val)), 'k', 'Color', myColors(1,:))
uq_plot(X_val, Yvar_ordinary, 'Color', myColors(2,:))
uq_plot(X_val, Yvar_polynomial, 'Color', myColors(3,:))
uq_plot(X_val, Yvar_custom, 'Color', myColors(4,:))
uq_plot(X, zeros(size(X)), 'ko','MarkerFaceColor','k')
hold off 
set(gca, 'fontsize', 14, 'box', 'on')
axis([0 15 0 40])
xlabel('$$X$$','interpreter','latex')
ylabel('$$\sigma^2_{\hat{Y}}(x)$$','interpreter','latex')
legend({'True model', 'Ordinary Kriging', '3rd deg. polynomial trend',...
    'Custom trend', 'Observations'},'Location','NorthWest',...
    'fontsize',14)