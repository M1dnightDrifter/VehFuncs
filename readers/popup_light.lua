function readPopupLight(name)
    local ax, ay, az, x, y, z, speed  = 30, 0, 0, 0, 0, 0, 0;

    ax = tonumber(string.match(name, "ax(%d+)")) or 0;
    ay = tonumber(string.match(name, "ay(%d+)")) or 0;
    az = tonumber(string.match(name, "az(%d+)")) or 0;
    x = tonumber(string.match(name, "[^a]x(%d+)")) or 0;
    y = tonumber(string.match(name, "[^a]y(%d+)")) or 0;
    z = tonumber(string.match(name, "[^a]z(%d+)")) or 0;
    speed = tonumber(string.match(name, "s(%d+%.?%d*)")) or 0;

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