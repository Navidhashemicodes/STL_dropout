clear all
close all
clc

FF=1;
N=100;
x = FF*(linspace(0,10,N));
y = FF*(linspace(0,10,N));
z = FF*(linspace(-5,5,N));
f=zeros(N,N,N);
for i=1:N
    for j=1:N
        for k=1:N
            f(i,j,k) = reward([x(i);y(j);z(k);zeros(3,1)]);
        end
    end
end

for k=1:10
    figure(k)
    z_index= 10*(k-1)+1;
    [X, Y] = meshgrid(x,y);
    F = squeeze(f(:,:,z_index));
    surf(X,Y,F,'FaceAlpha',0.5)
end

for i=1:10
    figure(i)
    x_index= 10*(i-1)+1;
    [Y, Z] = meshgrid(y,z);
    F = squeeze(f(x_index,:,:));
    surf(Y,Z,F,'FaceAlpha',0.5)
end