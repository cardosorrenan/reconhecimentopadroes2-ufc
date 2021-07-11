clc
clear

// Ler e randomizar base de dados
base = csvRead('/home/renan/Área de Trabalho/Renan/S1/RecPadroes/Trab 1/dermatology.data');
base = base(grand(1, 'prm', (1:size(base)(1))), :)

// Remoção das rows com Nan
[rows_remove, columns_remove] = find(string(base) == 'Nan')
base(rows_remove, :) = []

acc = []
acc_n = []

// Hold-out, 20 amostras para validação
for tests = 1:10
    rows = grand(1, 'prm', 1:size(base)(1))(1:20)
    test = base(rows, :)
    base(rows, :) = []
    train = base
    
    train_x = train(:, 1:34)
    test_x = test(:, 1:34)
    test_y = test(:, 35)
    
    // Matriz de covariância
    m_cov = cov(train_x)
    inv_m_cov = inv(m_cov)
        
    // Matriz de covariância (Naive)
    m_cov_n = eye(34, 34)
    for i = 1:34
        m_cov_n(i, i) = cov(train_x(:, i))    
    end
    inv_m_cov_n = inv(m_cov_n)
    
    // Calculando os centróides
    [rows1, columns1] = find(train(:, 35) == 1)
    [rows2, columns2] = find(train(:, 35) == 2)
    [rows3, columns3] = find(train(:, 35) == 3)
    [rows4, columns4] = find(train(:, 35) == 4)
    [rows5, columns5] = find(train(:, 35) == 5)
    [rows6, columns6] = find(train(:, 35) == 6)
    centroid_c1 = mean(train_x(rows1, :), 'r');
    centroid_c2 = mean(train_x(rows2, :), 'r');
    centroid_c3 = mean(train_x(rows3, :), 'r');
    centroid_c4 = mean(train_x(rows4, :), 'r');
    centroid_c5 = mean(train_x(rows5, :), 'r');
    centroid_c6 = mean(train_x(rows6, :), 'r');
    
    // Teste do modelo para cada amostra
    hits = 0;
    for i = 1:size(test_x)(1)
        sample_test = test_x(i, :)
        label = test_y(i)
        f1 = (sample_test - centroid_c1) * inv_m_cov * (sample_test - centroid_c1)'; 
        f2 = (sample_test - centroid_c2) * inv_m_cov * (sample_test - centroid_c2)'; 
        f3 = (sample_test - centroid_c3) * inv_m_cov * (sample_test - centroid_c3)'; 
        f4 = (sample_test - centroid_c4) * inv_m_cov * (sample_test - centroid_c4)'; 
        f5 = (sample_test - centroid_c5) * inv_m_cov * (sample_test - centroid_c5)'; 
        f6 = (sample_test - centroid_c6) * inv_m_cov * (sample_test - centroid_c6)';
        [min_value, index] = min([f1, f2, f3, f4, f5, f6])
        if label == index
            hits = hits + 1
        end
    end
    
    // Teste do modelo para cada amostra
    hits_n = 0;
    for i = 1:size(test_x)(1)
        sample_test = test_x(i, :)
        label = test_y(i)
        f1_n = (sample_test - centroid_c1) * inv_m_cov_n * (sample_test - centroid_c1)'; 
        f2_n = (sample_test - centroid_c2) * inv_m_cov_n * (sample_test - centroid_c2)'; 
        f3_n = (sample_test - centroid_c3) * inv_m_cov_n * (sample_test - centroid_c3)'; 
        f4_n = (sample_test - centroid_c4) * inv_m_cov_n * (sample_test - centroid_c4)'; 
        f5_n = (sample_test - centroid_c5) * inv_m_cov_n * (sample_test - centroid_c5)'; 
        f6_n = (sample_test - centroid_c6) * inv_m_cov_n * (sample_test - centroid_c6)';
        [min_value, index_n] = min([f1_n, f2_n, f3_n, f4_n, f5_n, f6_n])
        if label == index_n
            hits_n = hits_n + 1
        end
    end
    
    acc = cat(1, acc, hits/size(test_x)(1))
    acc_n = cat(1, acc_n, hits_n/size(test_x)(1))
    
end

disp('Acurácia: ', mean(acc))
disp('Acurácia Naive: ', mean(acc_n))
