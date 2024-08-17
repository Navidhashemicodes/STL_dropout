clear all
clc
close all 

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'))
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'))

load('Good_results_submitted.mat')
Param = param{iter};
Param0 = param{1};
clearvars -except Param  Param0  phi  Pred

T=45;
dim = [13,20,20,10,4];

[W, B, L]  = param2net(Param, dim, 'tanh');
net.weights = W; net.biases=B; net.layers = L;
FF=0.1;
s0 = zeros(12,1) ;

C = eye(12);
D= zeros(12,1);
a{1} = NN(net, [C*s0+D;0], []);
s{1} = model([s0;a{1}]);
for i=2:T
    a{i} = NN(net, [C*s{i-1}+D;i-1], []);
    s{i} = model2([s{i-1};a{i}]);
end

ss=[s{:}];

x = [50 50 50 41 50 54; 54 50 54 41 54 54; 54 41 45 45 45 45; 50 41 41 45 41 45]-10;
y = [10 10 10 22 10 13; 13 10 13 22 13 13; 13 22 25 25 25 25; 10 22 22 25 22 25]+5;
z = [10 10 25 10 10 10; 10 25 25 25 10 25; 25 25 25 25 10 25; 25 10 25 10 10 10]+7;
c = ones(size(x));
fill3(FF*x, FF*y, FF*z, c);
axis equal

hold on

x = [80 80 80 80 80 65; 80 80 80 80 80 65; 80 65 65 65 65 65; 80 65 65 65 65 65]+15;
y = [50 50 50 55 50 50; 55 55 50 55 55 50; 55 55 50 55 55 55; 50 50 50 55 50 55]+4;
z = [50 65 50 50 50 50; 50 65 65 65 50 65; 65 65 65 65 50 65; 65 65 50 50 50 50]-5;
c = ones(size(x));
fill3(FF*x, FF*y, FF*z, c);
axis equal


x = [17 29 20 17 20 20; 20 32 32 29 32 32; 20 32 32 29 29 29; 17 29 20 17 17 17];
y = [84 93 80 84 80 80; 80 89 89 93 89 89; 80 89 89 93 93 93; 84 93 80 84 84 84]-5;
z = [20 20 20 20 35 20; 20 20 20 20 35 20; 35 35 35 35 35 20; 35 35 35 35 35 20];
c = ones(size(x));
fill3(FF*x, FF*y, FF*z, c);
axis equal
xlim(FF*[-100,100])
ylim(FF*[-50,100])
zlim(FF*[-100,150])

% xlim(FF*[0,100])
% ylim(FF*[0,100])
% zlim(FF*[0,100])


color = '-g.' ;
plot3([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)],[s0(3,1) ss(3,:)], color, 'Linewidth', 0.75);

hold on

%%%%%%%%%%%%%%%%%%%

[W, B, L]  = param2net(Param0, dim, 'tanh');
Net.weights = W; Net.biases=B; Net.layers = L;

a2{1} = NN(Net, [C*s0+D;0], []);
s2{1} = model([s0;a2{1}]);
for i=2:T
    a2{i} = NN(Net, [C*s2{i-1}+D;i-1], []);
    s2{i} = model2([s2{i-1};a2{i}]);
end
ss2=[s2{:}];
color = '-r.' ;
plot3([s0(1,1) ss2(1,:)],[s0(2,1) ss2(2,:)],[s0(3,1) ss2(3,:)], color, 'Linewidth', 0.75);






% n=12;
% m=4;
% 
% KK=500000;
% s0s = s0 + [  0.1*(2*rand(3,KK)-1);   zeros(9,KK)  ]; 
% xx = cell(1,KK);
% Trajectory = zeros(n*(T+1), KK);
% rho = zeros(1,KK);
% parfor i=1:KK
%     s0 =  s0s(:,floor(KK*rand)+1);
%     a0 = NN( net , [s0;0] , []);
%     xx{i} = zeros(n,T);
%     xx{i}(:,1)=model( [ s0;a0]  );
%     a =zeros(m,T);
%     for ij=1:T-1
%         a(:,ij)=NN(net, [xx{i}(:,ij);ij], []);
%         xx{i}(:,ij+1)=model([xx{i}(:,ij);a(:,ij)]);
%     end
% 
%     Traj = [s0 xx{i}(:,1:T)];
%     % Trajectory(:,i) = reshape( Traj , [numel(Traj) , 1]);
%     
%     % Trajectory  = [s0 , [s{:}]];
%     times = 0:1:T;
%     rho(i) =dp_taliro(phi,Pred,Traj',times');
% 
% end
% figure(4)
% plot(rho)
% min(rho)
