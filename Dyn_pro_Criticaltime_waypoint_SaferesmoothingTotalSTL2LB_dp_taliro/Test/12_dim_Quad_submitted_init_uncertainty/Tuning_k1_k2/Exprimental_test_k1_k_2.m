clear all
close all
clc

lb = zeros(12,1);
ub = [0.2*ones(3,1) ; zeros(9,1) ];
timestep =0.1;
horizon =100;
num_traj = 10000;
Output = Quad_12_nln_Datagenerator_ss(lb, ub, timestep, horizon, num_traj) ;

s = 0;
for i =1:num_traj
    traj = Output(:,i);
    Traj = reshape(traj, [12 , horizon+1]);
    
    if Traj(3,end)>0
        s = s+1;
        plot3(Traj(1,:) , Traj(2,:) , Traj(3,:) , 'LineWidth', 2);
        hold on
        plot3(Traj(1,1) , Traj(2,1) , Traj(3,1) , '*' , 'LineWidth', 2)
        axis equal
    end
end

chance = s/ num_traj;
