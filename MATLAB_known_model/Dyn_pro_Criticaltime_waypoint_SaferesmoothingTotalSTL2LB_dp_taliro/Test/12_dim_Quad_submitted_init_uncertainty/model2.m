function s_next  = model2(input)

dt = 0.1;

a = input(13:16);

x = input( 1:12);

uu = 0.5*tanh(a/10)+0.5;
     
[~,in_out] =  ode45(@(t,x)Quad_12(t,x,uu),[0 dt],x');

s_next=in_out(end,:)';

end