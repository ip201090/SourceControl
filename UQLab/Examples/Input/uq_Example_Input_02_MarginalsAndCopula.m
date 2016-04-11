%% INPUT MODULE: MARGINALS AND COPULA
%  This example showcases how to define a probabilistic input model with or
%  without a copula dependency.


%% 1 - INITIALIZE THE UQLAB FRAMEWORK AND CLEAR THE WORKSPACE
%uqlab
%clearvars

%% 2 - PROBABILISTIC INPUT MODEL DEFINITION (WITHOUT DEPENDENCY)
% The probabilistic input model consists of 2 variables:
% * $X_1 \sim \mathcal{N}(0, 1)$
% * $X_2 \sim \mathcal{B}(1, 3)$
Input.Marginals(1).Type = 'Gaussian' ;
Input.Marginals(1).Parameters = [0 1] ;
Input.Marginals(2).Type = 'Beta' ;
Input.Marginals(2).Parameters = [1 3] ;
%%
% By default, the variables are considered independent

%%
% Create and store the input object in UQLab
myInput1 = uq_createInput(Input);

%%
% Produce a report of the generated input object
uq_print(myInput1)

%% 2 - PROBABILISTIC INPUT MODEL DEFINITION (WITH DEPENDENCY: GAUSSIAN COPULA) 
% The distributions of the variables of the input model are already defined inside
% the struct Input. Dependency using a Gaussian copula is added as follows:
Input.Copula.Type = 'Gaussian' ;
Input.Copula.RankCorr = [1 0.8; 0.8 1] ; % the Spearman correlation matrix

%%
% Create and store the input object in UQLab
myInput2 = uq_createInput(Input) ;

%%
% Produce a report of the generated input object
uq_print(myInput2)

%% 3 - COMPARISON OF THE GENERATED INPUT MODELS 
% Each of the generated input object can be quickly visualized using the
% function uq_display
uq_display(myInput1);
uq_display(myInput2);
