clear all
close all
clc

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'))
load('Grad_approx_result_norepeat_submitted.mat')
iter = iter+1;
Param=param{iter};
color = 'xblack' ;
traj = zeros(7,T);
s0 =  [  FF*[-40;0]   ;  zeros(4,1) ;FF*10 ]  ;
plot3(s0(1,1) ,s0(2,1),s0(3,1) , color, 'MarkerSize',10, 'Linewidth', 2);
hold on
center = FF*[   0; 0; 15 ] ;
plotcube(center,1 , [10, 10,30], 'red' , 0.3)
hold on
center = [FF*(-40), 0  , 0];
plotcube(center,1 , [1, 1, 0.1] , 'green' , 1)
hold on
center = [s0(7,1) ,0,0];
plotcube(center,1 , [2, 2, 0.1] , 'green' , 1)
drawnow
hold off
% pause(0.05)


a0 = Actor(C*s0+D,0,dim,Param, 'tanh');
traj(:,1)=model( [ s0;a0]  );
plot3( traj(1,1),traj(2,1),traj(3,1), color, 'MarkerSize',10, 'Linewidth', 2);
hold on
center = FF*[   0; 0; 15 ] ;
plotcube(center,1 , [10, 10,30], 'red' , 0.3)
hold on
center = [FF*(-40), 0  , 0];
plotcube(center,1 , [1, 1, 0.1] , 'green' , 1)
hold on
center = [traj(7,1), 0  , 0];
plotcube(center,1 , [2, 2, 0.1] , 'green' , 1)
drawnow
hold off
% pause(0.05)

E = 20;

for ij=1:T+E
    a(:,ij)=Actor(C*traj(:,ij)+D,ij,dim,Param, 'tanh');
    traj(:,ij+1)=model([traj(:,ij);a(:,ij)]);
    if ij>1100 && traj(3,ij+1)<0.1
        traj(1,ij+1) = traj(1,ij)+traj(7,ij+1)-traj(7,ij);traj(2,ij+1) = traj(2,ij);traj(3,ij+1) = traj(3,ij);
    end
    plot3( traj(1,ij+1), traj(2,ij+1), traj(3,ij+1), color, 'MarkerSize',10, 'Linewidth', 2);
    hold on
    center = FF*[   0; 0; 15 ] ;
    plotcube(center,1 , [10, 10,30], 'red' , 0.3)
    hold on
    center = [FF*(-40), 0  , 0];
    plotcube(center,1 , [1, 1, 0.1] , 'green' , 1)
    hold on
    center = [traj(7,ij+1), 0  , 0];
    plotcube(center,1 , [2, 2, 0.1] , 'green' , 1)
    drawnow
    hold off
%     pause(0.05)  
end



figure(2)
center = FF*[   0; 0; 15 ] ;
plotcube(center,1 , [10, 10,30], 'red' , 0.3)
hold on
center = [FF*(-40), 0  , 0];
plotcube(center,1 , [1, 1, 0.1] , 'green' , 1)
hold on
color = '-g.' ;
plot3([s0(1,1) traj(1,:)],[s0(2,1) traj(2,:)],[s0(3,1) traj(3,:)], color, 'Linewidth', 0.75);
hold on
color = '-b.' ;
plot3([s0(7,1) traj(7,:)], zeros(1, T+E+2)  , zeros(1, T+E+2) , color , 'Linewidth', 0.75); 
axis equal

