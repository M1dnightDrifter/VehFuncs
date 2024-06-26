local showComponents = false
bindKey("F5", "down", function() showComponents = not showComponents end)

addEventHandler("onClientRender", root, function()
    if not showComponents then return end

    local usedCoords = {};
    -- for _, veh in pairs(getElementsByType("vehicle", root, true)) do
    local veh = getPedOccupiedVehicle(localPlayer);
    if not veh then
      return;
    end
    for compname in pairs(getVehicleComponents(veh)) do
        local x, y = getScreenFromWorldPosition(getVehicleComponentPosition(veh, compname, "world"))

        if x then
            if not usedCoords[x] then
              usedCoords[x] = {};
            end
            if usedCoords[x][y] then
              z = z + 0.1;
            end
            dxDrawText(compname, x, y, 0, 0)
        end
    end 
    -- end
end)


function toggleLights ()
    if isPedInVehicle(getLocalPlayer()) then -- checks is the player in vehicle if yes, then: 
          playerVehicle = getPedOccupiedVehicle ( getLocalPlayer() )       -- get the local player's vehicle
          if ( playerVehicle ) then
              if ( getVehicleOverrideLights ( playerVehicle ) ~= 2 ) then  -- if the current state isn't 'force on'
                  setVehicleOverrideLights ( playerVehicle, 2 )            -- force the lights on
              else
                  setVehicleOverrideLights ( playerVehicle, 1 )            -- otherwise, force the lights off
              end
          end
      end
end
bindKey("j", "down", toggleLights)