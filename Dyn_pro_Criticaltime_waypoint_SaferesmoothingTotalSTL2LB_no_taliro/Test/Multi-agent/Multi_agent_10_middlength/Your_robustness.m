function [critic , rob ] = Your_robustness(Trajectory, Map)


T   = 60;
T_f = 48;
t_g = 12;
t_F = 20;
num_agent = 10;


traj = reshape(Trajectory , [2*num_agent , T+1]);


state = traj(:,t_F+1);
i=1;
[Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
winner0 = [4*i+ind-4, t_F];
Rob1 =Rob0;
winner1 = winner0;
for g=1:t_g
    state = traj(:,t_F+g+1);
    [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
    winner0 = [4*i+ind-4, t_F+g];
    [Rob1, ind] = min( [ Rob1, Rob0 ] );
    if ind==2
        winner1 = winner0;
    end
end
Rob2 = Rob1;
winner2 = winner1;
for f = t_F+1:T_f
    state = traj(:,f+1);
    [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
    winner0 = [4*i+ind-4, f];
    Rob1 =Rob0;
    winner1 = winner0;
    for g=1:t_g
        state = traj(:,f+g+1);
        [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
        winner0 = [4*i+ind-4, f+g];
        [Rob1, ind] = min( [ Rob1, Rob0 ] );
        if ind==2
            winner1 = winner0;
        end
    end
    [Rob2, ind] = max( [ Rob2, Rob1 ] );
    if ind==2
        winner2 = winner1;
    end
end
Rob3 = Rob2;
winner3 = winner2;


for i=2:num_agent

    state = traj(:,t_F+1);
    [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
    winner0 = [4*i+ind-4, t_F];
    Rob1 =Rob0;
    winner1 = winner0;
    for g=1:t_g
        state = traj(:,t_F+g+1);
        [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
        winner0 = [4*i+ind-4, t_F+g];
        [Rob1, ind] = min( [ Rob1, Rob0 ] );
        if ind==2
            winner1 = winner0;
        end
    end
    Rob2 = Rob1;
    winner2 = winner1;
    for f = t_F+1:T_f
        state = traj(:,f+1);
        [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
        winner0 = [4*i+ind-4, f];
        Rob1 =Rob0;
        winner1 = winner0;
        for g=1:t_g
            state = traj(:,f+g+1);
            [Rob0 ,ind] = min( [ Map.C(4*i-3,:)*state + Map.d(4*i-3,1),  Map.C(4*i-2,:)*state + Map.d(4*i-2,1),  Map.C(4*i-1,:)*state + Map.d(4*i-1,1),  Map.C(4*i,:)*state + Map.d(4*i,1)]);
            winner0 = [4*i+ind-4, f+g];
            [Rob1, ind] = min( [ Rob1, Rob0 ] );
            if ind==2
                winner1 = winner0;
            end
        end
        [Rob2, ind] = max([Rob2, Rob1]);
        if ind==2
            winner2 = winner1;
        end
    end
    [Rob3, ind] = min( [Rob3, Rob2]);
    if ind==2
        winner3 = winner2;
    end
end

rob1 = Rob3;
critic1 = winner3;


index = 4*num_agent;



state = traj(:,1);
[Rob0,ind] = max( [ Map.C(index+1,:)*state + Map.d(index+1,1),  Map.C(index+2,:)*state + Map.d(index+2,1), Map.C(index+3,:)*state + Map.d(index+3,1), Map.C(index+4,:)*state + Map.d(index+4,1) ]);
winner0 = [index+ind , 0];
Rob1 = Rob0;
winner1 = winner0;

for g=1:T
    state = traj(:,g+1);
    [Rob0,ind] = max( [ Map.C(index+1,:)*state + Map.d(index+1,1),  Map.C(index+2,:)*state + Map.d(index+2,1), Map.C(index+3,:)*state + Map.d(index+3,1), Map.C(index+4,:)*state + Map.d(index+4,1) ]);
    winner0 = [index+ind , g];
    [Rob1 , ind] = min( [ Rob1, Rob0 ]);
    if ind==2
        winner1 = winner0;
    end
end

Rob2 = Rob1;
winner2 = winner1;

index = index + 4;


for i=2:num_agent-1
    for j=i+1:num_agent

        state = traj(:,1);
        [Rob0,ind] = max( [ Map.C(index+1,:)*state + Map.d(index+1,1),  Map.C(index+2,:)*state + Map.d(index+2,1), Map.C(index+3,:)*state + Map.d(index+3,1), Map.C(index+4,:)*state + Map.d(index+4,1) ]);
        winner0 = [index+ind , 0];
        Rob1 = Rob0;
        winner1 = winner0;

        for g=1:T
            state = traj(:,g+1);
            [Rob0,ind] = max( [ Map.C(index+1,:)*state + Map.d(index+1,1),  Map.C(index+2,:)*state + Map.d(index+2,1), Map.C(index+3,:)*state + Map.d(index+3,1), Map.C(index+4,:)*state + Map.d(index+4,1) ]);
            winner0 = [index+ind , g];
            [Rob1 , ind] = min( [ Rob1, Rob0 ]);
            if ind==2
                winner1 = winner0;
            end
        end

        [Rob2 , ind] = min([Rob2, Rob1]);
        if ind == 2
            winner2 = winner1;
        end

        index = index+4;
    end
end
rob2 = Rob2;
critic2 = winner2;


[rob,ind] = min([rob1, rob2]);
if ind == 1
    critic = critic1;
else
    critic = critic2;
end

end