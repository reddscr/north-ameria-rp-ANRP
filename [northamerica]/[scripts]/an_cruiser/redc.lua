-------------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
-------------------------------------------------------------------------------------------------------------------------------------
local cruiservelocity = 0
local cruiserstarted = false
local cruiservehicle = nil
-------------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT FUNCTIONS
-------------------------------------------------------------------------------------------------------------------------------------
function startcruiser()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
       -- if (getVehicleType(veh) == "Automobile") then
            if getPedOccupiedVehicleSeat ( localPlayer ) == 0 then 
                if not cruiserstarted then
                    if (not getPedControlState( "brake_reverse" )) and (not getPedControlState( "accelerate" )) and (not getPedControlState( "handbrake" )) then
                        local speed = math.floor(getFormatSpeed(localPlayer))
                        if speed >= 10 then
                            if speed <= 80 then
                                cruiservehicle = veh
                                cruiserstarted = true
                                cruiservelocity = tonumber(math.round(speed))
                                exports.an_infobox:addNotification("<b>Cruise control</b> ativado","info")
                            else
                                exports.an_infobox:addNotification("O <b>cruise control</b> só pode ser ativado abaixo de <b>80 mph</b>","erro")
                            end
                        else
                            exports.an_infobox:addNotification("O <b>cruise control</b> só pode ser ativado acima de <b>10 mph</b>","erro")
                        end
                    else
                        exports.an_infobox:addNotification("Você não pode freiar ou acelerar ativando o <b>cruise control</b>","info")
                    end
                else
                    cruiservelocity = 0
                    cruiserstarted = false
                    cruiservehicle = nil
                    exports.an_infobox:addNotification("<b>Cruise control</b> desativado","info")
                end
            end
       -- end
    end
end
bindKey('c','down',startcruiser)

function stopanddebugscruiser()
    if cruiserstarted then
        cruiservelocity = 0
        cruiserstarted = false
        cruiservehicle = nil
        exports.an_infobox:addNotification("<b>Cruise control</b> desativado","info")
    end
end
addEvent ("stopanddebugscruiser", true)
addEventHandler ("stopanddebugscruiser", root, stopanddebugscruiser)

function exitingVehicle(player, seat, door)
	if (seat==0) then
		stopanddebugscruiser()
    end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), exitingVehicle)

function cruisercontrol()
    if cruiserstarted then
        if (not isElement(cruiservehicle)) or (not getVehicleEngineState(cruiservehicle)) or (tonumber(getElementData(cruiservehicle,'fuel')) <= 0 ) then
            cruiservelocity = 0
            cruiserstarted = false
            cruiservehicle = nil
        end    
        if isElement(cruiservehicle) then
            local x,y = angle(cruiservehicle)
            if (x<15) then
                local speed = getElementSpeed(cruiservehicle)
                local targetSpeedTmp = speed + 1
                if (targetSpeedTmp > cruiservelocity) then
                    targetSpeedTmp = cruiservelocity
                end
                if (targetSpeedTmp > 3) then
                    setElementSpeed(cruiservehicle, "mph", targetSpeedTmp)
                end
            end
        end
        if getPedControlState(localPlayer, 'handbrake') or getPedControlState(localPlayer, 'accelerate') or getPedControlState(localPlayer, 'brake_reverse') then
            stopanddebugscruiser()
        end
    end
end
addEventHandler("onClientRender", root, cruisercontrol)
-------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-------------------------------------------------------------------------------------------------------------------------------------
function getFormatSpeed(ply)
    local speedes = (getVehicleVelocity((getPedOccupiedVehicle(ply)))) * 1.558
    return speedes
end

function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	return relateVelocity((speedx^2 + speedy^2 + speedz^2)^ 0.5 * 100)
end

local factor = 0.675
function relateVelocity(speed)
	return factor * speed
end 

function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

function angle(vehicle)
	if isElement(vehicle) then
        local vx,vy,vz = getElementVelocity(vehicle)
        local modV = math.sqrt(vx*vx + vy*vy)
        if not isVehicleOnGround(vehicle) then return 0,modV end
        local rx,ry,rz = getElementRotation(vehicle)
        local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
        local cosX = (sn*vx + cs*vy)/modV
        return math.deg(math.acos(cosX))*0.5, modV
    end
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	else
		return false
	end
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------