function Grad  =  safe_resmoothing_TotalLB(s0, C, D, param, dim, T, th, STL2LB, b)

n = size(s0,1);
[Weights, Biases,~] = param2net(param, dim, []);

num_layer = length(dim)-2;
%%% Generate the trajectory

Preactivate = cell(num_layer,T);
Postactivate  = cell(num_layer,T);
a   = cell(1,T);
s   = cell(1,T);
s_c = cell(1,T);

s0_c = C*s0+D;
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


action_traj = [a{:}];
Trajectory = [s0, [s{:}] ];
[Pre , ~] = NN_middle(STL2LB, reshape(Trajectory , [numel(Trajectory) , 1])  ,  b );
d_Rho_Traj = in_out_der(Pre, STL2LB, b);
d_Rho_Traj(:, 1:n) = [];  %%% remove the gradients for initial state
Grad = zeros(size(param));
for i=1:length(th)
    D_D = zeros(n, length(th{i}));
    for j = 1:n
        D_D(j,:) = d_Rho_Traj(1, (th{i}-1)*n+j);
    end
    d_Rho_X = reshape(D_D, [numel(D_D) , 1])';
    d_X_P   = smooth_grad(Trajectory, action_traj, C, D, s_c, Postactivate, param, dim,  th{i});
    Grad = Grad + d_Rho_X * d_X_P;
end

end