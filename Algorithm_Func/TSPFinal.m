function [bestPath, bestCost, count] = TSPFinal(adjMat, startCity, timeWin, proiSeq, serCost, esp)
     
    count = 0;

    if nargin <= 4 || isempty(startCity)
        startCity = 1;
    end

    if nargin <= 5 || isempty(esp)
        esp = 1e-6;   
    end
    
    % Number of cities
    n = size(adjMat, 1);
    idxVec = 1:n;

    % Basic checks
    if size(adjMat,1) ~= size(adjMat,2)
        error('Distance matrix must be square.');
    end
    
    if startCity < 1 || startCity > n
        error('Invalid start city index.');
    end

    [twRows, twCols] = size(timeWin);
    if twRows ~= n || twCols ~= 2
        error('timeWin must be n by 2 matrix.');
    end
    % Check time window validity
    if any(timeWin(:,1) > timeWin(:,2))
        error('Every time window must satisfy a_i <= b_i.');
    end

    % Initialize lower cost and upper cost
    ub = inf;
    lb = -inf;

    bestPath = [];
    bestCost = ub;

    % Creat the initial node
    % Node structure: path, costPath, lowerBound, upperBound
    node.path = startCity;
    node.costPath = 0;
    node.lowerBound = -inf;
    node.upperBound = inf;

    % Adopting DFS, initialize the stack
    visitStack = node; % Add the root node

    while ~ isempty(visitStack) && abs(ub-lb) > esp
        count = count + 1;
        curNode = visitStack(end);
        visitStack(end) = [];
        % If this node has visited all cities, construct the tour
        if length(curNode.path) == n
            tempPathMat = path2mat(curNode.path, n); %From row to col
            tempPathMat(curNode.path(end), startCity) = 1;
            finCost = sum(sum(tempPathMat.*adjMat));
            if finCost < bestCost
                bestCost = finCost;
                bestPath = [curNode.path, startCity];
                ub = finCost;
            end
            continue
        end

        % Check each bounds of sub-nodes
        unVisit = setdiff(idxVec, curNode.path);
        for tempNodeIdx = unVisit
            tempPath = [curNode.path, tempNodeIdx];
            templb = calTWLB(adjMat, tempPath, timeWin);  % solve for relaxation prob
            if templb >= ub
                % Prune this node; do not push this node into visitStack
                continue
            else
                % this node is active
                lb = max(lb, templb); % update global lower bound

                % find a feasible solution via heuristic func for the upper bound
                [tempSol, tempub] = calFinUB(adjMat, tempPath, timeWin, proiSeq, serCost);
                
                if tempub < ub
                    bestPath = tempSol; % best solution so far
                    bestCost = tempub;
                    ub = tempub; % update global upper bound                    
                end

                if abs(tempub - templb) < 1e-12
                    % Prune optimality/infeasiblity
                    continue
                else
                    % Branching
                    newNode.path = tempPath;
                    newNode.costPath = sum(nansum(adjMat .* path2mat(newNode.path, n)));
                    newNode.lowerBound = templb;
                    newNode.upperBound = tempub;
                    visitStack(end+1) = newNode;
                end
            end
        end

    end
end