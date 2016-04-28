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

%Obtaining a reference value, which will be computed just once and then
%hard coded
% X_ref = uq_getSample(1000000,'MC',myInput);
% Y_ref = uq_evalModel(X_ref,myModel);
% mean_ref = 1:size(X_ref,1);
% std_ref = 1:size(X_ref,1);
% for j=1:size(X_ref,1)
%     mean_ref(j) = mean(Y_ref(1:j,1));
%     std_ref (j) = std(Y_ref(1:j,1));
% end
% mean_ref(1000000)
% mean_ref_max = 3.5003;
% std_ref_max = 3.7227;
% 

range = 100:100:100000;
temp = length(range);
%X = zeros(1,temp);
%Y = zeros(1,temp);
y_mean = zeros(1,temp);
y_std = zeros(1,temp);


for k=100:100:100000
    X = uq_getSample(k,'MC',myInput);
    Y = uq_evalModel(X,myModel);
    y_mean(k/100) = mean(Y);
    y_std(k/100) = std(Y);

end

figure;
plot(range,y_mean,'b');

figure;
plot(range,y_std,'r');