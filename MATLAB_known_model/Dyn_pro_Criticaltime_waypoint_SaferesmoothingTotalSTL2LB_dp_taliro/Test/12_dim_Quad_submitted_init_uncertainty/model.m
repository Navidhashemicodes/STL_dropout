function s_next  = model(input)

dt = 0.1;
N = 100;

a = input(13:16);

a_scaled = 0.5*tanh(a/10)+0.5;

x = input( 1:12);


X =cell(1,N);
X{1}     = x       + (dt / N) * Quad_12([], x, a_scaled);
for i=2:N
    X{i}     = X{i-1}      +  (dt / N) * Quad_12([] , X{i-1}, a_scaled);
end

s_next=X{N};

end