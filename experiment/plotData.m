function plotData(PosData)
t = PosData.time;
x = PosData.signals(1).values;
theta = PosData.signals(2).values;
phi = mod(theta, 2 * pi) - pi;
acc = PosData.signals(4).values;
dt = t(2:end) - t(1:end-1);
dx = x(2:end) - x(1:end-1);
dphi = phi(2:end) - phi(1:end-1);
dx_dt = dx./dt;
dphi_dt = dphi./dt;
tx = t(2:end);
accx = acc(2:end);
xx = x(2:end);
phix = phi(2:end);
Xt = [xx';dx_dt';phix';dphi_dt'];

plotXtAcc(tx, Xt, accx);
end