clear all
clc
close all 

T=1500;
dim = [8,20,20,10,4];

FF=1;
s0 = [ FF*[-40;0]+0.01*(2*rand(2,1)-1)  ; zeros(4,1) ; FF*10 ] ;
dd=true;

C = eye(7); 
D= zeros(7,1);

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
    
    S = norm(s{end}(1:3,1)-s0(1:3,1))
    if S<100
        dd=false;
    end
end

ss=[s{:}];
center = FF*[   0; 0; 15 ] ;
plotcube(center,1 , [10, 10,30], 'red' , 0.3)
hold on

center = FF*[ -40; 0; 0];
plotcube(center,1 , [0.1, 0.1, 0.001] , 'green' , 1)
hold on

color = '-g.' ;
plot3([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)],[s0(3,1) ss(3,:)], color, 'Linewidth', 0.75);
hold on
color = '-r.' ;
plot3([s0(7,1) ss(7,:)], zeros(1, T+1)  , zeros(1, T+1)    , color, 'Linewidth', 0.75); 


Param=net2param(net, dim);

clearvars -except Param

save('init20_20_10', 'Param')