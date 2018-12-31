function plotXtAcc(tx, Xt, accx)
x = Xt(1,:);
phi = Xt(3,:);
ax(1) = subplot(3, 1, 1);
plot(tx, x);
title('x');
ax(2) = subplot(3, 1, 2);
plot(tx, phi);
title('phi');
ax(3) = subplot(3, 1, 3);
plot(tx, accx);
title('acc');
linkaxes(ax,'x');
xlim([min(tx),max(tx)]);
end