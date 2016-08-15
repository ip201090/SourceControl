%% Script to display the results for the sensitivity analysis

close all;
clear all;
uqlab
%% Loading the necessary files

load('sensitivityQuad');
load('sensitivityOLS');
load('sensitivityLAR');

% Displaying the Total Sobol Indices
% figure;
% uq_bar((1:10) -.25,PCESobolAnalysisQuadrature.Results.Total,0.4,'r');
% hold on;
% uq_bar((1.25:1:10.25),PCESobolAnalysisOLS.Results.Total,0.4,'k');
% hold on;
% uq_bar((1.5:1:10.5),PCESobolAnalysisLARS.Results.Total,0.5,'b');
% ylim([0 1]);
% set(gca, 'xtick', 1:length(IOpts.Marginals), 'xticklabel', PCESobolAnalysisQuadrature.Results.VariableNames, 'fontsize',14);
% xlabel('Variable name', 'fontsize', 14)

y = zeros(10,3);
a = zeros(10,3);
for i=1:10
    for j=1:3
       switch j
           case 1
             y(i,j) = PCESobolAnalysisQuadrature.Results.Total(i);
             a(i,j) = PCESobolAnalysisQuadrature.Results.FirstOrder(i);
           case 2
             y(i,j) = PCESobolAnalysisOLS.Results.Total(i);
             a(i,j) = PCESobolAnalysisOLS.Results.Total(i);
           case 3
               y(i,j) = PCESobolAnalysisLARS.Results.Total(i);
               a(i,j) = PCESobolAnalysisLARS.Results.FirstOrder(i);
       end
    end
end

figure;
b = bar(y,1.5,'group');
b(1).FaceColor = 'red';
b(2).FaceColor = 'black';
b(3).FaceColor = 'blue';
set(gca, 'xtick', 1:length(IOpts.Marginals), 'xticklabel', PCESobolAnalysisQuadrature.Results.VariableNames, 'fontsize',16);
xlabel('Uncertainties', 'fontsize', 16,'FontWeight','bold');
ylabel('Total Sobol Indice','fontsize',16,'FontWeight','bold');
legend('Sparse Quadrature','OLS','LAR','Location','northwest');
grid on;

figure;
c = bar(a,1.5,'group');
c(1).FaceColor = 'red';
c(2).FaceColor = 'black';
c(3).FaceColor = 'blue';
set(gca, 'xtick', 1:length(IOpts.Marginals), 'xticklabel', PCESobolAnalysisQuadrature.Results.VariableNames, 'fontsize',16);
xlabel('Uncertainties', 'fontsize', 16,'FontWeight','bold');
ylabel('First Order Sobol Indice','fontsize',16,'FontWeight','bold');
legend('Sparse Quadrature','OLS','LAR','Location','northwest');
grid on;