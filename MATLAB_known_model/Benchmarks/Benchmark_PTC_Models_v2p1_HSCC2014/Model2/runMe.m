c1=0.41328;
c2=-0.366;
c3=0.08979;
c4=-0.0337;
c5=0.0001;
c6=2.821;
c7=-0.05231;
c8=0.10299;
c9=-0.00063;
c10=1.0;
c11=14.7;
c12=0.9;
c13=0.04;
c14=0.14;
% total simulation time
simTime = 50 ; 
% time to start measurement, mainly used to ignore 
% Simulink initialization phase
measureTime = 1;  
fault_time = 100; 
en_speed = 1000;

p_init = 0.725; % +/- 10%
lambda_init = 14.7; % +/- 1%
p_est_init = 0.5455; % 
i_init = 0; % [0 0.1]

c23=1.0;
c24=1.0;
c25=1.0;

% pick time horizon of 20, only track reach states after time 10
% 0.02, 0.05, 0.1 (objective: reduce conservatism) 
% use sim command to call simulink

% interp1 (linear)







