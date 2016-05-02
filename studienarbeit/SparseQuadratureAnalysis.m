%% Evaluation of the Ishigami Function using the gPC Sparse Quadrature Method
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

%% Creation and Calculation of a Sparse Grid gPC Model

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Smolyak';

numbSamplesQuadSparse = zeros(1,15);
mean_quad_sparse = zeros(1,15);
sd_quad_sparse = zeros(1,15);
degreeSparse = zeros(1,15);
error_quad_sparse = zeros(1,15);
for k = 1:15
    MetaOpts.Degree = k;
    PCE_QuadratureSparse = uq_createModel(MetaOpts);
    numbSamplesQuadSparse(k) = PCE_QuadratureSparse.ExpDesign.NSamples;
    mean_quad_sparse(k) = PCE_QuadratureSparse.PCE.Moments.Mean;
    sd_quad_sparse(k) = sqrt(PCE_QuadratureSparse.PCE.Moments.Var);
    
    if PCE_QuadratureSparse.Error.normEmpError < 1e-20
        error_quad_sparse(k) = 0;
    else
        error_quad_sparse(k) = PCE_QuadratureSparse.Error.normEmpError;
    end
    degreeSparse(k) = k;
end

%% %% Evaluation of the Sparse Quadrature Method
% This evaluation you actually do not need, just in case you want to
% calculate the quadrature output for a particular sample set
X = uq_getSample(6300,'MC',myInput);
Y_SparseQuad = uq_evalModel(X,PCE_QuadratureSparse);

%Histogram for the output. Depending on the MATLAB version that is used the
%command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(Y_SparseQuad);
    title('OLS Regression');
    drawnow

%Matlab release 2016 
elseif ver(1) == '9'
    
    figure;
    histogram(Y_SparseQuad,'FaceColor','m');
    title('OLS Regression');
    drawnow
end


%% Plots for the Sparse Quadrature Method

figure;
subplot(2,1,1);
uq_plot(degreeSparse,mean_quad_sparse,'m');
xlabel('Degrees'),ylabel('Mean');
title('Mean Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesQuadSparse,mean_quad_sparse,'m');
xlabel('Amount of Samples'),ylabel('Mean');
title('Mean Convergence in Dependence on the Samp. Points');
drawnow

figure;
subplot(2,1,1);
uq_plot(degreeSparse,sd_quad_sparse,'m');
xlabel('Degrees'),ylabel('SD');
title('SD Convergence in Dependence on the Pol. Degree');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesQuadSparse,sd_quad_sparse,'m');
xlabel('Amount of Samples'),ylabel('SD');
title('SD Convergence in Dependence on the Samp. Points')
drawnow


figure;
subplot(2,1,1);
uq_plot(degreeSparse,log10(error_quad_sparse),'m');
xlabel('Degrees'),ylabel('log(Error)');
title('Sparse Quadrature Error');
drawnow

subplot(2,1,2);
uq_plot(numbSamplesQuadSparse,log10(error_quad_sparse),'m');
xlabel('Amount of Samples'),ylabel('log(error)');
title('Sparse Quadrature Error');
drawnow
