%% Evaluation of the Ishigami Function using the gPC LARS Method
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

%% Creation and Calculation of a Least Angle Regression gPC Model

MetaOpts.Method = 'LARS';
%MetaOpts.LARS.LarsEarlyStop = 'False';
MetaOpts.ExpDesign.Sampling = 'MC';

numbSamplesLARS = zeros(1,15);
mean_lars = zeros(1,15);
sd_lars = zeros(1,15);
degreeLARS = zeros(1,15);
error_lars = zeros(1,15);

for k =1:15
   MetaOpts.Degree = k;
   numbSamplesLARS(k) = k*100;
   MetaOpts.ExpDesign.NSamples = numbSamplesLARS(k);
   PCE_LARS = uq_createModel(MetaOpts);
   mean_lars(k) = PCE_LARS.PCE.Moments.Mean;
   sd_lars(k) = sqrt(PCE_LARS.PCE.Moments.Var);
   error_lars(k) = PCE_LARS.Error.LOO;
   degreeLARS(k) = k;
   
end

%% %% %% Evaluation of the LARS Method
% This evaluation you actually do not need, just in case you want to
% calculate the quadrature output for a particular sample set
%X = uq_getSample(6300,'MC',myInput);
%Y_LARS = uq_evalModel(X,PCE_LARS);

%Histogram for the output. Depending on the MATLAB version that is used the
%command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(PCE_LARS.ExpDesign.Y,'FaceColor','c');
    title('LARS');
    drawnow

%Matlab release 2016 
elseif ver(1) == '9'
    
%     figure;
%     histogram(Y_LARS,'FaceColor','c');
%     title('LARS');
%     drawnow
    
    figure;
    histogram(PCE_LARS.ExpDesign.Y,'FaceColor','c');
    title('LARS');
    drawnow
end

%% Plots for the LARS 

figure;
subplot(2,1,1);
uq_plot(degreeLARS,mean_lars,'c');
xlabel('Degrees'),ylabel('Mean of LARS');
title('Mean Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesLARS,mean_lars,'c');
xlabel('Amount of Samples'),ylabel('Mean of LARS');


figure;
subplot(2,1,1);
uq_plot(degreeLARS,sd_lars,'c');
xlabel('Degrees'),ylabel('SD of LARS');
title('SD Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesLARS,sd_lars,'c');
xlabel('Amount of Samples'),ylabel('SD of LARS');
title('SD Convergence in Dependence on the Amount of Samples');
drawnow

figure;
subplot(2,1,1);
uq_plot(degreeLARS,log10(error_lars),'c');
xlabel('Degrees'),ylabel('log(Error)');
title('LARS Error');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesLARS,log10(error_lars),'c');
xlabel('Amount of Samples'),ylabel('log(Error)');
title('LARS Error');
drawnow


