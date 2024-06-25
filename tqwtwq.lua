-- Initialize a table to store vehicle components
local vehicleComponents = {}


-- Function to check if the vehicle has the component
function checkVehicleComponent()
    local player = localPlayer  -- assuming localPlayer is defined elsewhere
    local vehicle = getPedOccupiedVehicle(player)
    
    if vehicle then
        -- Clear previous components from the table
        for k in pairs(vehicleComponents) do
            vehicleComponents[k] = nil
        end
        
        -- Get vehicle components
        local components = getVehicleComponents(vehicle)
        
        -- Add components to the table
        for i in pairs(components) do
            table.insert(vehicleComponents, i)
        end
        
        -- Output vehicle components to console
        outputConsole("Vehicle components:")
        for _, component in ipairs(vehicleComponents) do
            outputConsole("- " .. component)
        end
        
        -- Output components starting with "f_pop" to chat
        
        
        -- Output to chat (optional)
        outputChatBox("Vehicle components listed. Check the console (F8).")
    else
        outputChatBox("You are not in a vehicle.")
    end
end




-- Command to check the vehicle components
addCommandHandler("checkcomponents", checkVehicleComponent)


function outputC()
    local player = localPlayer  -- assuming localPlayer is defined elsewhere
    local vehicle = getPedOccupiedVehicle(player)
    local count = 0
    
    for _, component in ipairs(vehicleComponents) do
        if string.sub(component, 1, 5) == "f_fan" then
            count = count + 1
            local after_f_pop = string.sub(component, 6)  -- Assuming "f_pop_" is 6 characters
            local combined = "f_fan" .. after_f_pop
            
            outputChatBox("Component starting with 'f_pop': " .. component)
            outputChatBox(" - Combined component: " .. combined)
            local cx, cy, cz = getVehicleComponentPosition(vehicle, combined)
            setVehicleComponentRotation(vehicle, combined, cx, cy, cz+2)
            -- Extract rotation angle (ax)
            
        end
    end
    
    outputChatBox("Total components starting with 'f_pop': " .. count)
end


addCommandHandler("testnow", outputC)
-- Function to retrieve the stored components table (if needed elsewhere)
function getVehicleComponentsTable()
    return vehicleComponents
end


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
                local after_f_pop = string.sub(component, 6)
                local combined = "f_fan" .. after_f_pop
                local rx, ry, rz = getElementRotation(obj)
                setElementRotation(obj, rx, ry + rotationSpeed, rz)  -- Rotate the object
                setVehicleComponentRotation(vehicle, combined, rx, ry + rotationSpeed, rz)  -- Rotate the vehicle component
            elseif string.sub(component, 1, 6) == "f_gear" then
                local after_f_pop = string.sub(component, 7)
                local combined = "f_gear" .. after_f_pop
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
