clear all
clc
close all 

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_no_taliro\src'));

T=60;


num_agent = 10;

L_x = 12;
L_y = 12;

N = floor(0.5*num_agent);
d = 1.35;
dd1 = (L_x-d)/N;
dd2 = (L_y-d)/(num_agent-N);

s0 = cell(1, num_agent);
center = cell(1, num_agent);
for i=1: num_agent

    if i<=N

        center{i} = [(i-1)*dd1+dd1/2 ; L_y-d];
        s0{i} = [L_x-(i-1)*dd1-dd1/2 ; d];

    else

        j = i-N;
        center{i} = [L_x-d ; (L_y-d)-(j-1)*dd2-dd2/2];
        s0{i} = [d; d+(j-1)*dd2+dd2/2];

    end

end


dim = [2*num_agent+1,2*num_agent+5,2*num_agent+5,2*num_agent];


s0 =[s0{:}];

s0 = reshape(s0, [numel(s0),1]);


C = eye(2*num_agent); 
D=  zeros(2*num_agent,1);

len = length(dim);

% load('10agents.mat')
% Param = param{iter};
load('random_init_submission');
[net.weights , net.biases, net.layers] = param2net(Param, [21,40,20], 'tanh');


% for i=1:len-1
%     net.weights{i} = 1*(2*rand(dim(i+1), dim(i))-1);
%     net.biases{i} =  1*( 2*rand(dim(i+1),1)-1);
%     if i<=len-2
%         L = cell(dim(i+1),1);
%         L(:) = {'tanh'};
%         net.layers{i} = L;
%     end
% end


a{1} = NN(net, [C*s0+D;0], []);
s{1} = model([s0;a{1}]);
for i=2:T
    a{i} = NN(net, [C*s{i-1}+D;i-1], []);
    s{i} = model([s{i-1};a{i}]);
end


ss=[s0 , [s{:}]];



figure(1)

for i=1:num_agent
    start = 2*(i-1)+1;
    plot(ss(start,:),ss(start+1,:))
    hold on
    plot(s0(start), s0(start+1), '*r')
end
    
axis equal




Param=net2param(net, dim);

clearvars -except Param

save('init_21_40_20', 'Param')