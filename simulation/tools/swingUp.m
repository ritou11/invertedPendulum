function y = swingUp(X)
x = X(1);
phi = X(3);
dphi = X(4);
eps = 1e-5;
m = 0.109;
l = 0.25;
I = 1/3*m*l^2;% 0.0034;
g = 9.80;
umax = 0.1 * g;
if(abs(cos(phi)) < eps || abs(dphi) < eps)
   y = 0; 
else
    y = ( - sign((1/2*(I + m * l^2)*dphi^2+m*g*l*(cos(phi)-1))*dphi*cos(phi))) * umax;
    if(sign(y * x) > 0)
        y = 0;
    end
end