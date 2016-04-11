%% MODEL MODULE: COMPUTATIONAL MODELS WITH MULTIPLE OUTPUTS
% This example showcases the definition and usage of computational models with multiple 
% outputs. To this end the computational model of the deflection of a simply supported
% beam at several points along its length will be produced


%% 1 - CLEAR THE WORKSPACE AND INITIALIZE THE UQLAB FRAMEWORK 
clearvars
uqlab


%% 2 - COMPUTATIONAL MODEL
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


%% 4 - VISUALISATION OF THE COMPUTATIONAL MODEL

%%
% Retrieve 5 samples of the input vector
X = uq_getSample(5, 'LHS');

%%
% Evaluate the corresponding computational model responses
Y = uq_evalModel(X, myModel);

%%
% The output vector Y comprises of 5 realizations with 9 values each.
% Results are stored in a $5\times 9$ matrix.
Ysize = size(Y)

%% 
% The deflection V at the 9 points is plotted for the 5 samples generated 
% (in relative length units for comparison, as L is one of the 
% input random variables):
uq_figure('Position',[50 50 500 400]);
hold on;
myColors = uq_cmap(5); % use the UQLab colormap
% normalized positions 
li = 0:0.1:1;
% Loop over the realizations
for ii = 1 : size(Y,1)
    % plot each realization with a different colour
    uq_plot(li, [0,Y(ii,:),0], 'color', myColors(ii,:));
end
hold off
xlabel('L_{rel}')
ylabel('V (m)')

