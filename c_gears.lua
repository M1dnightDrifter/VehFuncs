local vehicleComponents = {}
addEvent("onVehicleComponentsChecked", true)
addEventHandler("onVehicleComponentsChecked", resourceRoot, function(components)
    vehicleComponents = components  -- Update local table with received components
    
    --[[outputConsole("Received vehicle components from another resource:")
    for _, component in ipairs(vehicleComponents) do
        outputConsole("- " .. component)
    end ]] -- DEBUGGING
end)
-- Create a function to create and rotate the object
function createRotatingObject()
    -- Replace these coordinates with the desired position
    local vehicle = getPedOccupiedVehicle(localPlayer)
    local x, y, z = getElementPosition(localPlayer)  -- Example position
    


-- Create the object
    local obj = createObject(1337, x,y,z)
    if not obj then
        outputChatBox("Failed to create object.", 255, 0, 0)
        return
    end
    local rotationSpeed = 5
    local incdecrate = 4
    
-- Check if object creation was successful
    local function updateRotation()
        
        -- Check vehicle engine state
        if getVehicleEngineState(vehicle) then
            rotationSpeed = rotationSpeed + incdecrate  -- Increase rotation speed
            if rotationSpeed > 5 then
                rotationSpeed = rotationSpeed  -- Cap rotation speed at maxRotationSpeed
            end
        else
            rotationSpeed = rotationSpeed - incdecrate  -- Decrease rotation speed
            if rotationSpeed < 0 then
                rotationSpeed = 0  -- Ensure rotation speed doesn't go below 0
            end
        end
        
        -- Rotate the object and vehicle component
        for _, component in ipairs(vehicleComponents) do
            if string.sub(component, 1, 5) == "f_fan" then
                local after_component = string.sub(component, 6)
                local combined = "f_fan" .. after_component
                local rx, ry, rz = getElementRotation(obj)
                setElementRotation(obj, rx, ry + rotationSpeed, rz)  -- Rotate the object
                setVehicleComponentRotation(vehicle, combined, rx, ry + rotationSpeed, rz)  -- Rotate the vehicle component
            elseif string.sub(component, 1, 6) == "f_gear" then
                local after_component = string.sub(component, 7)
                local combined = "f_gear" .. after_component
                local rx, ry, rz = getElementRotation(obj)
                setElementRotation(obj, rx, ry + rotationSpeed, rz)  -- Rotate the object
                setVehicleComponentRotation(vehicle, combined, rx, ry + rotationSpeed, rz)
            end
        end
    end

    -- Set up a timer to update rotation every 50 milliseconds (adjust as needed)
    setTimer(updateRotation, 1, 0)

end

-- Call the function to create the rotating object
addCommandHandler("createrotatingobject", createRotatingObject)
    

function toggleEngine()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle and getVehicleController(vehicle) == localPlayer then
        setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
    end
end

-- Bind the toggleEngine function to the 'J' key
bindKey("j", "down", toggleEngine)
