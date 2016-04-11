%% PCE METAMODELLING: COMPARISON OF PCE CALCULATION STRATEGIES
%  This example showcases how various strategies for the computation of PCE
%  coefficients can be deployed in UQLab. The performance of the resulting
%  metamodels are also compared.
%  The model of choice is the Ishigami function, a standard benchmark in
%  PCE applications.

%% 1. INITIALIZE THE UQLAB FRAMEWORK AND CLEAR THE WORKSPACE
clearvars
uqlab


%% 2. COMPUTATIONAL MODEL
% The Ishigami function is defined as:
%
% $$Y(\mathbf{X}) = \sin(X_1) + 7 \sin^2(X_2) + 0.1 X_3^4 \sin(X_1) $$

%%
% The Ishigami function is available in UQLab and can be found in the file 
% Examples\SimpleTestFunctions\uq_ishigami.m
% 
% Create a model object that uses the Ishigami function:
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
% In this section several ways to calculate the polynomial chaos expansion
% coefficients are showcased

%%
% Select the metamodelling tool and the PCE module
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'PCE';

%% 
% Because several models will be created in this section, we specify that
% the model that is to be surrogated in all cases is the Ishigami model
% just defined.
metaopts.FullModel = myModel;

%% 4.1 Quadrature-based calculation of the coefficients
% Quadrature-based methods automatically use the computational model
% created earlier to gather the model responses on the quadrature nodes.



%%
% Specify the 'Quadrature' calculation method. By default, Smolyak' sparse
% quadrature is used
metaopts.Method = 'Quadrature' ;

%%
% Specify the maximum polynomial degree. The appropriate quadrature level
% is determined automatically by UQLab
metaopts.Degree = 14;

%% 
% Create and add the quadrature-based PCE model to UQLab
myPCE_Quadrature = uq_createModel(metaopts);

%%
% A report on the calculated coefficients can be produced as follows:
uq_print(myPCE_Quadrature);
%%
% Similarly, a visual representation of the distribution of the
% coefficients can be obtained as:
uq_display(myPCE_Quadrature);

%% 4.2 Least-square calculation of the coefficients
% A second metamodel based on ordinary least-squares (OLS) can be created
% by using the same basic options as for the quadrature case, but
% selecting the 'OLS' method
metaopts.Method = 'OLS' ;
%%
% Least-square methods allow for degree-adaptive calculation of the PCE
% coefficients: if an array of possible degrees is given, the degree with
% the lowest Leave-One-Out cross-validation error (LOO error) is
% automatically selected. 
metaopts.Degree = 3:15;

%% 
% Least-square methods rely on the evaluation of the model response on an
% experimental design. The following options configure UQLab to generate an
% experimental design of size 500 based on a latin hypercube sampling of
% the input model
metaopts.ExpDesign.NSamples = 500;
metaopts.ExpDesign.Sampling = 'LHS'; % Also available: 'MC', 'Sobol', 'Halton'

%%
% Create and add the OLS-based PCE model to UQLab
myPCE_OLS = uq_createModel(metaopts);
%%
% Print a summary of the calculated coefficients and display them
% graphically:
uq_print(myPCE_OLS);
uq_display(myPCE_OLS);

%% 4.3 Sparse Least-Angle-Regression-based (LARS) calculation of the coefficients
% The sparse-favouring least-square minimization LARS can be enabled
% similarly to OLS:
metaopts.Method = 'LARS' ;
%%
% LARS allows for degree-adaptive calculation of the PCE
% coefficients: if an array of possible degrees is given, the degree with
% the lowest Leave-One-Out cross-validation error (LOO error) is
% automatically selected. 
metaopts.Degree = 3:15;

%% 
% Specify a sparse truncation scheme: hyperbolic norm with q = 0.75
metaopts.TruncOptions.qNorm = 0.75;

%%
% In general, sparse PCE requires a vastly inferior number of samples to
% properly converge w.r.t. to both quadrature and OLS:
metaopts.ExpDesign.NSamples = 150;

%%
% Create and add the LARS-based PCE model to UQLab
myPCE_LARS = uq_createModel(metaopts);
%%
% Print a summary of the calculated coefficients and display them
% graphically:
uq_print(myPCE_LARS);
uq_display(myPCE_LARS);

%% 5. VALIDATION OF THE METAMODELS

%% 5.1 Generation of a validation set
% Create a validation sample of size $10^4$ from the input model 
X = uq_getSample(10000);

%%
% Evaluate the full model response on the validation sample
Y_full = uq_evalModel(X, myModel);
%%
% Evaluate the corresponding responses for each of the three PCE metamodels
% generated
Y_Quadrature = uq_evalModel(X,myPCE_Quadrature);
Y_OLS = uq_evalModel(X,myPCE_OLS);
Y_LARS = uq_evalModel(X,myPCE_LARS);

%% 5.2 Comparison of the results
% To visually assess the performance of each metamodel, produce scatter
% plots of the metamodel vs. the true response on the validation set
%%
% * Quadrature method
uq_figure('Position', [50 50 500 400]);
uq_plot(Y_full, Y_Quadrature, '.');
set(gca, 'fontsize', 14)
axis equal;
xlim([-11 18]);
ylim([-11 18]);
xlabel('$Y$','Interpreter','latex','FontSize', 14);
ylabel('$Y^{PC}$','Interpreter','latex','FontSize', 14)

%%
%
% * Ordinary Least Squares method: 
uq_figure('Position', [50 50 500 400]);
uq_plot(Y_full, Y_OLS, '.');
axis equal;
set(gca, 'fontsize', 14)
xlim([-11 18]);
ylim([-11 18]);
xlabel('$Y$','Interpreter','latex','FontSize', 14);
ylabel('$Y^{PC}$','Interpreter','latex','FontSize', 14)


%%
%
% * Least Angle Regression method: 
uq_figure('Position', [50 50 500 400]);
uq_plot(Y_full, Y_LARS, '.');
axis equal;
set(gca, 'fontsize', 14)
xlim([-11 18]);
ylim([-11 18]);
xlabel('$Y$','Interpreter','latex','FontSize', 14);
ylabel('$Y^{PC}$','Interpreter','latex','FontSize', 14)


