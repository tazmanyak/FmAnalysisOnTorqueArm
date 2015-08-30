
% Element area calculation with three nodes
function A = Area(xi,yi,xj,yj,xm,ym)
    A = 0.5*det([1 xi yi;1 xj yj; 1 xm ym]);%(xi*(yj-ym) + xj*(ym-yi) + xm*(yi-yj))/2;
end
