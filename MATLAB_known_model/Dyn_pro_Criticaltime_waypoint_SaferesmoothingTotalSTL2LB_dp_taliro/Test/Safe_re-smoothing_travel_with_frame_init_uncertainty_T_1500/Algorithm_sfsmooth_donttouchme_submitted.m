clear all
clc
close all

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'));


Num=30000;

FF=1;


T=1500;


phi = '([]_[0,1500]( a1 \/ a2\/ a3 \/ a4  \/ a5) /\ <>_[1100,1500]( b1 /\ b2 /\ b3 /\ b4 /\ b5 /\ b6 /\ b7 /\ b8 /\ b9 /\ b10 /\ b11 /\ b12 )  /\ []_[0,1500]( c1 ) )' ;

i=1; 
Pred(i).str = 'a1';
Pred(i).A=[ 0  1    0   0   0   0  0];
Pred(i).b=  FF*(0-9);  %%% the right edge of building is on -5 and we add 5 more space to be safe



i=i+1;
Pred(i).str = 'a2';
Pred(i).A=[ 0 -1    0   0   0   0  0];
Pred(i).b= -FF*(0+9);  %%% the left edge of building is on  5 and we add 5 more space to be safe

i=i+1;
Pred(i).str = 'a3';
Pred(i).A=[  1  0   0   0   0   0  0];
Pred(i).b=  FF*(0-9);  %%% the back edge of the building is at -5 and we add 5 more space to be safe 


i=i+1;
Pred(i).str = 'a4';
Pred(i).A=[ -1  0   0   0   0   0  0];
Pred(i).b= -FF*(0+9);  %%%  the front edge of the building is at 5 and we add 5 more space to be safe

i=i+1;
Pred(i).str = 'a5';
Pred(i).A=[  0  0  -1   0   0   0  0];
Pred(i).b= -FF*(0+35);  %%% The hight of the building is 30 and we add 5 more to be safe.


i=i+1;
Pred(i).str = 'b1';
Pred(i).A=[  1  0   0   0   0   0 -1];
Pred(i).b= FF*1;     %%%  The center of the drone and frame (x-axis) are to be close with this threshold

i=i+1;
Pred(i).str = 'b2';
Pred(i).A=[ -1  0   0   0   0   0  1];
Pred(i).b= FF*1;     %%%  The center of the drone and frame (x-axis) are to be close with this threshold

i=i+1;
Pred(i).str = 'b3';
Pred(i).A=[  0  1   0   0   0   0  0];
Pred(i).b= FF*(0+1);     %%%  The center of the drone and frame are to be close with this threshold the center of the frame (y-axis) is always on 0 

i=i+1;
Pred(i).str = 'b4';
Pred(i).A=[  0 -1   0   0   0   0  0];
Pred(i).b= -FF*(0-1);    %%%  The center of the drone and frame are to be close with this threshold the center of the frame (y-axis) is always on 0   



i=i+1;
Pred(i).str = 'b5';
Pred(i).A=[  0  0   1   0   0   0  0];
Pred(i).b=  FF*(0.1+0.5);   %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis) 

i=i+1;
Pred(i).str = 'b6';
Pred(i).A=[  0  0  -1   0   0   0  0];
Pred(i).b= -FF*(0.1+0.01);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)


i=i+1;
Pred(i).str = 'b7';
Pred(i).A=[  0  0   0   1   0   0  0];
Pred(i).b=  FF*(1+1);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)

i=i+1;
Pred(i).str = 'b8';
Pred(i).A=[  0  0   0  -1   0   0  0];
Pred(i).b= -FF*(1-1);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)


i=i+1;
Pred(i).str = 'b9';
Pred(i).A=[  0  0   0   0   1   0  0];
Pred(i).b=  FF*(0+1);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)i=i+1;

i=i+1;
Pred(i).str = 'b10';
Pred(i).A=[  0  0   0   0  -1   0  0];
Pred(i).b= -FF*(0-1);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)



i=i+1;
Pred(i).str = 'b11';
Pred(i).A=[  0  0   0   0   0   1  0];
Pred(i).b=  FF*(0+1);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)

i=i+1;
Pred(i).str = 'b12';
Pred(i).A=[  0  0   0   0   0  -1  0];
Pred(i).b= -FF*(0-1);      %%%  The frame is 0.1 high. so the center of the drone and frame are to be close with this threshold (z-axis)



i=i+1;
Pred(i).str = 'c1';
Pred(i).A=[  0  0   0   0   0   0 -1];
Pred(i).b= -FF*(9.5);



%%%%%%%%%%  STL2NN
cell_P1 = str2stl('[1,0]');
cell_P2 = str2stl('[2,0]');
cell_P3 = str2stl('[3,0]');
cell_P4 = str2stl('[4,0]');
cell_P5 = str2stl('[5,0]');


cell_P6 = str2stl('[6,0]');
cell_P7 = str2stl('[7,0]');
cell_P8 = str2stl('[8,0]');
cell_P9  = str2stl('[9 ,0]');
cell_P10 = str2stl('[10,0]');
cell_P11 = str2stl('[11,0]');
cell_P12 = str2stl('[12,0]');
cell_P13 = str2stl('[13,0]');
cell_P14 = str2stl('[14,0]');
cell_P15 = str2stl('[15,0]');
cell_P16 = str2stl('[16,0]');
cell_P17 = str2stl('[17,0]');

cell_P18 = str2stl('[18,0]');

predicate_list = 1:1:18;


cell_E_1 = or_operation( cell_P1, or_operation( cell_P2, or_operation( cell_P3 , or_operation( cell_P4 , cell_P5 ) ) ) );
cell_E_2 = and_operation( cell_P6, and_operation( cell_P7, and_operation( cell_P8 , and_operation( cell_P9, and_operation( cell_P10, and_operation( cell_P11, and_operation( cell_P12,...
                                   and_operation( cell_P13,and_operation( cell_P14, and_operation( cell_P15,and_operation( cell_P16,  cell_P17 )   )   )   )   )   )   )  )  )  )  ) ;

cell_G_frame = G_operation(cell_P18 , 0, T);
cell_G  = G_operation(cell_E_1,0   ,T);
cell_F  = F_operation(cell_E_2,1100  ,T); 



STR = and_operation( cell_F , and_operation(cell_G , cell_G_frame) );
cell_STL =STR.cntn;


[s1,s2] = size(cell_STL);
TT = regexprep(strjoin(reshape(string(cell_STL)', [1,s1*s2]))  , ' ',  ''); %%% If you print TT you think it is the STL formula written in terms of '&' and '|'.
char_TT = char(TT);



%%% E_1
predicate_transformation.C(1,:)=[ 0 -1    0   0   0   0  0];
predicate_transformation.d(1,1)=  FF*(0-9);
predicate_transformation.C(2,:)=[ 0  1    0   0   0   0  0];
predicate_transformation.d(2,1)= -FF*(0+9);
predicate_transformation.C(3,:)=[-1  0    0   0   0   0  0];
predicate_transformation.d(3,1)=  FF*(0-9);
predicate_transformation.C(4,:)=[ 1  0    0   0   0   0  0];
predicate_transformation.d(4,1)= -FF*(0+9);
predicate_transformation.C(5,:)=[ 0  0    1   0   0   0  0];
predicate_transformation.d(5,1)= -FF*(0+35);



%%% E_2
predicate_transformation.C(6,:)=[ -1  0   0   0   0   0  1];
predicate_transformation.d(6,1)=   FF*1;
predicate_transformation.C(7,:)=[  1  0   0   0   0   0 -1];
predicate_transformation.d(7,1)=   FF*1;
predicate_transformation.C(8,:)=[  0 -1   0   0   0   0  0];
predicate_transformation.d(8,1)=   FF*(0+1);
predicate_transformation.C(9,:)=[  0  1   0   0   0   0  0];
predicate_transformation.d(9,1)=  -FF*(0-1);
predicate_transformation.C(10,:)=[ 0  0  -1   0   0   0  0];
predicate_transformation.d(10,1)=  FF*(0.1+0.5);
predicate_transformation.C(11,:)=[ 0  0   1   0   0   0  0];
predicate_transformation.d(11,1)= -FF*(0.1+0.01);
predicate_transformation.C(12,:)=[ 0  0   0  -1   0   0  0];
predicate_transformation.d(12,1)=  FF*(1+1);
predicate_transformation.C(13,:)=[ 0  0   0   1   0   0  0];
predicate_transformation.d(13,1)= -FF*(1-1);
predicate_transformation.C(14,:)=[ 0  0   0   0  -1   0  0];
predicate_transformation.d(14,1)=  FF*(0+1);
predicate_transformation.C(15,:)=[ 0  0   0   0   1   0  0];
predicate_transformation.d(15,1)= -FF*(0-1);
predicate_transformation.C(16,:)=[ 0  0   0   0   0  -1  0];
predicate_transformation.d(16,1)=  FF*(0+1);
predicate_transformation.C(17,:)=[ 0  0   0   0   0   1  0];
predicate_transformation.d(17,1)= -FF*(0-1);


%%%%%  E_3
predicate_transformation.C(18,:)=[ 0  0   0   0   0   0  1];
predicate_transformation.d(18,1)= -FF*(9.5);



tic;
b=15;   %%% My experimental results shows b should be low to have acceptable gradients
type = 'smooth';
STL2LB = Logic_Net(char_TT, predicate_transformation , T , type);

% [STL2LB, ~]   = traj2STL_smooth( predicate_transformation , cell_STL);
%%%%%%%%%%%%%%%%%%
Run1 = toc;

C = eye(7); 
D= zeros(7,1);
param=cell(1,Num);

dim = [8,20,20,10,4];
load('Init20_20_10.mat')
leng =length(dim)-1;
len =0;
for i=1:leng
    len =len + (dim(i)+1)*dim(i+1);
end
param{1} = Param;
if len~= numel(param{1})
    error('???')
end

J2=cell(1,Num);
J1=cell(1,Num);
% 
KK=9;
s0s(:,1)= [ FF*([-40;0]+[ 0.1; 0.1 ]) ; zeros(4,1) ; FF*(10+0.1)  ] ;
s0s(:,2)= [ FF*([-40;0]+[-0.1;-0.1 ]) ; zeros(4,1) ; FF*(10+0.1)  ] ;
s0s(:,3)= [ FF*([-40;0]+[ 0.1;-0.1 ]) ; zeros(4,1) ; FF*(10+0.1)  ] ;
s0s(:,4)= [ FF*([-40;0]+[-0.1; 0.1 ]) ; zeros(4,1) ; FF*(10+0.1)  ] ;
s0s(:,5)= [ FF*([-40;0]+[ 0.1; 0.1 ]) ; zeros(4,1) ; FF*(10-0.1)  ] ;
s0s(:,6)= [ FF*([-40;0]+[-0.1;-0.1 ]) ; zeros(4,1) ; FF*(10-0.1)  ] ;
s0s(:,7)= [ FF*([-40;0]+[ 0.1;-0.1 ]) ; zeros(4,1) ; FF*(10-0.1)  ] ;
s0s(:,8)= [ FF*([-40;0]+[-0.1; 0.1 ]) ; zeros(4,1) ; FF*(10-0.1)  ] ;
s0s(:,9)= [ FF*([-40;0]+[ 0; 0 ]) ; zeros(4,1) ; FF*10  ] ;


[J2{1}, J1{1}] = wp_STL_obj(s0s(:,randi([1,KK],1)), C, D, param{1}, dim, T, phi, Pred);
rng(0)
% 
% 
% 

% 
% 
N = 15;
attempts = 30;
attempts_stl2lb = 3;

averageGrad = [];
averageSqGrad = [];
epsilli = 0.00001;
partition = 100;
Part = floor(T/partition);

method = zeros(1,Num);
tic;

for iter =1:Num
   
    
    param2 = param{iter};
    param1 = param{iter};
    averageGrad2 = averageGrad ; averageSqGrad2 = averageSqGrad; averageGrad1 = averageGrad;  averageSqGrad1 = averageSqGrad;
    
    % Update the parameters using the current gradient
    J2_candidate = zeros(1,KK);
    J1_candidate = zeros(1,KK);
    PPP = param{iter};
    parfor i=1:KK
        [J2_candidate(i), J1_candidate(i)] = wp_STL_obj(s0s(:,i), C, D, PPP,  dim, T, phi, Pred );
    end
    [J2_discuss , ind] = min(J2_candidate);
    s0 = s0s(:,ind);
    J1_discuss = J1_candidate(ind);
    if J2_discuss > 0
        break;
    end

    for i=1:attempts
        [grad2, sampled_T] = Back_prop_STL_sampled(s0, C, D, param2, dim, T, Pred, phi , N);
        [param2 , averageGrad2 , averageSqGrad2  ] = adamupdate(param2, -grad2/attempts     , averageGrad2,averageSqGrad2,iter);
        grad1 = Back_prop_wp_sampled( s0, C, D, param1, dim, T, sampled_T);
        [param1 , averageGrad1 , averageSqGrad1  ] = adamupdate(param1, -grad1/attempts     , averageGrad1,averageSqGrad1,iter);
    end

    
    
    if mod(iter, 10)==0
        [soft, hard] = soft_obj(s0, C, D, param{iter},  dim, T, STL2LB, b, char_TT , predicate_transformation);
        fprintf('Iteration %d: obj1 = %s. obj2 = %s, G1 = %s. G2 = %s.\n\n', iter, mat2str(hard), mat2str(soft), mat2str(grad1,1), mat2str(grad2,1));
    else
        fprintf('Iteration %d: obj1 = %s. G1 = %s. G2 = %s.\n\n', iter, mat2str(J2_discuss), mat2str(grad1,1), mat2str(grad2,1));
    end
    
    [J2next1  , J1next1 ] = wp_STL_obj(s0, C, D, param1,  dim, T, phi, Pred  );
    [J2next2  , J1next2 ] = wp_STL_obj(s0, C, D, param2 , dim, T, phi, Pred  );
    %%% In case the gradient of differentiable helper function does not decrease the
    %%% robustness we use this gradient because our first goal is to direct
    %%% the trajectory to lie on the desired path. This gradient is also
    %%% hopeful for noticeable increase in robustness since our desired path
    %%% is designed for this purpose. But if this gradient decreases the
    %%% robustness value we neglect it and go for the gradient of non-smooth
    %%% robustness function. Ths priority is to presnt the helper function
    %%% as a coach in the optimization which makes it difficult for
    %%% controller to deviate from the desired path.
    
    if J2next1>J2_discuss
        if J1next2>=J1_discuss
            J2_max = max(J2next1, J2next2);
            if J2_max == J2next1
                param{iter+1} = param1;
                J1{iter+1} = J1next1;
                J2{iter+1} = J2next1;
                averageGrad = averageGrad1;
                averageSqGrad = averageSqGrad1;
                method(iter) = 1;
            elseif J2_max == J2next2
                param{iter+1} = param2;
                J1{iter+1} = J1next2;
                J2{iter+1} = J2next2;
                averageGrad = averageGrad2;
                averageSqGrad = averageSqGrad2;
                method(iter) = 2;
            end
        elseif  J1next2<J1_discuss
            param{iter+1} = param1;
            J1{iter+1} = J1next1;
            J2{iter+1} = J2next1;
            averageGrad = averageGrad1;
            averageSqGrad = averageSqGrad1;
            method(iter) = 1;
        end
    else
        
        if J2next2>=J2_discuss
            param{iter+1} = param2;
            J1{iter+1} = J1next2;
            J2{iter+1} = J2next2;
            averageGrad = averageGrad2;
            averageSqGrad = averageSqGrad2;
            method(iter) = 2;
        else
            
            dd=true;
            scale =1;
            while dd
                
                gg =norm(param2-param{iter}, 'inf')/scale;
                if gg > epsilli
                    scale = 2*scale;
                    theparam = param{iter} + (param2-param{iter})/scale;
                    [ award , helper ] = wp_STL_obj(s0, C, D, theparam , dim, T, phi, Pred  );
                    if award > J2_discuss
                        param{iter+1} = theparam;
                        J1{iter+1} = helper;
                        J2{iter+1} = award;
                        averageGrad = averageGrad + (averageGrad2-averageGrad)/scale;
                        averageSqGrad = averageSqGrad + (averageSqGrad2-averageSqGrad)/scale;
                        method(iter) =2;
                        dd= false;
                    end
                else

                    param3 = param{iter};
                    averageGrad3 = averageGrad; averageSqGrad3 = averageSqGrad;
                    for j = 1:attempts_stl2lb
                        TH = 1:T; %% Do not include 0, it doesnt have gradient with param
                        th = cell(1, partition);
                        for i=1:partition-1
                            X=randperm(length(TH), Part);
                            th{i} = sort(TH(X));
                            TH = setdiff(TH , th{i});
                        end
                        th{partition} = sort(TH);

                        gradient_STL  =  safe_resmoothing_TotalLB(s0, C, D, param3, dim, T, th, STL2LB, b);
                        [param3 , averageGrad3 , averageSqGrad3  ] = adamupdate(param3, -gradient_STL/attempts_stl2lb, averageGrad3, averageSqGrad3, iter);
                    end
                    param{iter+1} = param3; averageGrad = averageGrad3; averageSqGrad = averageSqGrad3;
                    [ J2{iter+1} , J1{iter+1} ] = wp_STL_obj(s0, C, D, param{iter+1} , dim, T, phi, Pred  );
                    method(iter) = 3;
                    dd = false;
                end       
                
            end
        end
    end
    
end

Runtime =toc;