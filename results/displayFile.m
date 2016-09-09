%% Script for analysis of the obtained results
close all;
clear all;

%% Loading the results
uqlab;
load('resultsSparseQuad.mat');
load('resultsOLSqNorm0.5.mat');
load('resultsLARSqNorm0.5Adaptive.mat');
load('resultsTotalQuad.mat');

%% Displaying the results

% Mean Plots
figure;
uq_plot(numbSamplesQuad,mean_quad,'r-d',numbSamplesOLS,mean_OLS,'k-o',...
    numbSamplesLARS,mean_LARS,'b-^',...
    numbSamplesTotalQuad,mean_total_quad,'g-o');
xlabel('Amount of Evaluations'),ylabel('Mean Value');
legend('Sparse Quadrature','OLS','LAR','Total Quadrature');

figure;
uq_plot(degree,mean_quad,'r-d',degree,mean_OLS,'k-o',...
    degree,mean_LARS,'b-^', degree,mean_total_quad,'g-o');
    xlabel('Polynomial Degree'),ylabel('Mean Value');
    legend('Sparse Quadrature','OLS','LAR','Total Quadrature');
    


% SD Plot
figure;
uq_plot(numbSamplesQuad,sd_quad,'r-d',numbSamplesOLS,sd_OLS,'k-o',...
    numbSamplesLARS,sd_LARS,'b-^',numbSamplesTotalQuad,sd_total_quad,'g-o');
xlabel('Amount of Evaluations'),ylabel('SD');
legend('Sparse Quadrature','OLS','LAR','Total Quadrature','Location','southeast');

figure;
uq_plot(degree,sd_quad,'r-d',degree,sd_OLS,'k-o',degree,sd_LARS,'b-^');
xlabel('Polynomial Degree'),ylabel('SD');
legend('Sparse Qaudrature','OLS','LAR','Total Quadrature','Location','southeast');

% Sample Plot
figure;
uq_plot(degree,numbSamplesQuad,'r-d',degree,numbSamplesOLS,'k-o',...
    degree,numbSamplesLARS,'b-^',degree,numbSamplesTotalQuad,'g-o');
xlabel('Polynomial Degree'),ylabel('Amount of Samples');
legend('Sparse Quadrature','OLS','LARS','Total Quadrature','Location','northwest');


% Error Plot
figure;
uq_plot(numbSamplesQuad,error_quad,'r-d',numbSamplesOLS,error_OLS,'k-o',...
    numbSamplesLARS,error_LARS,'b-^',...
    numbSamplesTotalQuad,error_total_quad,'g-o');
xlabel('Amount of Evaluations'),ylabel('Error');
legend('Sparse Quadrature','OLS','LAR','Total Quadrature','Location','northwest');

figure;
uq_plot(degree,error_quad,'r-d',degree,error_OLS,'k-o',...
    degree,error_LARS,'b-^',degree,error_total_quad,'g-o');
xlabel('Polynomial Degree'),ylabel('Error');
legend('Sparse Quadrature','OLS','LAR','Total Quadrature','Location','northwest');
% ha3 = gca;
% set(ha3,'yscale','log');
% 
