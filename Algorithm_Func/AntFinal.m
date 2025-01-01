function [bestPath, bestLength] = AntFinal(adjMat, numAnts, NC_max, alpha, beta, rho, Q, timeWin, proiSeq, serCost)
    
    n = size(adjMat, 1);
    eta = 1./adjMat;
    tau = ones(n, n);
    lossMat = adjMat;

    bestLength = inf;
    bestPath = [];

    for NC = 1:NC_max
        paths = zeros(numAnts, n + 1);
        loopLoss = zeros(numAnts, 1);

        % Ants loop
        for ant = 1:numAnts
            visited = false(n, 1);
            startCity = 1;
            currentCity = startCity;
            visited(currentCity) = true;
            paths(ant, 1) = currentCity;
            antLoss = 0;
            currentTime = 0;
            % Construct the path for this ant
            for j = 2:n
                unvisitedIdx = find(~visited);
                tempMax = 0;
                feasibleCities = [];
                for ii = unvisitedIdx'
                    if proiSeq(currentCity) >= proiSeq(ii)
                        if proiSeq(ii) > tempMax
                            feasibleCities = [ii];
                            tempMax = proiSeq(ii);
                        elseif proiSeq(ii) == tempMax
                            feasibleCities(end+1) = ii;
                        end
                    end
                end

                if isempty(feasibleCities)
                    antLoss = inf;
                    break
                end

                ptot = sum(tau(currentCity, feasibleCities').^alpha .* eta(currentCity, feasibleCities').^beta);
                p = (((tau(currentCity, feasibleCities').^alpha) .* (eta(currentCity, feasibleCities).^beta)) ./ ptot)';
                % Select the next city
                pcum = cumsum(p);
                select = find(pcum>=rand);
                nextCity = feasibleCities(select(1));

                % Calculate the arrival time at the selected city
                currentTime = currentTime + serCost(currentCity) + adjMat(currentCity, nextCity);

                % Calculate the loss to this city
                antLoss = antLoss + adjMat(currentCity, nextCity) + twPunish(currentTime, timeWin(nextCity, :));

                % Update path and current city
                paths(ant, j) = nextCity;
                visited(nextCity) = true;
                currentCity = nextCity;   

            end
            % Construct the tour and calculate total loss
            paths(ant, n+1) = startCity;
            antLoss = antLoss + adjMat(paths(ant, n), startCity);
            loopLoss(ant) = antLoss;

            if antLoss < bestLength
                bestLength = antLoss;
                bestPath = paths(ant, :);
            end
        end

        % Update tau matrix
        tau = (1-rho) .* tau; % Evaporation

        for ant = 1:numAnts
            for step = 1:n
                i = paths(ant, step);
                j = paths(ant, step + 1);
                tau(i, j) = tau(i, j) + Q / loopLoss(ant);
            end
        end

    end


end