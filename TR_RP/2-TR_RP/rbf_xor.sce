clear
clc
X = [0 0 1 1 ;0 1 0 1]
D = [0 1 1 0]

//neuronio 1
v1 = zeros(1,4)
t1 = [0 0]'
for i = 1:4
    v1(i) = norm(X(1,i) - t1)
end
n1 = exp(-v1.^2)

//neuronio 2
v2 = zeros(1,4)
t2 = [0 0]'
for i = 1:4
    v2(i) = norm(X(2,i) - t2)
end
n2 = exp(-v2.^2)

Z = [ones(1,4); n1; n2]
M = D * Z' * (Z * Z')^-1

d_test = X * M
