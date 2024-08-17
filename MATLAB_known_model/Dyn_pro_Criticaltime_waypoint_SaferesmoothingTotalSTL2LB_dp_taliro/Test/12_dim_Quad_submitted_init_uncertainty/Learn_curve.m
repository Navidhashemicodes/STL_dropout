clear all
clc
close all

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'));

load('Good_results_submitted.mat')




Iter = iter;
J2_hard = zeros(1,Iter);
parfor iter =1:Iter
    disp(iter)
    J2 = zeros(1,KK);
    for i=1:KK
        [J2(i), ~] = wp_STL_obj(s0s(:,i) , C, D, param{iter}, dim, T, phi, Pred);
    end
    J2_hard(iter) = min(J2); 
end

save('Learn_curve', 'J2_hard')

plot(J2_hard)