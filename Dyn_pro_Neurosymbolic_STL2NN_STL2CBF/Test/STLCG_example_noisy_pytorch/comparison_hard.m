clear all
clc
close all


addpath(genpath('C:\Users\navid\Documents\MATLAB\MATLAB_prev\Toyota\ICLR\Toolbox\Dyn_pro_Neurosymbolic_STL2NN_STL2CBF\src'));


T = 49;

%%%%%%%%%%%%%%%%%  STL2NN


cell_P1 = str2stl('[1,0]');
cell_P2 = str2stl('[2,0]');
cell_P3 = str2stl('[3,0]');
cell_P4 = str2stl('[4,0]');


cell_P5 = str2stl('[5,0]');
cell_P6 = str2stl('[6,0]');
cell_P7 = str2stl('[7,0]');
cell_P8 = str2stl('[8,0]');

cell_P9  = str2stl('[9 ,0]');
cell_P10 = str2stl('[10,0]');
cell_P11 = str2stl('[11,0]');
cell_P12 = str2stl('[12,0]');


cell_P13 = str2stl('[13,0]');
cell_P14 = str2stl('[14,0]');
cell_P15 = str2stl('[15,0]');
cell_P16 = str2stl('[16,0]');
cell_P17 = str2stl('[17,0]');
cell_P18 = str2stl('[18,0]');
cell_P19 = str2stl('[19,0]');
cell_P20 = str2stl('[20,0]');

cell_B_1 = and_operation( cell_P1, and_operation( cell_P2, and_operation( cell_P3 , cell_P4 )));
cell_B_2 = and_operation( cell_P5, and_operation( cell_P6, and_operation( cell_P7 , cell_P8 )));
cell_B_3 = and_operation( cell_P9, and_operation( cell_P10,and_operation( cell_P11, cell_P12)));
cell_C   = or_operation( cell_P13,or_operation( cell_P14,or_operation( cell_P15,or_operation(cell_P16, or_operation(cell_P17 , or_operation(cell_P18, or_operation( cell_P19 , cell_P20 )))))));


cell_FB1 = F_operation(G_operation(cell_B_1, 0 , 5), 0 , T-5);
cell_FB2 = F_operation(G_operation(cell_B_2, 0 , 5), 0 , T-5);
cell_FB3 = F_operation(G_operation(cell_B_3, 0 , 5), 0 , T-5);
cell_GC  = G_operation(cell_C, 0 , T);



STR  = and_operation( cell_FB2 , and_operation( cell_FB3 , cell_GC ) );

cell_phi = STR.cntn;


[s1,s2] = size(cell_phi);
TT = regexprep(strjoin(reshape(string(cell_phi)', [1,s1*s2]))  , ' ',  ''); %%% If you print TT you think it is the STL formula written in terms of '&' and '|'.
char_TT = char(TT);



%%% B_1
predicate_transformation.C(1,:)=[  1  0 ];
predicate_transformation.d(1,1)=  1  ;

predicate_transformation.C(2,:)=[ -1  0 ];
predicate_transformation.d(2,1)= -0.7;

predicate_transformation.C(3,:)=[  0  1 ];
predicate_transformation.d(3,1)=  0.2;

predicate_transformation.C(4,:)=[  0 -1 ];
predicate_transformation.d(4,1)=  0.5;



%%% B_2
predicate_transformation.C(5,:)=[  1  0 ];
predicate_transformation.d(5,1)=  0  ;

predicate_transformation.C(6,:)=[ -1  0 ];
predicate_transformation.d(6,1)=  0.9;

predicate_transformation.C(7,:)=[  0  1 ];
predicate_transformation.d(7,1)=  1  ;

predicate_transformation.C(8,:)=[  0 -1 ];
predicate_transformation.d(8,1)= -0.5;



%%% B_3
predicate_transformation.C(9,:) =[  1  0 ];
predicate_transformation.d(9,1) =  -0.2  ;

predicate_transformation.C(10,:)=[ -1  0 ];
predicate_transformation.d(10,1)=  0.7;

predicate_transformation.C(11,:)=[  0  1 ];
predicate_transformation.d(11,1)= -0.8  ;

predicate_transformation.C(12,:)=[  0 -1 ];
predicate_transformation.d(12,1)=  1.2;



%%% C
r=0.4;
a = (2-sqrt(2))*r;

x0 = r-a; y0 = -r; x1 = r; y1 = a-r;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
predicate_transformation.C(13,:) =[ -m  -1 ];
predicate_transformation.d(13,1) =  -d  ;
%%%%
x0 = r;   y0 = a-r; x1 = r; y1 =  r-a;
predicate_transformation.C(14,:)=[   1  0 ];
predicate_transformation.d(14,1)= -r;
%%%%
x0 = r;   y0 =  r-a; x1 = r-a; y1 =  r;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
predicate_transformation.C(15,:)=[  m  1 ];
predicate_transformation.d(15,1)=  d  ;
%%%%
x0 = r-a; y0 = r; x1 = a-r; y1 = r;
predicate_transformation.C(16,:)=[  0  1 ];
predicate_transformation.d(16,1)=  -r;
%%%%
x0 = a-r; y0 = r; x1 = -r; y1 = r-a;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
predicate_transformation.C(17,:)=[  m  1 ];
predicate_transformation.d(17,1)=  d  ;
%%%%
x0 = -r; y0 = r-a; x1 = -r; y1 = a-r;
predicate_transformation.C(18,:)=[ -1  0 ];
predicate_transformation.d(18,1)=  -r;
%%%%
x0 = -r; y0 = a-r; x1 = a-r; y1 = -r;
m = -(y1-y0)/(x1-x0);
d = ( (y1-y0)/(x1-x0) )*x0 -y0;
predicate_transformation.C(19,:)=[ -m -1 ];
predicate_transformation.d(19,1)= -d  ;
%%%%
x0 = a-r; y0 = -r; x1 = r-a; y1 = -r;
predicate_transformation.C(20,:)=[  0  -1 ];
predicate_transformation.d(20,1)=  -r;



tic

type = 'hard';
STL2NN    = Logic_Net(char_TT, predicate_transformation , T , type);
STL2NN_sorted = Linear_Nonlinear(STL2NN);

weights = STL2NN_sorted.weights;

Len = length(STL2NN_sorted.layers);
WL = cell(1,Len+1);
Wn = cell(1, Len);
BL = cell(1, Len+1);
Bn = cell(1, Len);
for i=1:Len
    L = STL2NN_sorted.layers{i};
    ss = 0;
    for j=1:length(L)
        
        if strcmp(L{j}, 'purelin')
            ss = ss+1;
        end
    end
    WL{i} = STL2NN_sorted.weights{i}(1:ss     , :);
    Wn{i} = STL2NN_sorted.weights{i}(ss+1:end , :);
    BL{i} = STL2NN_sorted.biases{i}(1:ss     , :);
    Bn{i} = STL2NN_sorted.biases{i}(ss+1:end , :);
end

for i=1:Len
    WL{i} = full(WL{i});
    Wn{i} = full(Wn{i});
end
WL{Len+1} = full(STL2NN_sorted.weights{Len+1});
save('weights_acc', 'WL', 'Wn')

for i=1:Len
    BL{i} = full(BL{i})';
    Bn{i} = full(Bn{i})';
end
BL{Len+1} = full(STL2NN_sorted.biases{Len+1})';
save('biases_acc', 'BL', 'Bn')



x = ones((T+1)*2,1);

for i=1:Len
    xn = poslin(Wn{i}*x + Bn{i}');
    xl = WL{i}*x + BL{i}';
    x = [xl ; xn];
end
y = WL{Len+1}*x + BL{Len+1}'