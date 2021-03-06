%% Evaluation of the Ishigami Function using the gPC OLS Regression Method
%% Deleting everything before running the code
% clear variables;
% clc;
% close all;
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

%% Setup of PCE

MetaOpts.Type = 'uq_metamodel';
MetaOpts.MetaType = 'PCE';

% Type definition for the polynomials that are classicaly orthogonal
% regarding their distribution. By now, only the Hermite and Legendre are
% available.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

%% Creation and Calculation of a gPC Least-Square Model

%Calculation of a OLS regression model by sweeping the polynomial degree
MetaOpts.Method = 'OLS';

MetaOpts.ExpDesign.Sampling = 'MC';

mean_ols = zeros(1,15);
sd_ols = zeros(1,15);
degreeOLS = zeros(1,15);
error_ols = zeros(1,15);
numbOLSSamp = zeros(1,15);

% Sweeping over the polynomial degree
for n=1:15
    MetaOpts.Degree = n;
    % Expressing the amount of samples in dependece on the polynomial
    % degree...the higher the polynomial degree, the more samples you need,
    % but unforutunately this relation is not linear
    numbOLSSamp (n) = 3*nchoosek(MetaOpts.Degree+3,MetaOpts.Degree);
    MetaOpts.ExpDesign.NSamples = numbOLSSamp(n);
    PCE_OLS = uq_createModel(MetaOpts);
    mean_ols(n) = PCE_OLS.PCE.Moments.Mean;
    sd_ols(n) = sqrt(PCE_OLS.PCE.Moments.Var);
    
    if PCE_OLS.Error.LOO < 1e-20
        error_ols(n) = 0;
    else
         error_ols(n) = PCE_OLS.Error.normEmpError;
    end
    degreeOLS(n) = n;
end

%% Evaluation of the OLS Regression Method
% This evaluation you actually do not need, just in case you want to
% calculate the quadrature output for a particular sample set
% X = uq_getSample(6300,'MC',myInput);
% Y_OLS = uq_evalModel(X,PCE_OLS);

%Histogram for the output. Depending on the MATLAB version that is used the
%command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(PCE_OLS.ExpDesign.Y);
    %title('OLS Regression');
    drawnow

%Matlab release 2016 
elseif ver(1) == '9'
    
%     figure;
%     histogram(Y_OLS,'FaceColor','g');
%     title('OLS Regression');
%     drawnow

    figure;
    histogram(PCE_OLS.ExpDesign.Y,'FaceColor','g');
    %title('OLS Regression');
    drawnow
end


%% Plots for the OLS Regression Method

figure;
%subplot(2,1,1);
uq_plot(degreeOLS,mean_ols,'g');
xlabel('Polynomial Degree'),ylabel('Mean');
%title('Mean Convergence in Dependence on the Pol. Degree');
drawnow

figure;
%subplot(2,1,2);
uq_plot(numbOLSSamp,mean_ols,'g');
xlabel('Amount of Samples'),ylabel('Mean');
%title('Mean Convergence in Dependence on the Samp. Points');
drawnow


figure;
%subplot(2,1,1);
uq_plot(degreeOLS,sd_ols,'g');
xlabel('Polynomial Degree'),ylabel('SD');
%title('SD Convergence in Dependence on the Pol. Degree');
drawnow

figure;
%subplot(2,1,2);
uq_plot(numbOLSSamp,sd_ols,'g');
xlabel('Amount of Samples'),ylabel('SD');
%title('SD Convergence in Dependence on the Samp. Points');
drawnow

figure;
%subplot(2,1,1);
uq_plot(degreeOLS,error_ols,'g');
xlabel('Polynomial Degree'),ylabel('Error');
%xlim([0 15]);
%title('OLS Regression Error Depending on the Polynomial Degree');
drawnow

ha1 = gca;
set(ha1,'yscale','log');

figure;
%subplot(2,1,2);
uq_plot(numbOLSSamp,error_ols,'g');
xlabel('Amount of Samples'),ylabel('Error');
%title('OLS Regression Error Depending on the Polynomial Degree');
drawnow

ha2 = gca;
set(ha2,'yscale','log');