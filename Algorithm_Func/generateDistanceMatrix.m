function distMat = generateDistanceMatrix(City_Coord, seed, setDiagonalInf)
    [~, nCities] = size(City_Coord);
    rng(seed);
    
    if nargin >= 3
        if islogical(setDiagonalInf)
            setDiag = setDiagonalInf;
        else
            error('setDiagonalInf.');
        end
    else
        setDiag = true;
    end
    
    distMat = zeros(nCities, nCities);
    
    for i = 1:nCities
        for j = i:nCities
            if i == j
                distMat(i,j) = 0;  
            else
                dist_ij = norm(City_Coord(:,i) - City_Coord(:,j));
                distMat(i,j) = dist_ij;
                distMat(j,i) = dist_ij;  
            end
        end
    end
    
    if setDiag
        for i = 1:nCities
            distMat(i,i) = Inf;  
        end
    end
end
