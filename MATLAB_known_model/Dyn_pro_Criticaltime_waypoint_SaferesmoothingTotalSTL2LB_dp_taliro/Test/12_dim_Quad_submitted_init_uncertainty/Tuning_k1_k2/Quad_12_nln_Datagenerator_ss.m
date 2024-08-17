function Output = Quad_12_nln_Datagenerator_ss(lb, ub, timestep, horizon, num_traj) 

n=12;


Nend=(horizon+1)*n;
N0=n;
Input = zeros(N0, num_traj);
Output = zeros(Nend, num_traj);

parfor j = 1:num_traj
    F = zeros(Nend,1);
    initial=lb + rand(n,1).*(ub-lb);
    Input(:,j) = initial;
    F(1:n,1) = initial;
    for i=1:horizon
        init_a = initial;
        a_control = rand(4,1);
        % a_control = [sin(i)^2; cos(i)^2; sin(i)^8; cos(i)^3];
        [~,in_out] =  ode45(@(t,x)Quad_12(t,x,a_control),[0 timestep],initial');
        in_out=in_out(end,:)';
        index = n*i;
        F(index+1:index+n,1) = in_out;
        initial = in_out;
    end
    Output(:,j) = F;
    
end




end