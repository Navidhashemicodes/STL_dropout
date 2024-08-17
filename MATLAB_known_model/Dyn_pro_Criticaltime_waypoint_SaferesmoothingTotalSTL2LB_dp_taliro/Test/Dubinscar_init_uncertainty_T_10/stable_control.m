clear all
clc
close all 

T=10000;
FF=T/10000;


dim = [3,20,2];


s0 = FF*zeros(2,1);

dd=true;

C = eye(2); 
D= zeros(2,1);

len = length(dim);

while dd
    for i=1:len-1
        net.weights{i} = (2*randn(dim(i+1), dim(i))-1);
        net.biases{i} =  (2*randn(dim(i+1),      1)-1);
        if i<=len-2
            L = cell(dim(i+1),1);
            L(:) = {'tanh'};
            net.layers{i} = L;
        end
    end
    
    % load("init20.mat")
    % [W, B, L] = param2net(Param, dim , 'tanh');
    % net.weights = W;
    % net.biases = B;
    % net.layers = L;
    
    a{1} = NN(net, [C*s0+D;0], []);
    s{1} = model([s0;a{1}]);
    for i=2:T
        a{i} = NN(net, [C*s{i-1}+D;i-1], []);
        s{i} = model([s{i-1};a{i}]);
    end
    
    S = norm(s{end}-s0);
    if S<1500 && S>1200
        dd=false;
    end
end


x = FF*[-10; 10; 10;-10 ];
y = FF*[-10;-10; 10; 10 ];
fill(x,y,'blue', 'FaceAlpha', 0.3)

hold on

x = FF*[ 300; 700; 700; 300 ];
y = FF*[ 300; 300; 700; 700 ];
fill(x,y,'r', 'FaceAlpha', 0.3)


hold on

x = FF*[ 875; 925; 925; 875 ];
y = FF*[ 875; 875; 925; 925 ];
fill(x,y,'green', 'FaceAlpha', 0.3)

axis equal

xlim(FF*[-30, 1000])
ylim(FF*[-30, 1000])

ss=[s{:}];
color = '-g.' ;
plot([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)], color, 'Linewidth', 0.75);




Param=net2param(net, dim);

clearvars -except Param

save('init20', 'Param')