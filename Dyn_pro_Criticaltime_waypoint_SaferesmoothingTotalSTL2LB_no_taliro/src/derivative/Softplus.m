% function y = Softplus(x,b)
% 
% y = (1/b) *(log(1+exp(b*x)));
% 
% end



function y = Softplus(x,b)


if numel(x)>1 || numel(b)==0
    error('vector is not allowed or b should be assigned.')
end


if b*x >50
    y = x;
elseif abs(b*x)<50
    y = (1/b) *(log(1+exp(b*x)));
else
    y = 0;
end


end