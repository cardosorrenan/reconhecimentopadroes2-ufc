clc;
clear;
warning('off');

// Ler e randomizar base de dados
PATH = './dermatology.data'
base = csvRead(PATH)
n_feat = 34
base = base(grand(1, 'prm', (1:size(base)(1))), :)

// Remoção das rows com Nan
[rows_remove, columns_remove] = find(string(base) == 'Nan')
base(rows_remove, :) = []
n_base = size(base)(1)

// Normalização
for i = 1:n_feat
    base(:, i) = (base(:, i) - mean(base(:, i)))/stdev(base(:, i))
end

// Discretização dos dados
for i = 1:n_base
    label = base(i, 35)
    if label == 1
        new_label = [1, 0, 0, 0, 0, 0]
    elseif label == 2
        new_label = [0, 1, 0, 0, 0, 0]
    elseif label == 3
        new_label = [0, 0, 1, 0, 0, 0]
    elseif label == 4
        new_label = [0, 0, 0, 1, 0, 0]
    elseif label == 5
        new_label = [0, 0, 0, 0, 1, 0]
    elseif label == 6
        new_label = [0, 0, 0, 0, 0, 1]
    end
    base(i, 35:40) = new_label
end

// Configurações da rede e validação
n_test = floor(n_base*0.2)  // Holdout (20% dados para teste)
n_train = n_base - n_test
n_neurons = 40
execs = 20  // Holdout (20 repetições)
acc_total = 0

for i = 1:execs
    // Dados Treino
    rows = grand(1, 'prm', 1:size(base)(1))(1:n_test)
    train = base
    train(rows, :) = []
    train_x = train(:, 1:34)
    train_y = train(:, 35:40)
    
    // Dados Teste/
    test = base(rows, :)
    test_x = test(:, 1:34)
    test_y = test(:, 35:40)
    
    // Camada Oculta
    W = rand(n_neurons, n_feat+1, 'normal')
    X = [(-1)*ones(1, n_train);train_x']
    Z = 1./(1+exp(W*X))
    lambda = 0.01
    M = train_y'*Z'*(Z*Z'+lambda*eye(n_neurons, n_neurons))^(-1)
    
    // Camada de Saída
    z_test = W*[(-1)*ones(1, n_test);test_x']
    z_test = 1./(1+exp(z_test))
    output = M*z_test
    
    // Validação
    acc = 0
    count = 0
    for t = 1:n_test
        [a b] = max(test_y(t, :))
        [c d] = max(output(:, t))
        if b==d
            count = count + 1
        end
    end

    acc = count / n_test
    acc_total = acc_total + acc
    disp(acc)
end

acc_total = acc_total / execs
disp("Acurácia Total:")
disp(acc_total)
