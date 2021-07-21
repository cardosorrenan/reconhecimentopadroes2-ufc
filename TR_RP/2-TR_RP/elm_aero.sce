clear
clc
base = fscanfMat('/home/renan/Área de Trabalho/reconhecimentopadroes2-ufc/TR_RP/2-TR_RP/aerogerador.dat')

q = 4
p = 1
w = rand(q,p+1,'normal')
x = base(:,1)
len = size(x)(1)
x = [ones(1,len);x']
d = base(:,2)
d = d'

z = w * x
z = 1./1+exp(z)
z = [ones(1,len);z]
m = d * z' * inv(z * z')
d_test = m * z

sq_e = 0
s_yy = 0
d_media = mean(d)
d_media_test = mean(d_test)
i = 0
for i = 1:200
    sq_e = sq_e + (d(i) - d_test(i))^2
    s_yy = s_yy + (d(i) - d_media)^2
end
r2 = 1 - (sq_e/s_yy)

