function lbValue = calLB(adjMat, partialPath)
    [n, m] = size(adjMat);
    if n ~= m
        error('adjMat must be square.');
    end
    costFixed = 0;
    if length(partialPath) >= 2
        for k = 1 : (length(partialPath) - 1)
            i = partialPath(k);
            j = partialPath(k+1);
            costFixed = costFixed + adjMat(i, j);
        end
    end
    redMat = adjMat;
    visitedSet = partialPath(1:end-1);
    for c = visitedSet
        redMat(c, :) = inf;
    end
    for c = partialPath
        redMat(:, c) = inf;
    end
    
    if length(partialPath) >= 2
        for k = 1 : (length(partialPath) - 1)
            i = partialPath(k);
            j = partialPath(k+1);
            redMat(i, j) = adjMat(i, j);
        end
    end
    bigVal = 1e9;
    [~, costAssign] = matchpairs(redMat, bigVal, 'min');
    lbValue = costFixed + costAssign;
end
