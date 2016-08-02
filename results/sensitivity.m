%% Script for the calculation and depiction of the sensitivity for the respective methods

close all;
clear all;
clc;
uqlab

%% Sensitivity for Sparse Quadrature

load('resultsSparseQuad.mat');

PCESobol.Type = 'uq_sensitivity';
PCESobol.Method = 'Sobol';
%PCESobol.Options.M = 10;
PCESobol.Sobol.PCEBased = true;

% Maximum Order of the Sobol Indices
PCESobol.Sobol.Order = 1;
PCESobolAnalysisQuad = uq_createAnalysis(PCESobol);

clear all -except PCESobolAnalysisQuad;
%% Sensitivity for OLS
% Selection of the Sensitivity Tool: Sobol Indices
load('resultsOLSqNorm0.5.mat');
PCESobol.Type = 'uq_sensitivity';
PCESobol.Method = 'Sobol';

% Maximum Order of the Sobol Indices
PCESobol.Sobol.Order = 1;

PCESobolAnalysisOLS = uq_createAnalysis(PCESobol);

%% Sensitivity for LARS
clear all -except PCESobolAnalysisQuad PCESobolAnalysisOLS;

load('resultsLARSqNorm0.5Adaptive.mat');

PCESobol.Type = 'uq_sensitivity';
PCESobol.Method = 'Sobol';

% Maximum Order of the Sobol Indices
PCESobol.Sobol.Order = 1;

PCESobolAnalysisLAR = uq_createAnalysis(PCESobol);

%% Displaying the results

uq_display(PCESobolAnalysisQuad);
uq_display(PCESobolAnalysisOLS);
uq_display(PCESobolAnalysisLAR);
