clear all
clc
close all
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Neurosymbolic_STL2NN_STL2CBF\src'));
load('STL2CBF_b10_Test_STL_wiser_ordered_3pointsfar_badinit_donttouchme.mat')




Iter = iter;
J2_hard = zeros(1,Iter);
parfor iter =1:Iter
    disp(iter)
    J2 = zeros(1,KK);
    for i=1:KK
        J2(i) = hard_rob2(s0s(:,i), param{iter}, dim, T,  predicate_transformation , char_TT)
    end
    J2_hard(iter) = min(J2); 
end

save('Learn_curve', 'J2_hard')

plot(J2_hard)