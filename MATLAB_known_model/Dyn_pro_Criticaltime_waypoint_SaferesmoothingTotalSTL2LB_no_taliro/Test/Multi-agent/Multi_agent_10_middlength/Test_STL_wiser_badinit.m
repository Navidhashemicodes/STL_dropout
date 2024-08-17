clear all
clc
close all

addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\others\Files\Dp_Taliro'));
addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Criticaltime_waypoint_SaferesmoothingTotalSTL2LB_no_taliro\src'));

Num=30000;
% 
num_agent = 10;
% 
L_x = 12;
L_y = 12;


dist = 0.5;


if L_x~=L_y
    error('update dist')
end

N = floor(0.5*num_agent);
d = 1.35;
dd1 = (L_x-d)/N;
dd2 = (L_y-d)/(num_agent-N);

s0 = cell(1, num_agent);
center = cell(1, num_agent);
for i=1: num_agent

    if i<=N

        center{i} = [(i-1)*dd1+dd1/2 ; L_y-d];
        s0{i} = [L_x-(i-1)*dd1-dd1/2 ; d];

    else

        j = i-N;
        center{i} = [L_x-d ; (L_y-d)-(j-1)*dd2-dd2/2];
        s0{i} = [d; d+(j-1)*dd2+dd2/2];

    end

end



%%%%%%%%%%%%%%%%%  STL2NN
tic


T   = 60;
T_f = 48;
t_g = 12 ;
t_F = 20;


logics = 4*num_agent  + 2*num_agent*(num_agent-1);

Map.C = zeros(logics, 2*num_agent);
Map.d = zeros(logics, 1);

for i=1:num_agent



    for index = 4*i-3:4*i
        eval(['cell_P' num2str(index) ' = str2stl(char("[' num2str(index) ',0]"));'])
    end

    %%%%%%%%%%%%%  Map






    % 
    start = 2*(i-1)+1;
    W = zeros(1,2*num_agent);
    W(1,start) =  1  ;
    Map.C(4*i-3,:) =    W;
    Map.d(4*i-3,1)=   -(center{i}(1)-d/3) ;



    W = zeros(1,2*num_agent);
    W(1,start) = -1  ;
    Map.C(4*i-2,:) =    W;
    Map.d(4*i-2,1)=   center{i}(1)+d/3 ;


    W = zeros(1,2*num_agent);
    W(1,start+1) =  1 ;
    Map.C(4*i-1,:) =    W;
    Map.d(4*i-1,1)=   -(center{i}(2)-d/3) ;



    W = zeros(1,2*num_agent);
    W(1,start+1) = -1 ;
    Map.C(4*i,:) =      W;
    Map.d(4*i,1)=     center{i}(2)+d/3 ;



    %%%%%%%%%%%%%



    eval(['cell_P_' num2str(i) ' = and_operation(cell_P' num2str(4*i) ' ,and_operation(cell_P' num2str(4*i-1) ' ,and_operation(cell_P' num2str(4*i-2) ' ,cell_P' num2str(4*i-3) ' ) ) );']);
    eval(['cell_G_' num2str(i) ' = G_operation( cell_P_' num2str(i) ' ,0 ,t_g);']);
    eval(['cell_FG_' num2str(i) ' = F_operation( cell_G_' num2str(i) ' ,t_F ,T_f);']);

    if i==1
        STR1 = cell_FG_1;
    else
        eval(['STR1  = and_operation( STR1, cell_FG_' num2str(i) ');'])
    end

end

index = 4*num_agent;

for i=1:num_agent-1
    for j=i+1:num_agent

        eval(['cell_P_' num2str(i) 'by' num2str(j) '_x1 = str2stl(char("[' num2str(index+1) ',0]"));'])
        eval(['cell_P_' num2str(i) 'by' num2str(j) '_x2 = str2stl(char("[' num2str(index+2) ',0]"));'])
        eval(['cell_P_' num2str(i) 'by' num2str(j) '_y1 = str2stl(char("[' num2str(index+3) ',0]"));'])
        eval(['cell_P_' num2str(i) 'by' num2str(j) '_y2 = str2stl(char("[' num2str(index+4) ',0]"));'])



        %%%%%%%%%%%%%%%% Map

        start1 = 2*(i-1)+1;
        start2 = 2*(j-1)+1;
        W = zeros(1, 2*num_agent);
        W(1,start1) =  1 ; W(1,start2) = -1 ;
        Map.C(index+1,:) = W;
        Map.d(index+1,:) = -dist;


        W = zeros(1, 2*num_agent);
        W(1,start1) = -1 ; W(1,start2) =  1 ;
        Map.C(index+2,:) = W;
        Map.d(index+2,:) = -dist;

        W = zeros(1, 2*num_agent);
        W(1,start1+1) =  1 ; W(1,start2+1) = -1 ;
        Map.C(index+3,:) = W;
        Map.d(index+3,:) = -dist;


        W = zeros(1, 2*num_agent);
        W(1,start1+1) = -1 ; W(1,start2+1) =  1 ;
        Map.C(index+4,:) = W;
        Map.d(index+4,:) = -dist;

        %%%%%%%%%%%%%%%%


        index = index+4;

        eval(['cell_P_' num2str(i) 'by' num2str(j) ' = or_operation(cell_P_' num2str(i) 'by' num2str(j)...
                                                    '_x1 ,or_operation(cell_P_' num2str(i) 'by' num2str(j)...
                                                    '_x2 ,or_operation(cell_P_' num2str(i) 'by' num2str(j)...
                                                    '_y1 ,cell_P_' num2str(i) 'by' num2str(j) '_y2 ) ) );']);

        eval(['cell_G_' num2str(i) 'by' num2str(j) ' = G_operation( cell_P_' num2str(i) 'by' num2str(j) ' ,0 ,T);']);                                       

        if i==1 && j==2
            STR2 = cell_G_1by2;
        else
            eval(['STR2  = and_operation( STR2, cell_G_' num2str(i) 'by' num2str(j) ');'])
        end

    end
end

STR = and_operation(STR1 , STR2);


cell_phi = STR.cntn;


[s1,s2] = size(cell_phi);
TT = regexprep(strjoin(reshape(string(cell_phi)', [1,s1*s2]))  , ' ',  ''); %%% If you print TT you think it is the STL formula written in terms of '&' and '|'.
char_TT = char(TT);


runtime =toc;


clearvars -except char_TT Map T Num runtime s0 num_agent

tic

b=15;   %%% My experimental results shows b should be low to have acceptable gradients
type = 'smooth';
STL2LB   = Logic_Net(char_TT, Map , T , type);
Run1 = toc;




C = eye(2*num_agent); 
D= zeros(2*num_agent,1);
param=cell(1,Num);

dim=[2*num_agent+1,4*num_agent,2*num_agent];
% len = length(dim);
% for i=1:len-1
%     net.weights{i} = 1*(2*rand(dim(i+1), dim(i))-1);
%     net.biases{i} =  1*( 2*rand(dim(i+1),1)-1);
%     if i<=len-2
%         L = cell(dim(i+1),1);
%         L(:) = {'tanh'};
%         net.layers{i} = L;
%     end
% end
% Param=net2param(net, dim);


load('random_init.mat')
param{1} = Param;




J2=cell(1,Num);
J1=cell(1,Num);
% 
KK=1;
s0= reshape([s0{:}]  , [2*num_agent , 1 ]);

[soft, hard] = soft_obj(s0, C, D, param{1},  dim, T, STL2LB, b , Map);
fprintf('Test for b: obj1 = %s. obj2 = %s.\n\n',  mat2str(hard), mat2str(soft));




[J2{1}, J1{1}] = wp_STL_obj(s0(:,1), C, D, param{1}, dim, T, Map);



rng(0)




partition = T/5;
N = 5;
attempts = 30;

averageGrad = [];
averageSqGrad = [];
epsilli = 0.000001;
Part = floor(T/partition);

method = zeros(1,Num);
tic;

for iter =1:Num
    
    

    add = (2*rand(2*num_agent,1)-1)*0.01;
    

    param2 = param{iter};
    param1 = param{iter};
    averageGrad2 = averageGrad ; averageSqGrad2 = averageSqGrad; averageGrad1 = averageGrad;  averageSqGrad1 = averageSqGrad;
 
    for i=1:attempts
        [grad2, sampled_T] = Back_prop_STL_sampled(s0+add, C, D, param2, dim, T, Map, N);
        [param2 , averageGrad2 , averageSqGrad2  ] = adamupdate(param2, -grad2/attempts     , averageGrad2,averageSqGrad2,iter);
        grad1 = Back_prop_wp_sampled( s0+add, C, D, param1, dim, T, sampled_T);
        [param1 , averageGrad1 , averageSqGrad1  ] = adamupdate(param1, -grad1/attempts     , averageGrad1,averageSqGrad1,iter);
    end

    
    

    % Update the parameters using the provided gradients
    
    [J2_discuss , J1_discuss] = wp_STL_obj(s0, C, D, param{iter},  dim, T,  Map );
     
    
    fprintf('Iteration %d: obj1 = %s. G1 = %s. G2 = %s, pre-method= %d.\n\n', iter, mat2str(J2_discuss), mat2str([min(grad1),mean(grad1), max(grad1)],1), mat2str([min(grad2),mean(grad2), max(grad2)],1), method(max(1,iter-1)));
  
    
    [J2next1  , J1next1 ] = wp_STL_obj(s0, C, D, param1,  dim, T,  Map  );
    [J2next2  , J1next2 ] = wp_STL_obj(s0, C, D, param2 , dim, T,  Map  );
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
                    [ award , helper ] = wp_STL_obj(s0, C, D, theparam , dim, T,  Map  );
                    if award > J2_discuss
                        param{iter+1} = theparam;
                        J1{iter+1} = helper;
                        J2{iter+1} = award;
                        if ~isempty(averageGrad)
                            averageGrad = averageGrad + (averageGrad2-averageGrad)/scale;
                            averageSqGrad = averageSqGrad + (averageSqGrad2-averageSqGrad)/scale;
                        end
                        method(iter) =2;
                        dd= false;
                    end
                else

                    TH = 1:T; %% Do not include 0, it doesnt have gradient with param
                    th = cell(1, partition);
                    for i=1:partition-1
                        X=randperm(length(TH), Part);
                        th{i} = sort(TH(X));
                        TH = setdiff(TH , th{i});
                    end
                    th{partition} = sort(TH);
                    
                    gradient_STL  =  safe_resmoothing_TotalLB(s0+add, C, D, param{iter}, dim, T, th, STL2LB, b);
                    [param{iter+1} , averageGrad , averageSqGrad  ] = adamupdate(param{iter}, -gradient_STL    , averageGrad,averageSqGrad,iter);
                    [ J2{iter+1} , J1{iter+1} ] = wp_STL_obj(s0, C, D, param{iter+1} , dim, T,  Map  );
                    method(iter) = 3;
                    dd = false;
                end       
                
            end
        end
    end
    if J2{iter+1} > 0
        break;
    end
end

Runtime =toc;