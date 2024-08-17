function z = reward(s)

FF = 1000/10000;

scl = (90/999)*1000+0.1;

F   = zeros(1,4);
x     = cell(1,4);


x{1}  = [50 ; 200];
x{2}  = [200; 700];
x{3}  = [500; 850];
x{4}  = [900; 900];


z=0;
for i=1:4 
    F(i) = (s-FF*x{i})'*(s-FF*x{i});
    z = z + exp(  -F(i)  / (scl^2)  );
end

end