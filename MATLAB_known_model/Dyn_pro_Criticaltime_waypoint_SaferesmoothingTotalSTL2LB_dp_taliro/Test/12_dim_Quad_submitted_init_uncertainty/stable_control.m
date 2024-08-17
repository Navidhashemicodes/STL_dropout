clear all
clc
close all 


addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'))


T=100;
dim = [13,20,20,10,4];

FF=0.5;
s0 = zeros(12,1) ;
dd=true;

C = eye(12); 
D= zeros(12,1);

len = length(dim);

while dd
    for i=1:len-1
        net.weights{i} = 0.2*randn(dim(i+1), dim(i));%(2*rand(dim(i+1), dim(i))-1);
        net.biases{i} =0.2*randn(dim(i+1),1);%( 2*rand(dim(i+1),1)-1);
        if i<=len-2
            L = cell(dim(i+1),1);
            L(:) = {'tanh'};
            net.layers{i} = L;
        end
    end
    
    a{1} = NN(net, [C*s0+D;0], []);
    s{1} = model([s0;a{1}]);
    for i=2:T
        a{i} = NN(net, [C*s{i-1}+D;i-1], []);
        s{i} = model([s{i-1};a{i}]);
    end
    
    S = norm(s{end}(1:3,1)-s0(1:3,1));
    if S<FF*170
        dd=false;
    end
end

ss=[s{:}];

x = [50 50 50 41 50 54; 54 50 54 41 54 54; 54 41 45 45 45 45; 50 41 41 45 41 45];
y = [10 10 10 22 10 13; 13 10 13 22 13 13; 13 22 25 25 25 25; 10 22 22 25 22 25];
z = [10 10 25 10 10 10; 10 25 25 25 10 25; 25 25 25 25 10 25; 25 10 25 10 10 10];
c = ones(size(x));
fill3(FF*x, FF*y, FF*z, c);
axis equal

hold on

x = [80 80 80 80 80 65; 80 80 80 80 80 65; 80 65 65 65 65 65; 80 65 65 65 65 65];
y = [50 50 50 55 50 50; 55 55 50 55 55 50; 55 55 50 55 55 55; 50 50 50 55 50 55];
z = [50 65 50 50 50 50; 50 65 65 65 50 65; 65 65 65 65 50 65; 65 65 50 50 50 50];
c = ones(size(x));
fill3(FF*x, FF*y, FF*z, c);
axis equal


x = [17 29 20 17 20 20; 20 32 32 29 32 32; 20 32 32 29 29 29; 17 29 20 17 17 17];
y = [84 93 80 84 80 80; 80 89 89 93 89 89; 80 89 89 93 93 93; 84 93 80 84 84 84];
z = [20 20 20 20 35 20; 20 20 20 20 35 20; 35 35 35 35 35 20; 35 35 35 35 35 20];
c = ones(size(x));
fill3(FF*x, FF*y, FF*z, c);
axis equal
% xlim(FF*[0,100])
% ylim(FF*[0,100])
% zlim(FF*[-100,100])


color = '-g.' ;
plot3([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)],[s0(3,1) ss(3,:)], color, 'Linewidth', 0.75);


Param=net2param(net, dim);

clearvars -except Param

save('init20_20_10', 'Param')