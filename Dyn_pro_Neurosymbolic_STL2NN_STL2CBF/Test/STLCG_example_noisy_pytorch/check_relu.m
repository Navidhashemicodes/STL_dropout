clear all

close all

clc

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Neurosymbolic_STL2NN_STL2CBF\src'));


T=49;

load('trainedNN.mat')
Net.weights = net.weights;
Net.biases = net.biases;
dim = net.dims;
n = dim(1);
for i = 1:length(dim)-2
    L = cell(dim(i+1),1);
    L(:) = {'poslin'};
    Net.layers{i} = L ;
end


figure(1)

%%%%%  C
N=101;
x = zeros(1,N);
y = zeros(1,N);
r = 0.4;
for i=1:N
    thet = 2*pi*i/(N-1);
    
    x(i) = r*cos(thet);
    y(i) = r*sin(thet);
end
plot(x,y,'black')

hold on 
a = (2-sqrt(2))*r;
x0 = r-a; y0 = -r; x1 = r; y1 = a-r;
t=x0:0.001:x1;

m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
plot(t, -m*t-d , 'red');
% plot(t, ((y1-y0)/(x1-x0))*(t-x0)+y0 , 'red');

hold on 

x0 = r;   y0 = a-r; x1 = r; y1 =  r-a;
t=y0:0.001:y1;
plot(r*ones(size(t)), t , 'red');

hold on

x0 = r; y0 =  r-a; x1 = r-a; y1 =  r;
t=x0:-0.001:x1;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
plot(t, -m*t-d , 'red');

hold on 

x0 = r-a; y0 = r; x1 = a-r; y1 = r;
t=x0:-0.001:x1;
plot(t, r*ones(size(t)) , 'red');

hold on 

x0 = a-r; y0 = r; x1 = -r; y1 = r-a;
t=x0:-0.001:x1;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
plot(t, -m*t-d , 'red');


hold on 

x0 = -r; y0 = r-a; x1 = -r; y1 = a-r;
t=y0:-0.001:y1;
plot(-r*ones(size(t)),  t, 'red');


hold on 

x0 = -r; y0 = a-r; x1 = a-r; y1 = -r;
t=x0: 0.001:x1;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
plot(t, -m*t-d , 'red');

hold on 

x0 = a-r; y0 = -r; x1 = r-a; y1 = -r;
t=x0:0.001:x1;
plot(t, -r*ones(size(t)) , 'red');

%%%%%

%%%%  B1 

y = -0.2:0.01:0.5;
x= -1*ones(size(y));
plot(x,y,'green')
hold on
x= -0.7*ones(size(y));
plot(x,y,'green')
hold on
x = -1:0.01:-0.7;
y= -0.2*ones(size(x));
plot(x,y,'green')
hold on
y= 0.5*ones(size(x));
plot(x,y,'green')
hold on

%%%%%%%%%%%%%%

%%%%  B2 

y = -1:0.01:-0.5;
x= 0*ones(size(y));
plot(x,y,'blue')
hold on
x= 0.9*ones(size(y));
plot(x,y,'blue')
hold on
x = 0:0.01:0.9;
y= -1*ones(size(x));
plot(x,y,'blue')
hold on
y= -0.5*ones(size(x));
plot(x,y,'blue')
hold on

%%%%%%%%%%%%%%


%%%%  B3 

y = 0.8:0.01:1.2;
x= 0.2*ones(size(y));
plot(x,y,'red')
hold on
x= 0.7*ones(size(y));
plot(x,y,'red')
hold on
x = 0.2:0.01:0.7;
y= 0.8*ones(size(x));
plot(x,y,'red')
hold on
y= 1.2*ones(size(x));
plot(x,y,'red')
hold on

%%%%%%%%%%%%%%

axis equal

s0 =  zeros(2,1);
a0 = NN( Net , [s0;0] , []);
xx = zeros(2,T);
xx(:,1)=model( [ s0;a0]  );
a =zeros(2,T);
for ij=1:T-1
    a(:,ij)=NN(Net, [xx(:,ij);ij], []);
    xx(:,ij+1)=model([xx(:,ij);a(:,ij)]);
end

color = '-g.' ;
plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
hold on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Net0 = Net;
load('init_weights.mat')
Net0.weights = W;
load('init_biases.mat')
Net0.biases = b;


s0 =  zeros(2,1);
a0 = NN( Net0 , [s0;0] , []);
xx_init = zeros(2,T);
xx_init(:,1)=model( [ s0;a0]  );
a =zeros(2,T);
for ij=1:T-1
    a(:,ij)=NN(Net0, [xx_init(:,ij);ij], []);
    xx_init(:,ij+1)=model([xx_init(:,ij);a(:,ij)]);
end

color = '-black.' ;
plot([s0(1,1) xx_init(1,:)],[s0(2,1) xx_init(2,:)], color, 'Linewidth', 0.75);
hold on

