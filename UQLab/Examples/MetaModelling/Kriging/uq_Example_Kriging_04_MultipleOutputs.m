%% KRIGING METAMODELLING: MULTIPLE OUTPUTS
% This example showcases an application of Kriging to the modelling of the
% deflection of a simply supported beam to a uniform random load at
% several points along its length.

%% 1 - CLEAR THE WORKSPACE AND INITIALIZE THE UQLAB FRAMEWORK 
clearvars
uqlab
rng(100) % also set the random seed to a fixed value for repeatable results

%% 2 - COMPUTATIONAL MODEL
% The simply supported beam problem is shown in the following figure:
uq_figure('Position', [50 50 500 400]) 
[I,map] = imread('SimplySupportedBeam.png');
imshow(I,map);
truesize([300 400]);
%% 
% The deflection of the beam at any longitudinal coordinate x
% is given by:
%
% $$ V(x) = \frac{p x (L^3 - 2x^2 L + x^3) }{2E b h^3} $$
%
% A function that calculates the model response in 9 points uniformly
% spaced along the length of a beam is available in UQLab in
% Examples\SimpleTestFunctions\uq_SimplySupportedBeam9points.m 

%%
% Create a model object that uses the uq_SimplySupportedBeam9points function:
Model.mFile = 'uq_SimplySupportedBeam9points'; % specify the function name
myModel = uq_createModel(Model);               % create and add the model to UQLab

%% 3 - PROBABILISTIC INPUT MODEL 
% The simply supported beam model has 5 independent inputs, modelled by
% Lognormal variables. 
% The detailed model is given in the following table:

%%
% <html>
% <table border=1><tr>
% <td><b>Variable</b></td>
% <td><b>Description</b></td>
% <td><b>Distribution</b></td>
% <td><b>Mean</b></td>
% <td><b>Std. deviation</b></td></tr>
% <tr>
% <td>b</td>
% <td>Beam width</td>
% <td>Lognormal</td>
% <td>0.15 m</td>
% <td>7.5 mm</td>
% </tr>
% <tr>
% <td>h</td>
% <td>Beam height</td>
% <td>Lognormal</td>
% <td>0.3 m</td>
% <td>15 mm</td>
% </tr>
% <tr>
% <td>L</td>
% <td>Length</td>
% <td>Lognormal</td>
% <td>5 m</td>
% <td>50 mm</td>
% </tr>
% <tr>
% <td>E</td>
% <td>Young modulus</td>
% <td>Lognormal</td>
% <td>30000 MPa</td>
% <td>4500 MPa</td>
% </tr>
% <tr>
% <td>p</td>
% <td>Uniform load</td>
% <td>Lognormal</td>
% <td>10 kN/m</td>
% <td>2 N/m</td>
% </tr>
% </table>
% </html>

%%
% The corresponding marginals define a UQLab input model:

Input.Marginals(1).Name = 'b';
Input.Marginals(1).Type = 'Lognormal';
Input.Marginals(1).Moments = [0.15 0.0075]; % (m)

Input.Marginals(2).Name = 'h';
Input.Marginals(2).Type = 'Lognormal';
Input.Marginals(2).Moments = [0.3 0.015]; % (m)

Input.Marginals(3).Name = 'L';
Input.Marginals(3).Type = 'Lognormal';
Input.Marginals(3).Moments = [5 0.05]; % (m)

Input.Marginals(4).Name = 'E';
Input.Marginals(4).Type = 'Lognormal';
Input.Marginals(4).Moments = [30000e6 4500e6] ; % (Pa)

Input.Marginals(5).Name = 'p';
Input.Marginals(5).Type = 'Lognormal';
Input.Marginals(5).Moments = [10000 2000]; % (N/m)

myInput = uq_createInput(Input);


%% 4 - KRIGING METAMODEL
% Select the metamodelling tool and the Kriging module:
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'Kriging';

%%
% If an input object and a model object are specified, the experimental
% design is automatically generated and evaluated 
metaopts.Input = myInput;
metaopts.FullModel = myModel;

%%
% Specify the sampling strategy and the number of samples for the
% experimental design
metaopts.ExpDesign.Sampling = 'LHS';
metaopts.ExpDesign.NSamples = 150;

%%
% Set a linear trend
metaopts.Trend.Type = 'linear' ;

%%
% Use the exponential correlation family
metaopts.Corr.Family = 'exponential';

%%
% Use maximum-likelihood-based hyperparameter estimation
metaopts.EstimMethod = 'ML';

%%
% Use hybrid genetic algorithm-based global optimization 
metaopts.Optim.Method = 'HGA';

%%
% Reduce verbosity during optimization to avoid excessive output
metaopts.Optim.Display = 'none';

%% 
% Set the maximum number of generations and the population size
metaopts.Optim.MaxIter = 30;
metaopts.Optim.HGA.nPop = 30;

%%
% Create the metamodel object and add it to UQLab
myKriging = uq_createModel(metaopts);

%% 5 - VALIDATION OF THE RESULTS
% The deflection V at the 9 points is plotted for three random samples of
% the input random parameters. Relative length units are used for
% comparison, because L is one of the  input random variables.

%% 5.1 - Create and evaluate the validation set
% Generate a validation sample from the input vector:
X_val = uq_getSample(3);
%%
% Evaluate the full model on the validation sample:
Y_val = uq_evalModel(X_val, myModel);
%%
% Evaluate the Kriging model on the same sample 
Y_kriging = uq_evalModel(X_val, myKriging);

%% 5.2 - Create plots
% For each sample of the validation set $\mathbf{x}^{(1)}$ the simply 
% supported beam deflection $\mathcal{M}(\mathbf{x}^{(i)})$ is compared against the one obtained by the
% Kriging predictor's mean $\mathcal{M}^{K}(\mathbf{x}^{(i)})$:
uq_figure('Position', [50 50 500 400])
hold on;
myColors = uq_cmap(3);  % use the UQLab colormap
% normalized positions 
li = 0:0.1:1;
% Loop over the realizations
for ii = 1 : size(Y_val,1)
    % plot each realization with a different colour
    uq_plot(li, [0,Y_val(ii,:),0], 'LineWidth',2, 'color', myColors(ii,:));
    uq_plot(li, [0,Y_kriging(ii,:),0], ':',  'LineWidth',2, 'color', myColors(ii,:));
end
hold off
ylim([-0.013 0.005])
set(gca, 'fontsize', 14, 'box', 'on')
xlabel('$L_{rel}$','Interpreter','Latex')
ylabel('$V$ (m)', 'Interpreter', 'Latex')
legend({'$\mathcal{M}(\mathbf{x}^{(1)})$', '$\mathcal{M}^{K}(\mathbf{x}^{(1)})$',...
    '$\mathcal{M}(\mathbf{x}^{(2)})$', '$\mathcal{M}^{K}(\mathbf{x}^{(2)})$',...
    '$\mathcal{M}(\mathbf{x}^{(3)})$', '$\mathcal{M}^{K}(\mathbf{x}^{(3)})$'}, ...
    'interpreter', 'latex', 'location','north')