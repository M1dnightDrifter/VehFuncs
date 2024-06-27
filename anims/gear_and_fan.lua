function animateRotatePart(vehicle, deltaTime, part)
    local dtFactor = deltaTime / 500; -- investigate the correct dtFactor!!! the 1.6666 doesnt work well
    local speed = (dtFactor * 22) * part.speedMult;

    if part.isGear then -- add gear validaitons, engine ON 
        local rpm = getVehicleRPM(vehicle);
        speed = speed + (rpm / 500);
    end

    part.rotation = (part.rotation + speed) % 360;
    
    if part.axis == "x" then
        setVehicleComponentRotation(vehicle, part.component, part.rotation, 0, 0);
    elseif part.axis == "z" then
        setVehicleComponentRotation(vehicle, part.component, 0, 0, part.rotation);
    else -- "y"
        setVehicleComponentRotation(vehicle, part.component, 0, part.rotation, 0, "parent");
    end
end