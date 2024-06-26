-- The vehicles only will be added if have compatible components.
StreamedVehicles = {};

-- Evaluate a vehicle components
function checkComponents(vehicle)
    local components = getVehicleComponents(vehicle);

    if not StreamedVehicles[vehicle] then
        StreamedVehicles[vehicle] = {};
    end

    local stream = false;
    local lightStatus = areVehicleLightsOn(vehicle); -- Is not need to get every component

    for component, visible in pairs(components) do
        -- Popup Lights
        local found = string.find(component, "f_pop");
        if found then
            stream = true;

            if not StreamedVehicles[vehicle].PopupLights then
                StreamedVehicles[vehicle].PopupLights = {};
                StreamedVehicles[vehicle].PopupLights[-1] = { -- [3] = Shared variables.
                    lightStatus = lightStatus,
                };
            end

            local side = string.sub(component, found + 5, found + 5); -- 5 is length of f_pop.
            local props;
            local id = -1;

            if side == "l" then -- Front left
                id = 0;
                props = readPopupLight(component);
            elseif side == "r" then -- Front right
                id = 1;
                props = readPopupLight(component);
            end

            if id ~= -1 then
                resetVehicleComponentPosition(vehicle, component);
                resetVehicleComponentRotation(vehicle, component);

                local rx, ry, rz = getVehicleComponentRotation(vehicle, component, "parent");
                local x, y, z = getVehicleComponentPosition(vehicle, component, "parent");
                
                if lightStatus then
                    setVehicleComponentRotation(vehicle, component, props.ax, props.ay, props.az, "parent");
                    setVehicleComponentPosition(vehicle, component, x + props.x, y + props.y, z + props.z, "parent");
                end
                outputConsole("START =========="..id.."========")
                outputConsole(inspect(StreamedVehicles))

                StreamedVehicles[vehicle].PopupLights[id] = {
                    component = component,
                    type = id == 0 and "left" or "right",
                    props = props,
                    defaults = {
                        rx = rx, ry = ry, rz = rz,
                        x = x, y = y, z = z,
                    },
                    animationState = 0,
                    progress = lightStatus and 1 or 0
                };

                outputConsole("end =========="..id.."========")
                outputConsole(inspect(StreamedVehicles))
            end
        end
        -- outputConsole(component);
    end

    if not stream then -- Prevent stream if component f_pop not valid and the vehicle is a new stream.
        StreamedVehicles[vehicle] = nil;
    end
    outputConsole(inspect(StreamedVehicles))
end

-- Remove streamed vehicle.
function destroyInstance(vehicle)
    if StreamedVehicles[source] then
        StreamedVehicles[source] = nil;
        -- PENDING: Destroy more elements and logic if needed
    end
end

-- When a vehicle is streamed in by client.
function handleStreamedIn()
    if getElementType(source) == "vehicle" then
        checkComponents(source);
    end
end
addEventHandler("onClientElementStreamIn", root, handleStreamedIn);

-- When a vehicle is streamed out by client.
function handleStreamedOut()
    destroyInstance(source);
end
addEventHandler("onClientElementStreamOut", root, handleStreamedOut);
addEventHandler("onClientElementDestroy", root, handleStreamedOut);

-- When a vehicle model change.
function handleModelChange()
    -- Remove current instance.
    destroyInstance(source);
    -- Re-evaluate if new model needs to be streamed.
    checkComponents(source);
end
addEventHandler("onClientElementModelChange", root, handleModelChange);


-- Detect streamed vehicles when resource start.
function handleResourceStart()
    local vehicles = getElementsByType("vehicle", root, true);

    for _, vehicle in ipairs(vehicles) do
        checkComponents(vehicle);
    end
end
addEventHandler("onClientResourceStart", resourceRoot, handleResourceStart);