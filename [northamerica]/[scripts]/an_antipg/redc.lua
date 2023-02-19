
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function anantipg()
    if isPedInVehicle ( localPlayer ) then
        if getPedOccupiedVehicleSeat ( localPlayer ) == 0 then 
            veh = getPedOccupiedVehicle ( localPlayer )
            if veh then
                if isVehicleOnGround ( veh ) then
                    if (getVehicleType(veh) == "Automobile") then
                        x,y,z = getElementRotation(veh)
                        if x>=150 and x <=250 or x>=-250 and x <=-150 or y>=150 and y <=250 or y>=-250 and y <=-150 then
                            triggerServerEvent("anantipg",veh,veh)     
                        end
                    end
                end
            end
        end
    end
end
addEventHandler ( "onClientRender", root, anantipg ) 
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local vehplane = false
function anantipg2()
    if isPedInVehicle ( localPlayer ) then
        if getPedOccupiedVehicleSeat ( localPlayer ) == 0 then 
            veh = getPedOccupiedVehicle ( localPlayer )
            if veh then
                if (not isVehicleOnGround ( veh )) and (not isVehicleWheelOnGround ( veh, "front_left" )) and (not isVehicleWheelOnGround ( veh, "rear_left" )) and (not isVehicleWheelOnGround ( veh, "front_right" )) and (not isVehicleWheelOnGround ( veh, "rear_right" )) then
                    if (getVehicleType(veh) == "Automobile") then
                        local px, py, pz = getElementPosition ( veh )
                    -- if pz >= getGroundPosition ( px, py, pz )+7 then
                        local dist = 6.5
                        if getDistanceBetweenPoints3D (px, py, pz, px, py, getGroundPosition ( px, py, pz )) >= dist then
                            dist = getDistanceBetweenPoints3D (px, py, pz, px, py, getGroundPosition ( px, py, pz ))
                            if not vehplane then
                                vehplane = veh
                            end
                        end
                        --end
                    end
                end
            end
        end
    end
end
addEventHandler ( "onClientRender", root, anantipg2 ) 
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function anantipg2()
    if isElement(vehplane) then
        if isVehicleOnGround ( vehplane ) then
            triggerServerEvent("anantipg2",vehplane,vehplane)   
            vehplane = false
        end
    else
        vehplane = false
    end
end
addEventHandler ( "onClientRender", root, anantipg2 ) 
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
