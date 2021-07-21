clear
clc

function [r_2] = coeff_det(y, y_pred)
    SQe = sum((y - y_pred)^2)
    Syy = sum((y - mean(y))^2)
    r_2 = 1 - SQe / Syy
endfunction

function [r_2] = coeff_det_adj(y, y_pred)
    k = 1
    p = k + 1
    SQe = sum((y - y_pred)^2)
    Syy = sum((y - mean(y))^2)
    r_2 = 1 - (SQe/(n - p)) / (Syy/(n - 1))
endfunction

PATH = 'aerogerador.dat'
base = fscanfMat(PATH)
x = base(:, 1)
y = base(:, 2)
n = size(base)(1)

degree_user = input("Choose degree [2, 7]: ")

if degree_user < 2 || degree_user > 7 then
    abort
end

select degree_user
    case 2
        X = [ones(n, 1) x x^2]
        B = inv(X'*X)*X'*y
        Y = B(1) + B(2)*x + B(3)*(x^2)
    case 3
        X = [ones(n, 1) x x^2 x^3]
        B = inv(X'*X)*X'*y
        Y = B(1) + B(2)*x + B(3)*(x^2) + B(4)*(x^3)
    case 4
        X = [ones(n, 1) x x^2 x^3 x^4]
        B = inv(X'*X)*X'*y
        Y = B(1) + B(2)*x + B(3)*(x^2) + B(4)*(x^3) + B(5)*(x^4)
    case 5
        X = [ones(n, 1) x x^2 x^3 x^4 x^5]
        B = inv(X'*X)*X'*y
        Y = B(1) + B(2)*x + B(3)*(x^2) + B(4)*(x^3) + B(5)*(x^4) + B(6)*(x^5)
    case 6
        X = [ones(n, 1) x x^2 x^3 x^4 x^5 x^6]
        B = inv(X'*X)*X'*y
        Y = B(1) + B(2)*x + B(3)*(x^2) + B(4)*(x^3) + B(5)*(x^4) + B(6)*(x^5) + B(7)*(x^6) 
    case 7
        X = [ones(n, 1) x x^2 x^3 x^4 x^5 x^6 x^7]
        B = inv(X'*X)*X'*y
        Y = B(1) + B(2)*x + B(3)*(x^2) + B(4)*(x^3) + B(5)*(x^4) + B(6)*(x^5) + B(7)*(x^6) + B(8)*(x^7)
    else
        disp('Invalid degree!')
end

scatter(x, y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0 0 1], "linewidth",0.25)
xset("thickness", 2)
r2 = coeff_det(y, Y)
r2_adj = coeff_det_adj(y, Y)
title('r2:  ' + string(r2) + '  -  ' + 'r2_adj: ' + string(r2_adj), 'fontsize', 4)
plot2d(x, Y, style=color("red"))
