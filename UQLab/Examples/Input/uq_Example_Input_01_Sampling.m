%% INPUT MODULE: SAMPLING STRATEGIES
%  This example showcases how to define a probabilistic input model and then 
%  use it draw samples using various sampling strategies. 


%% 1 - CLEAR THE WORKSPACE AND INITIALIZE THE UQLAB FRAMEWORK
clearvars
uqlab


%% 2 - PROBABILISTIC INPUT MODEL DEFINITION
% The probabilistic input model consists of 2 uniform variables:
% $X_i \in \mathcal{U}(0, 1)\quad i \in \{1,2\}$

Input.Marginals(1).Type = 'Uniform' ;
Input.Marginals(1).Parameters = [0 1] ;
Input.Marginals(2).Type = 'Uniform' ;
Input.Marginals(2).Parameters = [0 1] ;

%%
% Create and store the input object in UQLab
myInput = uq_createInput(Input) ;

%%
% A report on the generated input model can be produced as follows: 
uq_print(myInput);



%% 3 - DRAWING SAMPLES 
% Samples from the predefined input model are going to be drawn using
% various sampling methods 

%% 3.1 - Monte Carlo sampling

X_MC = uq_getSample(80,'MC');

uq_figure('Position', [50 50 500 400]);
uq_plot(X_MC(:,1), X_MC(:,2), '.', 'markersize',10)
set(gca, 'fontsize', 14)
title('Monte Carlo Sampling','fontsize', 14, 'fontweight', 'normal')
xlabel('X_1');
ylabel('X_2');

%% 3.2 - Latin Hypercube sampling

X_LHS = uq_getSample(80,'LHS');

uq_figure('Position', [50 50 500 400]);
uq_plot(X_LHS(:,1), X_LHS(:,2), '.', 'markersize',10)
set(gca, 'fontsize', 14)
title('Latin Hypercube Sampling', 'fontsize', 14, 'fontweight', 'normal')
xlabel('X_1');
ylabel('X_2');

%% 3.3 - Sobol sequence sampling

X_Sobol = uq_getSample(80,'Sobol');

uq_figure('Position', [50 50 500 400]);
uq_plot(X_Sobol(:,1), X_Sobol(:,2), '.', 'markersize',10)
set(gca, 'fontsize', 14)
title('Sobol Sampling', 'fontsize', 14, 'fontweight', 'normal')
xlabel('X_1');
ylabel('X_2');

%% 3.4 - Halton sequence sampling

X_Halton = uq_getSample(80,'Halton');

uq_figure('Position', [50 50 500 400]);
uq_plot(X_Halton(:,1), X_Halton(:,2), '.', 'markersize',10)
set(gca, 'fontsize', 14)
title('Halton Sampling', 'fontsize', 14, 'fontweight', 'normal')
xlabel('X_1');
ylabel('X_2');

%% 4 - COMPARISON OF SAMPLING STRATEGIES
% Next, a comparison plot of the sampling strategies is shown
uq_figure('Position', [50 50 500 400]);

subplot(2,2,1)
uq_plot(X_MC(:,1), X_MC(:,2), '.', 'markersize', 10) ;
set(gca, 'fontsize', 12)
title('MCS', 'fontsize',14, 'fontweight', 'normal');
ylabel('X_2')

subplot(2,2,2)
uq_plot(X_LHS(:,1), X_LHS(:,2), '.', 'markersize', 10) ;
set(gca, 'fontsize', 12)
title('LHS', 'fontsize', 14, 'fontweight', 'normal');

subplot(2,2,3)
uq_plot(X_Sobol(:,1), X_Sobol(:,2), '.', 'markersize', 10) ;
set(gca, 'fontsize', 12)
title('Sobol''', 'fontsize', 14, 'fontweight', 'normal');
xlabel('X_1')
ylabel('X_2')

subplot(2,2,4)
uq_plot(X_Halton(:,1), X_Halton(:,2), '.', 'markersize', 10) ;
set(gca, 'fontsize', 12)
title('Halton', 'fontsize', 14, 'fontweight', 'normal');
xlabel('X_1')
