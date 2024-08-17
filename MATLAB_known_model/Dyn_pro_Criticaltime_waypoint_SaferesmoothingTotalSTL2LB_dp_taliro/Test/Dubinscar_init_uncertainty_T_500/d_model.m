function grad = d_model(input)

a = input(3:4,1);

dt =0.1;


v   = tanh(0.5*a(1,1))+1;


d_d_a = zeros(2,2);

d_d_a(1  ,1  ) =  dt * cos(a(2,1)) * (1 - tanh(0.5*a(1,1))^2) * 0.5;
d_d_a(1  ,2  ) = -dt * v  * sin(a(2,1)); 
d_d_a(2  ,1  ) =  dt * sin(a(2,1)) * (1 - tanh(0.5*a(1,1))^2) * 0.5;
d_d_a(2  ,2  ) =  dt * v * cos(a(2,1));

grad = [ eye(2)  ,  d_d_a ];


end