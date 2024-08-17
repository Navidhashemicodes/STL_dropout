function  [D_f_s,  D_f_a] = repeated_d_model(Trajectory, action_traj, i, j)


%%% If the derivative is with respect to the initial condition then i
%%% should be zero. Here Trahectory(:,1) is the initial state.

n= size(Trajectory, 1);


Grad = 1;


for k = j:-1:i+2
    Input = [Trajectory(:,k) ; action_traj(:,k)];
    Grad_sa = d_model(Input); 
    Grad = Grad*Grad_sa(:,1:n);
end
% disp([i,j])
Input = [Trajectory(:,i+1) ; action_traj(:,i+1)];
Grad_sa = d_model(Input); 


if i==0
    D_f_s = [];
else
    D_f_s = Grad * Grad_sa(:,1:n);
end
D_f_a = Grad * Grad_sa(:,n+1:end);

end
