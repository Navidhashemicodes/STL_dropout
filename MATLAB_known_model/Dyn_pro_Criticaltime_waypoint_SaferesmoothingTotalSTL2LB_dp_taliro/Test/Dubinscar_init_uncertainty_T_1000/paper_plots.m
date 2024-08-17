clear all
clc
close all
% 
% 

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'));


load('Result_Algo2_sampling.mat')


a =cell(1,T);
s = cell(1,T);

Param =param{iter};
[W, B, L] = param2net(Param, dim , 'tanh');
net.weights = W;
net.biases = B;
net.layers = L;

a{1} = NN(net, [C*s0+D;0], []);
s{1} = model([s0;a{1}]);
for i=2:T
    a{i} = NN(net, [C*s{i-1}+D;i-1], []);
    s{i} = model([s{i-1};a{i}]);
end



axis equal


ss=[s{:}];
color = '-g.' ;
plot([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)], color, 'Linewidth', 0.75);


hold on

Param =param{1};
[W, B, L] = param2net(Param, dim , 'tanh');
net.weights = W;
net.biases = B;
net.layers = L;

a{1} = NN(net, [C*s0+D;0], []);
s{1} = model([s0;a{1}]);
for i=2:T
    a{i} = NN(net, [C*s{i-1}+D;i-1], []);
    s{i} = model([s{i-1};a{i}]);
end



hold on

x = FF*[ 300; 700; 700; 300 ];
y = FF*[ 300; 300; 700; 700 ];
fill(x,y,'r', 'FaceAlpha', 0.3)


hold on

x = FF*[ 875; 925; 925; 875 ];
y = FF*[ 875; 875; 925; 925 ];
fill(x,y,'green', 'FaceAlpha', 0.3)

axis equal


ss=[s{:}];
color = '-r.' ;
plot([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)], color, 'Linewidth', 0.75);

axis equal
xlim([-50,100])
ylim([-50,100])

