local vehicleComponents = {}
addEvent("onVehicleComponentsChecked", true)
addEventHandler("onVehicleComponentsChecked", resourceRoot, function(components)
    vehicleComponents = components  -- Update local table with received components
    
     --[[outputConsole("Received vehicle components from another resource:")
    for _, component in ipairs(vehicleComponents) do
        outputConsole("- " .. component)
    end ]] -- DEBUGGING
end)


function outputC()
    local player = localPlayer  -- assuming localPlayer is defined elsewhere
    local vehicle = getPedOccupiedVehicle(player)
    local count = 0
    
    for _, component in ipairs(vehicleComponents) do
        if string.sub(component, 1, 5) == "f_pop" then
            count = count + 1
            local after_component = string.sub(component, 6)  -- Assuming "f_pop_" is 6 characters
            local combined = "f_pop" .. after_component
            
    
            
            -- Extract rotation angle (ax)
            local afterEquals = string.match(combined, "=([^=]+)$")
            local extracted = string.match(afterEquals, "([^s]+)")
            local after_s = string.match(combined, "s%d+%.?%d*")
      
            local s = tonumber(string.sub(after_s, 2)) or 0  -- Convert to number
            
            local ax = tonumber(string.sub(extracted, 3)) or 0  -- Convert to number
            
            
           
            local cx, _, _ = getVehicleComponentRotation(vehicle, combined)
            -- Gradual rotation using timer
            local currentRotation = cx
            local step = 1  -- Rotation step
            local interval = s  -- Interval in milliseconds
            
            local function rotateComponent()
                
                currentRotation = currentRotation + step
                if currentRotation > ax then
                    currentRotation = ax
                    
                    return  -- Stop timer
                end
                setVehicleComponentRotation(vehicle, combined, currentRotation, 0, 0)
                if currentRotation == ax then
                    setVehicleOverrideLights(vehicle, 2)
                end
                
            end
            
            -- Start the timer for gradual rotation
            setTimer(rotateComponent, interval, 35 - currentRotation)
        end
    
    end
    if count == 0 then
        outputChatBox("TEST")
    end
end


addCommandHandler("starttest", outputC)




function resetComponentRotation()
    local player = localPlayer  -- assuming localPlayer is defined elsewhere
    local vehicle = getPedOccupiedVehicle(player)
    
    if vehicle then
        local count = 0
        for _, component in ipairs(vehicleComponents) do
            if string.sub(component, 1, 5) == "f_pop" then
                count = count + 1
                local after_component = string.sub(component, 6)  -- Assuming "f_pop_" is 6 characters
                local combined = "f_pop" .. after_component
                
                local afterEquals = string.match(combined, "=([^=]+)$")
                local extracted = string.match(afterEquals, "([^s]+)")
                local after_s = string.match(combined, "s(%d+%.?%d*)")
                local s = tonumber(after_s) or 0  -- Convert to number
                local ax = tonumber(string.sub(extracted, 3)) or 0  -- Convert to number
                
                -- Get current rotation
                local rx, ry, rz = getVehicleComponentRotation(vehicle, combined)
                local currentRotation = rx  -- Start with the current X rotation
                
                local step = -1  -- Rotation step
                local interval = s  -- Interval in milliseconds
                
                local function rotateComponent()
                    currentRotation = currentRotation + step
                    if currentRotation < 0 then
                        currentRotation = 0
                    
                        return  -- Stop timer
                    end
                    setVehicleComponentRotation(vehicle, combined, currentRotation, 0, 0)
                    setVehicleOverrideLights(vehicle, 1)
                end
                
                -- Start the timer for gradual rotation
                setTimer(rotateComponent, interval, 0)
            end
        end
        

    else
        
    end
end
local lightstatus = false
local delay = false
-- Command to reset rotation of components starting with "f_pop"
addCommandHandler("reset", resetComponentRotation)


function popupHandler()
    local hasPopup = false
    for _, component in ipairs(vehicleComponents) do
        if string.sub(component, 1, 5) == "f_pop" then
            hasPopup = true
            outputChatBox("hasPopup")
            break
        end
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if hasPopup then
        outputChatBox("TEST")
    end

    
    if not vehicle then
        return
    end
    if not hasPopup then
        removeEventHandler("onClientPreRender", root, popupHandler)
        return
    end
    if hasPopup then
        local lights = getVehicleOverrideLights(vehicle)
        -- lights 2 > activates the popup rotating function which then after popup rotates it will then set the lights on.
        if lights == 2 and not lightstatus then
            outputChatBox("Lights are 2, turning on...")
            setVehicleOverrideLights(vehicle, 1)
            outputC()
            lightstatus = true
            delay = true
            local delayTimer = setTimer(function()
                delay = false 
            end, 1000, 1)
        elseif (lights == 0 or lights == 1) and lightstatus and not delay then
            outputChatBox("Lights are 0 or 1, turning off...")
            resetComponentRotation()
            lightstatus = false
            delay = false
        end
    end
end
function onVehicleEnter()
    outputDebugString("Added")
    addEventHandler("onClientPreRender", root, popupHandler)
end
function onVehicleExit()
    outputDebugString("Removed")
    removeEventHandler("onClientPreRender", root, popupHandler)
end
addEventHandler("onClientPreRender", root, popupHandler)
addEventHandler("onClientVehicleEnter", root, onVehicleEnter)
addEventHandler("onClientVehicleExit", root, onVehicleExit)
