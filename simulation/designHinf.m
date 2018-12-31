function Khinf = designHinf(A2, B2, B21, Q, R, gamma)
C21 = sqrt(Q);
D21 = sqrt(R);
B22 = B2;
B = [B21 , B22];
m1 = size(B21,2);
m2 = size(B22,2);
Rp = [-gamma^2*eye(m1) zeros(m1,m2) ; zeros(m2,m1) eye(m2)];
P = care(A2,B,Q,Rp);
Khinf = inv(D21' * D21)*B22'*P;

if(max(real(eig(A2-B2*Khinf))) > 0)
    disp('No zero dynamic!');
else
    disp('Success');
    nc = size(C21,2);
    nd = size(D21,2);
    C = [C21;zeros(nd,size(C21,1))];
    D = [zeros(nc,size(D21,1));D21];
    hsys = ss((A2 - B22 * Khinf),B21,C,D);
    [ninf, fpeak] = hinfnorm(hsys, 1e-6);
    fprintf('ninf=%.3f, fpeak=%s\n',ninf,fpeak);
end
end