function grad = d_reward(s)
FF = 100/10000;

scl = (90/999)*100+0.1;

F   = zeros(1,4);
x     = cell(1,4);
x{1}  = [50 ; 200];
x{2}  = [200; 700];
x{3}  = [500; 850];
x{4}  = [900; 900];

grad = zeros(1, 2);
for i=1:4
    F(i) = (s-FF*x{i})'*(s-FF*x{i});
    grad = grad -  2*(s-FF*x{i})'* exp(  -F(i)  /(scl^2)  ) / (scl^2);
end

end