-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
function vehicleStartExit(ply, seat, jacked)
    if getElementData(ply, "seatbelt") then
        exports.an_infobox:addNotification(ply,"Você está com o <b>cinto de segurança</b>.","aviso")
		cancelEvent()		
	end
	if isVehicleLocked(getPedOccupiedVehicle(ply)) then
		if (getVehicleType(source) == "Automobile") then
			exports.an_infobox:addNotification(ply,"O veiculo está <b>trancado</b>.","aviso")
			cancelEvent()
		end
    end
    local speed = getElementSpeed(getPedOccupiedVehicle(ply))
    if speed >= 10 then
		cancelEvent()
    end
end
addEventHandler("onVehicleStartExit",getRootElement(),vehicleStartExit)
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------


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
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------