function [dx]=Quad_12(t,x,Control)

%%%%%%% del_f --> Control(1,1);
%%%%%%% del_r --> Control(2,1);
%%%%%%% del_b --> Control(3,1);
%%%%%%% del_l --> Control(4,1);


J_x = 0.054;  %%% The inertia with respect to z axis 
J_y = 0.054;  %%% The inertia with respect to y axis
J_z = 0.104;  %%% The inertia with respect to z axis
m   = 1.4;    %%% The total mass for drone
l   = 0.3273; %%% the distance from motor to the center of drone


k1 =  3*m*9.81/4;     %%%% To make motors capable to produce net force three times the drone's weight (we have 4 motors).
k2 =  3*0.5*l*k1;     %%%% to make tau_z to generate anglur velocity on z at most 1.5 times the maximum angular velocities on x and y.
%%%% Given this setting the chance in tuning unit is 7 percent.


%%%%%%%   F_r  , F_l  , F_f  , F_b   --->  k1 * (del_r, del_l, d_f, del_b)
%%%%%%%   tau_r, tau_l, tau_f, tau_b --->  k2 * (del_r, del_l, d_f, del_b)


M = [  k1      k1    k1     k1  ;...
       0     -l*k1    0    l*k1 ;...
      l*k1     0   -l*k1    0   ;...
      -k2      k2   -k2     k2  ];

nControl = M * Control; 

F     = nControl(1,1); %%%  F = F_r+F_l+F_f+F_b
tau_x = nControl(2,1); %%% tau_x = l (F_l -F_r)
tau_y = nControl(3,1); %%% tau_y = l (F_f -F_b)
tau_z = nControl(4,1); %%% tau_z = tau_r+tau_l-tau_f-tau_b


dx(1,1) = cos(x(8))*cos(x(9))*x(4) + (sin(x(7))*sin(x(8))*cos(x(9)) - cos(x(7))*sin(x(9)))*x(5) + (cos(x(7))*sin(x(8))*cos(x(9)) + sin(x(7))*sin(x(9)))*x(6);
dx(2,1) = cos(x(8))*sin(x(9))*x(4) + (sin(x(7))*sin(x(8))*sin(x(9)) + cos(x(7))*cos(x(9)))*x(5) + (cos(x(7))*sin(x(8))*sin(x(9)) - sin(x(7))*cos(x(9)))*x(6);
dx(3,1) = sin(x(8))*x(4) - sin(x(7))*cos(x(8))*x(5) - cos(x(7))*cos(x(8))*x(6);

dx(4,1) = x(12)*x(5) - x(11)*x(6) - 9.81*sin(x(8));
dx(5,1) = x(10)*x(6) - x(12)*x(4) + 9.81*cos(x(8))*sin(x(7));
dx(6,1) = x(11)*x(4) - x(10)*x(5) + 9.81*cos(x(8))*cos(x(7)) -  F/m ;
  
dx(7,1) = x(10) + sin(x(7))*tan(x(8))*x(11) + cos(x(7))*tan(x(8))*x(12);
dx(8,1) = cos(x(7))*x(11) - sin(x(7))*x(12);
dx(9,1) = (sin(x(7))/cos(x(8)))*x(11) + (cos(x(7))/cos(x(8)))*x(12);
  
dx(10,1) = ((J_y-J_z)/J_x)*x(11)*x(12) + (1/J_x)*tau_x;
dx(11,1) = ((J_z-J_x)/J_y)*x(10)*x(12) + (1/J_y)*tau_y;
dx(12,1) = (1/J_z)*tau_z;





end
