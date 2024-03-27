function [gradient_STL, sampled_T] = Back_prop_STL_sampled(s0, C, D, param, dim, T, Pred, phi, N_sample)


n = size(s0,1);
n_c = size(C,1);

[Weights, Biases,~] = param2net(param, dim, 'tanh');

num_layer = length(dim)-2;
%%% Generate the trajectory

Preactivate = cell(num_layer,T);
Postactivate  = cell(num_layer,T);
a   = cell(1,T);
s   = cell(1,T);
s_c = cell(1,T);

s0_c =C*s0+D;
Preactivate{1,1}=Weights{1}*[s0_c;0]+Biases{1};
Postactivate{1,1}=tanh(Preactivate{1,1});
for i=2:num_layer
    Preactivate{i,1}=Weights{i}*Postactivate{i-1,1}+Biases{i};
    Postactivate{i,1}=tanh(Preactivate{i,1});
end
a{1}=Weights{num_layer+1}*Postactivate{num_layer,1}+Biases{num_layer+1};
s{1} = model([s0;a{1}]);



for i=2:T
    s_c{i-1} = C*s{i-1}+D;
    Preactivate{1,i}=Weights{1}*[s_c{i-1};i-1]+Biases{1};
    Postactivate{1,i}=tanh(Preactivate{1,i});
    for j=2:num_layer
        Preactivate{j,i}=Weights{j}*Postactivate{j-1,i}+Biases{j};
        Postactivate{j,i}=tanh(Preactivate{j,i});
    end
    a{i}=Weights{num_layer+1}*Postactivate{num_layer,i}+Biases{num_layer+1};
    s{i} = model([s{i-1};a{i}]);

end

Trajectory = [s0, [s{:}] ];
times = 0:1:T;
[~, aux] = dp_taliro(phi,Pred,Trajectory',times');
critical_time = aux.i-1;
position =aux.pred;
grad_state = -Pred(position).A;


if critical_time == 0
    

    gradient_STL = zeros(size(param));
    sampled_T = sort(randperm(T, N_sample));

else
    
    N_after  = floor( (1-critical_time/T)*N_sample  );
    N_before = N_sample - N_after -1;    %%% you can easilly prove critical_time is always more than N_before
    
    sampled_STL = sort(      union(    randperm(critical_time-1,N_before)  ,  critical_time     )    );
    N_STL = N_before +1;
    sampled_other = critical_time +  randperm(T-critical_time , N_after);
    
    sampled_T = sort(union(sampled_STL, sampled_other));
    
    
    action_traj = [a{:}];
    
    %%% Re-define dynamics and trajectory states based on new Postactivatemple times
    %%% We assume the first Postactivatempled state is always s0 and the array Postactivatempled_T
    %%% refers to the other Postactivatempled states.
    
    
    D_f_a = cell(1, critical_time);
    D_f_s = cell(1, critical_time);
    D_S_step = cell(1, critical_time);
    D_J_S = cell(1, critical_time);
    
    
    [ D_f_s{1}, D_f_a{1} ] = repeated_d_model(Trajectory, action_traj, 0, sampled_STL(1));
    
    D_S_step{1}=0;
    D_J_S{1}=zeros(1,n);  %%% This is only an initialization. This value is to be counted
    %%% with back propagation please consider this is not with respect
    %%% to s0 that is a constant. in fact this is with respect to s{Postactivatempled_T(1)}
    
    for i=2:N_STL
        
        [ D_f_s{i}, D_f_a{i} ] = repeated_d_model(Trajectory, action_traj, sampled_STL(i-1), sampled_STL(i) );
        
        der =1;
        for j=num_layer+1:-1:2
            der  = der * Weights{j}*diag(1- Postactivate{j-1,sampled_STL(i)}.^2);
        end
        der = der * Weights{1}(:,1:n_c)*C;
        
        D_S_step{i}=D_f_s{i}+D_f_a{i} * der;
        D_J_S{i}=zeros(1,n);   %%% this is only an initialization, This value is to be counted with back propagation
        
    end
    
    %%% Do not look at robustness as a tree anymore, look at it as an identity
    %%% function which receives the critical predicate and returns the critical
    %%% predicate
    
    
    
    %%%%%%% Start of Back Propagation
    D_J_S{N_STL} = grad_state;   %%% This is exactly the challenge of critical time based design, you use a gradient that takes care 
    %%% of trajectory untile critical time, and it doesn't care what did gradient do on the rest of the trajectory. But once you bring smooth-STL2NN all over
    %%% the sampled points on the trajectory, then you  also take care what does your gradient do on the rest of the trajectory
    for i=N_STL-1:-1:1
        D_J_S{i} = D_J_S{i+1}*D_S_step{i+1};
    end
    
    
    %%%%%% First Layers
    
    D_Postactivate_W = cell(1,num_layer);
    D_Postactivate_B = cell(1,num_layer);
    D_S_W = cell(1,num_layer+1);
    D_S_B = cell(1,num_layer+1);
    D_J_Weight = cell(1,num_layer+1);
    D_J_Biases = cell(1,num_layer+1);
    D_J_W = cell(1,num_layer+1);
    D_J_B = cell(1,num_layer+1);
    D_J_param = cell(1,num_layer+1);
    
    
    for param_index=1:num_layer
        M = dim(param_index+1);
        I=eye(M);
        D_Postactivate_W{param_index} = cell(M,N_STL);
        D_Postactivate_B{param_index} = cell(M,N_STL);
        D_S_W{param_index} = cell(M,N_STL);
        D_S_B{param_index} = cell(M,N_STL);
        
        for m=1:M
            if param_index ==1
                D_Postactivate_W{param_index}{m,1}=kron(I(:,m), ((1-(Postactivate{param_index,1}(m,1))^2)*[s0_c;0])' );  %%% NN is designed for the time steps not the real times in seconds.
            else
                D_Postactivate_W{param_index}{m,1}=kron(I(:,m), ((1-(Postactivate{param_index,1}(m,1))^2)*Postactivate{param_index-1,1})' );
            end
            D_Postactivate_B{param_index}{m,1}=(1-(Postactivate{param_index,1}(m,1))^2)*I(:,m);
            
            der =1;
            for j=num_layer+1:-1:param_index+2
                der  = der * Weights{j}*diag(1-Postactivate{j-1,1}.^2);
            end
            der = der * Weights{param_index+1};
            
            D_S_W{param_index}{m,1}=D_f_a{1}*der*D_Postactivate_W{param_index}{m,1};
            D_S_B{param_index}{m,1}=D_f_a{1}*der*D_Postactivate_B{param_index}{m,1};
            
            for i=2:N_STL
                if param_index == 1
                    D_Postactivate_W{param_index}{m,i}=kron(I(:,m), ((1-(Postactivate{param_index,sampled_STL(i-1)+1}(m,1))^2)*[s_c{sampled_STL(i-1)};sampled_STL(i-1)])' );
                else
                    D_Postactivate_W{param_index}{m,i}=kron(I(:,m), ((1-(Postactivate{param_index,sampled_STL(i-1)+1}(m,1))^2)*Postactivate{param_index-1,sampled_STL(i-1)+1})' );
                end
                D_Postactivate_B{param_index}{m,i}=(1-(Postactivate{param_index,sampled_STL(i-1)+1}(m,1))^2)*I(:,m);
                
                der =1;
                for j=num_layer+1:-1:param_index+2
                    der  = der * Weights{j}*diag(1-Postactivate{j-1,sampled_STL(i-1)+1}.^2);
                end
                der = der * Weights{param_index+1};
                
                D_S_W{param_index}{m,i}=D_f_a{i}*der*D_Postactivate_W{param_index}{m,i}+D_f_s{i}*D_S_W{param_index}{m,i-1};
                D_S_B{param_index}{m,i}=D_f_a{i}*der*D_Postactivate_B{param_index}{m,i}+D_f_s{i}*D_S_B{param_index}{m,i-1};
            end
        end
        
        
        D_J_Weight{param_index}=[];
        D_J_Biases{param_index}=[];
        D_J_W{param_index} = cell(1,M);
        D_J_B{param_index} = cell(1,M);
        for m=1:M
            D_J_W{param_index}{m}=zeros(1,dim(param_index));
            D_J_B{param_index}{m}=zeros(1,1);
            for i=1:N_STL
                D_J_W{param_index}{m}=D_J_W{param_index}{m}+D_J_S{i}*D_S_W{param_index}{m,i};
                D_J_B{param_index}{m}=D_J_B{param_index}{m}+D_J_S{i}*D_S_B{param_index}{m,i};
            end
            D_J_Weight{param_index}=[D_J_Weight{param_index},D_J_W{param_index}{m}];
            D_J_Biases{param_index}=[D_J_Biases{param_index},D_J_B{param_index}{m}];
        end
        D_J_param{param_index}=[D_J_Weight{param_index},D_J_Biases{param_index}];
    end
    
    
    
    
    
    
    %%%%% Last Layer
    P =dim(end);
    I=eye(P);
    for p=1:P
        D_S_W{num_layer+1}{p,1}=D_f_a{1}*kron(I(:,p) , Postactivate{num_layer,1}');
        D_S_B{num_layer+1}{p,1}=D_f_a{1}*I(:,p);
        for i=2:N_STL
            D_S_W{num_layer+1}{p,i}=D_f_a{i}*kron(I(:,p) , Postactivate{num_layer,sampled_STL(i-1)+1}')+D_f_s{i}*D_S_W{num_layer+1}{p,i-1};
            D_S_B{num_layer+1}{p,i}=D_f_a{i}*I(:,p)+D_f_s{i}*D_S_B{num_layer+1}{p,i-1};
        end
    end
    
    
    D_J_Weight{num_layer+1}=[];
    D_J_Biases{num_layer+1}=[];
    for p=1:P
        D_J_W{num_layer+1}{p}=zeros(1,dim(end-1));
        D_J_B{num_layer+1}{p}=zeros(1,1);
        for i=1:N_STL
            D_J_W{num_layer+1}{p}=D_J_W{num_layer+1}{p}+D_J_S{i}*D_S_W{num_layer+1}{p,i};
            D_J_B{num_layer+1}{p}=D_J_B{num_layer+1}{p}+D_J_S{i}*D_S_B{num_layer+1}{p,i};
        end
        D_J_Weight{num_layer+1}=[D_J_Weight{num_layer+1},D_J_W{num_layer+1}{p}];
        D_J_Biases{num_layer+1}=[D_J_Biases{num_layer+1},D_J_B{num_layer+1}{p}];
    end
    
    D_J_param{num_layer+1}=[D_J_Weight{num_layer+1},D_J_Biases{num_layer+1}];
    
    
    gradient_STL = zeros(size(param));
    index = 0;
    for i=1:num_layer+1
        the_length = size(D_J_param{i} , 2);
        gradient_STL(index+1:index+the_length) = D_J_param{i};
        index = index+the_length;
    end
    
end
end


