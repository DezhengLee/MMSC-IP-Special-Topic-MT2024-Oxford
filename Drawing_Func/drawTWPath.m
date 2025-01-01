function drawTWPath(adjMat, path, tw)
    n = size(adjMat, 1);
    t = [0];
    for i = 1:n
        t(end+1) = t(end) + adjMat(path(i), path(i+1));
    end
    twHL = (tw(:, 2) - tw(:, 1))./2;
    twMP = (tw(:, 1)+tw(:, 2)) ./ 2;
    errorbar(1:n, twMP, twHL, LineStyle = "none")
    hold on
    xline(1)
    hold on
    for i = 1:length(t) -1
        plot([path(i), path(i+1)], [t(i), t(i+1)], "-o", LineWidth=1.2)
        %% 
        hold on
    end
    hold off
    
end