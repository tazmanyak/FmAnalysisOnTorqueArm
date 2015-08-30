
function y = Stiffness(E,NU,t,xi,yi,xj,yj,xm,ym)
%Stiffnes of ith element
A = Area(xi,yi,xj,yj,xm,ym);
b1 = yj-ym;
b2 = ym-yi;
b3 = yi-yj;
c1 = xm-xj;
c2 = xi-xm;
c3 = xj-xi;

B = (1/(2*A))*[b1 0 b2 0 b3 0;0 c1 0 c2 0 c3 ;c1 b1 c2 b2 c3 b3];
D=(E/(1-NU^2))*[1 NU 0;NU 1 0;0 0 (1-NU)/2];
y = t*A*B'*D*B; % By theory
end