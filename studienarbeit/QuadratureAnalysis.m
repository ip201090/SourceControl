%% Evaluation of the Ishigami Function using the gPC Quadrature Method
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
% possible.
MetaOpts.PolyTypes = {'Legendre','Legendre','Legendre'};

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

% Creation of sample set, in case you want to test the quadrature method
% for this particular sample
%X = uq_getSample(6300,'MC',myInput);


%% Creation and Calculation of a gPC Quadrature Model

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Full';

numbSamplesQuad = zeros(1,15);
mean_quad = zeros(1,15);
sd_quad = zeros(1,15);
degree = zeros(1,15);
error_quad = zeros(1,15);
%Sweeping over the Polynomial Degree as this is the decisive variable for
%this method
for k = 1:15
    MetaOpts.Degree = k;
    PCE_Quadrature = uq_createModel(MetaOpts);
    numbSamplesQuad(k) = PCE_Quadrature.ExpDesign.NSamples;
    mean_quad(k) = PCE_Quadrature.PCE.Moments.Mean;
    sd_quad(k) = sqrt(PCE_Quadrature.PCE.Moments.Var);
    
    if PCE_Quadrature.Error.normEmpError < 1e-20
        error_quad(k) = 0;
    else
        error_quad(k) = PCE_Quadrature.Error.normEmpError;
    end
    degree(k) = k;
end

%% Evaluation of the Quadrature Method

% This evaluation you actually do not need, just in case you want to
% calculate the quadrature output for a particular sample set
%Y_Quadrature = uq_evalModel(X,PCE_Quadrature);

%Histogram for the output. Depending on the MATLAB version that is used the
%command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(PCE_Quadrature.ExpDesign.Y);
    title('Quadrature Method');
    drawnow

%Matlab release 2016 
elseif ver(1) == '9'
    
%     figure;
%     histogram(Y_Quadrature,'FaceColor','r');
%     title('Quadrature Method');
%     drawnow

    figure;
    histogram(PCE_Quadrature.ExpDesign.Y,'FaceColor','r');
    title('Quadrature Method');
    drawnow
end

%% Plots for the Quadrature Method

figure;
subplot(2,1,1);
uq_plot(degree,mean_quad,'r');
xlabel('Polynomial Degree'), ylabel('Mean');
title('Mean Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesQuad,mean_quad,'r');
xlabel('Amount of Samples'),ylabel('Mean');
title('Mean Convergence in Dependence on the Samp. Points');
drawnow

figure;
subplot(2,1,1);
uq_plot(degree,sd_quad,'r');
xlabel('Polynomial Degree'),ylabel('SD');
title('SD Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesQuad,sd_quad,'r');
xlabel('Amount of Samples'),ylabel('SD');
title('SD Convergence in Dependence on the Samp. Points')
drawnow

figure;
subplot(2,1,1);
uq_plot(degree,log10(error_quad),'r');
xlabel('Degree'),ylabel('log(error)');
title('Quadrature Error');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesQuad,log10(error_quad),'r');
xlabel('Amount of Samples'),ylabel('log(error)');
title('Quadrature Error');
drawnow
