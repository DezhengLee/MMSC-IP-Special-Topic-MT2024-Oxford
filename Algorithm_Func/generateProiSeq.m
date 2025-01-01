function proiSeq = generateProiSeq(n, maxLevel)
    proiSeq = randi(maxLevel, [1, n]);
    proiSeq(1) = inf;
end