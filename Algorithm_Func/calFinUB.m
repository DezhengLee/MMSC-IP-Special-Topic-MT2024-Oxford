function [feasiblePath, feasibleCost] = calFinUB(adjMat, partialPath, timeWindows, proiSeq, serCost)
    n = size(adjMat, 1);
    
    feasiblePath = [];
    feasibleCost = Inf;  
    currentPath = partialPath;
    visited = false(n,1);
    visited(partialPath) = true;
    currentTime = 0;
    loss = 0;
    for i = 1:length(partialPath)-1
        tempCity = partialPath(i);
        nextCity = partialPath(i+1);
        if proiSeq(nextCity) > proiSeq(tempCity)
            return
        end
        % Loss func at this city
        loss = loss + currentTime + twPunish(currentTime, timeWindows(tempCity, :));
        % Service time at this city
        currentTime = currentTime + serCost(tempCity); 
        % Travel time from this city to next city (and arrival time at the next city). 
        currentTime = currentTime + adjMat(tempCity, nextCity); 
    end
    % Add the service time to currentTime at the last partialPath
    currentTime = currentTime + serCost(partialPath(end));

    while length(currentPath) < n
        currentCity = currentPath(end);
        unvisited = find(~visited)';

        % Search for the next feasible city
        feasibleCities = [];
        feasibleLoss = [];
        feasibleArrivalTimes = [];
        for idx = 1:length(unvisited)
            city = unvisited(idx);
            travelTime = adjMat(currentCity, city);
            if ~isfinite(travelTime)
                continue
            elseif proiSeq(currentCity) < proiSeq(city)
                continue
            end
            arrivalTime = currentTime + travelTime;

            feasibleCities(end+1) = city;
            feasibleLoss(end+1) = travelTime + twPunish(arrivalTime, timeWindows(city, :)); 
            feasibleArrivalTimes(end+1) = arrivalTime;

        end

        if isempty(feasibleCities)
            return
        end
            
        [~,minIdx] = min(feasibleLoss);
        nextCity = feasibleCities(minIdx);
        travelTime = adjMat(currentCity, nextCity);
        arrivalTime = feasibleArrivalTimes(minIdx);
        currentPath(end+1) = nextCity;
        loss = loss + travelTime + twPunish(arrivalTime, timeWindows(nextCity, :));
        currentTime = arrivalTime + serCost(nextCity); 
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

    loss = loss + travelTime + twPunish(arrivalTime, timeWindows(startCity, :));
    currentPath(end+1) = startCity;

    feasiblePath = currentPath;
    feasibleCost = loss;
    
end