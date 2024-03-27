clear all
close all
clc

tic

num_agent = 50;

L_x = 4;
L_y = 4;

T=15;

if L_x~=L_y
    error('update dist')
end

N = floor(0.5*num_agent);
d = 4/26;
dd1 = (L_x-d)/N;
dd2 = (L_y-d)/(num_agent-N);

s0 = cell(1, num_agent);
center = cell(1, num_agent);
eps = cell(1, num_agent);
for i=1: num_agent

    if i<=N

        center{i} = [(i-1)*dd1+dd1/2 ; L_y-d];
        s0{i} = [L_x-(i-1)*dd1-dd1/2 ; d];

    else

        j = i-N;
        center{i} = [L_x-d ; (L_y-d)-(j-1)*dd2-dd2/2];
        s0{i} = [d; d+(j-1)*dd2+dd2/2];

    end

    eps{i} = center{i}-s0{i};

end
s = cell(1,T);
s{1}=[s0{:}];
figure(1)
plot(s{1}(1,:),s{1}(2,:));
xlim([0,4]);
ylim([0,4]);
axis equal
epsilon=[eps{:}];

for i=2:T
    s{i} = s{i-1}+epsilon/(T-1); 
    figure(i)
    plot(s{i}(1,:),s{i}(2,:));
    xlim([0,4]);
    ylim([0,4]);
    axis equal
end


Run = 2000*toc




% tic;
% 
% state = rand(100,1);
% num_agent = 50;
% 
% scl = 10;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% L_x = 4;
% L_y = 4;
% 
% T=15;
% 
% N = floor(0.5*num_agent);
% d = 4/26;
% dd1 = (L_x-d)/N;
% dd2 = (L_y-d)/(num_agent-N);
% 
% s0 = cell(1, num_agent);
% center = cell(1, num_agent);
% eps = cell(1, num_agent);
% for i=1: num_agent
% 
%     if i<=N
% 
%         center{i} = [(i-1)*dd1+dd1/2 ; L_y-d];
%         s0{i} = [L_x-(i-1)*dd1-dd1/2 ; d];
% 
%     else
% 
%         j = i-N;
%         center{i} = [L_x-d ; (L_y-d)-(j-1)*dd2-dd2/2];
%         s0{i} = [d; d+(j-1)*dd2+dd2/2];
% 
%     end
% 
%     eps{i} = center{i}-s0{i};
% 
% end
% s = cell(1,T);
% s{1}=reshape([s0{:}], [2*num_agent,1]);
% F = zeros(1, T);
% F(1) = (state-s{1})'*(state-s{1});
% epsilon=reshape([eps{:}], [2*num_agent,1]);
% 
% z =  exp(   -F(1)  /(scl^2)   )  ;
% for i=2:T
%     s{i} = s{i-1}+epsilon/(T-1); 
%     F(i) = (state-s{i})'*(state-s{i});
%     z = z + exp(  -F(i)  /(scl^2)  ) ;
% end


% Run =2000*toc
% 



% tic;
% 
% state = rand(100,1);
% 
% num_agent = 50;
% 
% scl = 10;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% L_x = 4;
% L_y = 4;
% 
% T=15;
% 
% N = floor(0.5*num_agent);
% d = 4/26;
% dd1 = (L_x-d)/N;
% dd2 = (L_y-d)/(num_agent-N);
% 
% s0 = cell(1, num_agent);
% center = cell(1, num_agent);
% eps = cell(1, num_agent);
% for i=1: num_agent
% 
%     if i<=N
% 
%         center{i} = [(i-1)*dd1+dd1/2 ; L_y-d];
%         s0{i} = [L_x-(i-1)*dd1-dd1/2 ; d];
% 
%     else
% 
%         j = i-N;
%         center{i} = [L_x-d ; (L_y-d)-(j-1)*dd2-dd2/2];
%         s0{i} = [d; d+(j-1)*dd2+dd2/2];
% 
%     end
% 
%     eps{i} = center{i}-s0{i};
% 
% end
% s = cell(1,T);
% s{1}=reshape([s0{:}], [2*num_agent,1]);
% F = zeros(1, T);
% F(1) = (state-s{1})'*(state-s{1});
% epsilon=reshape([eps{:}], [2*num_agent,1]);
% 
% grad = -  2*(state-s{1})' * exp(   -F(1)  /(scl^2)   )  / (scl^2);
% for i=2:T
%     s{i} = s{i-1}+epsilon/(T-1); 
%     F(i) = (state-s{i})'*(state-s{i});
%     grad = grad -  2*(state-s{i})' * exp(  -F(i)  /(scl^2)  ) / (scl^2);
% end
% 
% Run =2000*toc

