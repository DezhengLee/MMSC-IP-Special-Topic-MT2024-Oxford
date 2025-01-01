function timeWindows = genTimeWin(n, seed, minWinLen, M, d)
    if ~isempty(seed)
        rng(seed);
    end
    
    timeWindows = zeros(n, 2);
    timeWindows(1, :) = [0, inf];
    
    for i = 2:n
        ai = max(0, d + rand);     
        windowLength = minWinLen + M * rand;
        bi = ai + windowLength;
        timeWindows(i, :) = [ai, bi];
    end 
    
end
