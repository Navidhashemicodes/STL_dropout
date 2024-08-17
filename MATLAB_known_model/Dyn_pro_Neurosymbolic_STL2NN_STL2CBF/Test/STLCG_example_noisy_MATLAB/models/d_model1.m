function grad = d_model(input)

a = input(3:4,1);

dt =0.1;

a(1,1)=0.5*a(1,1);
a(2,1)=0.5*a(2,1);

d_d_s=  eye(2);


f11= 2 * dt * (1- tanh(a(1,1))^2);

f22= 2 * dt * (1- tanh(a(2,1))^2);

d_d_a=[  f11   0    ;...
           0   f22  ];

grad  =  [d_d_s, d_d_a];


end