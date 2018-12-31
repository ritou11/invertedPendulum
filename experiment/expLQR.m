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

data = load(sprintf('data/lqr%d.%d.mat', Q(1), Q(3)), 'PosData');
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
t = t(2:end);
x = x(2:end);
phi = phi(2:end);
xref = xref(2:end);
acc = PosData.signals(4).values(2:end);
cX = [x' - xref';dx_dt';phi';dphi_dt'];
accCalc = -Klqr * cX;

fig = figure();
ax(1) = subplot(2,1,1);
hold on;
plot(t, acc);
plot(t, accCalc);
grid on; grid minor;
legend('原始数据', '去除大尖峰后');
legend('Location','southeast')
ylabel('加速度 / m/s^2');
title('加速度大尖峰去除');
ax(2) = subplot(2,1,2);
plot(t, xref);
grid on; grid minor;
ylabel('位置 / m');
xlabel('时间t / s');
title('位置设定值');
linkaxes(ax,'x');
xlim([min(t),max(t)]);
saveas(fig, 'fig/acchuge.png');
close(fig);
%% Use preprocessLQR
[t, X, acc, xref] = preprocessLQR(PosData, 100, 100);

windowSize = 100;
b = (1/windowSize)*ones(1,windowSize);
a = 1;

accf1 = medfilt1(acc, 5);
accf2 = filter(b,a,acc);

fig = figure('position',[0,0,400,800]);
x = X(1,:);
v = X(2,:);
ax(1) = subplot(4, 1, 1);
plot(t, v);
title('速度');
ylabel('dx / m/s');
grid on; grid minor;
ax(2) = subplot(4, 1, 2);
plot(t, X(4,:));
title('角速度');
ylabel('d\phi / rad/s');
grid on; grid minor;
ax(3) = subplot(4, 1, 3);
plot(t, acc);
title('输入加速度');
ylabel('a / m/s^2');
grid on; grid minor;
ax(4) = subplot(4, 1, 4);
hold on;
plot(t, accf1);
plot(t, accf2);
title('加速度(滤波后)');
legend('中值滤波','均值滤波');
legend('location','northwest');
ylabel('a / m/s^2');
grid on; grid minor;
xlabel('时间t / s');
linkaxes(ax,'x');
xlim([min(t),max(t)]);
saveas(fig, 'fig/acctiny.png');
close(fig);