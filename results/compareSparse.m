%% Script to compare the results obtained by the enhanced sparse models
close all;
clear all;

%% Loading the results
uqlab;
load('Sparse3RV.mat');
load('sparse4RV.mat');
load('sparse5RV.mat');
load('sparse6RV.mat');
load('sparse7RV.mat');
load('sparse8RV.mat');

figure;
uq_plot(numbSamples_3RV,error_3RV,'r',numbSamples_4RV,error_4RV,'b',...
    numbSamples_5RV,error_5RV,'g',numbSamples_6RV,error_6RV,'c',...
    numbSamples_7RV,error_7RV,'m',numbSamples_8RV,error_8RV,'k');
xlabel('Amount of Evaluations'),ylabel('Error');
legend('3RV','4RV','5RV','6RV','7RV','8RV');