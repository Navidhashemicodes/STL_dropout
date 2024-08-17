clear all
clc
close all
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Neurosymbolic_STL2NN_STL2CBF\src'));
load('STL2CBF_b30_Test_STL_wiser_STLCG_noisy_badinit_strong_controller_0point001.mat')
n = size(s0,1);
[W,B,L] =param2net(param{iter}, dim , 'tanh');
Net.weights = W;
Net.biases = B;
Net.layers = L;


S=zeros(iter-1,len);
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
J = [J2_smooth{:}];
plot(J(1:iter),'black')
hold on
J= [J2_hard{:}];
plot(J(1:iter),'green')

avg = zeros(2,1);
cov = 0.001*eye(2);
% cov = 0.00*eye(2);
init_varation = 0.0005;
% init_varation = 0.0;
dt = 0.1;
KK = 100;
KK2 = 1000;

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
for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'black')
end

hold on 
a = (2-sqrt(2))*r;
x0 = r-a; y0 = -r; x1 = r; y1 = a-r;
t=x0:0.001:x1;

m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;

for jf =3:8
    figure(jf)
    hold on
    plot(t, -m*t-d , 'red');
end



hold on 

x0 = r;   y0 = a-r; x1 = r; y1 =  r-a;
t=y0:0.001:y1;

for jf =3:8
    figure(jf)
    hold on
    plot(r*ones(size(t)), t , 'red');
end


hold on

x0 = r; y0 =  r-a; x1 = r-a; y1 =  r;
t=x0:-0.001:x1;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;

for jf =3:8
    figure(jf)
    hold on
    plot(t, -m*t-d , 'red');
end


hold on 

x0 = r-a; y0 = r; x1 = a-r; y1 = r;
t=x0:-0.001:x1;

for jf =3:8
    figure(jf)
    hold on
    plot(t, r*ones(size(t)) , 'red');
end


hold on 

x0 = a-r; y0 = r; x1 = -r; y1 = r-a;
t=x0:-0.001:x1;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;


for jf =3:8
    figure(jf)
    hold on
    plot(t, -m*t-d , 'red');
end



hold on 

x0 = -r; y0 = r-a; x1 = -r; y1 = a-r;
t=y0:-0.001:y1;

for jf =3:8
    figure(jf)
    hold on
    plot(-r*ones(size(t)),  t, 'red');
end



hold on 

x0 = -r; y0 = a-r; x1 = a-r; y1 = -r;
t=x0: 0.001:x1;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;

for jf =3:8
    figure(jf)
    hold on
    plot(t, -m*t-d , 'red');
end


hold on 

x0 = a-r; y0 = -r; x1 = r-a; y1 = -r;
t=x0:0.001:x1;


for jf =3:8
    figure(jf)
    hold on
    plot(t, -r*ones(size(t)) , 'red');
end


%%%%%

%%%%  B1 

y = -0.2:0.01:0.5;
x= -1*ones(size(y));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'green')
end

hold on
x= -0.7*ones(size(y));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'green')
end

hold on
x = -1:0.01:-0.7;
y= -0.2*ones(size(x));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'green')
end

hold on
y= 0.5*ones(size(x));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'green')
end

hold on

%%%%%%%%%%%%%%

%%%%  B2 

y = -1:0.01:-0.5;
x= 0*ones(size(y));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'blue')
end

hold on
x= 0.9*ones(size(y));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'blue')
end

hold on
x = 0:0.01:0.9;
y= -1*ones(size(x));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'blue')
end

hold on
y= -0.5*ones(size(x));
for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'blue')
end
hold on

%%%%%%%%%%%%%%


%%%%  B3 

y = 0.8:0.01:1.2;
x= 0.2*ones(size(y));
for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'red')
end
hold on
x= 0.7*ones(size(y));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'red')
end

hold on
x = 0.2:0.01:0.7;
y= 0.8*ones(size(x));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'red')
end
hold on
y= 1.2*ones(size(x));

for jf =3:8
    figure(jf)
    hold on
    plot(x,y,'red')
end
hold on

%%%%%%%%%%%%%%

for jf =3:8
    figure(jf)
    axis equal
end




s0 = -ones(2,1)+init_varation*randn(2,1);
a0 = NN( Net , [s0;0] , []);
xx = zeros(2,T);
xx(:,1)=model( [ s0;a0]  );
a =zeros(2,T);
for ij=1:T-1
    a(:,ij)=NN(Net, [xx(:,ij);ij], []);
    xx(:,ij+1)=model([xx(:,ij);a(:,ij)]);
end

color = '-g.' ;
figure(3)
hold on
plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
hold on


[W,B,L] =param2net(param{1}, dim , 'tanh');
Net0.weights = W;
Net0.biases = B;
Net0.layers = L;


s0 = -ones(2,1)+init_varation*randn(2,1);
a0 = NN( Net0 , [s0;0] , []);
xx_init = zeros(2,T);
xx_init(:,1)=model( [ s0;a0]  );
a =zeros(2,T);
for ij=1:T-1
    a(:,ij)=NN(Net0, [xx_init(:,ij);ij], []);
    xx_init(:,ij+1)=model([xx_init(:,ij);a(:,ij)]);
end

color = '-black.' ;
figure(3)
hold on
plot([s0(1,1) xx_init(1,:)],[s0(2,1) xx_init(2,:)], color, 'Linewidth', 0.75);
hold on







load('STLCG_result_noisy_no_end_target_strong_controller.mat')
uu = X';
s0 = -ones(2,1)+init_varation*randn(2,1);
xx = zeros(2,T);
noise  = mvnrnd(avg, cov, 1)';
xx(:,1)=s0 + uu(:,1)*dt + noise;
for ij=1:T-1
    noise  = mvnrnd(avg, cov, 1)';
    xx(:,ij+1)=xx(:,ij) + uu(:,ij+1)*dt + noise;
end

color = '-g.' ;

figure(4)
hold on
plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
hold on

s0 = -ones(2,1)+init_varation*randn(2,1);
u_init = (20/T)*ones(2,T);
xx_init = zeros(2,T);
noise  = mvnrnd(avg, cov, 1)';
xx_init(:,1)= s0  +  u_init(:,1)*dt + noise;
for ij=1:T-1
    noise  = mvnrnd(avg, cov, 1)';
    xx_init(:,ij+1)= xx_init(:,ij) + u_init(:,ij+1) *dt  + noise;
end

color = '-black.' ;
figure(4)
hold on
plot([s0(1,1) xx_init(1,:)],[s0(2,1) xx_init(2,:)], color, 'Linewidth', 0.75);
hold on







[W,B,L] =param2net(param{iter}, dim , 'tanh');
net.weights = W;
net.biases = B;
net.layers = L;


for i=1:KK
    s0 = -ones(2,1)+init_varation*randn(2,1);
    a0 = NN( net , [s0;0] , []);
    xx = zeros(2,T);
    xx(:,1)=model( [ s0;a0]  );
    a =zeros(2,T);
    for ij=1:T-1
        a(:,ij)=NN(net, [xx(:,ij);ij], []);
        xx(:,ij+1)=model([xx(:,ij);a(:,ij)]);
    end
    
    Traj = [s0 xx(:,1:T)];
    Traj = reshape( Traj , [numel(Traj) , 1]);
    
    rho = NN(STL2NN, Traj);

    if rho>0
        figure(5)
        color = '-g.' ;
        plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
        hold on
    else
        figure(6)
        color = '-r.' ;
        plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
        hold on
    end
end


conf_NN = 0;
for i=1:KK2
    s0 = -ones(2,1)+init_varation*randn(2,1);
    a0 = NN( net , [s0;0] , []);
    xx = zeros(2,T);
    xx(:,1)=model( [ s0;a0]  );
    a =zeros(2,T);
    for ij=1:T-1
        a(:,ij)=NN(net, [xx(:,ij);ij], []);
        xx(:,ij+1)=model([xx(:,ij);a(:,ij)]);
    end
    
    Traj = [s0 xx(:,1:T)];
    Traj = reshape( Traj , [numel(Traj) , 1]);
    
    rho = NN(STL2NN, Traj);

    if rho>0
        conf_NN = conf_NN +1;
    end
end
conf_NN = conf_NN/KK2



for i=1:KK
    s0 = -ones(2,1)+ init_varation*randn(2,1);
    xx = zeros(2,T);
    noise  = mvnrnd(avg, cov, 1)';
    xx(:,1)= s0 + uu(:,1)*dt  + noise;
    for ij=1:T-1
        noise  = mvnrnd(avg, cov, 1)';
        xx(:,ij+1)= xx(:,ij) + uu(:,ij+1) *dt  + noise;
    end
    
    Traj = [s0 xx(:,1:T)];
    Traj = reshape( Traj , [numel(Traj) , 1]);
    
    rho = NN(STL2NN, Traj);

    if rho>0
        figure(7)
        color = '-g.' ;
        plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
        hold on
    else
        figure(8)
        color = '-r.' ;
        plot([s0(1,1) xx(1,:)],[s0(2,1) xx(2,:)], color, 'Linewidth', 0.75);
        hold on
    end
end


conf_stlcg = 0;
for i=1:KK2
    s0 = -ones(2,1)+ init_varation*randn(2,1);
    xx = zeros(2,T);
    noise  = mvnrnd(avg, cov, 1)';
    xx(:,1)= s0 + uu(:,1)*dt  + noise;
    for ij=1:T-1
        noise  = mvnrnd(avg, cov, 1)';
        xx(:,ij+1)= xx(:,ij) + uu(:,ij+1) *dt  + noise;
    end
    
    Traj = [s0 xx(:,1:T)];
    Traj = reshape( Traj , [numel(Traj) , 1]);
    
    rho = NN(STL2NN, Traj);

    if rho>0
        conf_stlcg = conf_stlcg +1;
    end
end
conf_stlcg = conf_stlcg/KK2
