function grad = d_reward(s)
FF = 1;
s=s(1:3,1);

dest1 =FF*[-36  ;  0  ;   1   ];
dest2 =FF*[-32  ;  0  ;   5.76];
dest3 =FF*[-28  ;  0  ;   9.23];
dest4 =FF*[-24  ;  0  ;  11.76];
dest5 =FF*[-20  ;  0  ;  13.6 ];
dest6 =FF*[-18  ;  0  ;  15   ];
dest7 =FF*[-14  ;  0  ;  15.9 ];
dest8 =FF*[-10  ;  0  ;  16.6 ];
dest9 =FF*[ -6  ;  0  ;  17.1 ];
dest10=FF*[  0  ;  0  ;  17.5 ];
dest11=FF*[  6  ;  0  ;  15.8 ];
dest12=FF*[ 12  ;  0  ;  12   ];
dest13=FF*[ 18  ;  0  ;   7   ];
dest14=FF*[ 24  ;  0  ;   3.5 ];
dest15=FF*[ 30  ;  0  ;   1   ];
dest16=FF*[ 36  ;  0  ;   0.4 ];
dest17=FF*[ 42  ;  0  ;   0.1 ];
dest18=FF*[ 48  ;  0  ;   0.1 ];
dest19=FF*[ 50  ;  0  ;   0.1 ];
dest20=FF*[ 56  ;  0  ;   0.1 ];

F1=   (s(1)-dest1(1) )^2 + ( 1 - (s(2)-dest1(2) )^2/((20/ 30)^2)   -(s(3)-dest1(3) )^2/((45/ 30)^2)  )^2;
F2=   (s(1)-dest2(1) )^2 + ( 1 - (s(2)-dest2(2) )^2/((20/ 25)^2)   -(s(3)-dest2(3) )^2/((45/ 25)^2)  )^2;
F3=   (s(1)-dest3(1) )^2 + ( 1 - (s(2)-dest3(2) )^2/((20/ 20)^2)   -(s(3)-dest3(3) )^2/((45/ 20)^2)  )^2;
F4=   (s(1)-dest4(1) )^2 + ( 1 - (s(2)-dest4(2) )^2/((20/ 16)^2)   -(s(3)-dest4(3) )^2/((45/ 16)^2)  )^2;
F5=   (s(1)-dest5(1) )^2 + ( 1 - (s(2)-dest5(2) )^2/((20/ 12)^2)   -(s(3)-dest5(3) )^2/((45/ 12)^2)  )^2;
F6=   (s(1)-dest6(1) )^2 + ( 1 - (s(2)-dest6(2) )^2/((20/  9)^2)   -(s(3)-dest6(3) )^2/((45/  9)^2)  )^2;
F7=   (s(1)-dest7(1) )^2 + ( 1 - (s(2)-dest7(2) )^2/((20/  6)^2)   -(s(3)-dest7(3) )^2/((45/  6)^2)  )^2;
F8=   (s(1)-dest8(1) )^2 + ( 1 - (s(2)-dest8(2) )^2/((20/  3)^2)   -(s(3)-dest8(3) )^2/((45/  3)^2)  )^2;
F9=   (s(1)-dest9(1) )^2 + ( 1 - (s(2)-dest9(2) )^2/((20/  2)^2)   -(s(3)-dest9(3) )^2/((45/  2)^2)  )^2;
F10=  (s(1)-dest10(1))^2 + ( 1 - (s(2)-dest10(2))^2/((20/  1)^2)   -(s(3)-dest10(3))^2/((45/  1)^2)  )^2;
F11=  (s(1)-dest11(1))^2 + ( 1 - (s(2)-dest11(2))^2/((20/  2)^2)   -(s(3)-dest11(3))^2/((45/  2)^2)  )^2;
F12=  (s(1)-dest12(1))^2 + ( 1 - (s(2)-dest12(2))^2/((20/  5)^2)   -(s(3)-dest12(3))^2/((45/  5)^2)  )^2;
F13=  (s(1)-dest13(1))^2 + ( 1 - (s(2)-dest13(2))^2/((20/ 10)^2)   -(s(3)-dest13(3))^2/((45/ 10)^2)  )^2;
F14=  (s(1)-dest14(1))^2 + ( 1 - (s(2)-dest14(2))^2/((20/ 16)^2)   -(s(3)-dest14(3))^2/((45/ 16)^2)  )^2;
F15=  (s(1)-dest15(1))^2 + ( 1 - (s(2)-dest15(2))^2/((20/ 24)^2)   -(s(3)-dest15(3))^2/((45/ 24)^2)  )^2;
F16=  (s(1)-dest16(1))^2 + ( 1 - (s(2)-dest16(2))^2/((20/ 30)^2)   -(s(3)-dest16(3))^2/((45/ 30)^2)  )^2;
F17=  (s(1)-dest17(1))^2 + ( 1 - (s(2)-dest17(2))^2/((20/ 70)^2)   -(s(3)-dest17(3))^2/((45/ 70)^2)  )^2;
F18=  (s(1)-dest18(1))^2 + ( 1 - (s(2)-dest18(2))^2/((20/100)^2)   -(s(3)-dest18(3))^2/((45/100)^2)  )^2;
F19=  (s(1)-dest19(1))^2 + ( 1 - (s(2)-dest19(2))^2/((20/100)^2)   -(s(3)-dest19(3))^2/((45/100)^2)  )^2;
F20=  (s(1)-dest20(1))^2 + ( 1 - (s(2)-dest20(2))^2/((20/100)^2)   -(s(3)-dest20(3))^2/((45/100)^2)  )^2;

scl =10;

grad1 = -[2*(s(1)-dest1(1))  2*( 1 - (s(2)-dest1(2) )^2/((20/ 30)^2)   -(s(3)-dest1(3) )^2/((45/ 30)^2)  )*[ -2*(s(2)-dest1(2) )/((20/ 30)^2)   -2*(s(3)-dest1(3) )/((45/ 30)^2)  ]     ] *exp(  -F1 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest2(1))  2*( 1 - (s(2)-dest2(2) )^2/((20/ 25)^2)   -(s(3)-dest2(3) )^2/((45/ 25)^2)  )*[ -2*(s(2)-dest2(2) )/((20/ 25)^2)   -2*(s(3)-dest2(3) )/((45/ 25)^2)  ]     ] *exp(  -F2 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest3(1))  2*( 1 - (s(2)-dest3(2) )^2/((20/ 20)^2)   -(s(3)-dest3(3) )^2/((45/ 20)^2)  )*[ -2*(s(2)-dest3(2) )/((20/ 20)^2)   -2*(s(3)-dest3(3) )/((45/ 20)^2)  ]     ] *exp(  -F3 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest4(1))  2*( 1 - (s(2)-dest4(2) )^2/((20/ 16)^2)   -(s(3)-dest4(3) )^2/((45/ 16)^2)  )*[ -2*(s(2)-dest4(2) )/((20/ 16)^2)   -2*(s(3)-dest4(3) )/((45/ 16)^2)  ]     ] *exp(  -F4 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest5(1))  2*( 1 - (s(2)-dest5(2) )^2/((20/ 12)^2)   -(s(3)-dest5(3) )^2/((45/ 12)^2)  )*[ -2*(s(2)-dest5(2) )/((20/ 12)^2)   -2*(s(3)-dest5(3) )/((45/ 12)^2)  ]     ] *exp(  -F5 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest6(1))  2*( 1 - (s(2)-dest6(2) )^2/((20/  9)^2)   -(s(3)-dest6(3) )^2/((45/  9)^2)  )*[ -2*(s(2)-dest6(2) )/((20/  9)^2)   -2*(s(3)-dest6(3) )/((45/  9)^2)  ]     ] *exp(  -F6 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest7(1))  2*( 1 - (s(2)-dest7(2) )^2/((20/  6)^2)   -(s(3)-dest7(3) )^2/((45/  6)^2)  )*[ -2*(s(2)-dest7(2) )/((20/  6)^2)   -2*(s(3)-dest7(3) )/((45/  6)^2)  ]     ] *exp(  -F7 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest8(1))  2*( 1 - (s(2)-dest8(2) )^2/((20/  3)^2)   -(s(3)-dest8(3) )^2/((45/  3)^2)  )*[ -2*(s(2)-dest8(2) )/((20/  3)^2)   -2*(s(3)-dest8(3) )/((45/  3)^2)  ]     ] *exp(  -F8 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest9(1))  2*( 1 - (s(2)-dest9(2) )^2/((20/  2)^2)   -(s(3)-dest9(3) )^2/((45/  2)^2)  )*[ -2*(s(2)-dest9(2) )/((20/  2)^2)   -2*(s(3)-dest9(3) )/((45/  2)^2)  ]     ] *exp(  -F9 /(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest10(1)) 2*( 1 - (s(2)-dest10(2))^2/((20/  1)^2)   -(s(3)-dest10(3))^2/((45/  1)^2)  )*[ -2*(s(2)-dest10(2))/((20/  1)^2)   -2*(s(3)-dest10(3))/((45/  1)^2)  ]     ] *exp(  -F10/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest11(1)) 2*( 1 - (s(2)-dest11(2))^2/((20/  2)^2)   -(s(3)-dest11(3))^2/((45/  2)^2)  )*[ -2*(s(2)-dest11(2))/((20/  2)^2)   -2*(s(3)-dest11(3))/((45/  2)^2)  ]     ] *exp(  -F11/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest12(1)) 2*( 1 - (s(2)-dest12(2))^2/((20/  5)^2)   -(s(3)-dest12(3))^2/((45/  5)^2)  )*[ -2*(s(2)-dest12(2))/((20/  5)^2)   -2*(s(3)-dest12(3))/((45/  5)^2)  ]     ] *exp(  -F12/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest13(1)) 2*( 1 - (s(2)-dest13(2))^2/((20/ 10)^2)   -(s(3)-dest13(3))^2/((45/ 10)^2)  )*[ -2*(s(2)-dest13(2))/((20/ 10)^2)   -2*(s(3)-dest13(3))/((45/ 10)^2)  ]     ] *exp(  -F13/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest14(1)) 2*( 1 - (s(2)-dest14(2))^2/((20/ 16)^2)   -(s(3)-dest14(3))^2/((45/ 16)^2)  )*[ -2*(s(2)-dest14(2))/((20/ 16)^2)   -2*(s(3)-dest14(3))/((45/ 16)^2)  ]     ] *exp(  -F14/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest15(1)) 2*( 1 - (s(2)-dest15(2))^2/((20/ 24)^2)   -(s(3)-dest15(3))^2/((45/ 24)^2)  )*[ -2*(s(2)-dest15(2))/((20/ 24)^2)   -2*(s(3)-dest15(3))/((45/ 24)^2)  ]     ] *exp(  -F15/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest16(1)) 2*( 1 - (s(2)-dest16(2))^2/((20/ 30)^2)   -(s(3)-dest16(3))^2/((45/ 30)^2)  )*[ -2*(s(2)-dest16(2))/((20/ 30)^2)   -2*(s(3)-dest16(3))/((45/ 30)^2)  ]     ] *exp(  -F16/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest17(1)) 2*( 1 - (s(2)-dest17(2))^2/((20/ 70)^2)   -(s(3)-dest17(3))^2/((45/ 70)^2)  )*[ -2*(s(2)-dest17(2))/((20/ 70)^2)   -2*(s(3)-dest17(3))/((45/ 70)^2)  ]     ] *exp(  -F17/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest18(1)) 2*( 1 - (s(2)-dest18(2))^2/((20/100)^2)   -(s(3)-dest18(3))^2/((45/100)^2)  )*[ -2*(s(2)-dest18(2))/((20/100)^2)   -2*(s(3)-dest18(3))/((45/100)^2)  ]     ] *exp(  -F18/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest19(1)) 2*( 1 - (s(2)-dest19(2))^2/((20/100)^2)   -(s(3)-dest19(3))^2/((45/100)^2)  )*[ -2*(s(2)-dest19(2))/((20/100)^2)   -2*(s(3)-dest19(3))/((45/100)^2)  ]     ] *exp(  -F19/(  (scl*FF)^2  )  )/(  (scl*FF)^2  )...
        -[2*(s(1)-dest20(1)) 2*( 1 - (s(2)-dest20(2))^2/((20/100)^2)   -(s(3)-dest20(3))^2/((45/100)^2)  )*[ -2*(s(2)-dest20(2))/((20/100)^2)   -2*(s(3)-dest20(3))/((45/100)^2)  ]     ] *exp(  -F20/(  (scl*FF)^2  )  )/(  (scl*FF)^2  );
        
grad  =   [ grad1      zeros(1,4)];

end