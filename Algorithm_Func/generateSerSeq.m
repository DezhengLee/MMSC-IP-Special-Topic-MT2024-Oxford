function serSeq = generateSerSeq(n, seed)
    rng(seed)
    serSeq = rand([1, n]);
    serSeq(1) = 0;
end