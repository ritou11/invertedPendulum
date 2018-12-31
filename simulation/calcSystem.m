%% parameters
M = 1.096;
m = 0.109;
b = 0.1;
l = 0.25;
I = 1/3*m*l^2;
% I = 0.0034;
g = 9.80;
%% use F
A1 = [0 1 0 0;
    0 -((I+m*l^2)*b)/(I*(M+m)+M*m*l^2) m^2*g*l^2/(I*(M+m)+M*m*l^2) 0
    0 0 0 1
    0 -(m*l*b)/(I*(M+m)+M*m*l^2) m*g*l*(M+m)/(I*(M+m)+M*m*l^2) 0];
B1 = [0
    (I+m*l^2)/(I*(M+m)+M*m*l^2)
    0
    m*l/(I*(M+m)+M*m*l^2)];
C1 = [1 0 0 0
    0 0 1 0];
D1 = [0
    0];
[num, den] = ss2tf(A1,B1,C1,D1);
% printsys(num, den);
%% use a
A2 = [0 1 0 0;
    0 0 0 0
    0 0 0 1
    0 0 m*g*l/(I + m*l^2) 0];
B2 = [0
    1
    0
    m*l/(I+m*l^2)];
C2 = [1 0 0 0
    0 0 1 0];
D2 = [0
    0];
[num, den] = ss2tf(A2,B2,C2,D2);
% printsys(num, den);
%% lqr
Q = C2.' * C2;
R = 1;
Klqr = designLQR(A2, B2, Q, R);
Klqr1 = designLQR(A2, B2, diag([1,0,1,0]), 1);
Klqr2 = designLQR(A2, B2, diag([100,0,100,0]), 1);
Klqr3 = designLQR(A2, B2, diag([900,0,100,0]), 1);
Klqr4 = designLQR(A2, B2, diag([9000,0,1000,0]), 1);

%% hinf
Q = C2.' * C2;
R = 1;
gamma = 2;
B21 = [0;1;0;0];
Khinf = designHinf(A2, B2, [0;1;0;0], Q, R, gamma);
Q = diag([100,0,100,0]);
Khinf1 = designHinf(A2, B2, B21,Q, R, 2.4);
Khinf2 = designHinf(A2, B2, B21, Q, R, 2.5);
Khinf3 = designHinf(A2, B2, B21, Q, R, 2.6);
Khinf4 = designHinf(A2, B2, B21, Q, R, 2.7);