%% MODEL MODULE: COMPUTATIONAL MODEL DEFINITION
%  This example showcases the various ways how a computational model can
%  be defined. 

%% 1 - INITIALIZE THE UQLAB FRAMEWORK AND CLEAR THE WORKSPACE
uqlab
clearvars

%% 2 - PROBABILISTIC INPUT MODEL
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


%% 3 - COMPUTATIONAL MODEL
% The Ishigami function is defined as:
%
% $$Y(\mathbf{X}) = \sin(X_1) + 7 \sin^2(X_2) + 0.1 X_3^4 \sin(X_1) $$
%%
% The Model module in UQLab offers three ways to define a computational
% model:
% * using an m-file
% * using a function handle
% * using a string
% Each of the available ways will be used next in order to define the
% Ishigami function as a computational model in UQLab. 

%% 3.1 - Using an m-file
% The Ishigami function is available in UQLab and can be found in the file 
% Examples\SimpleTestFunctions\uq_ishigami.m
Model.mFile = 'uq_ishigami';           % specify the function name
myModel_mFile = uq_createModel(Model); % create and add the model object to UQLab


%% 3.2 - Using a function handle
% The already available uq_ishigame function can also be defined using
% function handles:
clear Model
Model.mHandle = @uq_ishigami;           % specify the function handle
myModel_mHandle = uq_createModel(Model);% create and add the model object to UQLab

%% 3.3 - Using a string
clear Model
%%
% The Ishigami function is specified in a string as follows:
Model.mString = 'sin(X(:,1)) + 7*(sin(X(:,2)).^2) + 0.1*(X(:,3).^4).* sin(X(:,1))';

myModel_mString = uq_createModel(Model);% create and add the model object to UQLab

%% 4 - COMPARISON OF THE MODELS
% Create a validation sample of size $10^4$ from the input model using Latin 
% Hypercube Sampling
X = uq_getSample(10^4, 'LHS');

%%
% Evaluate the corresponding responses for each of the three computational
% models generated
Y_mFile = uq_evalModel(X, myModel_mFile);
Y_mHandle = uq_evalModel(X, myModel_mHandle);
Y_mString = uq_evalModel(X, myModel_mString);

%%
% It can be observed that the results are identical
Diff_MFileMHandle = max(abs(diff(Y_mFile(:)-Y_mHandle(:))))
Diff_MFileMString = max(abs(diff(Y_mFile(:)-Y_mString(:))))

%%
% Produce a histogram of the model response
uq_figure('Position', [50 50 500 400]);
uq_histogram(Y_mFile);
xlabel('Y')
ylabel('Number of samples')