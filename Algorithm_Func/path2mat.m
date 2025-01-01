function mat = path2mat(path, n)
    mat = zeros(n);
    for i = 1:length(path) - 1
        mat(path(i), path(i+1)) = 1;
    end
end