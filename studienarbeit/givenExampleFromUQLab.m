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

% Defaultly = standard trunction scheme with p = 3 ... we will stick to
% that. Otherwise we could change it with MetaOpts.Degree = x; For the
% sake of completeness we will denote it anyways
MetaOpts.Degree = 3;

% Specification of the input
MetaOpts.Input = myInput;

% Specification of the model...the used model will be all the time the
% Ishigami model that was created
MetaOpts.FullModel = myModel;

X = uq_getSample(10000,'MC');

%% Calculating the coefficients with different methods

% Used method: Quadrature
MetaOpts.Method = 'Quadrature';
PCE_Quadrature = uq_createModel(MetaOpts);

% % Used method: Least-Squares
MetaOpts.Method = 'OLS';
MetaOpts.ExpDesign.NSamples = 10000;
MetaOpts.ExpDesign.Sampling = 'MC';

PCE_OLS = uq_createModel(MetaOpts);

% Evaluation
Y_Quadrature = uq_evalModel(X,PCE_Quadrature);
Y_OLS = uq_evalModel(X,PCE_OLS);

% Reference value
Y_full = uq_evalModel(X, myModel);

figure;
plot(X,Y_full,'b')
xlabel('MC Samples'),ylabel('Y MC');


figure;
plot(X,Y_Quadrature,'r');
xlabel('MC Samples'),ylabel('Y Quadrature gPC');

figure;
plot(X,Y_OLS,'g');
xlabel('MC Sampel'),ylabel('Y OLS gPC');


%% Calculation of the mean and the sd for y_full,y_quadrature and y_ols
y_mean = 1:size(X,1);
y_sd = 1:size(X,1);
y_mean_tot = mean(Y_full,1);
y_sd_tot = sqrt(1/(length(Y_full)-1) *(sum(Y_full(:)-y_mean_tot)).^2);

y_mean_quad = 1:size(X,1);
y_sd_quad = 1:size(X,1);
y_mean_tot_quad = mean(Y_Quadrature);

y_mean_ols = 1:size(X,1);
y_sd_ols = 1:size(X,1);
y_mean_tot_ols = mean(Y_OLS);

for j=1:size(X,1)
    y_mean(j) = mean(Y_full(1:j,1));
    y_sd(j) = sqrt(1/(length(y_mean(j)-1))*sum(y_mean(j(:))-y_mean_tot).^2);
    
    y_mean_quad(j) = mean(Y_Quadrature(1:j,1));
    y_sd_quad(j) = sqrt(1/(length(y_mean_quad(j)-1))*sum(y_mean_quad(j(:))- ...
        y_mean_tot_quad).^2);
    
    y_mean_ols(j) = mean(Y_OLS(1:j,1));
    y_sd_ols(j) = sqrt(1/(length(y_mean_ols(j)-1))*sum(y_mean_ols(j(:))-...
        y_mean_tot_ols).^2);
    if(j>3)
         eoc_mean_mc(j) = ...
         log10(...
        abs((y_mean(j)-y_mean(j-1))/(y_mean(j-1)-y_mean(j-2))))...
             /...
             log10(...
             abs((y_mean(j-1)-y_mean(j-2))/(y_mean(j-2)-y_mean(j-3))));
%        eoc_mean_quad = log10(y_mean_quad(j)/y_mean_quad(j-1))/log10(j/(j-1));
%        eoc_mean_ols = log10(y_mean_ols(j)/y_mean_ols(j-1))/log10(j/(j-1));
%        
%        eoc_sd_mc = log10(y_sd(j)/y_sd(j-1))/log10(j/(j-1));
%        eoc_sd_quad = log10(y_sd_quad(j)/y_sd(j-1))/log10(j/(j-1));
%        eoc_sd_ols = log10(y_sd_ols(j)/y_sd(j-1))/log10(j/(j-1));
    end
end

%% Calculation of the eoc (estimated order of convergence)




%% Plot of the respective mean
range = 1:size(X,1);

figure;
plot(range,y_mean,'b',range,y_mean_quad,'r',range,y_mean_ols,'g'),
ylim([2 6]);
xlabel('Amount of Samples'), ylabel('Mean of the Ishigami Output');
legend('Mean of Y calc. with MC','Mean of Y calc. with Quadrature PC',...
    'Mean of Y calc. with OLS Regression');
title('Means of the Ishigami Function calc. with Different Methods');

figure;
plot(range,ones(size((range),2))*y_mean_tot);
ylim([3.25 3.75]);
hold on;
plot(y_mean,'b');
xlabel('Amount of Samples'), ylabel('Y_{Mean}_{MC}');
title('Convergence of the Mean via MC Simulation')
hold off;


figure;
plot(range,ones(size((range),2))*y_mean_tot_quad);
hold on;
plot(y_mean_quad,'r');
xlabel('Amount of Samples'),ylabel('Y_{Mean}_{Quadrature}');
title('Convergence of the Mean via Quadrature gPC');
hold off;

figure;
plot(range,ones(size((range),2))*y_mean_tot_ols);
ylim([2 4]);
hold on;
plot(y_mean_ols,'g');
xlabel('Amount of Samples'),ylabel('Y_{Mean}_{OLS}');
title('Convergence of the Mean via OLS Regression gPC');
hold off;
%% Plot of the respective SD

figure;
plot(range,y_sd,'b',range,y_sd_quad,'r',range,y_sd_ols,'g'),
ylim([-0.1 0.5])
xlabel('Amount of Samples'), ylabel('SD of the Ishigami Output');
legend('SD of Y calc. with MC','SD of Y calc. with Quadrature PC',...
    'SD of Y calc. with OLS Regression');
title('SDs of the Ishigami Function calc. with Different Methods');

figure;
plot(range,ones(size((range),2))*y_sd_tot);
ylim([-0.1 0.25]);
hold on;
plot(y_sd,'b');
xlabel('Amount of Samples'), ylabel('Y_{SD}_{MC}');
title('Convergence of the SD via MC');
hold off;

figure;
plot(range,ones(size((range),2))*y_sd_tot);
ylim([-0.1 0.25]);
hold on;
plot(y_sd_quad,'r')
xlabel('Amount of Samples'), ylabel('Y_{SD}_{Quadrature}');
title('Convergence of the SD via Quadrature gPC');

figure,
plot(range,ones(size((range),2))*y_sd_tot);
ylim([-0.1 0.25]);
hold on;
plot(range,y_sd_ols,'g');
xlabel('Amount of Samples'), ylabel('Y_{SD}_{OLS}');
title('Convergence of the SD via OLS Regression gPC');



