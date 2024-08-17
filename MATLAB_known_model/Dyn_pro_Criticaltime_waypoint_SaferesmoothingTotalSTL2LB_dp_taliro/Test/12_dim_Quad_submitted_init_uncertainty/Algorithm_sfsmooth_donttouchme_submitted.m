clear all
clc
close all

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_dp_taliro\src'));


Num=30000;


T=45;
FF = 0.1;

phi = '<>_[10,15]( a1 /\ a2 /\ a3 /\ a4  /\ a5 /\ a6  /\  <>_[10,15](  b1 /\ b2 /\ b3 /\ b4  /\ b5 /\ b6  /\ <>_[10,15](  c1 /\ c2 /\ c3 /\ c4  /\ c5 /\ c6  )   )   )';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=1; 
Pred(i).str = 'a1';
x1 = 40; y1 = 15; x2 = 44; y2 = 18;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [ a -1 zeros(1,10)];
Pred(i).b=  -FF*b;  

i=i+1; 
Pred(i).str = 'a2';
x1 = 31; y1 = 27; x2 = 40; y2 = 15;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [ a -1 zeros(1,10)];
Pred(i).b=  -FF*b;  

i=i+1; 
Pred(i).str = 'a3';
x1 = 35; y1 = 30; x2 = 44; y2 = 18;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [-a  1 zeros(1,10)];
Pred(i).b=   FF*b;


i=i+1; 
Pred(i).str = 'a4';
x1 = 31; y1 = 27; x2 = 35; y2 = 30;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [-a  1 zeros(1,10)];
Pred(i).b=   FF*b;


i=i+1; 
Pred(i).str = 'a5';
ha =17;
Pred(i).A = [ 0  0  -1  zeros(1,9)];
Pred(i).b=  -FF*ha;

i=i+1; 
Pred(i).str = 'a6';
Pred(i).A = [ 0  0   1  zeros(1,9)];
Pred(i).b=   FF*(ha+15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=i+1; 
Pred(i).str = 'b1';
Pred(i).A = [ 0 -1 zeros(1,10)];
Pred(i).b= -FF*54;  


i=i+1; 
Pred(i).str = 'b2';
Pred(i).A = [ 0  1 zeros(1,10)];
Pred(i).b=  FF*59;  


i=i+1; 
Pred(i).str = 'b3';
Pred(i).A = [-1  0 zeros(1,10)];
Pred(i).b=  -FF*80;


i=i+1; 
Pred(i).str = 'b4';
Pred(i).A = [ 1  0 zeros(1,10)];
Pred(i).b=   FF*95;


i=i+1; 
Pred(i).str = 'b5';
Pred(i).A = [ 0  0  -1  zeros(1,9)];
Pred(i).b=  -FF*45;


i=i+1; 
Pred(i).str = 'b6';
Pred(i).A = [ 0  0   1  zeros(1,9)];
Pred(i).b=   FF*60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=i+1; 
Pred(i).str = 'c1';
x1 = 17; y1 = 79; x2 = 20; y2 = 75;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [ a -1 zeros(1,10)];
Pred(i).b=  -FF*b;  


i=i+1; 
Pred(i).str = 'c2';
x1 = 20; y1 = 75; x2 = 32; y2 = 84;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [ a -1 zeros(1,10)];
Pred(i).b=  -FF*b;  


i=i+1; 
Pred(i).str = 'c3';
x1 = 17; y1 = 79; x2 = 29; y2 = 88;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [-a  1 zeros(1,10)];
Pred(i).b=   FF*b;


i=i+1; 
Pred(i).str = 'c4';
x1 = 29; y1 = 88; x2 = 32; y2 = 84;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
Pred(i).A = [-a  1 zeros(1,10)];
Pred(i).b=   FF*b;


i=i+1; 
Pred(i).str = 'c5';
hc =20;
Pred(i).A = [ 0  0  -1  zeros(1,9)];
Pred(i).b=  -FF*hc;


i=i+1; 
Pred(i).str = 'c6';
Pred(i).A = [ 0  0   1  zeros(1,9)];
Pred(i).b=   FF*(hc+15);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%  STL2NN
cell_a1 = str2stl('[1,0]');
cell_a2 = str2stl('[2,0]');
cell_a3 = str2stl('[3,0]');
cell_a4 = str2stl('[4,0]');
cell_a5 = str2stl('[5,0]');
cell_a6 = str2stl('[6,0]');


cell_b1 = str2stl('[7,0]');
cell_b2 = str2stl('[8,0]');
cell_b3 = str2stl('[9,0]');
cell_b4 = str2stl('[10,0]');
cell_b5 = str2stl('[11,0]');
cell_b6 = str2stl('[12,0]');


cell_c1 = str2stl('[13,0]');
cell_c2 = str2stl('[14,0]');
cell_c3 = str2stl('[15,0]');
cell_c4 = str2stl('[16,0]');
cell_c5 = str2stl('[17,0]');
cell_c6 = str2stl('[18,0]');




cell_a = and_operation( cell_a1, and_operation( cell_a2, and_operation( cell_a3 , and_operation( cell_a4 , and_operation(cell_a5 , cell_a6) ) ) ) );
cell_b = and_operation( cell_b1, and_operation( cell_b2, and_operation( cell_b3 , and_operation( cell_b4 , and_operation(cell_b5 , cell_b6) ) ) ) );
cell_c = and_operation( cell_c1, and_operation( cell_c2, and_operation( cell_c3 , and_operation( cell_c4 , and_operation(cell_c5 , cell_c6) ) ) ) );

STR = F_operation( and_operation( cell_a , ...
                                           F_operation( and_operation( cell_b , ...
                                                                                F_operation( cell_c, 10, 15)...
                                                                     ), 10 ,15   ) ...
                                 ),  10, 15 ) ;


cell_STL =STR.cntn;


[s1,s2] = size(cell_STL);
TT = regexprep(strjoin(reshape(string(cell_STL)', [1,s1*s2]))  , ' ',  ''); %%% If you print TT you think it is the STL formula written in terms of '&' and '|'.
char_TT = char(TT);



%%% a
%a1
x1 = 40; y1 = 15; x2 = 44; y2 = 18;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(1,:)=[-a  1    0   zeros(1,9)];
predicate_transformation.d(1,1)=  -FF*b;
%a2
x1 = 31; y1 = 27; x2 = 40; y2 = 15;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(2,:)=[-a  1    0   zeros(1,9)];
predicate_transformation.d(2,1)=  -FF*b;
%a3
x1 = 35; y1 = 30; x2 = 44; y2 = 18;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(3,:)=[ a -1    0   zeros(1,9)];
predicate_transformation.d(3,1)=   FF*b;
%a4
x1 = 31; y1 = 27; x2 = 35; y2 = 30;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(4,:)=[ a -1    0   zeros(1,9)];
predicate_transformation.d(4,1)=   FF*b;
%a5
ha=17;
predicate_transformation.C(5,:)=[ 0  0    1   zeros(1,9)];
predicate_transformation.d(5,1)=  -FF*ha;
%a6
predicate_transformation.C(6,:)=[ 0  0   -1   zeros(1,9)];
predicate_transformation.d(6,1)=   FF*(ha+15);

%%%


%%% b
%b1
predicate_transformation.C(7,:) =[ 1  0    0   zeros(1,9)];
predicate_transformation.d(7,1) =  -FF*80;
%b2
predicate_transformation.C(8,:) =[-1  0    0   zeros(1,9)];
predicate_transformation.d(8,1) =   FF*95;
%b3
predicate_transformation.C(9,:) =[ 0  1    0   zeros(1,9)];
predicate_transformation.d(9,1) =  -FF*54;
%b4
predicate_transformation.C(10,:)=[ 0 -1    0   zeros(1,9)];
predicate_transformation.d(10,1)=   FF*59;
%b5
predicate_transformation.C(11,:)=[ 0  0    1   zeros(1,9)];
predicate_transformation.d(11,1)=  -FF*45;
%b6
predicate_transformation.C(12,:)=[ 0  0   -1   zeros(1,9)];
predicate_transformation.d(12,1)=   FF*60;

%%%


%%% c
%c1
x1 = 17; y1 = 79; x2 = 20; y2 = 75;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(13,:)=[-a  1    0   zeros(1,9)];
predicate_transformation.d(13,1)=  -FF*b;
%c2
x1 = 20; y1 = 75; x2 = 32; y2 = 84;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(14,:)=[-a  1    0   zeros(1,9)];
predicate_transformation.d(14,1)=  -FF*b;
%c3
x1 = 17; y1 = 79; x2 = 29; y2 = 88;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(15,:)=[ a -1    0   zeros(1,9)];
predicate_transformation.d(15,1)=   FF*b;
%c4
x1 = 29; y1 = 88; x2 = 32; y2 = 84;
a = (y2-y1)/(x2-x1); b = y1 - a*x1;
predicate_transformation.C(16,:)=[ a -1    0   zeros(1,9)];
predicate_transformation.d(16,1)=   FF*b;
%c5
hc=20;
predicate_transformation.C(17,:)=[ 0  0    1   zeros(1,9)];
predicate_transformation.d(17,1)=  -FF*ha;
%c6
predicate_transformation.C(18,:)=[ 0  0   -1   zeros(1,9)];
predicate_transformation.d(18,1)=   FF*(ha+15);

%%%




tic;
b=5;   %%% My experimental results shows b should be low to have acceptable gradients
type = 'smooth';
STL2LB = Logic_Net(char_TT, predicate_transformation , T , type);

%%%%%%%%%%%%%%%%%%
Run1 = toc;

C = eye(12); 
D= zeros(12,1);
param=cell(1,Num);

dim = [13,20,20,10,4];
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
s0s(:,1)= FF*[ 1;  1;  1 ; zeros(9,1) ] ;
s0s(:,2)= FF*[ 1;  1; -1 ; zeros(9,1) ] ;
s0s(:,3)= FF*[ 1; -1;  1 ; zeros(9,1) ] ;
s0s(:,4)= FF*[ 1; -1; -1 ; zeros(9,1) ] ;
s0s(:,5)= FF*[-1;  1;  1 ; zeros(9,1) ] ;
s0s(:,6)= FF*[-1;  1; -1 ; zeros(9,1) ] ;
s0s(:,7)= FF*[-1; -1;  1 ; zeros(9,1) ] ;
s0s(:,8)= FF*[-1; -1; -1 ; zeros(9,1) ] ;
s0s(:,9)= zeros(12,1) ;


[J2{1}, J1{1}] = wp_STL_obj(s0s(:, randi([1,KK],1) ), C, D, param{1}, dim, T, phi, Pred);
rng(0)
% 
% 
% 

% 
% 
N = 5;
attempts = 30;
attempt_stl2lb = 40;

averageGrad = [];
averageSqGrad = [];
epsilli = 0.000001;
partition = T/5;
Part = floor(T/partition);

method = zeros(1,Num);
tic;

for iter =1:Num
    
    J2_candidate = zeros(1,KK);
    J1_candidate = zeros(1,KK);
    PPP = param{iter};
    parfor i=1:KK
        [J2_candidate(i), J1_candidate(i)] = wp_STL_obj(s0s(:,i) , C, D, PPP, dim, T, phi, Pred);
    end
    [J2_discuss , ind] = min(J2_candidate);
    J1_discuss = J1_candidate(ind);
    s0 = s0s(:, ind);

    if J2_discuss>0
        break;
    end

   
    param2 = param{iter};
    param1 = param{iter};
    averageGrad2 = averageGrad ; averageSqGrad2 = averageSqGrad; averageGrad1 = averageGrad;  averageSqGrad1 = averageSqGrad;
 
    for i=1:attempts
        [grad2, sampled_T] = Back_prop_STL_sampled(s0, C, D, param2, dim, T, Pred, phi , N);
        [param2 , averageGrad2 , averageSqGrad2  ] = adamupdate(param2, -grad2/attempts     , averageGrad2,averageSqGrad2,iter);
        grad1 = Back_prop_wp_sampled( s0, C, D, param1, dim, T, sampled_T);
        [param1 , averageGrad1 , averageSqGrad1  ] = adamupdate(param1, -grad1/attempts     , averageGrad1,averageSqGrad1,iter);
    end

    
    

    % Update the parameters using the provided gradients
     
    fprintf('Iteration %d: obj1 = %s. G1 = %s. G2 = %s, pre-method= %d.\n\n', iter, mat2str(J2_discuss), mat2str([min(grad1),mean(grad1), max(grad1)],1), mat2str([min(grad2),mean(grad2), max(grad2)],1), method(max(1,iter-1)));

   
    
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
                        if isempty(averageGrad)
                            averageGrad = (averageGrad2)/scale;
                            averageSqGrad = (averageSqGrad2)/scale;
                        else
                            averageGrad = averageGrad + (averageGrad2-averageGrad)/scale;
                            averageSqGrad = averageSqGrad + (averageSqGrad2-averageSqGrad)/scale;
                        end
                        method(iter) =2;
                        dd= false;
                    end
                else
                    
                    param3 = param{iter};
                    averageGrad3 = averageGrad;  averageSqGrad3 = averageSqGrad;
                    for j=1:attempt_stl2lb
                        TH = 1:T; %% Do not include 0, it doesnt have gradient with param
                        th = cell(1, partition);
                        for i=1:partition-1
                            X=randperm(length(TH), Part);
                            th{i} = sort(TH(X));
                            TH = setdiff(TH , th{i});
                        end
                        th{partition} = sort(TH);

                        gradient_STL  =  safe_resmoothing_TotalLB(s0, C, D, param3, dim, T, th, STL2LB, b);
                        [param3 , averageGrad3 , averageSqGrad3  ] = adamupdate(param{iter}, -gradient_STL/attempt_stl2lb    , averageGrad3,averageSqGrad3,iter);

                    end
                    param{iter+1} = param3;
                    averageGrad = averageGrad3; averageSqGrad = averageSqGrad3;
                    [ J2{iter+1} , J1{iter+1} ] = wp_STL_obj(s0, C, D, param{iter+1} , dim, T, phi, Pred  );
                    method(iter) = 3;
                    dd = false;
                end       
                
            end
        end
    end
end

Runtime =toc;