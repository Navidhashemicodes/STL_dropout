function X_P  = smooth_grad(Trajectory, action_traj, C, D, s_c, Postactivate, param, dim,  sampled_T)

s0 = Trajectory(:,1);
s0_c = C*s0+D;

n=size(s0,1);

[Weights, ~,~] = param2net(param, dim, []);

num_layer = length(dim)-2;
n_c  = size(C,1);



N_sample = length(sampled_T);


D_f_a = cell(1, N_sample);
D_f_s = cell(1, N_sample);
D_S_step = cell(1, N_sample);


[ D_f_s{1}, D_f_a{1} ] = repeated_d_model(Trajectory, action_traj, 0, sampled_T(1));

D_S_step{1}=0;

%%% with back propagation please consider this is not with respect
%%% to s0 that is a constant. in fact this is with respect to s{Postactivatempled_T(1)}

for i=2:N_sample
    
    [ D_f_s{i}, D_f_a{i} ] = repeated_d_model(Trajectory, action_traj, sampled_T(i-1), sampled_T(i) );
    
    der =1;
    for j=num_layer+1:-1:2
        der  = der * Weights{j}*diag(Postactivate{j-1,sampled_T(i)}.^2);
    end
    der = der * Weights{1}(:,1:n_c)*C;
    
    D_S_step{i}=D_f_s{i}+D_f_a{i} * der;

end



%%%%%% First Layers

D_Postactivate_W = cell(1,num_layer);
D_Postactivate_B = cell(1,num_layer);
D_S_W = cell(1,num_layer+1);
D_S_B = cell(1,num_layer+1);

for param_index=1:num_layer
    M = dim(param_index+1);
    I=eye(M);
    D_Postactivate_W{param_index} = cell(M,N_sample);
    D_Postactivate_B{param_index} = cell(M,N_sample);
    D_S_W{param_index} = cell(M,N_sample);
    D_S_B{param_index} = cell(M,N_sample);
    
    for m=1:M
        if param_index ==1
            D_Postactivate_W{param_index}{m,1}=kron(I(:,m), ((1-(Postactivate{param_index,1}(m,1))^2)*[s0_c;0])' );  %%% NN is designed for the time steps not the real times in seconds.
        else
            D_Postactivate_W{param_index}{m,1}=kron(I(:,m), ((1-(Postactivate{param_index,1}(m,1))^2)*Postactivate{param_index-1,1})' );
        end
        D_Postactivate_B{param_index}{m,1}=(1-(Postactivate{param_index,1}(m,1))^2)*I(:,m);
        
        der =1;
        for j=num_layer+1:-1:param_index+2
            der  = der * Weights{j}*diag(Postactivate{j-1,1}.^2);
        end
        der = der * Weights{param_index+1};
        
        D_S_W{param_index}{m,1}=D_f_a{1}*der*D_Postactivate_W{param_index}{m,1};
        D_S_B{param_index}{m,1}=D_f_a{1}*der*D_Postactivate_B{param_index}{m,1};
        
        for i=2:N_sample
            if param_index == 1
                D_Postactivate_W{param_index}{m,i}=kron(I(:,m), ((1-(Postactivate{param_index,sampled_T(i-1)+1}(m,1))^2)*[s_c{sampled_T(i-1)};sampled_T(i-1)])' );
            else
                D_Postactivate_W{param_index}{m,i}=kron(I(:,m), ((1-(Postactivate{param_index,sampled_T(i-1)+1}(m,1))^2)*Postactivate{param_index-1,sampled_T(i-1)+1})' );
            end
            D_Postactivate_B{param_index}{m,i}=(1-(Postactivate{param_index,sampled_T(i-1)+1}(m,1))^2)*I(:,m);
            
            der =1;
            for j=num_layer+1:-1:param_index+2
                der  = der * Weights{j}*diag(Postactivate{j-1,sampled_T(i-1)+1}.^2);
            end
            der = der * Weights{param_index+1};
            
            D_S_W{param_index}{m,i}=D_f_a{i}*der*D_Postactivate_W{param_index}{m,i}+D_f_s{i}*D_S_W{param_index}{m,i-1};
            D_S_B{param_index}{m,i}=D_f_a{i}*der*D_Postactivate_B{param_index}{m,i}+D_f_s{i}*D_S_B{param_index}{m,i-1};
        end
    end
end



P =dim(end);
I=eye(P);
for p=1:P
    D_S_W{num_layer+1}{p,1}=D_f_a{1}*kron(I(:,p) , Postactivate{num_layer,1}');
    D_S_B{num_layer+1}{p,1}=D_f_a{1}*I(:,p);
    for i=2:N_sample
        D_S_W{num_layer+1}{p,i}=D_f_a{i}*kron(I(:,p) , Postactivate{num_layer,sampled_T(i-1)+1}')+D_f_s{i}*D_S_W{num_layer+1}{p,i-1};
        D_S_B{num_layer+1}{p,i}=D_f_a{i}*I(:,p)+D_f_s{i}*D_S_B{num_layer+1}{p,i-1};
    end
end





X_P = zeros(n*N_sample , length(param));
kk=0;
for param_index = 1: num_layer+1
    M = dim(param_index+1);
    ww = 0;
    for m=1:M
        hh = 0;
        for i=1:N_sample
            [hp , wp] = size(D_S_W{param_index}{m,i});
            X_P(hh+1:hh+hp , kk+ww+1:kk+ww+wp) = D_S_W{param_index}{m,i};
            hh = hh+hp;
        end
        ww = ww+wp;
    end
    for m=1:M
        hh = 0;
        for i=1:N_sample
            [hp , wp] = size(D_S_B{param_index}{m,i});
            X_P(hh+1:hh+hp , kk+ww+1:kk+ww+wp) = D_S_B{param_index}{m,i};
            hh = hh+hp;
        end
        ww = ww+wp;
    end
    kk = kk + ww;
end


end