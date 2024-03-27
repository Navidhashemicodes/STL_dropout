function grad  = d_model(input)

N=100;

dt = 0.1;

a = input(13:16);

a_scaled = 0.5*tanh(a/10)+0.5;

x = input( 1:12);


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



d_f_x = diff_f_x(x);

d_f_a = [   0,      0,      0,      0;...
            0,      0,      0,      0;...
            0,      0,      0,      0;...
            0,      0,      0,      0;...
            0,      0,      0,      0;...
         -1/m,      0,      0,      0;...
            0,      0,      0,      0;...
            0,      0,      0,      0;...
            0,      0,      0,      0;...
            0,  1/J_x,      0,      0;...
            0,      0,  1/J_y,      0;...
            0,      0,      0,  1/J_z]  *   M    *   diag(  1/20 - tanh(a/10).^2/20  );
 

d_F_a = dt * d_f_a;  %%% This is because d_f_a is not a function of state but d_f_x is a function of it

D_F_x = cell(1,N);
X     = cell(1,N);


D_F_x{1} = eye(12) + (dt / N) * d_f_x;
X{1}     = x       + (dt / N) * Quad_12([], x, a_scaled);


for i=2:N
    D_F_x{i} = D_F_x{i-1}  +  (dt / N) * diff_f_x( X{i-1} ) * D_F_x{i-1};
    X{i}     = X{i-1}      +  (dt / N) * Quad_12([] , X{i-1}, a_scaled);
end

d_F_x = D_F_x{N};


grad  =   [ d_F_x ,   d_F_a ];


end 


function  grad_x = diff_f_x(x)


J_x = 0.054;  %%% The inertia with respect to z axis 
J_y = 0.054;  %%% The inertia with respect to y axis
J_z = 0.104;  %%% The inertia with respect to z axis


grad_x = [0, 0, 0, cos(x(8))*cos(x(9)),   cos(x(9))*sin(x(7))*sin(x(8))-cos(x(7))*sin(x(9)), sin(x(7))*sin(x(9))+cos(x(7))*cos(x(9))*sin(x(8)),   x(5)*(sin(x(7))*sin(x(9))+cos(x(7))*cos(x(9))*sin(x(8)))+x(6)*(cos(x(7))*sin(x(9))-cos(x(9))*sin(x(7))*sin(x(8))), x(6)*cos(x(7))*cos(x(8))*cos(x(9))-x(4)*cos(x(9))*sin(x(8))+x(5)*cos(x(8))*cos(x(9))*sin(x(7)), x(6)*(cos(x(9))*sin(x(7))-cos(x(7))*sin(x(8))*sin(x(9)))-x(5)*(cos(x(7))*cos(x(9))+sin(x(7))*sin(x(8))*sin(x(9)))-x(4)*cos(x(8))*sin(x(9)),                      0,                       0,                        0;...
          0, 0, 0, cos(x(8))*sin(x(9)),   cos(x(7))*cos(x(9))+sin(x(7))*sin(x(8))*sin(x(9)), cos(x(7))*sin(x(8))*sin(x(9))-cos(x(9))*sin(x(7)),  -x(5)*(cos(x(9))*sin(x(7))-cos(x(7))*sin(x(8))*sin(x(9)))-x(6)*(cos(x(7))*cos(x(9))+sin(x(7))*sin(x(8))*sin(x(9))), x(6)*cos(x(7))*cos(x(8))*sin(x(9))-x(4)*sin(x(8))*sin(x(9))+x(5)*cos(x(8))*sin(x(7))*sin(x(9)), x(6)*(sin(x(7))*sin(x(9))+cos(x(7))*cos(x(9))*sin(x(8)))-x(5)*(cos(x(7))*sin(x(9))-cos(x(9))*sin(x(7))*sin(x(8)))+x(4)*cos(x(8))*cos(x(9)),                      0,                       0,                        0;...
          0, 0, 0,           sin(x(8)),                                -cos(x(8))*sin(x(7)),                              -cos(x(7))*cos(x(8)),                                                                   x(6)*cos(x(8))*sin(x(7))-x(5)*cos(x(7))*cos(x(8)),                               x(4)*cos(x(8))+x(6)*cos(x(7))*sin(x(8))+x(5)*sin(x(7))*sin(x(8)),                                                                                                                                          0,                      0,                       0,                        0;...
          0, 0, 0,                   0,                                               x(12),                                            -x(11),                                                                                                                   0,                                                                           -(981*cos(x(8)))/100,                                                                                                                                          0,                      0,                   -x(6),                     x(5);...
          0, 0, 0,              -x(12),                                                   0,                                             x(10),                                                                                       (981*cos(x(7))*cos(x(8)))/100,                                                                 -(981*sin(x(7))*sin(x(8)))/100,                                                                                                                                          0,                   x(6),                       0,                    -x(4);...
          0, 0, 0,               x(11),                                              -x(10),                                                 0,                                                                                      -(981*cos(x(8))*sin(x(7)))/100,                                                                 -(981*cos(x(7))*sin(x(8)))/100,                                                                                                                                          0,                  -x(5),                    x(4),                        0;...
          0, 0, 0,                   0,                                                   0,                                                 0,                                                                 x(11)*cos(x(7))*tan(x(8))-x(12)*sin(x(7))*tan(x(8)),                                x(12)*cos(x(7))*(tan(x(8))^2+1)+x(11)*sin(x(7))*(tan(x(8))^2+1),                                                                                                                                          0,                      1,     sin(x(7))*tan(x(8)),      cos(x(7))*tan(x(8));...
          0, 0, 0,                   0,                                                   0,                                                 0,                                                                                    -x(12)*cos(x(7))-x(11)*sin(x(7)),                                                                                              0,                                                                                                                                          0,                      0,               cos(x(7)),               -sin(x(7));...
          0, 0, 0,                   0,                                                   0,                                                 0,                                                             (x(11)*cos(x(7)))/cos(x(8))-(x(12)*sin(x(7)))/cos(x(8)),                (x(12)*cos(x(7))*sin(x(8)))/cos(x(8))^2+(x(11)*sin(x(7))*sin(x(8)))/cos(x(8))^2,                                                                                                                                          0,                      0,     sin(x(7))/cos(x(8)),      cos(x(7))/cos(x(8));...
          0, 0, 0,                   0,                                                   0,                                                 0,                                                                                                                   0,                                                                                              0,                                                                                                                                          0,                      0,   (x(12)*(J_y-J_z))/J_x,    (x(11)*(J_y-J_z))/J_x;...
          0, 0, 0,                   0,                                                   0,                                                 0,                                                                                                                   0,                                                                                              0,                                                                                                                                          0, -(x(12)*(J_x-J_z))/J_y,                       0,   -(x(10)*(J_x-J_z))/J_y;...
          0, 0, 0,                   0,                                                   0,                                                 0,                                                                                                                   0,                                                                                              0,                                                                                                                                          0,                      0,                       0,                        0];


end