function lb = calTWLB(adjMat, tempPath, timeWin)
    n = size(adjMat, 1);
    currentTime = 0;
    
    for i = 1:length(tempPath)-1
        from = tempPath(i);
        to = tempPath(i+1);
        travelTime = adjMat(from, to);
        
        if ~isfinite(travelTime)
            lb = inf;
            return;
        end
        
        arrivalTime = currentTime + travelTime;

        if arrivalTime > timeWin(to, 2) || arrivalTime < timeWin(to, 1)
            lb = inf;
            return;
        end
        
        currentTime = arrivalTime;
    end
    
    lb = calLB(adjMat, tempPath);
end
