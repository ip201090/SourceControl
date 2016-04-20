%% Evaluation of the Ishigami Function using 3 uniformly distributed inputs

%% Deleting everything before running the code
clear variables;
clc;
close all;
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


% Defaultly = standard trunction scheme with p = 3
MetaOpts.Degree = 6;

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

X = uq_getSample(10000,'MC',myInput);

%% Calculating the coefficients with different methods
%% Calculation for the gPC using Quadrature

% Used method: Quadrature (old way)to plot the histogram
MetaOpts.Method = 'Quadrature';

MetaOpts.Degree = 6;
PCE_Quadrature = uq_createModel(MetaOpts);

% new way
numbSamples = zeros(1,10);
mean_quad = zeros(1,10);
sd_quad = zeros(1,10);
degree = zeros(1,10);
for k = 1:10
    MetaOpts.Type = 'uq_metamodel';
    MetaOpts.MetaType = 'PCE';
    MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};
    MetaOpts.Method = 'Quadrature';
    MetaOpts.Degree = k;
    MetaOpts.Input = myInput;
    MetaOpts.FullModel = myModel;
    PCE_Quadrature_New = uq_createModel(MetaOpts);
    numbSamples(k) = PCE_Quadrature_New.ExpDesign.NSamples;
    mean_quad(k) = PCE_Quadrature_New.PCE.Moments.Mean;
    sd_quad(k) = sqrt(PCE_Quadrature_New.PCE.Moments.Var);
    degree(k) = k;
end
% MetaOpts.Degree = 6;
% PCE_Quadrature = uq_createModel(MetaOpts);
%% Creation of the Least-Square Model

% Used method: Least-Squares
MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.NSamples = 10000;
MetaOpts.ExpDesign.Sampling = 'MC';

PCE_OLS = uq_createModel(MetaOpts);

%% Evaluation of the Respective Method
Y_Quadrature = uq_evalModel(X,PCE_Quadrature);
Y_OLS = uq_evalModel(X,PCE_OLS);

% Reference value
Y_full = uq_evalModel(X, myModel);

% Histogram plots for the outputs respectively. Depending on the MATLAB
% version that is used, the command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(Y_full);
    drawnow
    
    figure;
    hist(Y_Quadrature);
    drawnow
    
    figure;
    hist(Y_OLS);
    drawnow
    
    % Matlab release 2016
elseif ver(1) == '9'
    figure;
    histogram(Y_full,'FaceColor','b');
    drawnow
    
    figure;
    histogram(Y_Quadrature,'FaceColor','r');
    drawnow
    
    figure;
    histogram(Y_OLS,'FaceColor','g');
    drawnow
    
end
%% Calculation of the mean and the sd for y_full,y_quadrature and y_ols
y_mean = 1:size(X,1);
y_sd = 1:size(X,1);
y_mean_tot = mean(Y_full,1);
y_sd_tot = sqrt(1/(length(Y_full)-1) *(sum(Y_full(:)-y_mean_tot)).^2);


y_mean_ols = 1:size(X,1);
y_sd_ols = 1:size(X,1);
y_mean_tot_ols = mean(Y_OLS);

for j=1:size(X,1)
    y_mean(j) = mean(Y_full(1:j,1));
    y_sd(j) = sqrt(1/(length(y_mean(j)-1))*sum(y_mean(j(:))-y_mean_tot).^2);
        
    y_mean_ols(j) = mean(Y_OLS(1:j,1));
    y_sd_ols(j) = sqrt(1/(length(y_mean_ols(j)-1))*sum(y_mean_ols(j(:))-...
        y_mean_tot_ols).^2);
    
    %     if(j>3)
    %          eoc_mean_mc(j) = ...
    %          log10(...
    %         abs((y_mean(j)-y_mean(j-1))/(y_mean(j-1)-y_mean(j-2))))...
    %              /...
    %              log10(...
    %              abs((y_mean(j-1)-y_mean(j-2))/(y_mean(j-2)-y_mean(j-3))));
    %        eoc_mean_quad = log10(y_mean_quad(j)/y_mean_quad(j-1))/log10(j/(j-1));
    %        eoc_mean_ols = log10(y_mean_ols(j)/y_mean_ols(j-1))/log10(j/(j-1));
    %
    %        eoc_sd_mc = log10(y_sd(j)/y_sd(j-1))/log10(j/(j-1));
    %        eoc_sd_quad = log10(y_sd_quad(j)/y_sd(j-1))/log10(j/(j-1));
    %        eoc_sd_ols = log10(y_sd_ols(j)/y_sd(j-1))/log10(j/(j-1));
    %       end
end

%% Plot of the respective mean
range = 1:size(X,1);

%Comparison Plot with all 3 methods
figure;
plot(range,y_mean,'b',numbSamples,mean_quad,'r',...
    range,y_mean_ols,'g'),
ylim([2 6]);
xlabel('Amount of Samples'), ylabel('Mean of the Ishigami Output');
legend('Mean of Y calc. with MC',...
    'Mean of Y calc. with Quadrature PC',...
    'Mean of Y calc. with OLS Regression');
title('Means of the Ishigami Function calc. with Different Methods');
drawnow

% Plot for MC 
figure;
plot(range,ones(size((range),2))*y_mean_tot);
ylim([3.25 3.75]);
hold on;
plot(y_mean,'b');
xlabel('Amount of Samples'), ylabel('Y_{Mean}_{MC}');
title('Convergence of the Mean via MC Simulation')
hold off;
drawnow

% Plot for Quadrature Method
figure;
plot(numbSamples,mean_quad,'r');
xlabel('Amount of Samples'), ylabel('Mean of Y_Quadrature');
title('Convergence of the Mean via Quadrature gPC');
drawnow

% Plot for OLS Regression
figure;
plot(range,ones(size((range),2))*y_mean_tot_ols);
ylim([2 4]);
hold on;
plot(y_mean_ols,'g');
xlabel('Amount of Samples'),ylabel('Y_{Mean}_{OLS}');
title('Convergence of the Mean via OLS Regression gPC');
hold off;
drawnow
%% Plot of the respective SD

%Comparison Plot with all 3 methods
figure;
plot(range,y_sd,'b',numbSamples,sd_quad,'r',range,y_sd_ols,'g'),
ylim([-0.1 0.5])
xlabel('Amount of Samples'), ylabel('SD of the Ishigami Output');
legend('SD of Y calc. with MC','SD of Y calc. with Quadrature PC',...
    'SD of Y calc. with OLS Regression');
title('SDs of the Ishigami Function calc. with Different Methods');
drawnow

% Plot for MC
figure;
plot(range,ones(size((range),2))*y_sd_tot);
ylim([-0.1 0.25]);
hold on;
plot(y_sd,'b');
xlabel('Amount of Samples'), ylabel('Y_{SD}_{MC}');
title('Convergence of the SD via MC');
hold off;
drawnow

% Plot for Quadrature Method
figure;
plot(numbSamples,sd_quad,'r');
xlabel('Amount of Samples'),ylabel('SD of the Y_Quadrature');
title('Convergence of the SD via Quadrature gPC');
drawnow

% Plot for OLS Regression
figure,
plot(range,ones(size((range),2))*y_sd_tot);
ylim([-0.1 0.25]);
hold on;
plot(range,y_sd_ols,'g');
xlabel('Amount of Samples'), ylabel('Y_{SD}_{OLS}');
title('Convergence of the SD via OLS Regression gPC');
drawnow


%% New Plots for the Quadrature Method

figure;
plot(degree,mean_quad);
xlabel('Polynomial Degree'), ylabel('Mean of Y_Quadrature');
title('Convergence of the Mean via Quadrature gPC');
drawnow


figure;
plot(degree,sd_quad);
xlabel('Polynomial Degree'),ylabel('SD of Y_Quadrature');
title('Convergence of the SD via Quadrature gPC');
drawnow


