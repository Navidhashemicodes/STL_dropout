clear all
clc
close all

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'));


Num=30000;

T = 50;

FF=T/10000;


phi = ['[]_[0,' num2str(T) ']( a1 \/ a2\/ a3 \/ a4 ) /\ <>_[' num2str(floor(0.9*T)) ',' num2str(T) ']( b1 /\ b2 /\ b3 /\ b4 )'] ;

i=1; 
Pred(i).str = 'a1';
Pred(i).A=[  1  0 ];
Pred(i).b=  FF*(300); 



i=i+1;
Pred(i).str = 'a2';
Pred(i).A=[ -1  0 ];
Pred(i).b= -FF*(700); 

i=i+1;
Pred(i).str = 'a3';
Pred(i).A=[  0  1 ];
Pred(i).b=  FF*(300); 


i=i+1;
Pred(i).str = 'a4';
Pred(i).A=[  0 -1 ];
Pred(i).b= -FF*(700);  


i=i+1;
Pred(i).str = 'b1';
Pred(i).A=[  1  0 ];
Pred(i).b=  FF*(925); 

i=i+1;
Pred(i).str = 'b2';
Pred(i).A=[ -1  0 ];
Pred(i).b= -FF*(875);

i=i+1;
Pred(i).str = 'b3';
Pred(i).A=[  0  1 ];
Pred(i).b=  FF*(925);

i=i+1;
Pred(i).str = 'b4';
Pred(i).A=[  0 -1 ];
Pred(i).b= -FF*(875);  




%%%%%%%%%%  STL2NN
cell_P1 = str2stl('[1,0]');
cell_P2 = str2stl('[2,0]');
cell_P3 = str2stl('[3,0]');
cell_P4 = str2stl('[4,0]');


cell_P5 = str2stl('[5,0]');
cell_P6 = str2stl('[6,0]');
cell_P7 = str2stl('[7,0]');
cell_P8 = str2stl('[8,0]');

predicate_list = 1:1:8;


cell_E_1 = or_operation( cell_P1, or_operation( cell_P2, or_operation( cell_P3 , cell_P4  ) ) ) ;
cell_E_2 = and_operation( cell_P5, and_operation( cell_P6, and_operation( cell_P7 , cell_P8 )  )  );

cell_G  = G_operation(cell_E_1,0   ,T);
cell_F  = F_operation(cell_E_2, floor(0.9*T)  ,T); 



STR = and_operation( cell_F , cell_G  );
cell_STL =STR.cntn;


[s1,s2] = size(cell_STL);
TT = regexprep(strjoin(reshape(string(cell_STL)', [1,s1*s2]))  , ' ',  ''); %%% If you print TT you think it is the STL formula written in terms of '&' and '|'.
char_TT = char(TT);



%%% E_1
Map.C(1,:)=[ -1  0 ];
Map.d(1,1)=  FF*(300); 

Map.C(2,:)=[  1  0 ];
Map.d(2,1)= -FF*(700); 

Map.C(3,:)=[  0 -1 ];
Map.d(3,1)=  FF*(300); 

Map.C(4,:)=[  0  1 ];
Map.d(4,1)= -FF*(700);  



%%%%% E2
Map.C(5,:)=[ -1  0 ];
Map.d(5,1)=  FF*(925); 

Map.C(6,:)=[  1  0 ];
Map.d(6,1)= -FF*(875);

Map.C(7,:)=[  0 -1 ];
Map.d(7,1)=  FF*(925);

Map.C(8,:)=[  0  1 ];
Map.d(8,1)= -FF*(875); 





tic;
b=15;   %%% My experimental results shows b should be low to have acceptable gradients
type = 'smooth';
STL2LB = Logic_Net(char_TT, Map , T , type);

% [STL2LB, ~]   = traj2STL_smooth( predicate_transformation , cell_STL);
%%%%%%%%%%%%%%%%%%
Run1 = toc;

C = eye(2); 
D= zeros(2,1);
param=cell(1,Num);

dim = [3,20,2];
load('Init20.mat')
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

% 

s0= FF*([0;0]);


rng(0)
% 
% 
% 

% 
% 

averageGrad = [];
averageSqGrad = [];

partition = floor(T/5);
Part = floor(T/partition);
attempts_stl2lb = 10;

tic;

for iter =1:Num


    % Update the parameters using the current gradient

    [J2_discuss, ~] = wp_STL_obj(s0, C, D, param{iter},  dim, T, phi, Pred );
    
    J2{iter} = J2_discuss;
    if J2_discuss > 0
        break;
    end
    

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
                     
    fprintf('Iteration %d: obj1 = %s. minG = %s, maxG = %s, meanG = %s.\n\n', iter, mat2str(J2_discuss), mat2str(min(gradient_STL)), mat2str(max(gradient_STL)), mat2str(mean(gradient_STL)));
    
end

Runtime =toc;