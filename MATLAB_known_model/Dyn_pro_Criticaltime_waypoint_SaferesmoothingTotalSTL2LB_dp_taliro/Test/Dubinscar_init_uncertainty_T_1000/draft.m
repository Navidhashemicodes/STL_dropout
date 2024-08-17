clear all
close all
clc

FF =1 ;

x1 = FF*[30; 200];
plot(x1(1), x1(2), '*')
hold on

x1 = FF*[55; 450];
plot(x1(1), x1(2), '*')
hold on

x1 = FF*[80; 600];
plot(x1(1), x1(2), '*')
hold on

x2 = FF*[125; 700];
plot(x2(1), x2(2), '*')
hold on


x2 = FF*[250; 800];
plot(x2(1), x2(2), '*')
hold on

x2 = FF*[375; 850];
plot(x2(1), x2(2), '*')
hold on


x3 = FF*[500; 875];
plot(x3(1), x3(2), '*')
hold on


x3 = FF*[700; 895];
plot(x3(1), x3(2), '*')
hold on


x3 = FF*[800; 900];
plot(x3(1), x3(2), '*')
hold on

x4 = FF*[900; 900];
plot(x4(1), x4(2), '*')
hold on

x = FF*[-10; 10; 10;-10 ];
y = FF*[-10;-10; 10; 10 ];
fill(x,y,'blue', 'FaceAlpha', 0.3)

hold on

x = FF*[ 300; 700; 700; 300 ];
y = FF*[ 300; 300; 700; 700 ];
fill(x,y,'r', 'FaceAlpha', 0.3)


hold on

x = FF*[ 875; 925; 925; 875 ];
y = FF*[ 875; 875; 925; 925 ];
fill(x,y,'green', 'FaceAlpha', 0.3)

axis equal

xlim(FF*[-30, 1000])
ylim(FF*[-30, 1000])