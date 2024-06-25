local vehicleComponents = {}
addEvent("onVehicleComponentsChecked", true)
addEventHandler("onVehicleComponentsChecked", resourceRoot, function(components)
    vehicleComponents = components  
    
    --[[outputConsole("Received vehicle components from another resource:")
    for _, component in ipairs(vehicleComponents) do
        outputConsole("- " .. component)
        if string.sub(component, 1, 6) == "f_popl" then
            outputChatBox(component)
        end

    end--]]
end)


function popup_up()
    local player = localPlayer  
    local vehicle = getPedOccupiedVehicle(player)
    local count = 0
    
    for _, component in ipairs(vehicleComponents) do
        if string.match(component, "^f_pop[lr]$") then
            
            count = count + 1
            
        
            local cx, _, _ = getVehicleComponentRotation(vehicle, component)
            
            local currentRotation = cx
            local step = 1  
            local interval = 4 
            
            local function rotateComponent()
                
                currentRotation = currentRotation + step
                if currentRotation > 30 then
                    currentRotation = 30
                    
                    return  
                end
                setVehicleComponentRotation(vehicle, component, currentRotation, 0, 0)
                if currentRotation == 30 then
                    setVehicleOverrideLights(vehicle, 2)
                end
                
            end
        
        
            setTimer(rotateComponent, interval, 30 - currentRotation)
        elseif string.sub(component, 1, 5) == "f_pop" then
            local after_component = string.sub(component, 6)  
            local combined = "f_pop" .. after_component
            
            local afterEquals = string.match(combined, "=([^=]+)$")
            local extracted = string.match(afterEquals, "([^s]+)")
            local after_s = string.match(combined, "s%d+%.?%d*")
            local s = tonumber(string.sub(after_s, 2)) or 0  
            
            local ax = tonumber(string.sub(extracted, 3)) or 0  
         

            local cx, _, _ = getVehicleComponentRotation(vehicle, combined)
            
            local currentRotation = cx
            local step = 1  
            local interval = s 
            
            local function rotateComponent()
                
                currentRotation = currentRotation + step
                if currentRotation > ax then
                    currentRotation = ax
                    
                    return 
                end
                setVehicleComponentRotation(vehicle, combined, currentRotation, 0, 0)
                if currentRotation == ax then
                    setVehicleOverrideLights(vehicle, 2)
                end
                
            end
            
            
            setTimer(rotateComponent, interval, 35 - currentRotation)
        
            
        end
    end
    if count == 0 then
    end
end







function popup_down()
    local player = localPlayer  
    local vehicle = getPedOccupiedVehicle(player)
    
    if vehicle then
        local count = 0
        for _, component in ipairs(vehicleComponents) do
            if string.match(component, "^f_pop[lr]$") then
                
                count = count + 1
                local cx, _, _ = getVehicleComponentRotation(vehicle, component)
            
                local currentRotation = cx
                local step = -1  
                local interval = 4  
                

                local function rotateComponent()
                        currentRotation = currentRotation + step
                    if currentRotation < 0 then
                        currentRotation = 0
                        
                        return  
                    end
                    setVehicleComponentRotation(vehicle, component, currentRotation, 0, 0)
                    
                end
                
                
                setTimer(rotateComponent, interval, 0)
            elseif string.sub(component, 1, 5) == "f_pop" then
                count = count + 1
                local after_component = string.sub(component, 6)  
                local combined = "f_pop" .. after_component
                
                local afterEquals = string.match(combined, "=([^=]+)$")
                local extracted = string.match(afterEquals, "([^s]+)")
                local after_s = string.match(combined, "s(%d+%.?%d*)")
                local s = tonumber(after_s) or 0  
                local ax = tonumber(string.sub(extracted, 3)) or 0  
                
           
                local rx, ry, rz = getVehicleComponentRotation(vehicle, combined)
                local currentRotation = rx  
                
                local step = -1  
                local interval = s  
                
                local function rotateComponent()
                    currentRotation = currentRotation + step
                    if currentRotation < 0 then
                        currentRotation = 0
                    
                        return 
                    end
                    setVehicleComponentRotation(vehicle, combined, currentRotation, 0, 0)
                    setVehicleOverrideLights(vehicle, 1)
                end
                
               
                setTimer(rotateComponent, interval, 0)
            end
        end
        

    else
        
    end
end


addCommandHandler("popup:down", popup_down)
addCommandHandler("popup:up", popup_up)





local lightstatus = false
local delay = false
function popupHandler()
    local hasPopup = false
    for _, component in ipairs(vehicleComponents) do
        if string.sub(component, 1, 5) == "f_pop" or string.match(component, "^f_pop[lr]$") then
            hasPopup = true
            --{outputChatBox("hasPopup")
            break
        end
    end
    
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if hasPopup then
        --{outputChatBox("TEST")
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
            --{{outputChatBox("Lights are 2, turning on...") - debug
            setVehicleOverrideLights(vehicle, 1)
            popup_up()
            lightstatus = true
            delay = true
            local delayTimer = setTimer(function()
                delay = false 
            end, 1000, 1)
        elseif (lights == 0 or lights == 1) and lightstatus and not delay then
            --{{outputChatBox("Lights are 0 or 1, turning off...") - debug
            popup_down()
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