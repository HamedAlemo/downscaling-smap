
% This code reads input data from SMAP 9km soil mositure estimates and
% NDVI estimates from MODIS to train a feed forward Neural Network to 
% downscale soil mositure estimates to 2.25 km EASE-Grid V2.0
%
% Details of the methodology is described in the following paper:
%
%
Alemohammad, S. H., Kolassa, J., Prigent, C., Aires, F., and Gentine, P.: 
% Global Downscaling of Remotely-Sensed Soil Moisture using Neural 
% Networks, Hydrol. Earth Syst. Sci. Discuss., 
% https://doi.org/10.5194/hess-2017-680, in review, 2018.
%
%
%
% Version: 1.0, Sep. 2018.
% Author:  S. Hamed Alemohammad, h.alemohammad@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clc
clear
close all

%% Read Inputs/Target
load('Target.mat', 'SMTarget');
load('Input.mat', 'SMInput', 'NDVIInput');


[inputs, target] = compile_training_data(SMInput, NDVIInput, SMTarget);
clear SMInput NDVIInput SMTarget 


%% Removing NaNs
[inputs, target] = removeNaN(inputs, target);

N = size(inputs, 2);
inputs = full(inputs(:, 1 : N));
target = full(target(:, 1 : N));

%% Parallel Toolbox Initiation
myCluster = parcluster('local');
myCluster.NumWorkers = 24;
saveProfile(myCluster);
parpool('local', 24)


%% NN Setup
hiddenLayerSize = 5 * ones(1, 1);
net = fitnet(hiddenLayerSize);

net.performFcn = 'mse';
net.trainParam.max_fail = 100; 
net.trainParam.min_grad = 1e-10;
net.trainParam.mu = 0.00001;  
net.trainParam.epochs = 5000; 
net.divideParam.trainRatio = 60/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 20/100;


%% Training

[net, tr] = train(net, inputs, target, 'useParallel', 'yes');

%% Prediction
output = net(inputs, 'useParallel', 'no');

% Performance
[output, target] = removeNaN(output, target);
r = corr(output', target');
perform = mean((output - target) .^ 2);

save('SMAP_DS.mat', 'net', 'tr', 'r', 'perform', 'output', 'inputs', 'target', '-v7.3')

