function [feasiblePath, feasibleCost] = calUB(adjMat, partialPath)
    n = size(adjMat, 1);
    if isempty(partialPath)
        partialPath = 1;
    end
   
    visitedSet = partialPath;           
    remain = setdiff(1:n, visitedSet);   
    curCity = partialPath(end);          

    feasiblePath = partialPath;          
    while ~isempty(remain)
        [~, idxMin] = min(adjMat(curCity, remain));
        nextCity = remain(idxMin);
        feasiblePath(end+1) = nextCity;
        remain(remain == nextCity) = [];
        curCity = nextCity;
    end
    startCity = partialPath(1);
    feasiblePath(end+1) = startCity;
    pathMat = path2mat(feasiblePath, n);
    feasibleCost = sum(nansum(pathMat .* adjMat));


end
