%% PCE METAMODELLING: SIMPLY SUPPORTED BEAM - ESTIMATION OF STATISTICAL MOMENTS
%  This example showcases an application of sparse PCE to the estimation of
%  the statistical moments of the mid-span deflection of a simply supported
%  beam subject to a uniform random load. The convergence behaviour of
%  PCE-based and pure Monte-Carlo based estimation of the statistical
%  moments is compared.


%% 1. CLEAR THE WORKSPACE AND INITIALIZE THE UQLAB FRAMEWORK
clearvars
uqlab
rng(100) % also set the random seed to a fixed value for repeatable results

%% 2. COMPUTATIONAL MODEL
% The simply supported beam model is shown in the following figure:
uq_figure; 
[I,map] = imread('SimplySupportedBeam.png');
imshow(I,map);
%truesize([300 400]);
%%
% The midspan deflection of the beam is given by 
%
% $$ V = \frac{5}{32} \frac{pL^4}{E b h^3} $$
%
% The function is available in UQLab in
% Examples\SimpleTestFunctions\uq_SimplySupportedBeam.m

%%
% Create a model object that uses the uq_SimplySupportedBeam function:
modelopts.mFile = 'uq_SimplySupportedBeam'; % specify the function name
myModel = uq_createModel(modelopts);        % create and add the model object to UQLab


%% 3. PROBABILISTIC INPUT MODEL
% The simply supported beam model has 5 inputs, modelled by independent 
% lognormal random variables. The detailed model is given in the following table:%
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


%% 5. MONTE-CARLO- VS PCE-BASED ESTIMATION OF MOMENTS
% The moments of a PCE can be analytically calculated from its coefficients
% without additional sampling. In this section mean and standard deviation
% estimates obtained from Monte-Carlo samples of increasing size are
% compared to the ones based on the PCE of the same samples.
% The simply supported beam model with lognormal input distributions allows
% for the explicit calculation of mean and standard deviation, which are
% provided for reference:
mean_exact = 0.008368320689566;
std_exact = 0.002538676671701;

%%
% Specify a set of experimental design sizes to test
NED = [50 100 150 200 500];

%%
% Initialize the arrays where the results will be stored
mean_MC = zeros(size(NED));
std_MC = zeros(size(NED));
mean_PCE = zeros(size(NED));
std_PCE = zeros(size(NED));

%% 
% Loop over the experimental design sizes
for ii = 1: length(NED)
    %%
    % Get a sample from the probabilistic input model with LHS sampling
    X_ED = uq_getSample(NED(ii), 'LHS') ;
    
    %%
    % Evaluate the full model on the current experimental design
    Y_ED = uq_evalModel(X_ED, myModel) ;
    
    %%
    % Calculate the moments of the experimental design
    mean_MC(ii) = mean(Y_ED);
    std_MC(ii) = std(Y_ED, 0 , 1);
    
    %%
    % Use the sample as the experimental design for the PCE
    metaopts.ExpDesign.X = X_ED;
    metaopts.ExpDesign.Y = Y_ED;
    
    %%
    % Create and add the PCE metamodel to UQLab
    myPCE = uq_createModel(metaopts);
    
    %%
    % Retrieve the mean and standard deviation calculated from the PCE
    % coefficients
    mean_PCE(ii) = myPCE.PCE.Moments.Mean;
    std_PCE(ii) = sqrt(myPCE.PCE.Moments.Var);
end


%% 6. CONVERGENCE PLOTS
%%
% Plot the convergence of the mean estimates for both MCS and PCE
uq_figure('Position', [50 50 500 400]);
myColors = uq_cmap(2);
semilogy(NED, abs(mean_MC/mean_exact - 1), '-','Linewidth', 2, 'Color', myColors(1,:));
hold on
semilogy(NED, abs(std_MC/std_exact - 1),'--','Linewidth', 2, 'Color', myColors(1,:));
semilogy(NED, abs(mean_PCE/mean_exact - 1),'-', 'Color', myColors(2,:));
semilogy(NED, abs(std_PCE/std_exact - 1),'--', 'Linewidth', 2, 'Color', myColors(2,:));
hold off;
xlabel('$N$', 'Interpreter','latex', 'fontsize',24) % Add proper labelling and a legend
legend({'$|\hat{\mu}_Y^{MC} / \mu_Y - 1 |$',...
    '$|\hat{\sigma}_Y^{MC} / \sigma_Y - 1 |$', ...
    '$|\hat{\mu}_Y^{PC} / \mu_Y - 1 |$', ...
    '$|\hat{\sigma}_Y^{PC} / \sigma_Y - 1 |$'}, ...
    'Interpreter','latex','fontsize',20, 'location', 'SouthWest')
grid on;
ylim([1e-8 1])
drawnow()
