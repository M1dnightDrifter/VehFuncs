function readPopupLight(name)
    local ax = tonumber(string.match(name, "ax(%d+)")) or 30;
    local ay = tonumber(string.match(name, "ay(%d+)")) or 0;
    local az = tonumber(string.match(name, "az(%d+)")) or 0;
    local x = tonumber(string.match(name, "[^a]x(%d+)")) or 0;
    local y = tonumber(string.match(name, "[^a]y(%d+)")) or 0;
    local z = tonumber(string.match(name, "[^a]z(%d+)")) or 0;
    local speed = tonumber(string.match(name, "s(%d+%.?%d*)")) or 0;

    return {
        ax = ax,
        ay = ay,
        az = az,
        x = x * 0.01,
        y = y * 0.01,
        z = z * 0.01,
        speed = speed
    };
end