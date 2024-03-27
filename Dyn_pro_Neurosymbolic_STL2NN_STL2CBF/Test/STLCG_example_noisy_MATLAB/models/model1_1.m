function s_next  = model(input)

s = input(1:2,1);
a = input(3:4,1);


dt =0.1;

a(1,1)=0.5*a(1,1);
a(2,1)=0.5*a(2,1);

s_next= s  +  4 * dt * tanh(a) ;

end