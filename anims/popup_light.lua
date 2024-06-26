function animatePopupLight(vehicle, deltaTime, lightStatus, popupLight)
    local finished = false;
    local props = popupLight.props;
    local defaults = popupLight.defaults;
    local speed = props.speed;
    if speed == 0 then
        speed = 4 * (deltaTime * 1.66) * 0.005;
    else
        speed = speed * (deltaTime * 1.66) * 0.005;
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