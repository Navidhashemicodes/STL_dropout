clear all
clc
close all
% 
% 
load('Good_results_submitted.mat')

s=zeros(iter,len);
STL=zeros(1,Num);
for j=1:iter
    s(j,:)=param{j};
end


figure(1)
for j=1:len
    plot(s(:,j))
    hold on
end

figure(2)
plot([J2{1:iter}],'-g')
hold on 
plot([J1{1:iter}],'-b')


figure(3)

[W, B, L]  = param2net(param{iter}, dim, 'tanh');
net.weights = W; net.biases=B; net.layers = L;

[W, B, L]  = param2net(param{1}, dim, 'tanh');
Net.weights = W; Net.biases=B; Net.layers = L;


FF=0.1;

x = [50 50 50 41 50 54; 54 50 54 41 54 54; 54 41 45 45 45 45; 50 41 41 45 41 45]-10;
y = [10 10 10 22 10 13; 13 10 13 22 13 13; 13 22 25 25 25 25; 10 22 22 25 22 25]+5;
z = [10 10 25 10 10 10; 10 25 25 25 10 25; 25 25 25 25 10 25; 25 10 25 10 10 10]+7;

fill3(FF*x, FF*y, FF*z, 'green');
axis equal

hold on

x = [80 80 80 80 80 65; 80 80 80 80 80 65; 80 65 65 65 65 65; 80 65 65 65 65 65]+15;
y = [50 50 50 55 50 50; 55 55 50 55 55 50; 55 55 50 55 55 55; 50 50 50 55 50 55]+4;
z = [50 65 50 50 50 50; 50 65 65 65 50 65; 65 65 65 65 50 65; 65 65 50 50 50 50]-5;
fill3(FF*x, FF*y, FF*z, 'blue');
axis equal


x = [17 29 20 17 20 20; 20 32 32 29 32 32; 20 32 32 29 29 29; 17 29 20 17 17 17];
y = [84 93 80 84 80 80; 80 89 89 93 89 89; 80 89 89 93 93 93; 84 93 80 84 84 84]-5;
z = [20 20 20 20 35 20; 20 20 20 20 35 20; 35 35 35 35 35 20; 35 35 35 35 35 20];

fill3(FF*x, FF*y, FF*z, 'red');
axis equal
xlim(FF*[-100,100])
ylim(FF*[-50,100])
zlim(FF*[-100,150])

hold on
x = [ 1 -1  1  1  1  1; 1 -1  1  1 -1 -1;1 -1 -1 -1 -1 -1; 1 -1 -1 -1  1  1];
y = [-1 -1 -1  1  1  1; 1  1 -1  1  1  1;1  1 -1  1 -1 -1;-1 -1 -1  1 -1 -1];
z = [-1 -1 -1 -1 -1  1;-1 -1  1  1 -1  1;1  1  1  1 -1  1; 1  1 -1 -1 -1  1];

fill3(FF*x, FF*y, FF*z, 'blue', 'FaceAlpha', 0.3 );


% xlim(FF*[0,100])
% ylim(FF*[0,100])
% zlim(FF*[0,100])



for ii=1:KK

s0 = s0s(:,ii);

C = eye(12);
D= zeros(12,1);
a = cell(1,T);
s = cell(1,T);
a{1} = NN(net, [C*s0+D;0], []);
s{1} = model([s0;a{1}]);
for i=2:T
    a{i} = NN(net, [C*s{i-1}+D;i-1], []);
    s{i} = model([s{i-1};a{i}]);
end

ss=[s{:}];



color = '-g.' ;
plot3([s0(1,1) ss(1,:)],[s0(2,1) ss(2,:)],[s0(3,1) ss(3,:)], color, 'Linewidth', 0.75);

hold on

%%%%%%%%%%%%%%%%%%%


a2 = cell(1,T);
s2 = cell(1,T);
a2{1} = NN(Net, [C*s0+D;0], []);
s2{1} = model([s0;a2{1}]);
for i=2:T
    a2{i} = NN(Net, [C*s2{i-1}+D;i-1], []);
    s2{i} = model([s2{i-1};a2{i}]);
end
ss2=[s2{:}];
color = '-r.' ;
plot3([s0(1,1) ss2(1,:)],[s0(2,1) ss2(2,:)],[s0(3,1) ss2(3,:)], color, 'Linewidth', 0.75);

end


figure(4)
histogram(method(1:iter+1))
