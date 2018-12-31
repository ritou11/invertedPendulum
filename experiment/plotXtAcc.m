function plotXtAcc(t, X, acc)
x = X(1,:);
phi = X(3,:);
ax(1) = subplot(3, 1, 1);
plot(t, x);
title('λ��');
ylabel('x / m');
grid on; grid minor;
ax(2) = subplot(3, 1, 2);
plot(t, phi);
title('�Ƕ�');
ylabel('\phi / rad');
grid on; grid minor;
ax(3) = subplot(3, 1, 3);
plot(t, acc);
title('������ٶ�');
ylabel('a / m/s^2');
grid on; grid minor;
xlabel('ʱ��t / s');
linkaxes(ax,'x');
xlim([min(t),max(t)]);
end