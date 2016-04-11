%% KRIGING METAMODELLING: ONE DIMENSIONAL EXAMPLE
% This example showcases how to perform Kriging metamodelling on a simple 
% 1D function, using various types of correlation families.


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

%% 5 - KRIGING METAMODEL
% Select the metamodelling tool and the Kriging module
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'Kriging';

%% 
% Use experimental design generated earlier
metaopts.ExpDesign.X = X;
metaopts.ExpDesign.Y = Y;

%%
% Perform ordinary Kriging (constant trend)
metaopts.Trend.Type = 'ordinary' ;

%%
% Set the correlation family to Matern 5/2
metaopts.Corr.Family = 'matern-5_2';

%%
% Use maximum-likelihood to estimate the hyperparameters
metaopts.EstimMethod = 'ML';

%%
% Use gradient-based optimization (BFGS) 
metaopts.Optim.Method = 'BFGS';

%%
% Create the metamodel object and add it to UQLab:
myKriging_mat = uq_createModel(metaopts);

%% 
% A report about the resulting Kriging object can be produced as follows
uq_print(myKriging_mat);

%%
% Similarly, a visual representation of the mean and the 95% confidence bounds of the
% Kriging predictor can be obtained (only for 1D functions)
uq_display(myKriging_mat);

%% 
% Create another Kriging metamodel with the same configuration
% options but with 'linear' correlation family 
metaopts.Corr.Family = 'linear';
myKriging_lin = uq_createModel(metaopts);

%%
% Similarly, use the 'exponential' correlation family
metaopts.Corr.Family = 'exponential';
myKriging_exp = uq_createModel(metaopts);


%% 6 - VALIDATION OF THE METAMODELS
%% 
% Create a validation sample of size 1000
X_val = linspace(0,15,1000)';

%%
% Evaluate the full model response on the validation sample
Y_full = uq_evalModel(X_val, myModel);

%%
% Evaluate the corresponding responses for each of the three Kriging
% metamodels. For each metamodel, the mean and the
% variance of the Kriging predictor are calculated
[Ymu_mat, Yvar_mat] = uq_evalModel(X_val, myKriging_mat);
[Ymu_lin, Yvar_lin] = uq_evalModel(X_val, myKriging_lin);
[Ymu_exp, Yvar_exp] = uq_evalModel(X_val, myKriging_exp);

%%
% Produce a comparative plot of the mean of the Kriging predictor of each metamodel
% as well as the output of the true model. Also produce a comparative 
% plot of the variance of each predictor.

%%
% * Kriging predictor mean

myColors = uq_cmap(4);
uq_figure('position',[50 50 500 400]);
hold on
uq_plot(X_val, Y_full, 'k', 'LineWidth', 2)
uq_plot(X_val,Ymu_mat,'LineWidth', 2)
uq_plot(X_val,Ymu_exp,'LineWidth', 2)
uq_plot(X_val,Ymu_lin,'LineWidth', 2)
uq_plot(X, Y, 'ko','MarkerFaceColor','k')
hold off
axis([0 15 -20 20])
set(gca, 'fontsize', 14)
box on
grid on
xlabel('$$X$$','interpreter','latex')
ylabel('$$\mu_{\hat{Y}}(x)$$','interpreter','latex')

%%
% * Kriging predictor variance

uq_figure('position',[50 50 500 400]);
hold on
uq_plot(X_val, zeros(size(X_val)), 'k', 'LineWidth', 2)
uq_plot(X_val,Yvar_mat,'LineWidth', 2)
uq_plot(X_val,Yvar_exp,'LineWidth', 2)
uq_plot(X_val,Yvar_lin,'LineWidth', 2)
uq_plot(X, zeros(size(X)), 'ko','MarkerFaceColor','k')
hold off
set(gca, 'fontsize', 14)
legend({'Full Model','Kriging, R: Matern 5/2', ...
    'Kriging, R: Exponential','Kriging, R: Linear','Observations'},...
    'Location','North',  'fontsize',14)
ylim([0,60]) 
box on
grid on
xlabel('$$X$$','interpreter','latex')
ylabel('$$\sigma^2_{\hat{Y}}(x)$$','interpreter','latex')