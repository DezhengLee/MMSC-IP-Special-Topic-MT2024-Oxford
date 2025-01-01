function [feasiblePath, feasibleCost] = calTWUB(adjMat, partialPath, timeWindows)
    n = size(adjMat, 1);

    feasiblePath = [];
    feasibleCost = Inf; 
    currentPath = partialPath;
    visited = false(n,1);
    visited(partialPath) = true;

    currentTime = sum(nansum(adjMat .* path2mat(partialPath, n)));
    totalDistance = currentTime;

    while length(currentPath) < n
        currentCity = currentPath(end);
        unvisited = find(~visited)';
        feasibleCities = [];
        feasibleDistances = [];
        feasibleArrivalTimes = [];
        for idx = 1:length(unvisited)
            city = unvisited(idx);
            travelTime = adjMat(currentCity, city);
            if ~isfinite(travelTime)
                continue;  
            end
            arrivalTime = currentTime + travelTime;
            if arrivalTime <= timeWindows(city,2) && arrivalTime >= timeWindows(city, 1)
                feasibleCities(end+1) = city; 
                feasibleDistances(end+1) = travelTime;
                feasibleArrivalTimes(end+1) = arrivalTime;
            end
        end
        
        if isempty(feasibleCities)
            return;
        end
        [~, minIdx] = min(feasibleDistances);
        nextCity = feasibleCities(minIdx);
        travelTime = feasibleDistances(minIdx);
        arrivalTime = feasibleArrivalTimes(minIdx);
        currentPath(end+1) = nextCity;
        totalDistance = totalDistance + travelTime;
        currentTime = arrivalTime;
        visited(nextCity) = true;
    end

    lastCity = currentPath(end);
    startCity = currentPath(1);
    travelTime = adjMat(lastCity, startCity);
    if ~isfinite(travelTime)
        return;
    end
    arrivalTime = currentTime + travelTime;
    if arrivalTime < timeWindows(startCity,1)
        arrivalTime = timeWindows(startCity,1);  
    end
    if arrivalTime > timeWindows(startCity,2)
        return;
    end
    totalDistance = totalDistance + travelTime;
    currentPath(end+1) = startCity;

    feasiblePath = currentPath;
    feasibleCost = totalDistance;
end
