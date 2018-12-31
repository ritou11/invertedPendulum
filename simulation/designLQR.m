function Klqr = designLQR(A2, B2, Q, R)
    [Klqr, ~, ~] = lqr(A2, B2, Q, R);
end