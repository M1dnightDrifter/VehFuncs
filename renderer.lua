function vehicleRenderer(deltaTime)
    for vehicle, funcs in pairs(StreamedVehicles) do
        -- PopupLights
        if funcs.PopupLights then
            local popupLights = funcs.PopupLights;

            local shared = popupLights[-1];
            local lightStatus = areVehicleLightsOn(vehicle);

            local frontLeft = popupLights[0];
            local frontRight = popupLights[1];
            
            if shared.lightStatus ~= lightStatus then -- Detect vehicle light changes
                shared.lightStatus = lightStatus;
                -- Start animation in each light
                if frontLeft then
                    frontLeft.animationState = 1;
                end
                if frontRight then
                    frontRight.animationState = 1;
                end
            end

            -- Front left
            if frontLeft and frontLeft.animationState == 1 then
                local finished = animatePopupLight(vehicle, deltaTime, lightStatus, frontLeft);
                if finished then
                    frontLeft.animationState = 0;
                end
            end
            
            -- Front right
            if frontRight and frontRight.animationState == 1 then
                local finished = animatePopupLight(vehicle, deltaTime, lightStatus, frontRight);
                if finished then
                    frontRight.animationState = 0;
                end
            end
        end

        -- RotateParts
        if funcs.RotateParts then
            local rotateParts = funcs.RotateParts;
            local count = 0;

            for _, part in ipairs(rotateParts[0]) do
                count = count + 0.5;
                setVehicleComponentPosition(vehicle, part.component, count, 0, 1, "parent");

                animateRotatePart(vehicle, deltaTime, part);

                local x, y = getScreenFromWorldPosition(getVehicleComponentPosition(vehicle, part.component, "world"))
                if x then
                    dxDrawText(part.component.." = "..math.floor(part.rotation), x, y + 30, 0, 0)
                end
            end
        end
    end
end
addEventHandler("onClientPreRender", root, vehicleRenderer);