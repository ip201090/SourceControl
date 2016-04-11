%% KRIGING METAMODELLING: ESTIMATION/OPTIMIZATION METHODS
% This Example showcases how to perform Kriging metamodelling
% for a simple 1D function, using various hyperparameter estimation and 
% optimization methods.

%% 1 - CLEAR THE WORKSPACE AND INITIALIZE THE UQLAB FRAMEWORK 
clearvars
uqlab
rng(100) % fix the random seed for repeatable results

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
% Select the metamodelling tool and the Kriging module:
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'Kriging';
%% 
% The (X,Y) that were previously produced are going to be used for
% creating the Kriging metamodel: 
metaopts.ExpDesign.X = X;
metaopts.ExpDesign.Y = Y;

%%
% Ordinary Kriging is going to be performed (just a constant value) so the 
% appropriate option is set for the trend:
metaopts.Trend.Type = 'ordinary' ;

%%
% The correlation family is set to Matern 5/2:
metaopts.Corr.Family = 'matern-5_2';

%%
% A number of Kriging metamodels are going to be created. In order to reduce 
% the amount of text that will be produced to the command window only the 
% final result of the optimization process for each metamodel is going to
% be shown:
metaopts.Optim.Display = 'final' ; 

%%
% The previous set of options are fixed, in a sense that all the Kriging
% metamodels that are going to be created will use them. 
% The selected optimization and hyperparameter estimation method will
% vary for each Kriging metamodel that is created next:
disp(['> Estimation Method: Maximum-Likelihood, ',...
    'Optimization method: BFGS'])
metaopts.EstimMethod = 'ML';
metaopts.Optim.Method = 'BFGS';
myKriging_ML_BFGS = uq_createModel(metaopts) ;
fprintf('\n\n')

disp(['> Estimation Method: Maximum-Likelihood, ',...
    'Optimization method: HGA'])
metaopts.Optim.Method = 'HGA';
myKriging_ML_HGA = uq_createModel(metaopts) ;
fprintf('\n\n')

disp(['> Estimation Method: Cross-Validation, ',...
    'Optimization method: BFGS'])
metaopts.EstimMethod = 'CV';
metaopts.Optim.Method = 'BFGS';
metaopts.Optim.maxIter = 30;
myKriging_CV_BFGS = uq_createModel(metaopts) ;
fprintf('\n\n')

disp(['> Estimation Method: Cross-Validation, ',...
    'Optimization method: HGA'])
metaopts.Optim.Method = 'HGA';
myKriging_CV_HGA = uq_createModel(metaopts) ;

%% 6 - COMPARISON OF THE METAMODELS
%%
% Create a validation sample of size 1000
X_val = linspace(0,15,1000)';

%%
% Evaluate the full model response on the validation sample:
Y_full = uq_evalModel(X_val, myModel);

%%
% Evaluate the corresponding responses for each of the generated Kriging
% metamodel. For each metamodel, the mean and the
% variance of the Kriging predictor are returned:
[Ymu_ML_BFGS, Yvar_ML_BFGS]  = uq_evalModel(X_val, myKriging_ML_BFGS);
[Ymu_ML_HGA, Yvar_ML_HGA] = uq_evalModel(X_val, myKriging_ML_HGA);
[Ymu_CV_BFGS, Yvar_CV_BFGS] = uq_evalModel(X_val, myKriging_CV_BFGS);
[Ymu_CV_HGA, Yvar_CV_HGA] = uq_evalModel(X_val, myKriging_CV_HGA);

%%
% Lastly, some comparative plots of the mean and variance of the Kriging
% predictors are generated. They are divided into two
% groups based on the hyperparameter estimation method.
%%
% * *Maximum likelihood estimation*

myColors = uq_cmap(2);
uq_figure('Position',[50 50 500 400]);
hold on;
uq_plot(X_val, Y_full, 'k')
uq_plot(X_val,Ymu_ML_BFGS, 'Color', myColors(1,:));
uq_plot(X_val,Ymu_ML_HGA, '--', 'Color', myColors(2,:),'LineWidth',3);
uq_plot(X,Y,'ro')
hold off
set(gca, 'fontsize', 14)
axis([0 15 -15 25])
box on
xlabel('$$X$$','interpreter','latex')
ylabel('$$\mu_{\hat{Y}}(x)$$','interpreter','latex')
legend({'Full model', 'Kriging, optim. method: BFGS', 'Kriging, optim. method: HGA',...
    'Observations'}, 'Location','north');
title('Maximum likelihood', 'fontweight', 'normal')

%%

uq_figure('Position', [50 50 500 400])
hold on;
uq_plot(X, zeros(size(X)), 'k')
uq_plot(X_val,Yvar_ML_BFGS, 'Color', myColors(1,:));
uq_plot(X_val,Yvar_ML_HGA, '--', 'Color', myColors(2,:),'LineWidth',3);
uq_plot(X,zeros(size(X)),'ro')
hold off
set(gca, 'fontsize', 14)
axis([0 15 0 30])
box on
xlabel('$$X$$','interpreter','latex')
ylabel('$$\sigma^2_{\hat{Y}}(x)$$','interpreter','latex')
legend({'Full model', 'Kriging, optim. method: BFGS', 'Kriging, optim. method: HGA',...
    'Observations'}, 'Location','North');
title('Maximum likelihood', 'fontweight', 'normal')
%%
% * *Cross-validation based estimation*

uq_figure('Position', [50 50 500 400])
hold on;
uq_plot(X_val, Y_full, 'k')
uq_plot(X_val, Ymu_CV_BFGS, 'Color', myColors(1,:));
uq_plot(X_val, Ymu_CV_HGA, '--', 'Color', myColors(2,:),'LineWidth',3);
uq_plot(X,Y,'ro')
hold off
set(gca, 'fontsize', 14)
axis([0 15 -15 25])
box on
xlabel('$$X$$','interpreter','latex')
ylabel('$$\mu_{\hat{Y}}(x)$$','interpreter','latex')
legend({'Full model', 'Kriging, optim. method: BFGS', 'Kriging, optim. method: HGA',...
    'Observations'}, 'Location','North');
title('(LOO) Cross-Validation', 'fontweight', 'normal')

%%

uq_figure('Position', [50 50 500 400])
hold on;
uq_plot(X, zeros(size(X)), 'k')
uq_plot(X_val,Yvar_CV_BFGS, 'Color', myColors(1,:));
uq_plot(X_val,Yvar_CV_HGA, '--', 'Color', myColors(2,:),'LineWidth',3);
uq_plot(X,zeros(size(X)),'ro')
hold off
set(gca, 'fontsize', 14)
axis([0 15 0 30])
box on
xlabel('$$X$$','interpreter','latex')
ylabel('$$\sigma^2_{\hat{Y}}(x)$$','interpreter','latex')
legend({'Full model', 'Kriging, optim. method: BFGS', 'Kriging, optim. method: HGA', 'Observations'},...
    'Location','North');
title('(LOO) Cross-Validation', 'fontweight', 'normal')