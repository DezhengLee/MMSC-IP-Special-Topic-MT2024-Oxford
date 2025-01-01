function p = twPunish(t, timeWin)
    if t <= timeWin(2) && t >= timeWin(1)
        p = 0;
    elseif t > timeWin(2)
        p = t - timeWin(2);
    else
        p = timeWin(1) - t;
    end

end