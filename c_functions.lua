
local vehicleComponents = {}
local playerinvehicle = nil

function checkVehicleComponent()
    local player = localPlayer
    local vehicle = getPedOccupiedVehicle(player)
    
    if vehicle then
        
        for k in pairs(vehicleComponents) do
            vehicleComponents[k] = nil
        end
        
        
        local components = getVehicleComponents(vehicle)
        
        
        for i in pairs(components) do
            if string.sub(i, 1, 2) == "f_" then
                table.insert(vehicleComponents, i)
            end
        end
        
        
        --[[outputConsole("Vehicle components (starting with 'f_'):")
        for _, component in ipairs(vehicleComponents) do
            outputConsole("- " .. component)
        end ]]--
        triggerEvent("onVehicleComponentsChecked", resourceRoot, vehicleComponents)
        
        
        --[outputChatBox("Vehicle components starting with 'f_' listed. Check the console (F8).")
    else
        --[outputChatBox("You are not in a vehicle.")
    end
end

function getVehicleComponentsTable()
    return vehicleComponents
end

addEventHandler("onClientPreRender", root, function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then
        return
    end
    
    local pedseat = getPedOccupiedVehicleSeat(localPlayer)
    
    if pedseat == 0 and not playerinvehicle then
        --outputChatBox("You are in the driver's seat of a vehicle.")
        playerinvehicle = true
        checkVehicleComponent()
    else
    
    end
end)
addEventHandler("onClientVehicleEnter", root, function()
    playerinvehicle = true
end)

addEventHandler("onClientVehicleExit", root, function()
    playerinvehicle = false
end)
addCommandHandler("checkcomponents", checkVehicleComponent)


function toggleEngine()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle and getVehicleController(vehicle) == localPlayer then
        setVehicleEngineState(vehicle, not getVehicleEngineState(vehicle))
    end
end

-- Bind the toggleEngine function to the 'J' key
bindKey("j", "down", toggleEngine)