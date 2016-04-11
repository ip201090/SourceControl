%% SENSITIVITY ANALYSIS: MULTIPLE OUTPUTS
%  This example showcases an application of sensitivity analysis on a model
%  with multiple outputs

%% 1 - INITIALIZE THE UQLAB FRAMEWORK AND CLEAR THE WORKSPACE
%  Clear variables from the workspace and reinitialize the UQLab framework
clearvars;
uqlab;

%% 2 - MODEL
%  COMPUTATIONAL MODEL
% The simply supported beam problem is shown in the following figure;
uq_figure('Position', [50 50 500 400]) 
[I,map] = imread('SimplySupportedBeam.png');
imshow(I,map);
truesize([300 400]);
%% 
% The (negative) deflection of the beam at any longitudinal coordinate
% $l_i$ is given by:
%
% $$ V(l_i) = -\frac{p l_i (L^3 - 2l_i^2 L + l_i^3) }{2E b h^3} $$
%
% The function is available in UQLab in
% Examples\SimpleTestFunctions\uq_SimplySupportedBeam9points.m

%%
% Create a model object that uses the uq_SimplySupportedBeam9points function:
Model.mFile = 'uq_SimplySupportedBeam9points'; % specify the function name
myModel = uq_createModel(Model);               % create and add the model to UQLab

%% 3 - PROBABILISTIC INPUT MODEL
% The simply supported beam model has 5 independent inputs, modelled by
% Lognormals. 
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
% <td>30000 Mpa</td>
% <td>4500 Mpa</td>
% </tr>
% <tr>
% <td>b</td>
% <td>Beam width(m)</td>
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
% <td>p</td>
% <td>Uniform load</td>
% <td>Lognormal</td>
% <td>10 kN/m</td>
% <td>2 N/m</td>
% </tr>
% </table>
% </html>

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



%% 4 - SENSITIVITY ANALYSIS
% Sensitivity analysis is performed by calculating the Sobol' indices for
% each of the output components separately.
%%
% Select the sensitivity tool and the Sobol' module
SobolOpts.Type = 'uq_sensitivity';
SobolOpts.Method = 'Sobol';
%%
%  Specify the sample size of each variable. Note that the total cost will
%  equal (M+2)*SampleSize for sampling-based Sobol' indices calculation
SobolOpts.Sobol.SampleSize = 10000;
%%
% Create and add the sensitivity analysis to UQLab
SobolAnalysis = uq_createAnalysis(SobolOpts);
%%
% Retrieve the analysis results
SobolResults = SobolAnalysis.Results;

%% 5 - RESULTS VISUALIZATION
%  Printout a report of the MC-based and PCE-based results
uq_print(SobolAnalysis);

%%
% Retrieve the total and first order indices
TotalSobolIndices = SobolResults.Total;
FirstOrderIndices = SobolResults.FirstOrder;

%%
% Plot the total indices for all the components
uq_figure('Position', [50 50 500 400])
uq_bar(TotalSobolIndices, 'edgecolor', 'none');
% add the variable names as axis ticks and a legend
ynames = {'Y_1', 'Y_2', 'Y_3', 'Y_4', 'Y_5', 'Y_6', 'Y_7', 'Y_8', 'Y_9'};
set(gca, 'xtick', 1:length(SobolResults.VariableNames), 'xticklabel', SobolResults.VariableNames);
uq_legend(ynames', 'location', 'northwest', 'fontsize', 12);
% title and labels
title('Total Sobol indices')
xlabel('Input variable');
ylabel('S_i');
% set nice plot limits
ylim([0 1]);
xlim([-1 6]);

%%
% Plot the $1^{st}$ order indices and format the plots properly
uq_figure('Position', [50 50 500 400]);
uq_bar(FirstOrderIndices, 'edgecolor', 'none');
% add the variable names as axis ticks and a legend
set(gca, 'xtick', 1:length(SobolResults.VariableNames), 'xticklabel', SobolResults.VariableNames);
uq_legend(ynames', 'location', 'northwest', 'fontsize', 12);
% plot title and labels
title('First order Sobol'' indices')
xlabel('Input variable');
ylabel('S_i')
% set nice plot limits
ylim([0 1]);
xlim([-1 6]);