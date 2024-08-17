function grad = d_model(input)

num_agent = 0.25*(size(input,1));


index = 2*num_agent;
a = input(index+1:index+2*num_agent,1);

dt =0.1 * (4/1.5);

v = zeros(1, num_agent);
for i=1:num_agent
    v(i)   = tanh(0.5*a(2*i-1,1))+1;
end

d_d_a = zeros(2*num_agent);
for i=1:num_agent
    index = 2*i-1;
    d_d_a(index  ,index  ) =  dt * cos(a(index+1,1)) * (1 - tanh(0.5*a(index,1))^2) * 0.5;
    d_d_a(index  ,index+1) = -dt * v(i) * sin(a(index+1,1)); 
    d_d_a(index+1,index  ) =  dt * sin(a(index+1,1)) * (1 - tanh(0.5*a(index,1))^2) * 0.5;
    d_d_a(index+1,index+1) =  dt * v(i) * cos(a(index+1,1));
end

grad = [ eye(2*num_agent)  ,  d_d_a ];


end