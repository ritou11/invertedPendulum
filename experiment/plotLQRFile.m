function plotLQRFile(Qx, Qphi, clfig)
data = load(sprintf('data/lqr%d.%d.mat', Qx, Qphi), 'PosData');
PosData = data.PosData;
fig = figure();
plotData(PosData);
print(fig, sprintf('fig/lqr%d.%d_org.png', Qx, Qphi), '-dpng', '-r300');
[tx, Xt, accx, ~] = preprocessLQR(PosData, Qx, Qphi);
plotXtAcc(tx, Xt, accx);
print(fig, sprintf('fig/lqr%d.%d_filt1.png', Qx, Qphi), '-dpng', '-r300');
accf = medfilt1(accx, 5);
plotXtAcc(tx, Xt, accf);
print(fig, sprintf('fig/lqr%d.%d_filt2.png', Qx, Qphi), '-dpng', '-r300');
if nargin >= 2 && clfig
    close(fig);
end
end