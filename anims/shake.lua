function animateShakePart(vehicle, deltaTime, part)
    local dtFactor = deltaTime / 50; -- investigate the correct dtFactor!!! the 1.6666 doesnt work well
    local rpmFactor = getVehicleRPM(vehicle) / 500;
    part.dotLife = part.dotLife + dtFactor * (0.2 * ((rpmFactor * 2.0) + 1));

    if part.dotLife > 100 then
        part.dotLife = 1;
    end

    local noise = perlin:noise(part.dotLife);

    if part.mult then
        noise = noise * part.mult;
    end

    local angle = noise * 1;

    if part.tilt then
        angle = angle + rpmFactor * part.tilt;
    end

    local currentRotation = (part.defaults.rotation + angle) % 360;
    
    if part.axis == "x" then
        setVehicleComponentRotation(vehicle, part.component, currentRotation, 0, 0);
    elseif part.axis == "z" then
        setVehicleComponentRotation(vehicle, part.component, 0, 0, currentRotation);
    else -- "y"
        setVehicleComponentRotation(vehicle, part.component, 0, currentRotation, 0);
    end
end