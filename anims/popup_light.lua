function animatePopupLight(vehicle, deltaTime, lightStatus, popupLight)
    local finished = false;
    local props = popupLight.props;
    local defaults = popupLight.defaults;
    local speed = props.speed;
    local dtFactor = deltaTime / 20; -- For some reason without dtFactor the animation is very fast...
    
    -- Extracted from https://github.com/JuniorDjjr/VehFuncs/blob/master/VehFuncs/PopupLights.cpp#L81
    if speed == 0 then
        speed = 4 * (dtFactor * 1.66) * 0.005;
    else
        speed = speed * (dtFactor * 1.66) * 0.005;
    end

    if lightStatus then
        popupLight.progress = popupLight.progress + speed;
        if (popupLight.progress >= 1) then
            popupLight.progress = 1;
            finished = true;
        end
    else
        popupLight.progress = popupLight.progress - speed;
        if (popupLight.progress <= 0) then
            popupLight.progress = 0;
            finished = true;
        end
    end

    setVehicleComponentRotation(vehicle, popupLight.component, props.ax * popupLight.progress, props.ay * popupLight.progress, props.az * popupLight.progress);
    setVehicleComponentPosition(vehicle, popupLight.component, defaults.x + (props.x * popupLight.progress), defaults.y + (props.y * popupLight.progress), defaults.z + (props.z * popupLight.progress));
    
    return finished;
end