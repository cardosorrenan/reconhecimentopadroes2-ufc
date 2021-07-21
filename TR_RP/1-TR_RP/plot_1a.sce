clear
clc

PATH = 'aerogerador.dat'
base = fscanfMat(PATH)
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

base_1x = base_1(:, 1)
base_1y = base_1(:, 2)

base_2x = base_2(:, 1)
base_2y = base_2(:, 2)

base_3x = base_3(:, 1)
base_3y = base_3(:, 2)

scatter(base_1x, base_1y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0 0.4 1], "linewidth",0.25)
scatter(base_2x, base_2y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0 0 1], "linewidth",0.25)
scatter(base_3x, base_3y, "markerEdgeColor",[1 1 1], "markerFaceColor",[0.4 0 1], "linewidth",0.25)

plot2d([5.5 5.5], [10 590], -5)
plot2d([5.5 5.5], [10 590])
plot2d([12 12], [10 590], -5)
plot2d([12 12], [10 590])
