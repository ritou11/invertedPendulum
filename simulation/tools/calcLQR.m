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
%% lqr
Q = [100,0,100,0];
R = 1;
Klqr = designLQR(A2, B2, diag(Q), R);
disp(Q);
disp(Klqr);

%%
Q = [900,0,100,0];
R = 1;
Klqr = designLQR(A2, B2, diag(Q), R);
disp(Q);
disp(Klqr);
Q = [1000,0,100,0];
R = 1;
Klqr = designLQR(A2, B2, diag(Q), R);
disp(Q);
disp(Klqr);
Q = [100,0,100,0];
Klqr = designLQR(A2, B2, diag(Q), R);
disp(Q);
disp(Klqr);
Q = [1000,0,200,0];
Klqr = designLQR(A2, B2, diag(Q), R);
disp(Q);
disp(Klqr);
Q = [800,0,200,0];
Klqr = designLQR(A2, B2, diag(Q), R);
disp(Q);
disp(Klqr);