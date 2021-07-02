clc
clear

base = csvRead('/home/renan/Área de Trabalho/Renan/S1/RecPadroes/Trab 1/dermatology.data');
[rows_remove, columns_remove] = find(string(base) == 'Nan')
base(rows_remove, :) = []

base = base(grand(1, 'prm', (1:size(base)(1))), :)
[rows, cols] = size(base)

accs = []

for i = 1:floor(rows/20)
    base_copy = base
    inf = 20 * i - 19
    sup = 20 * i
    test = base_copy(inf:sup, :)
    base_copy(inf:sup, :) = []
    train = base_copy
    
    train_x = train(:, 1:34)
    m_cov = cov(train_x);
    inv_m_cov = inv(m_cov);
    
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
    
    hit = 0;
    
    for i = 1:20
        test_x = test(i, 1:34)
        test_y = test(i, 35)
        
        f1 = (test_x - centroid_c1) * (eye(34, 34) .* inv_m_cov) * (test_x - centroid_c1)'; 
        f2 = (test_x - centroid_c2) * (eye(34, 34) .* inv_m_cov) * (test_x - centroid_c2)'; 
        f3 = (test_x - centroid_c3) * (eye(34, 34) .* inv_m_cov) * (test_x - centroid_c3)'; 
        f4 = (test_x - centroid_c4) * (eye(34, 34) .* inv_m_cov) * (test_x - centroid_c4)'; 
        f5 = (test_x - centroid_c5) * (eye(34, 34) .* inv_m_cov) * (test_x - centroid_c5)'; 
        f6 = (test_x - centroid_c6) * (eye(34, 34) .* inv_m_cov) * (test_x - centroid_c6)';
        
        [a, b] = min([f1, f2, f3, f4, f5, f6])
        
        if test_y == b
            hit = hit + 1
        end
    end
    
    acc = hit/20 * 100
    
    accs = cat(1, accs, acc)

end

bar(accs)
