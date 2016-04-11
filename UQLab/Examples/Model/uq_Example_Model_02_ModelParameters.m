%% MODEL MODULE: COMPUTATIONAL MODEL PARAMETERS
% This Example showcases how to pass parameters in a computational model.

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
% The Ishigami function in its general form is defined as:
%
% $$Y(\mathbf{X}) = \sin(X_1) + a \sin^2(X_2) + b X_3^4 \sin(X_1) $$

%%
% The Ishigami function is available in UQLab and can be found in the file 
% Examples\SimpleTestFunctions\uq_ishigami.m
Model.mFile = 'uq_ishigami';

%%
% First a typical parameter set is selected, that is $[a,b]=[7,0.1]$
Model.Parameters = [7,0.1];

%%
% Create and add the model object to UQLab
myModel = uq_createModel(Model);

%% 4 - COMPARISON OF THE MODEL RESPONSES FOR VARIOUS PARAMETER SETS
%% 4.1 - Using a fixed parameter set
% Create a validation sample of size $10^4$ from the input model using Latin 
% Hypercube Sampling
X = uq_getSample(10e4, 'LHS');

%%
% Evaluate the corresponding responses of the computational model
Y = uq_evalModel(X, myModel);

%%
% Plot a histogram of the model responses
uq_figure('Position',[50 50 500 400]);
uq_histogram(Y, 'facecolor', lines(1));
xlabel('Y')
ylabel('Number of samples')

%% 4.2 - Using various parameter sets
% First some parameter set values $[a,b]$ are stored in a matrix
parameterValues = ...
    [7, 0.1
     6, 0.1
     6, 0.2
     7, 0.05];
 %%
 % The histograms of the computational model's responses for each set of parameters
 % can be produced as follows:
 uq_figure('Position',[50 50 500 400]);
 % loop through each parameter set
 for ii = 1 : length(parameterValues)
    % assign the corresponding parameters
     myModel.Parameters = parameterValues(ii,:);
     % evaluate the computational model's responses
     Y =  uq_evalModel(X, myModel);
     % plot the histogram of the responses in a separate subplot
     subplot(2,2,ii);
     uq_histogram(Y);
     set(gca,'fontsize',16);
     title(sprintf('a=%.2f, b=%.2f',parameterValues(ii,1),...
         parameterValues(ii,2)), 'fontsize', 16)
 end
