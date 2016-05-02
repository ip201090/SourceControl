%% Starting Script for the Analysis of the Ishigami Function

%% Analysis using the Monte Carlo Method

mcAna = 'MCAnalysis.m';
run(mcAna);

%% Analysis using the Quadrature Method

quad = 'QuadratureAnalysis.m';
run(quad);

%% Analysis using the Least-Sqaures-Method

ols = 'OLSAnalysis.m';
run(ols);

%% Analysis using the Sparse-Quadrature-Method

sparseQuad = 'SparseQuadratureAnalysis.m';
run(sparseQuad);

%% Analysis using the Least-Angle-Regression-Method

lars = 'LARSAnalysis.m';
run(lars);



