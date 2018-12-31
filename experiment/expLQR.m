addpath('../simulation');
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
C2 = [1 0 0 0
    0 0 1 0];
D2 = [0
    0];
%% explain huge data of acc
Q = [100,0,100,0]; % TAKE 100.100 AS EXAMPLE
R = 1;
Klqr = designLQR(A2, B2, diag(Q), R);
Klqr = round(Klqr, 2);

data = load(sprintf('lqr%d.%d.mat', Q(1), Q(3)), 'PosData');
PosData = data.PosData;
t = PosData.time;
x = PosData.signals(1).values;
errx = PosData.signals(3).values(:,1);
xref = errx + x;
theta = PosData.signals(2).values;
phi = mod(theta, 2 * pi) - pi;
dt = t(2:end) - t(1:end-1);
dx = x(2:end) - x(1:end-1);
dphi = phi(2:end) - phi(1:end-1);
dx_dt = dx./dt;
dphi_dt = dphi./dt;
tx = t(2:end);
xx = x(2:end);
phix = phi(2:end);
xref = xref(2:end);
accx = PosData.signals(4).values(2:end);
cXt = [xx' - xref';dx_dt';phix';dphi_dt'];
accCalc = -Klqr * cXt;

fig = figure();
hold on;
plot(tx, accx);
plot(tx, accCalc);

%% xref detection
accErr = accx - accCalc';
for i = 2:size(accErr) - 1
    if abs(accErr(i)) > abs(accErr(i-1)) + abs(accErr(i+1))
        accErr(i) = accErr(i+1);
    end
end
xref = accErr / Klqr(1);
xref = 0.1 * (xref > 0.05);
figure();
plot(tx,xref);

Xt = [xx' - xref';dx_dt';phix';dphi_dt'];
accCalcJz = -Klqr * Xt;

figure();hold on;
plot(tx, accx);
plot(tx, accCalcJz);
%% Up detection
windowSize = 1000;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
phif = filter(b,a,phix);
figure();
subplot(2,1,1);
plot(tx, phif);
subplot(2,1,2);
plot(tx, phix);
t0i = find(abs(phif(round(windowSize/2):end)) < 5e-2, 1) + windowSize/2;
%% Use preprocessLQR
[tx, Xt, accx, xref] = preprocessLQR(PosData, 100, 100);
accf = medfilt1(accx, 5);

fig = figure();
plotXtAcc(tx, Xt, accf);