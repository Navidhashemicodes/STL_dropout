function s_next  = model(input)

num_agent = 0.25*(size(input,1));

s = input(1:2*num_agent,1);
index = 2*num_agent;
a = input(index+1:index+2*num_agent,1);



dt =0.1 * (4/1.5);

v = zeros(1, num_agent);
for i=1:num_agent
    a(2*i-1,1) = 0.5 * a(2*i-1,1);
    v(i)   = tanh(a(2*i-1,1))+1;
end

s_next = zeros(size(s));
for i=1:num_agent
    index = 2*i-1;
    s_next(index  ,1) = s(index  ,1) + dt * v(i)*cos(a(index+1,1));
    s_next(index+1,1) = s(index+1,1) + dt * v(i)*sin(a(index+1,1));
end


end