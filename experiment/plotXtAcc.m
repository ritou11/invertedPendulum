function plotXtAcc(t, X, acc)
x = X(1,:);
phi = X(3,:);
ax(1) = subplot(3, 1, 1);
plot(t, x);
title('位置');
ylabel('x / m');
grid on; grid minor;
ax(2) = subplot(3, 1, 2);
plot(t, phi);
title('角度');
ylabel('\phi / rad');
grid on; grid minor;
ax(3) = subplot(3, 1, 3);
plot(t, acc);
title('输入加速度');
ylabel('a / m/s^2');
grid on; grid minor;
xlabel('时间t / s');
linkaxes(ax,'x');
xlim([min(t),max(t)]);
end