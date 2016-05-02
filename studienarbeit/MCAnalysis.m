%% Evaluation of the Ishigami Function using the Monte Carlo Method
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

%Reference values
mean_ref = 3.4949;
std_ref = 3.7185;


%% Evaluation of the Ishigami Function

range = 1:10000;
temp = length(range);
%X = zeros(1,temp);
%Y = zeros(1,temp);
y_mean = zeros(1,temp);
y_std = zeros(1,temp);


for k=1:10000
    X = uq_getSample(k,'MC',myInput);
    Y = uq_evalModel(X,myModel);
    y_mean(k) = mean(Y);
    y_std(k) = std(Y);
end



mean_rel_error(:) = abs(y_mean(:)-mean_ref)./mean_ref;
std_rel_error(:) = abs(y_std(:)-std_ref)./std_ref;


%% Plotting the Results


%Histogram for the output. Depending on the MATLAB version that is used the
%command for the histogramms is different
ver = version;

% Matlab release 2014
if ver(1) == '8'
    
    figure;
    hist(Y);
    title('MC ');
    drawnow

%Matlab release 2016 
elseif ver(1) == '9'
    
    figure;
    histogram(Y,'FaceColor','b');
    title('MC');
    drawnow
end

figure;
uq_plot(range,y_mean,'b');
xlabel('Amount of Sample Points'),ylabel('Mean of MC Analysis');
title('Mean of MC Analysis');

figure;
uq_plot(range,y_std,'b');
xlabel('Amount of Sample Points'),ylabel('SD of MC Analysis');
title('SD of MC Analysis')

figure;
uq_plot(range,mean_rel_error);
xlabel('Amount of Sample Points'),ylabel('rel. Mean Error');
title('Rel. Mean Error');

figure;
uq_plot(range,std_rel_error);
xlabel('Amount of Sample Points'),ylabel('rel. SD Error');
title('Rel. SD Error');
