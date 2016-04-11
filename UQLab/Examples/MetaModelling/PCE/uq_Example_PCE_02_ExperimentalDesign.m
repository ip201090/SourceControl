%% PCE METAMODELLING: EXPERIMENTAL DESIGN OPTIONS
%  This Example shows different methods to create an experimental design
%  and calculate PCE coefficients with least square minimization.
%  The model of choice is the Ishigami function, a standard benchmark in
%  PCE applications.

%% 1. INITIALIZE THE UQLAB FRAMEWORK AND CLEAR THE WORKSPACE
uqlab
clearvars
rng(120) % fix the random seed to get repeatable results

%% 2. COMPUTATIONAL MODEL
% The Ishigami function is defined as:
%
% $$Y(\mathbf{X}) = \sin(X_1) + 7 \sin^2(X_2) + 0.1 X_3^4 \sin(X_1) $$

%%
% The Ishigami function is available in UQLab and can be found in the file 
% Examples\SimpleTestFunctions\uq_ishigami.m
% 
% A model object that uses the Ishigami function can be created in UQLab as
% follows:
modelopts.mFile = 'uq_ishigami' ;      % specify the function name
myModel = uq_createModel(modelopts);   % create and add the model object to UQLab

%% 3. PROBABILISTIC INPUT MODEL
% The probabilistic input model consists of 3 independent uniform 
% variables:
% $X_i \in \mathcal{U}(-\pi, \pi), \quad i \in \{1,2,3\}$

%%
% Specify the marginals. If no copula is given, they are assumed
% independent
for ii = 1 : 3
    Input.Marginals(ii).Type = 'Uniform' ;
    Input.Marginals(ii).Parameters = [-pi, pi] ; 
end

%%
% Create and add the resulting input object to UQLab
myInput = uq_createInput(Input);

%% 4. POLYNOMIAL CHAOS EXPANSION METAMODEL
% In this section a sparse polynomial chaos expansion is created to
% surrogate the Ishigami function. The method of choice is LARS.
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'PCE';

%% 
% Because several models will be created in this section, we specify that
% the model that is to be surrogated in all cases is the Ishigami model
% just defined.
metaopts.FullModel = myModel;

% Select the sparse-favouring least-square minimization strategy LARS.
metaopts.Method = 'LARS' ;

%%
% Least-square methods allow for degree-adaptive calculation of the PCE
% coefficients: if an array of possible degrees is given, the degree with
% the lowest Leave-One-Out cross-validation error (LOO error) is
% automatically selected. 
metaopts.Degree = 3:15;

%% 5. COMPARISON OF DIFFERENT EXPERIMENTAL DESIGN SIZES
% Least-square methods rely on the evaluation of the model response on an
% experimental design. The following options configure UQLab to generate an
% experimental design of size 20 based on a latin hypercube sampling of the
% input model. 
metaopts.ExpDesign.Sampling = 'LHS';
metaopts.ExpDesign.NSamples = 20;

%%
% Create and add to UQLab the PCE model based on 20 samples 
myPCE_LHS_20 = uq_createModel(metaopts);

%% 
% Create additional PCE models with an increasing number of points in the
% experimental design. Create a model for 40, 80 and 120 samples. Note that
% all the other options are left unchanged.
metaopts.ExpDesign.NSamples = 40;
myPCE_LHS_40 = uq_createModel(metaopts);

metaopts.ExpDesign.NSamples = 80;
myPCE_LHS_80 = uq_createModel(metaopts);

metaopts.ExpDesign.NSamples = 120;
myPCE_LHS_120 = uq_createModel(metaopts);

%% 6. COMPARISON OF DIFFERENT SAMPLING STRATEGIES
% Create additional metamodels with experimental designs of fixed size
% n=80 based on different sampling strategies: 
% MC: Monte Carlo sampling
% Sobol: Sobol pseudorandom sequence
% Halton: Halton pseudorandom sequence
metaopts.ExpDesign.NSamples = 80;

metaopts.ExpDesign.Sampling = 'MC';
myPCE_MC_80 = uq_createModel(metaopts);

metaopts.ExpDesign.Sampling = 'Sobol';
myPCE_Sobol_80 = uq_createModel(metaopts);

metaopts.ExpDesign.Sampling = 'Halton';
myPCE_Halton_80 = uq_createModel(metaopts);

%% 7. COMPARISON OF THE PERFORMANCE OF THE METAMODELS CREATED
% Comparison of the performance of the metamodels created is done by
% comparing the response of the full model and each of the calculated
% metamodels on a validation set of size $n_{val} = 80$

%% 
% Generate a validation sample of size $10^4$ from the probabilistic input
% model
X = uq_getSample(10000);

%%
% Calculate the response of the exact Ishigami model as a reference
Y_full = uq_evalModel(X, myModel);

%%
% Calculate the responses of all the metamodels created
Y_LHS_20 = uq_evalModel(X, myPCE_LHS_20) ;
Y_LHS_40 = uq_evalModel(X, myPCE_LHS_40) ;
Y_LHS_80 = uq_evalModel(X, myPCE_LHS_80) ;
Y_LHS_120 = uq_evalModel(X, myPCE_LHS_120) ;
Y_MC_80 = uq_evalModel(X, myPCE_MC_80) ;
Y_Sobol_80 = uq_evalModel(X, myPCE_Sobol_80) ;
Y_Halton_80 = uq_evalModel(X, myPCE_Halton_80) ;

%% 8.GRAPHICAL COMPARISON OF THE MODEL PERFORMANCE 
%% 8.1 Performance of LHS sampling for different sizes of the Experimental design 
uq_figure('Position', [50 50 500 400]);
subplot(2,2,1)
uq_plot(Y_full, Y_LHS_20,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('LHS, N=20 ')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

subplot(2,2,2) 
uq_plot(Y_full, Y_LHS_40,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('LHS, N=40')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

subplot(2,2,3)
uq_plot(Y_full, Y_LHS_80,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('LHS, N=80')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

subplot(2,2,4)
uq_plot(Y_full, Y_LHS_120,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('LHS, N=120')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

%% 8.2 Performance of different sampling strategies for fixed size N = 80
uq_figure('Position', [50 50 500 400]);
subplot(2,2,1) 
uq_plot(Y_full, Y_MC_80,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('MC, N=80')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

subplot(2,2,2)
uq_plot(Y_full, Y_LHS_80,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('LHS, N=80')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

subplot(2,2,3)
uq_plot(Y_full, Y_Sobol_80,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('Sobol, N=80')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)

subplot(2,2,4)
uq_plot(Y_full, Y_Halton_80,'.')
set(gca, 'fontsize', 16)
axis equal 
axis([-13 20 -13 20])
title('Halton, N=80')
xlabel('$Y$','Interpreter','latex','FontSize', 18);
ylabel('$Y_{PC}$','Interpreter','latex','FontSize', 18)