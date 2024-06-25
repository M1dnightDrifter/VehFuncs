
local obj = createObject(1337, 0,0,0)
local vehicleComponents = {}
addEvent("onVehicleComponentsChecked", true)
addEventHandler("onVehicleComponentsChecked", resourceRoot, function(components)
    vehicleComponents = components  -- Update local table with received components
    
    --[[outputConsole("Received vehicle components from another resource:")
    for _, component in ipairs(vehicleComponents) do
        outputConsole("- " .. component)
    end ]] -- DEBUGGING
end)

function spinning_enable()


    local vehicle = getPedOccupiedVehicle(localPlayer)
    local x, y, z = getElementPosition(localPlayer) 
    



    
    if not obj then
        outputChatBox("Failed to create object.", 255, 0, 0)
        return
    end
    local rotationSpeed = 5
    local incdecrate = 4
    

    local function updateRotation()
        
    
        if getVehicleEngineState(vehicle) then
            rotationSpeed = rotationSpeed + incdecrate  
            if rotationSpeed > 360 then
                rotationSpeed = rotationSpeed % 1  
            end
        else
            rotationSpeed = rotationSpeed - incdecrate  
            if rotationSpeed < 0 then
                rotationSpeed = 0 
            end
        end

        for _, component in ipairs(vehicleComponents) do
            if string.sub(component, 1, 5) == "f_fan" then
                local after_component = string.sub(component, 6)
                local combined = "f_fan" .. after_component
                local rx, ry, rz = getElementRotation(obj)
                setElementRotation(obj, rx, ry + rotationSpeed, rz)  
                setVehicleComponentRotation(vehicle, combined, rx, ry + rotationSpeed, rz)  
            elseif string.sub(component, 1, 6) == "f_gear" then
                local after_component = string.sub(component, 7)
                local combined = "f_gear" .. after_component
                local rx, ry, rz = getElementRotation(obj)
                setElementRotation(obj, rx, ry + rotationSpeed, rz) 
                setVehicleComponentRotation(vehicle, combined, rx, ry + rotationSpeed, rz)
            end
            
        end
        
    end


    setTimer(updateRotation, 1, 0)
end




    

function spinningHandler()
    local hasSpinning = false
    local spinning = true
    for _, component in ipairs(vehicleComponents) do
        if string.sub(component, 1, 5) == "f_fan" or "f_gear" then
            spinning = true
            hasSpinning = true
            
            break
        end
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)

    
    if not vehicle then
        return
    end
    if not spinning then
        removeEventHandler("onClientPreRender", root, spinningHandler)
        return
    end
    if hasSpinning then
        if getVehicleEngineState(vehicle) then
            spinning_enable()
            spinning = true
            removeEventHandler("onClientPreRender", root, spinningHandler)
        else
        end
    end
end
function onVehicleEnter()
    outputDebugString("Added")
    addEventHandler("onClientPreRender", root, spinningHandler)
end
function onVehicleExit()
    outputDebugString("Removed")
    removeEventHandler("onClientPreRender", root, spinningHandler)
end
addEventHandler("onClientPreRender", root, spinningHandler)
addEventHandler("onClientVehicleEnter", root, onVehicleEnter)
addEventHandler("onClientVehicleExit", root, onVehicleExit)
