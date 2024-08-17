
clear all

clc

close all


load('Pavone5_1hour_unsuccessfull.mat')
Net.weights = net.weights;
Net.biases = net.biases;
dim = net.dims;
n = dim(1);
for i = 1:length(dim)-2
    L = cell(dim(i+1),1);
    L(:) = {'tanh'};
    Net.layers{i} = L ;
end

param = net2param(Net , dim);

load('hard.mat')

smooth = false;
hard = true;

s0s = [  [ 6 ; 8 ;  -3*pi/4 ]  ,  [ 6 ; 8 ;  -5*pi/8  ]  , [ 6 ; 8 ;  -4*pi/8 ]  ];
for i=1:3
    s0 = s0s(:,i);
    [~, Hard(i)] = STL_obj(s0, param, dim, 40, [], [] , STL2NN, smooth , hard);
end
result =  min(Hard)
