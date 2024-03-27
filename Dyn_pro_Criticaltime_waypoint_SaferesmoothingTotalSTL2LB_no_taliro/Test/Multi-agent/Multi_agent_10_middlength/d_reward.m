function grad=d_reward(state)

num_agent = 10;

scl = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L_x = 12;
L_y = 12;

T=60;

N = floor(0.5*num_agent);
d = 1.35;
dd1 = (L_x-d)/N;
dd2 = (L_y-d)/(num_agent-N);

s0 = cell(1, num_agent);
center = cell(1, num_agent);
eps = cell(1, num_agent);
for i=1: num_agent

    if i<=N

        center{i} = [(i-1)*dd1+dd1/2 ; L_y-d];
        s0{i} = [L_x-(i-1)*dd1-dd1/2 ; d];

    else

        j = i-N;
        center{i} = [L_x-d ; (L_y-d)-(j-1)*dd2-dd2/2];
        s0{i} = [d; d+(j-1)*dd2+dd2/2];

    end

    eps{i} = center{i}-s0{i};

end
s = cell(1,T);
s{1}=reshape([s0{:}], [2*num_agent,1]);
F = zeros(1, T);
F(1) = (state-s{1})'*(state-s{1});
epsilon=reshape([eps{:}], [2*num_agent,1]);

grad = -  2*(state-s{1})' * exp(   -F(1)  /(scl^2)   )  / (scl^2);
for i=2:T
    s{i} = s{i-1}+epsilon/(T-1); 
    F(i) = (state-s{i})'*(state-s{i});
    grad = grad -  2*(state-s{i})' * exp(  -F(i)  /(scl^2)  ) / (scl^2);
end

end