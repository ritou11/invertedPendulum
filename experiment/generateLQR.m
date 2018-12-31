addpath('../simulation');
%% LQR file list
lqr_params = [100,100;
              900,100;
              1000,100;
              1000,200];
lqr_params_len = size(lqr_params, 1);
%% plot lqr files
for i = 1:lqr_params_len
    plotLQRFile(lqr_params(i, 1), lqr_params(i, 2), 1);
end
%% clear
clear;