clc;
clear;
warning('off');

disp('1 - Automático (50 pontos)')
disp('2 - Manual')

modo = input("Modo de povoamento: ")

// Modo inserção dados
if modo <= 2 then
    // Automático (50 pontos)
    if modo == 1 then
        a = [1:1:25]
        b = [51:1:75]
        for i = 1:3
            A(i, :) = a(grand(1, 'prm', (1:size(a')(1)))) 
            B(i, :) = b(grand(1, 'prm', (1:size(b')(1)))) 
        end            
        m = [A B]
        labels = [ones(1, 25) ones(1, 25)*2]
        base = [m' labels']
        N = 50
    end
    // Manual (x, y, z, classe)
    if modo == 2 then
        N = input("Quantidade de pontos: ")
        clc;
        for i = 1:N
           base(i, 1) = input("Coordenada x: ")
           base(i, 2) = input("Coordenada y: ")
           base(i, 3) = input("Coordenada x: ")
           base(i, 4) = input("Classe (1 ou 2): ")
           clc;
        end
    end
else
    abort
end

bias = -1
X = [bias*ones(1, N)' base(:, 1:3)]
tax_learn = 0.1
W = rand(1, 4)
epoch = 0

// Treinamento do Perceptron
while 1
    W_prev = W    
    err_epoch = 0
    epoch = epoch + 1
    outputs = (-1)*ones(1, N)
    
    for j = 1:N
        output = W*X(j, :)'
        
        // Função Ativação
        if output >= 1
            output = 2
        else
            output = 1
        end

        err = 0
        err = base(j, 4) - output    
        err_epoch = err_epoch + err

        // Aprendizagem
        for k = 1:4
            W(k) = W(k) + (tax_learn * X(j, k) * err)
        end

        outputs(j) = output
    end
    
    disp(i)
    disp(W)
    
    // Critério de parada
    if err_epoch == 0 && W_prev == W
        clc;
        disp(epoch)
        disp(W)
        break
    end
    
    if epoch == 1000
        disp('Sem convergência')
        abort
    end
    
end

// Validação
count = 0
for i = 1:N
    if outputs(i) == base(i, 4)
        count = count + 1
    end
end

// Plot
x = [-100:10:100]
y = [-100:10:100]
[X Y] = meshgrid(x, y)
Z = -(X*W(2) + Y*W(3) - W(1) + bias)/W(4)
mesh(X,Y,Z)
base1 = []
base2 = []
for i = 1:N
    d = base(i, 1:3)
    if base(i, 4) == 1 then
        base1 = cat(1, base1, d)
    else
        base2 = cat(1, base2, d)
    end                         
end

// Ajustes técnicos quando há somente uma amostra
if size(base1)(1) == 1 then
    base1(2, :) = base1(1, :)
end
if size(base2)(1) == 1 then
    base2(2, :) = base2(1, :)
end

scatter3(base1(:, 1), base1(:, 2), base1(:, 3), "markerEdgeColor",[0 0 1], "markerFaceColor",[0.8 0.8 1], "linewidth", 1)
scatter3(base2(:, 1), base2(:, 2), base2(:, 3), "markerEdgeColor",[1 0 0], "markerFaceColor",[1 0.8 0.8], "linewidth", 1)
