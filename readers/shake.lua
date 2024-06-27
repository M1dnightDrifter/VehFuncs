function readShake(name)
    local axis = string.match(name, "_([xyz])") or "y";
    local mult = tonumber(string.match(name, "_mu=([%d%.]+)")) or false;
    local tilt = tonumber(string.match(name, "_tl=([%d%.]+)")) or false;

    return {
        axis = axis,
        mult = mult,
        tilt = tilt
    };
end