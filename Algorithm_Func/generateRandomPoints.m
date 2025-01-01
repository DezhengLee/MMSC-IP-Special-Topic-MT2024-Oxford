function City_Coord = generateRandomPoints(n, seed)

    if nargin > 1 && ~isempty(seed)
        rng(seed);
    end
    City_Coord = rand(2, n);

end
