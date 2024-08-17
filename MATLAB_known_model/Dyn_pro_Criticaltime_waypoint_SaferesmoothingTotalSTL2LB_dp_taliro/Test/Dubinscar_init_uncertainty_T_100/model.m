function s_next  = model(input)


s = input(1:2,1);
a = input(3:4,1);



dt =0.1;

a(1,1) = 0.5 * a(1,1);
v   = tanh(a(1,1))+1;

s_next = zeros(2,1);

s_next(1,1) = s(1,1) + dt * v*cos(a(2,1));
s_next(2,1) = s(2,1) + dt * v*sin(a(2,1));



end