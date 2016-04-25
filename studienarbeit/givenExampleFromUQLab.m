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

X = uq_getSample(6300,'MC',myInput);

%% Creation and Calculation of a gPC Quadrature Model

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Full';

numbSamplesQuad = zeros(1,10);
mean_quad = zeros(1,10);
sd_quad = zeros(1,10);
degree = zeros(1,10);
error_quad = zeros(1,10);
for k = 1:10
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

%% Creation and Calculation of a gPC Least-Square Model

%Calculation of a OLS regression model by sweeping the polynomial degree
MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.NSamples = 6300;
MetaOpts.ExpDesign.Sampling = 'MC';

mean_ols = zeros(1,10);
sd_ols = zeros(1,10);
degreeOLS = zeros(1,10);
%numbSamplesOls = zeros(1,10);
error_ols_D = zeros(1,10);

for n=1:10
    MetaOpts.Degree = n;
    PCE_OLS_D = uq_createModel(MetaOpts);
    mean_ols(n) = PCE_OLS_D.PCE.Moments.Mean;
    sd_ols(n) = sqrt(PCE_OLS_D.PCE.Moments.Var);
    error_ols_D(n) = PCE_OLS_D.Error.LOO;
    degreeOLS(n) = n;
end

%Calculation of a Model OLS Regression Model by sweeping the amount of
%samples ... did not lead to reasonable results...
% MetaOpts.Method = 'OLS';
% MetaOpts.Degree = 3;
% MetaOpts.ExpDesign.Sampling = 'MC';
%
% mean_ols_S = zeros(1,30);
% sd_ols_S = zeros(1,30);
% numbSamplesOls = zeros(1,30);
% error_ols_S = zeros(1,30);
% for h=1000:1000:30000
%     MetaOpts.ExpDesign.NSamples = h;
%     PCE_OLS_S = uq_createModel(MetaOpts);
%     mean_ols_S(h/1000) = PCE_OLS_S.PCE.Moments.Mean;
%     sd_ols_S(h/1000) = sqrt(PCE_OLS_S.PCE.Moments.Var);
%     error_ols_S(h/1000) = PCE_OLS_S.Error.LOO;
%     numbSamplesOls(h/1000) = h;
% end

MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.NSamples = 6300;
MetaOpts.ExpDesign.Sampling = 'MC';
MetaOpts.Degree = 6;
PCE_OLS = uq_createModel(MetaOpts);


%% Creation and Calculation of a Sparse Grid gPC Model

MetaOpts.Method = 'Quadrature';
MetaOpts.Quadrature.Type = 'Smolyak';

%Necessary to override MetaOpts.ExpDesign from obove 
MetaOpts.ExpDesign = [];

numbSamplesQuadSparse = zeros(1,10);
mean_quad_sparse = zeros(1,10);
sd_quad_sparse = zeros(1,10);
degreeSparse = zeros(1,10);
error_quad_sparse = zeros(1,10);
for k = 1:10
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


%% Creation and Calculation of a Least Angle Regression gPC Model

MetaOpts.Method = 'LARS';
%MetaOpts.LARS.LarsEarlyStop = 'False';
MetaOpts.ExpDesign.Sampling = 'MC';
MetaOpts.ExpDesign.NSamples = 6300;
MetaOpts.Quadrature = [];
MetaOpts.FullModel = [];

numbSamplesLARS = zeros(1,10);
mean_lars = zeros(1,10);
sd_lars = zeros(1,10);
degreeLARS = zeros(1,10);
error_lars = zeros(1,10);

for k =1:10
   MetaOpts.Degree = k;
   PCE_LARS = uq_createModel(MetaOpts);
   mean_lars(k) = PCE_LARS.PCE.Moments.Mean;
   sd_lars(k) = sqrt(PCE_LARS.PCE.Moments.Var);
   error_lars(k) = PCE_LARS.Error.LOO;
   degreeLARS(k) = k;
   
end

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
    subplot(1,3,1); hist(Y_full);
    title('Full');
    drawnow
    
    subplot(1,3,2);hist(Y_Quadrature);
    title('Quadrature');
    drawnow
    
    subplot(1,3,3); hist(Y_OLS);
    title('OLS');
    drawnow
    
    % Matlab release 2016
elseif ver(1) == '9'
    
    figure;
    subplot(1,3,1); histogram(Y_full,'FaceColor','b');
    drawnow
    
    subplot(1,3,2); histogram(Y_Quadrature,'FaceColor','r');
    drawnow
    
    subplot(1,3,3); histogram(Y_OLS,'FaceColor','g');
    drawnow
    
end
%% Calculation of the mean and the sd for y_full,y_quadrature and y_ols
y_mean = 1:size(X,1);
y_sd = 1:size(X,1);
y_mean_tot = mean(Y_full,1);
%y_sd_tot = sqrt(1/(length(Y_full)-1) *(sum(Y_full(:)-y_mean_tot).^2));
y_sd_tot = std(Y_full,1);

y_mean_ols = 1:size(X,1);
y_sd_ols = 1:size(X,1);
y_mean_tot_ols = mean(Y_OLS,1);

for j=1:size(X,1)
    y_mean(j) = mean(Y_full(1:j,1));
    %     y_sd(j) = sqrt(1/(length(y_mean(j)-1))*...
    %         sum(y_mean(j(:))-y_mean_tot).^2);
    y_sd(j) = std(Y_full(1:j,1));
    
    y_mean_ols(j) = mean(Y_OLS(1:j,1));
    %     y_sd_ols(j) = sqrt(1/(length(y_mean_ols(j)-1))*sum(y_mean_ols(j(:))-...
    %         y_mean_tot_ols).^2);
    y_sd_ols(j) = std(Y_OLS(1:j,1));
end

%% Plot of the respective mean
range = 1:size(X,1);

%Comparison Plot with all 3 methods
figure;
subplot(4,1,1);
uq_plot(range,y_mean,'b',numbSamplesQuad,mean_quad,'r',range,y_mean_ols,'g'),
%ylim([2 6]);
xlabel('Amount of Samples'), ylabel('Mean of the Ishigami Output');
legend('Mean of Y calc. with MC',...
    'Mean of Y calc. with Quadrature PC',...
    'Mean of Y calc. with OLS Regression');
title('Means of the Ishigami Function calc. with Different Methods');
drawnow

% Plot for MC
%figure;
subplot(4,1,2);
uq_plot(range,ones(size((range),2))*y_mean_tot);
%ylim([3.25 3.75]);
hold on;
uq_plot(y_mean,'b');
xlabel('Amount of Samples'), ylabel('Y_{Mean}_{MC}');
title('Convergence of the Mean via MC Simulation')
hold off;
drawnow

% Plot for Quadrature Method
%figure;
subplot(4,1,3);
uq_plot(numbSamplesQuad,mean_quad,'r');
xlabel('Amount of Samples'), ylabel('Mean of Y_Quadrature');
title('Convergence of the Mean via Quadrature gPC');
drawnow

% Plot for OLS Regression
%figure;
subplot(4,1,4);
uq_plot(range,ones(size((range),2))*y_mean_tot_ols);
%plot(range,mean_ols);
%ylim([2 4]);
hold on;
uq_plot(y_mean_ols,'g');
xlabel('Amount of Samples'),ylabel('Y_{Mean}_{OLS}');
title('Convergence of the Mean via OLS Regression gPC');
hold off;
drawnow
%% Plot of the respective SD

%Comparison Plot with all 3 methods
figure;
subplot(4,1,1);
uq_plot(range,y_sd,'b',numbSamplesQuad,sd_quad,'r',range,y_sd_ols,'g');

%ylim([-0.1 0.5])
xlabel('Amount of Samples'), ylabel('SD of the Ishigami Output');
legend('SD of Y calc. with MC','SD of Y calc. with Quadrature PC',...
    'SD of Y calc. with OLS Regression');
title('SDs of the Ishigami Function calc. with Different Methods');
drawnow

% Plot for MC
%figure;
subplot(4,1,2);
uq_plot(range,ones(size((range),2))*y_sd_tot);
%ylim([-0.1 0.25]);
hold on;
plot(y_sd,'b');
xlabel('Amount of Samples'), ylabel('Y_{SD}_{MC}');
title('Convergence of the SD via MC');
hold off;
drawnow

% Plot for Quadrature Method
%figure;
subplot(4,1,3);
uq_plot(numbSamplesQuad,sd_quad,'r');
xlabel('Amount of Samples'),ylabel('SD of the Y_Quadrature');
title('Convergence of the SD via Quadrature gPC');
drawnow

% Plot for OLS Regression
%figure;
subplot(4,1,4);
uq_plot(range,ones(size((range),2))*y_sd_tot);
%plot(range,sd_mean);
%ylim([-0.1 0.25]);
hold on;
uq_plot(range,y_sd_ols,'g');
xlabel('Amount of Samples'), ylabel('Y_{SD}_{OLS}');
title('Convergence of the SD via OLS Regression gPC');
drawnow


%% Plots for the Quadrature Method

figure;
subplot(3,1,1);
uq_plot(degree,mean_quad,'r');
xlabel('Polynomial Degree'), ylabel('Mean of Y_Quadrature');
title('Convergence of the Mean via Quadrature gPC');
drawnow

subplot(3,1,2);
uq_plot(degree,sd_quad,'r');
xlabel('Polynomial Degree'),ylabel('SD of Y_Quadrature');
title('Convergence of the SD via Quadrature gPC');
drawnow

%figure;
subplot(3,1,3);
uq_plot(degree,log10(error_quad),'r');
xlabel('Degree'),ylabel('log(error)');
title('Quadrature Error');

%% Plots for the OLS Regression Method

figure;
subplot(3,1,1);
uq_plot(degreeOLS,mean_ols,'g');
xlabel('Degrees'),ylabel('Mean of OLS');
drawnow

subplot(3,1,2);
uq_plot(degreeOLS,sd_ols,'g');
xlabel('Degrees'),ylabel('SD of OLS');
drawnow

subplot(3,1,3);
uq_plot(degreeOLS,log10(error_ols_D),'g');
xlabel('Degree'),ylabel('log(error)');
title('OLS Regression Error Depending on the Polynomial Degree');

figure;
uq_plot(degree,log10(error_quad),'r',degreeOLS,log10(error_ols_D),'g',...
    degreeSparse,log10(error_quad_sparse),'m',degreeLARS,...
    log10(error_lars),'c');
xlabel('Polynomial Degree'),ylabel('Log(Error)');
title(...
    'Comparision of the Error between the Gaussian Quadrature and the OLS Regression ');
legend('Gaussian Quadrature','OLS Regression','Sparse Quadrature');

% figure;
% subplot(1,2,1);
% plot(numbSamplesOls,mean_ols_S);
% xlabel('Sample Number'),ylabel('Mean of OLS');
% drawnow
%
% subplot(1,2,2);
% plot(numbSamplesOls,sd_ols_S);
% xlabel('Sample Number'),ylabel('SD of OLS');
% drawnow

% figure;
% semilogy(numbSamplesOls,error_ols_S);
% xlabel('Amount of Samples'),ylabel('log(error)');
% title('OLS Regression Error Depending on the Polynomial Degree');
%% Plots for the Sparse Quadrature Method

figure;
subplot(3,1,1);
uq_plot(degreeSparse,mean_quad_sparse,'m');
xlabel('Degrees'),ylabel('Mean Sparse Quad.');
drawnow

%figure;
subplot(3,1,2);
uq_plot(degreeSparse,sd_quad_sparse,'m');
xlabel('Degrees'),ylabel('SD Sparse Quad.');
drawnow

% figure;
subplot(3,1,3);
uq_plot(degreeSparse,log10(error_quad_sparse),'m');
xlabel('Degrees'),ylabel('log(Error)');
drawnow
%% Plots for the LARS 

figure;
subplot(3,1,1);
uq_plot(degreeLARS,mean_lars,'c');
xlabel('Degrees'),ylabel('Mean of the LARS');
drawnow

subplot(3,1,2);
uq_plot(degreeLARS,sd_lars,'c');
xlabel('Degrees'),ylabel('SD of LARS');
drawnow

subplot(3,1,3);
uq_plot(degreeLARS,error_lars,'c');
xlabel('Degrees'),ylabel('log(Error)');
drawnow

