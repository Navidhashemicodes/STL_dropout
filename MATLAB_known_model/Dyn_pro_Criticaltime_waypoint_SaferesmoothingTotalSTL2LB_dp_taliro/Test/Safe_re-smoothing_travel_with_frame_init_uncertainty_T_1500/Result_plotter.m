clear all
clc
close all
% 
% 
load('Good_result_submitted.mat')

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

center = FF*[   0; 0; 15 ] ;
plotcube(center,1 , [10, 10,30], 'red' , 0.3)
hold on

center = FF*[ -40; 0; 0];
plotcube(center,1 , [0.1, 0.1, 0.001] , 'green' , 1)
hold on



Param=param{iter};


s0 =  [  FF*[-40;0]   ;  zeros(4,1) ;FF*10 ]  ;
a0 = Actor(C*s0+D,0,dim,Param, 'tanh');
xx = zeros(7,T);
xx(:,1)=model( [ s0;a0]  );
for ij=1:T
    a(:,ij)=Actor(C*xx(:,ij)+D,ij,dim,Param, 'tanh');
    xx(:,ij+1)=model([xx(:,ij);a(:,ij)]);
end


Trajectory  = [s0 , xx(:,1:T)];
times = 0:1:T;
[rob , aux] =dp_taliro(phi,Pred,Trajectory',times');
Endtime = aux.i; 

color = '-g.' ;
plot3([s0(1,1) xx(1,1:Endtime)],[s0(2,1) xx(2,1:Endtime)],[s0(3,1) xx(3,1:Endtime)], color, 'Linewidth', 0.75);
hold on
color = '-g.' ;
plot3([s0(7,1) xx(7,1:Endtime)], zeros(1, Endtime+1)  , zeros(1, Endtime+1) , color , 'Linewidth', 0.75);
axis equal


Param=param{1};


a0f = Actor(C*s0+D,0,dim,Param, 'tanh');
xxf = zeros(7,T);
xxf(:,1)=model( [ s0;a0f]  );
for ij=1:T
    af(:,ij)=Actor(C*xxf(:,ij)+D,ij,dim,Param, 'tanh');
    xxf(:,ij+1)=model([xxf(:,ij);af(:,ij)]);
end

color = '-r.' ;
plot3([s0(1,1) xxf(1,1:Endtime)],[s0(2,1) xxf(2,1:Endtime)],[s0(3,1) xx(3,1:Endtime)], color, 'Linewidth', 0.75);
hold on
plot3([s0(7,1) xx(7,1:Endtime)], zeros(1, Endtime+1)  , zeros(1, Endtime+1) , color , 'Linewidth', 0.75);


center = [xx(7,Endtime), 0  , 0];
plotcube(center,1 , [2, 2, 0.1] , 'green' , 1)

figure(4)
histogram(method(1:iter+1))



figure(5)
plot(xx(1,1:Endtime))
figure(6)
plot(xx(2,1:Endtime))
figure(7)
plot(xx(3,1:Endtime))
figure(8)
plot(xx(4,1:Endtime))
figure(9)
plot(xx(5,1:Endtime))
figure(10)
plot(xx(6,1:Endtime))
figure(11)
plot(xx(7,1:Endtime))