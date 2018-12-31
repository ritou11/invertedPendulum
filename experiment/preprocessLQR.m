function [t, X, acc, xref] = preprocessLQR(PosData, Qx, Qphi)
%% models
m = 0.109;
l = 0.25;
I = 1/3*m*l^2;
g = 9.80;
A2 = [0 1 0 0;
    0 0 0 0
    0 0 0 1
    0 0 m*g*l/(I + m*l^2) 0];
B2 = [0
    1
    0
    m*l/(I+m*l^2)];
Q = [Qx,0,Qphi,0];
R = 1;
Klqr = designLQR(A2, B2, diag(Q), R);
Klqr = round(Klqr, 2);
%% smooth acc
t = PosData.time;
x = PosData.signals(1).values;
err = PosData.signals(3).values(:,1);
xref = err + x;
theta = PosData.signals(2).values;
phi = mod(theta, 2 * pi) - pi;
dt = t(2:end) - t(1:end-1);
dx = x(2:end) - x(1:end-1);
dphi = phi(2:end) - phi(1:end-1);
dx_dt = dx./dt;
dphi_dt = dphi./dt;
t = t(2:end);
x = x(2:end);
phix = phi(2:end);
xref = xref(2:end);
X = [x';dx_dt';phix';dphi_dt'];
cXt = [x' - xref';dx_dt';phix';dphi_dt'];
accCalc = -Klqr * cXt;
%% up detection
windowSize = 1000;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
phif = filter(b,a,phix);
t0i = find(abs(phif(round(windowSize/2):end)) < 5e-2, 1) + windowSize/2;
X = X(:, t0i:end);
t = t(t0i:end);
xref = xref(t0i:end);
acc = accCalc(t0i:end);
end