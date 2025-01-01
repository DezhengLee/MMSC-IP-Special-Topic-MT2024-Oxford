function HKlb_sub = HKLB(adjMat, M)
    % Generate the graph
    n = size(adjMat, 1);
    G = graph(adjMat, 'omitselfloops');
    E = adjMat;

    % Initialize city weights
    G.Nodes.pi = zeros(n, 1);
    
    HKlb_sub = -1;
    C = inf(size(E));

    pred = zeros(n, 1);

    for m = 1:M
        for i = 2:n
            for j = neighbors(G, i)'
                C(i, j) = E(i, j) + G.Nodes.pi(i) + G.Nodes.pi(j);
            end
        end

        subG = graph((C(2:n, 2:n) + C(2:n, 2:n)')./2, 'omitselfloops');
        % SubG.Nodes.Names = G.Nodes.Names(2:n);

        try
            S = minspantree(subG);
        catch
            return 
        end

        for j = neighbors(G, 1)'
            C(1, j) = E(1, j) + G.Nodes.pi(1) + G.Nodes.pi(j);
            C(j, 1) = C(1, j);
        end

        [SC, pos] = sort(C(1, :));
        adjT = zeros(n);
        adjT(1, [pos(1), pos(2)]) = [SC(1), SC(2)];
        adjT([pos(1), pos(2)], 1) = [SC(1), SC(2)]';
        adjT(2:n, 2:n) = adjacency(S, 'weighted');

        T = graph(adjT, 'omitselfloops');
        % The cost of the min 1-tree T wrt the augmented edge cost C_ij
        L_T = sum(sum(adjT));

        d = degree(T);
        
        w = L_T - 2 * sum(G.Nodes.pi);

        if w > HKlb_sub
            HKlb_sub = w;
        end

        if m == 1
            t1 = 1/(2*n) * sum(E(find(adjT)));
            t = t1;
        else
            t = (m-1)*(2*M-5)/(2*M-2)*t1 - (m-2)*t1 +0.5*(m-1)*(m-2)/((M-1)*(M-2))*t1;
        end

        for i = 1:n             
            if d(i) ~= 2
                if m == 1
                    G.Nodes.pi(i) = G.Nodes.pi(i) + 0.6*t*(d(i)-2);
                else
                    G.Nodes.pi(i) = G.Nodes.pi(i) + 0.6*t*(d(i)-2) + 0.4*t*(pred(i)-2);
                end
                pred = d;
            end
        end
       
    end

end