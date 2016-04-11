%% Initializing UQLab
uqlab
clearvars
%% Creation of a Model

MOpts.mFile = 'uq_ishigami' ;
myModel = uq_createModel(MOpts);

%% Creating an Input
for i = 1:3
    IOpts.Marginals(i).Type = 'Uniform' ;
    IOpts.Marginals(i).Parameters = [-pi, pi] ;
end
myInput = uq_createInput(IOpts);
%% Setup of the PCE
MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% possible.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Defaultly = standard trunction scheme with p = 3 ... we will stick to
% that. Otherwise we could change it with MetaOpts.Degree = x; For the
% sake of completeness we will denote it anyways
MetaOpts.Degree = 3;

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

X = uq_getSample(10000,'MC');

%% Calculating the coefficients with different methods

% Used method: Quadrature
MetaOpts.Method = 'Quadrature';
PCE_Quadrature = uq_createModel(MetaOpts);

% % Used method: Least-Squares
MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.Nsamples = 10000;
MetaOpts.ExpDesign.Sampling = 'LHS';

myPCE_OLS = uq_createModel(MetaOpts);
%PCE_OLS = uq_createModel(MetaOpts);

% Evaluation
Y_Quadrature = uq_evalModel(X,PCE_Quadrature);
Y_OLS = uq_evalModel(X,PCE_OLS);

% Reference value
Y_full = uq_evalModel(X, myModel);

% uq_figure;
% uq_plot(Y_full,Y_Quadrature);

figure;
plot(Y_full);

figure;
plot(Y_Quadrature);

% uq_figure;
% uq_plot(Y_full,Y_OLS);




