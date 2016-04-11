%% PCE METAMODELLING: MULTIPLE POINT DEFLECTION OF A SIMPLY SUPPORTED BEAM
%  This example showcases the application of sparse PCE to surrogate a
%  model with multiple outputs. 

%% 1. INITIALIZE THE UQLAB FRAMEWORK AND CLEAR THE WORKSPACE
uqlab
clearvars
rng(100) % set the random seed to a fixed value for repeatable results

%% 2. COMPUTATIONAL MODEL
% The simply supported beam problem is shown in the following figure;
uq_figure; 
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

%% 3. PROBABILISTIC INPUT MODEL
% The simply supported beam model has 5 inputs, which are modelled by independent 
% lognormal random variables. 
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


%% 4. POLYNOMIAL CHAOS EXPANSION METAMODEL
% Select the metamodelling tool and the PCE module
metaopts.Type = 'uq_metamodel';
metaopts.MetaType = 'PCE';

%%
% Select the sparse-favouring least-square minimization LARS 
metaopts.Method = 'LARS' ;

%% 
% Specify a sparse truncation scheme: hyperbolic norm with q = 0.75
metaopts.TruncOptions.qNorm = 0.75;

%%
% Specify the range of degrees to be compared by the adaptive algorithm.
% The degree with the lowest LOO error estimator is chosen as the final
% metamodel.
metaopts.Degree = 2:10;

%% 
% Least-square calculation of the coefficients requires the model response
% on a sample of the input (the experimental design). UQLab can
% automatically calculate the response of the specified model on an optimal
% sample.
%
% Specify the full model to be used for the experimental design calculation:
metaopts.ExpDesign.Sampling = 'LHS';
metaopts.ExpDesign.NSamples = 150; % use 150 samples in the experimental design

%%
% Create and add the metamodel to UQLab
myPCE = uq_createModel(metaopts);

%% 5. VALIDATION OF THE RESULTS
% The deflection V at the 9 points is plotted for three random samples of
% the input random parameters. Relative length units are used for
% comparison, because L is one of the  input random variables.

%% 5.1 Create and evaluate the validation set
% Retrieve a sample of the input vector
Xval = uq_getSample(3);
%%
% Evaluate the full model on the sample
Y = uq_evalModel(Xval, myModel);
%%
% Evaluate the metamodel on the same sample
Y_PC = uq_evalModel(Xval, myPCE);

%% 5.2 Create plots
uq_figure('Position', [50 50 500 400]);
hold on;
myColors = uq_cmap(3); % use the UQLab colormap
% normalized positions 
li = 0:0.1:1;
% Loop over the realizations
for ii = 1 : size(Y,1)
    % plot each realization with a different colour
    uq_plot(li, [0,Y(ii,:),0], 'LineWidth',2, 'color', myColors(ii,:));
    uq_plot(li, [0,Y_PC(ii,:),0], '-.o',  'LineWidth',2, 'color', myColors(ii,:));
end
hold off
xlabel('L_{rel}')
ylabel('V (m)')
legend({'$\mathcal{M}(\mathbf{x}^{(1)})$', '$\mathcal{M}^{PC}(\mathbf{x}^{(1)})$',...
    '$\mathcal{M}(\mathbf{x}^{(2)})$', '$\mathcal{M}^{PC}(\mathbf{x}^{(2)})$',...
    '$\mathcal{M}(\mathbf{x}^{(3)})$', '$\mathcal{M}^{PC}(\mathbf{x}^{(3)})$'}, ...
    'interpreter', 'latex', 'location','north', 'fontsize',12)
