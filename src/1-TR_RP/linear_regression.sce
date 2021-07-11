clear
clc

function [b0, b1] = lin_reg(x, y, n)
    m_x = mean(x)
    m_y = mean(y)
    a = sum(y' * x) - n * m_y * m_x
    b = sum(x' * x) - n * m_x * m_x
    b1 = a / b
    b0 = m_y - b1 * m_x
endfunction


function [r_2] = coeff_det(y, y_pred)
    SQe = sum((y - y_pred)^2)
    Syy = sum((y - mean(y))^2)
    r_2 = 1 - SQe / Syy
endfunction


base = fscanfMat('/home/renan/Área de Trabalho/Renan/S1/RecPadroes/Trab 1/aerogerador.dat')
n = size(base)

base_1 = []
base_2 = []
base_3 = []

for i = 1:n(1)
    row = base(i, :)
    if row(1) <= 5.5 then
        base_1 = cat(1, base_1, row)
    elseif row(1) > 5.5 && row(1) < 12 then
        base_2 = cat(1, base_2, row)
    elseif row(1) >= 12 then
        base_3 = cat(1, base_3, row)
    end
end

// Sector 1 
base_1x = base_1(:, 1)
base_1y = base_1(:, 2)
n1 = size(base_1)(1)
[b_0, b_1] = lin_reg(base_1x, base_1y, n1)
y = b_0 + b_1 * base_1x
r2_1 = coeff_det(base_1y, y)
xset('window', 1);
xset("thickness", 2)
scatter(base_1x, base_1y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0 0.4 1], "linewidth",0.25)
title('r2:  ' + string(r2_1), 'fontsize', 4)
plot2d(base_1x, y, style=color("red"))

// Sector 2
base_2x = base_2(:, 1)
base_2y = base_2(:, 2)
n2 = size(base_2)(1)
[b_0, b_1] = lin_reg(base_2x, base_2y, n2)
y = b_0 + b_1 * base_2x
r2_2 = coeff_det(base_2y, y)
xset('window', 2);
xset("thickness", 2)
scatter(base_2x, base_2y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0 0 1], "linewidth",0.25)
title('r2:  ' + string(r2_2), 'fontsize', 4)
plot2d(base_2x, y, style=color("red"))

// Sector 3
base_3x = base_3(:, 1)
base_3y = base_3(:, 2)
n3 = size(base_3)(1)
[b_0, b_1] = lin_reg(base_3x, base_3y, n3)
y = b_0 + b_1 * base_3x
r2_3 = coeff_det(base_3y, y)
xset('window', 3);
xset("thickness", 2)
scatter(base_3x, base_3y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0.4 0 1], "linewidth",0.25)
title('r2:  ' + string(r2_3), 'fontsize', 4)
plot2d(base_3x, y, style=color("red"))
