addpath('../');
%% parameters
M = 1.096;
m = 0.109;
b = 0.1;
l = 0.25;
% I = 0.0034;
I = 1/3*m*l^2;
g = 9.80;
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
%% hinf
Q = C2.' * C2;
R = 1;
gamma = 1.3;
B21 = [0;1;0;3];
Khinf = designHinf(A2, B2, B21, Q, R, gamma);
%%
Q = diag([1000,0,100,0]); R = 1;
Khinf1 = designHinf(A2, B2, B21,Q, R, 1.1);
Khinf2 = designHinf(A2, B2, B21, Q, R, 1.2);
Khinf3 = designHinf(A2, B2, B21, Q, R, 1.3);
Khinf4 = designHinf(A2, B2, B21, Q, R, 1.4);
Khinf5 = designHinf(A2, B2, B21, Q, R, 2);