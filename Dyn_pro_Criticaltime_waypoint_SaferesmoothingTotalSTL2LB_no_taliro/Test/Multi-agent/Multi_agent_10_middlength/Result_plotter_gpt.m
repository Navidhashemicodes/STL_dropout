clear all
clc
close all


addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_no_taliro\src'));


load('10agent_T_60.mat')

n = size(s0,1);
[W,B,L] =param2net(param{iter}, dim , 'tanh');
net.weights = W;
net.biases = B;
net.layers = L;

len = numel(param{1});
S=zeros(iter,len);
STL=zeros(1,Num);
for j=1:iter-1
    S(j,:)=param{j};
end

figure(1)
for j=1:len
    plot(S(:,j))
    hold on
end

figure(2)
J = [J2{1:iter}];
plot(J(1:iter-1),'green')



[W,B,L] =param2net(param{iter+1}, dim , 'tanh');
net.weights = W;
net.biases = B;
net.layers = L;

figure(3)


num_agent = 10;

if num_agent>50
    error('update d')
end

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

SS0 = s0;

for i=1:num_agent

    y = center{i}(2)-d/3:0.01:center{i}(2)+d/3;
    x= (center{i}(1)-d/3)*ones(size(y));
    plot(x,y,'green', 'Linewidth', 3)
    hold on
    x= (center{i}(1)+d/3)*ones(size(y));
    plot(x,y,'green', 'Linewidth', 3)
    hold on
    x = center{i}(1)-d/3:0.01:center{i}(1)+d/3;
    y= (center{i}(2)-d/3)*ones(size(x));
    plot(x,y,'green', 'Linewidth', 3)
    hold on
    y= (center{i}(2)+d/3)*ones(size(x));
    plot(x,y,'green', 'Linewidth', 3)
    hold on

    plot(s0{i}(1), s0{i}(2), 'bo', 'Linewidth', 3)

end
axis equal
xlim([0,12])
ylim([0,12])



s0 =[s0{:}];

s0 = reshape(s0, [numel(s0),1]);


C = eye(2*num_agent); 
D=  zeros(2*num_agent,1);

len = length(dim);

a{1} = NN(net, [C*s0+D;0], []);
s{1} = model([s0;a{1}]);
for i=2:T
    a{i} = NN(net, [C*s{i-1}+D;i-1], []);
    s{i} = model([s{i-1};a{i}]);
end


ss=[s0 , [s{:}]];


for i=1:num_agent
    start = 2*(i-1)+1;
    plot(ss(start,:),ss(start+1,:))
    hold on
    plot(s0(start), s0(start+1), '*r')
end
    
xlim([-5,15])
ylim([-5,15])
drawnow
axis equal

drawnow


% Initialize figure outside the loop
% figure(4)
figure('Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);
pause(10)

% Constants and initializations
s0 = reshape(s0, [numel(s0),1]);
C = eye(2*num_agent); 
D = zeros(2*num_agent,1);
len = length(dim);

% Plot initial positions of agents and squares
for i = 1:num_agent
    % Plot the square around each agent
    rectangle('Position', [SS0{i}(1)-0.25, SS0{i}(2)-0.25, 0.5, 0.5], 'EdgeColor', 'blue')
    hold on
    % Plot the agent's initial position
    plot(SS0{i}(1), SS0{i}(2), 'b*')
    hold on
end

xlim([-5, 12])
ylim([-5, 12])
axis equal
drawnow

% Iterate through time steps
for time_step = 2:T
    % Clear the current figure
    clf
    % Plot squares and initial positions of agents
    for i = 1:num_agent
        % Plot the square around each agent
        % rectangle('Position', [SS0{i}(1)-0.25, SS0{i}(2)-0.25, 0.5, 0.5], 'EdgeColor', 'blue')
        % hold on
        % Plot the agent's initial position
        plot(SS0{i}(1), SS0{i}(2), 'go-')
        hold on
    end
    for i=1:num_agent
        
        y = center{i}(2)-d/3:0.01:center{i}(2)+d/3;
        x= (center{i}(1)-d/3)*ones(size(y));
        plot(x,y,'green', 'Linewidth', 3)
        hold on
        x= (center{i}(1)+d/3)*ones(size(y));
        plot(x,y,'green', 'Linewidth', 3)
        hold on
        x = center{i}(1)-d/3:0.01:center{i}(1)+d/3;
        y= (center{i}(2)-d/3)*ones(size(x));
        plot(x,y,'green', 'Linewidth', 3)
        hold on
        y= (center{i}(2)+d/3)*ones(size(x));
        plot(x,y,'green', 'Linewidth', 3)
        hold on
        
    end
    % Update agent positions
    a{time_step} = NN(net, [C*s{time_step-1}+D;time_step-1], []);
    s{time_step} = model([s{time_step-1};a{time_step}]);

    % Plot updated positions of agents
    for i = 1:num_agent
        start = 2*(i-1)+1;
        rectangle('Position', [s{time_step}(start,:)-0.25, s{time_step}(start+1,:)-0.25, 0.5, 0.5], 'EdgeColor', 'blue')
        hold on
        plot(s{time_step}(start,:), s{time_step}(start+1,:), 'b*')
        hold on
    end

    xlim([-5, 15])
    ylim([-5, 15])
    axis equal
    drawnow
    pause(0.75)
end


% % Initialize figure outside the loop
% figure(4)
% 
% % Constants and initializations
% s0 = reshape(s0, [numel(s0),1]);
% C = eye(2*num_agent); 
% D = zeros(2*num_agent,1);
% len = length(dim);
% 
% % Initialize arrays to store handles of squares
% square_handles = gobjects(num_agent, 1);
% 
% % Plot initial positions of agents and squares
% for i = 1:num_agent
%     % Plot the agent's initial position
%     plot(SS0{i}(1), SS0{i}(2), 'b*')
%     hold on
%     % Plot the square around each agent and store the handle
%     square_handles(i) = rectangle('Position', [SS0{i}(1)-0.25, SS0{i}(2)-0.25, 0.5, 0.5], 'EdgeColor', 'blue');
%     hold on
% end
% 
% xlim([-5, 15])
% ylim([-5, 15])
% axis equal
% drawnow
% 
% % Iterate through time steps
% for time_step = 2:T
%     % Clear the current figure
%     clf
%     % Plot initial positions of agents
%     for i = 1:num_agent
%         % Plot the agent's initial position
%         plot(SS0{i}(1), SS0{i}(2), 'b*')
%         hold on
%     end
% 
%     % Update agent positions
%     a{time_step} = NN(net, [C*s{time_step-1}+D;time_step-1], []);
%     s{time_step} = model([s{time_step-1};a{time_step}]);
% 
%     % Plot updated positions of agents and squares
%     for i = 1:num_agent
%         start = 2*(i-1)+1;
%         plot(s{time_step}(start,:), s{time_step}(start+1,:), 'b*')
%         hold on
%         % Update the position of the square to move with the agent
%         square_handles(i).Position = [s{time_step}(start,1)-0.25, s{time_step}(start,2)-0.25, 0.5, 0.5];
%     end
% 
%     xlim([-5, 15])
%     ylim([-5, 15])
%     axis equal
%     drawnow
% end
