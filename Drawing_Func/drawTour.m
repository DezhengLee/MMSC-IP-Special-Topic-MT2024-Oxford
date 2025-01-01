function drawTour(coord, path)
    n = size(path, 2) - 1;
    for i = 1:n
        plot(coord(1, path(i:i+1)), coord(2, path(i:i+1)), '-o')
        hold on
    end
    hold off
end