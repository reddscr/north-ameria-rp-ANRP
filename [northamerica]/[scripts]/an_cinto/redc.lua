----------------------------------------------------------------------------------------------------------------
-- SCREEN
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
----------------------------------------------------------------------------------------------------------------
-- DX
----------------------------------------------------------------------------------------------------------------
function dxcollisionseatbelt()
    dxDrawRectangle( 0, 0 , screenX, screenY, tocolor(0, 0, 0, 255), false)                 
end
----------------------------------------------------------------------------------------------------------------
-- TOGGLE SEATBELT
----------------------------------------------------------------------------------------------------------------
function togglecinto()
    if not isEventHandlerAdded("onClientRender", root, dxcollisionseatbelt) then 
        if getElementInterior(localPlayer) == 0 and getElementDimension(localPlayer) == 0 then
            local veh = getPedOccupiedVehicle(localPlayer) 
            if veh then
                if (getVehicleType(veh) == "Automobile") then
                    if getElementData(localPlayer,"seatbelt") then
                        toggleAllControls(false)
                        local sound = playSound("tcinto.ogg",false)
                        setSoundVolume(sound, 0.7)
                        setTimer(function()
                            toggleAllControls(true)
                            setElementData(localPlayer,"seatbelt",false)
                        end,1000,1)
                    else
                        local sound2 = playSound("ccinto.ogg",false)
                        setSoundVolume(sound2, 0.7)
                        toggleAllControls(false)
                        setTimer(function()
                            toggleAllControls(true)
                            setElementData(localPlayer,"seatbelt",true)
                        end,1000,1)
                    end
                end
            end
        end
    end
end
bindKey("F3", "down", togglecinto)
----------------------------------------------------------------------------------------------------------------
-- SEATBELT SYSTEM
----------------------------------------------------------------------------------------------------------------
local seatsound = nil
addEventHandler("onClientVehicleCollision", root, function(collider, force, bodyPart, x, y, z, nx, ny, nz)
    if source == getPedOccupiedVehicle(localPlayer) then
        local fDamageMultiplier = getVehicleHandling(source).collisionDamageMultiplier
        local realDamage = (force*fDamageMultiplier)*0.1
        if (getVehicleType(source) == "Automobile") then
            for _, occupant in pairs(getVehicleOccupants(source)) do 
                if getElementData(occupant, "seatbelt") then
                    if realDamage >= 65 then
                        realDamage = realDamage/3
                        setElementHealth(occupant, getElementHealth(occupant) - realDamage/2)
                        if not isEventHandlerAdded("onClientRender", root, dxcollisionseatbelt) then 
                            addEventHandler ("onClientRender", root, dxcollisionseatbelt)
                        end
                        if not seatsound then
                            local seatsound = playSound("heartbeat.ogg",false)
                            setSoundVolume(seatsound, 0.7)
                        end
                        enabletogglecontrol(1)
                        setTimer(function()
                            if isEventHandlerAdded("onClientRender", root, dxcollisionseatbelt) then 
                                removeEventHandler ("onClientRender", root, dxcollisionseatbelt)
                            end
                            enabletogglecontrol(2)
                        end,7500,1)
                    end
                else
                    if realDamage >= 25 then
                        realDamage = realDamage/3
                        setElementHealth(occupant, getElementHealth(occupant) - realDamage)
                        if not isEventHandlerAdded("onClientRender", root, dxcollisionseatbelt) then 
                            addEventHandler ("onClientRender", root, dxcollisionseatbelt)
                        end
                        if not seatsound then
                            local seatsound = playSound("heartbeat.ogg",false)
                            setSoundVolume(seatsound, 0.7)
                        end
                        enabletogglecontrol(1)
                        setTimer(function()
                            if isEventHandlerAdded("onClientRender", root, dxcollisionseatbelt) then 
                                removeEventHandler ("onClientRender", root, dxcollisionseatbelt)
                            end
                            enabletogglecontrol(2)
                        end,7500,1)
                    end
                end
            end
        end
    end
end)
----------------------------------------------------------------------------------------------------------------
-- TOGGLE CONTROL
----------------------------------------------------------------------------------------------------------------
function enabletogglecontrol(typ)
    if typ == 1 then
        toggleControl('accelerate',false)
        toggleControl('handbrake',false)
        toggleControl('brake_reverse',false)
        toggleControl('enter_exit',false)
        toggleControl('vehicle_left',false)
        toggleControl('vehicle_right',false)
        toggleControl('enter_passenger',false)
    elseif typ == 2 then
        toggleControl('accelerate',true)
        toggleControl('handbrake',true)
        toggleControl('brake_reverse',true)
        toggleControl('enter_exit',true)
        toggleControl('vehicle_left',true)
        toggleControl('vehicle_right',true)
        toggleControl('enter_passenger',true)
    end
end
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if 
        type( sEventName ) == 'string' and 
        isElement( pElementAttachedTo ) and 
        type( func ) == 'function' 
    then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end

    return false
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------