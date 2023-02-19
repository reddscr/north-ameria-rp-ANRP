------------------------------------------------------------------------------------------------------------------
-- MySql Connect
local connnnec = exports["an_connect"]:getConnection()

local repairrequest = {
    [1] = {['Plastic'] = 1, ['Steel'] = 1},
    [2] = {['Plastic'] = 1, ['Steel'] = 1, ['Copper'] = 1},
}
------------------------------------------------------------------------------------------------------------------
-- repair comand
------------------------------------------------------------------------------------------------------------------
addCommandHandler("torepair",
function(ply,cmd)
	if exports.an_account:hasPermission( ply, 'mechanic.permission') then
		if not isPedInVehicle(ply) then
				local vehicl = exports.an_player:getproxveh(ply,6)
				if vehicl then
					local vehicleHealth = getElementHealth ( vehicl ) / 10
						if vehicleHealth >= 60 then
							if getVehicleDoorOpenRatio (vehicl, 0 ) == 1 then
								if (getElementData(ply, 'Plastic') >= repairrequest[1].Plastic) and (getElementData(ply, 'Steel') >= repairrequest[1].Steel) then
                                    exports.an_inventory:sattitem(ply,"Plastic",repairrequest[1].Plastic,"menos")
                                    exports.an_inventory:sattitem(ply,"Steel",repairrequest[1].Steel,"menos")
									setPedAnimation(ply,"COP_AMBIENT", "Copbrowse_loop",-1,true,false,false,false)
									exports.an_infobox:addNotification(ply,"Fazendo reparos no <b>motor</b> do veiculo.","info")
									setTimer(function()
										fixVehicle(vehicl)
										setVehicleDoorOpenRatio(vehicl, 0, 1, 50)
										setVehicleDoorOpenRatio(vehicl, 1, 0, 50)
										setVehicleDoorOpenRatio(vehicl, 2, 0, 50)
										setVehicleDoorOpenRatio(vehicl, 3, 0, 50)
										setVehicleDoorOpenRatio(vehicl, 4, 0, 50)
										setVehicleDoorOpenRatio(vehicl, 5, 0, 50)
										setVehicleDamageProof(vehicl, false)
										exports.an_vehicles:saveVehicle(vehicl)
										setPedAnimation(ply,nil)
										exports.an_infobox:addNotification(ply,"<b>Veiculo</b> reparado com sucesso!","sucesso")
									end,1000*30,1)
								else
                                    exports.an_infobox:addNotification(ply,"Você precisa ter <br><br>".. repairrequest[1].Plastic.."x <b>Plastico</b><br>".. repairrequest[1].Steel.."x <b>Aço</b><br><br>para reparar o veículo.","aviso")
								end
							else
								exports.an_infobox:addNotification(ply,"Abra o <b>capô</b> do <b>veiculo</b>.","aviso")
							end
						else
							local proxy = getproxymechanic(ply,25)
							if proxy then
								if getVehicleDoorOpenRatio (vehicl, 0 ) == 1 then
									if (getElementData(ply, 'Plastic') >= repairrequest[2].Plastic) and (getElementData(ply, 'Steel') >= repairrequest[2].Steel) and (getElementData(ply, 'Copper') >= repairrequest[2].Copper) then
										exports.an_inventory:sattitem(ply,"Plastic",repairrequest[2].Plastic,"menos")
										exports.an_inventory:sattitem(ply,"Steel",repairrequest[2].Steel,"menos")
										exports.an_inventory:sattitem(ply,"Copper",repairrequest[2].Copper,"menos")
										setPedAnimation(ply,"COP_AMBIENT", "Copbrowse_loop",-1,true,false,false,false)
										exports.an_infobox:addNotification(ply,"Fazendo reparos no <b>motor</b> do veiculo.","info")
										setTimer(function()
											fixVehicle(vehicl)
											setVehicleDoorOpenRatio(vehicl, 0, 1, 50)
											setVehicleDoorOpenRatio(vehicl, 1, 0, 50)
											setVehicleDoorOpenRatio(vehicl, 2, 0, 50)
											setVehicleDoorOpenRatio(vehicl, 3, 0, 50)
											setVehicleDoorOpenRatio(vehicl, 4, 0, 50)
											setVehicleDoorOpenRatio(vehicl, 5, 0, 50)
											setVehicleDamageProof(vehicl, false)
											exports.an_vehicles:saveVehicle(vehicl)
											setPedAnimation(ply,nil)
											exports.an_infobox:addNotification(ply,"<b>Veiculo</b> reparado com sucesso!","sucesso")
										end,1000*65,1)
									else
										exports.an_infobox:addNotification(ply,"Você precisa ter <br><br>".. repairrequest[2].Plastic.."x <b>Plastico</b><br>".. repairrequest[2].Steel.."x <b>Aço</b><br>".. repairrequest[2].Copper.."x <b>Cobre</b><br><br>para reparar o veículo.","aviso")
									end
								else
									exports.an_infobox:addNotification(ply,"Abra o <b>capô</b> do <b>veiculo</b>.","aviso")
								end
							else
								exports.an_infobox:addNotification(ply,"Veículo muito danificado! leve o mesmo para <b>oficina</b>.","aviso")
							end
						end
				end
		end
	end
end
)
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
addCommandHandler("tow",
function(ply,cmd)
	if exports.an_account:hasPermission( ply, 'mechanic.permission') or exports.an_account:hasPermission( ply, 'police.permission') then
		local vehicl = getproxveh(ply,9)
		local vehic2 = getproxvehmechanic(ply,9)
		if not isPedInVehicle(ply) then
			if vehic2 then
				if not getElementData(vehic2,"towlevandocar") then
					if vehicl then
						for _,pv in pairs(getElementsByType("player")) do
							for _, player6 in pairs(getVehicleOccupants(vehicl,pv)) do
								removePedFromVehicle (player6)
							end
						end
						attachElements(vehicl, vehic2, 0, -2.5, 1.2)
						setElementData(vehic2,"towlevandocar",vehicl)
						exports.an_infobox:addNotification(ply,"<b>Veiculo</b> guinchado.","info")
					else
						exports.an_infobox:addNotification(ply,"Você está muito distante do <b>veiculo</b>.","aviso")
					end
				else
					local gettowerdcar = getElementData(vehic2,"towlevandocar")
					if gettowerdcar then
						for _,pv in pairs(getElementsByType("player")) do
							for _, player6 in pairs(getVehicleOccupants(vehicl,pv)) do
								removePedFromVehicle (player6)
							end
						end
						attachElements(gettowerdcar, vehic2, 0, -10, 1.2)
						attachElements(gettowerdcar, vehic2, 0, -10, 0)
						detachElements(gettowerdcar)
						exports.an_vehicles:saveVehicle(gettowerdcar)
						setElementData(vehic2,"towlevandocar",nil)
						exports.an_infobox:addNotification(ply,"<b>Veiculo</b> removido do <b>guincho</b>.","info")
					end
				end
			else
				exports.an_infobox:addNotification(ply,"Você está muito distante do <b>guincho</b>.","aviso")
			end
		end
	end
end
)

local userobject = {}
local usertimer = {}
addCommandHandler("color",
function(ply,cmd,r,g,b,r2,g2,b2)
	if exports.an_account:hasPermission( ply, 'mechanic.permission') then
		local proxy = getproxystuffa(ply,5)
		if proxy then
			local vehicl = exports.an_player:getproxveh(ply,3)
			if vehicl then
				if not isTimer(usertimer[ply]) then
					local plyx, plyy, plyz = getElementPosition(ply)
					if not r2 then
						setElementData(ply,"emacao",true)
						setPedAnimation( ply,"spraycan", "spraycan_full",-1,true,false,false,false)
						userobject[ply] = createObject(365, plyx, plyy, plyz)
						setElementCollisionsEnabled(userobject[ply], false)
						exports.bone_attach:attachElementToBone(userobject[ply],ply, 12, -0.01,-0.01,0.15,260,-50,50)
						usertimer[ply] = setTimer(function()
							destroyAttachetobj(ply)
							setPedAnimation( ply, nil)
							setElementData(ply,"emacao",false)
							setVehicleColor( vehicl, tonumber(r), tonumber(g), tonumber(b))
							exports.an_infobox:addNotification(ply,"<b>Veículo</b> pintado com sucesso!","sucesso")
							exports.an_vehicles:saveVehicle(vehicl)
						end,1000*30,1)
					elseif r2 then
						setElementData(ply,"emacao",true)
						setPedAnimation( ply,"spraycan", "spraycan_full",-1,true,false,false,false)
						userobject[ply] = createObject(365, plyx, plyy, plyz)
						setElementCollisionsEnabled(userobject[ply], false)
						exports.bone_attach:attachElementToBone(userobject[ply],ply, 12, 0.04,0.12,0.07,160,30,-130)
						usertimer[ply] = setTimer(function()
							destroyAttachetobj(ply)
							setPedAnimation( ply, nil)
							setElementData(ply,"emacao",false)
							setVehicleColor( vehicl, tonumber(r), tonumber(g), tonumber(b), tonumber(r2), tonumber(g2), tonumber(b2))
							exports.an_infobox:addNotification(ply,"<b>Veículo</b> pintado com sucesso!","sucesso")
							exports.an_vehicles:saveVehicle(vehicl)
						end,1000*30,1)
					end
				else
					exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
				end
			else
				exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
			end
		else
			exports.an_infobox:addNotification(ply,"Você precisa estar na <b>oficina</b>.","aviso")
		end
	end
end
)
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
function destroyAttachetobj(ply)
    if isElement(userobject[ply]) then
        exports.bone_attach:detachElementFromBone(userobject[ply])
        destroyElement(userobject[ply])
        userobject[ply] = nil
    end
end

function destroyOnQuit()
    if isElement(userobject[source]) then
        exports.bone_attach:detachElementFromBone(userobject[source])
        destroyElement(userobject[source])
        userobject[source] = nil
    end
end
addEventHandler ("onPlayerQuit", root, destroyOnQuit)

function getproxymechanic(ply,distance)
	local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
	for i, v in ipairs (cfg.mechanic) do 
		local sid, sx, sy, sz = unpack(v)
		if getDistanceBetweenPoints3D (x, y, z, sx, sy, sz) < dist then
			dist = getDistanceBetweenPoints3D (x, y, z, sx, sy, sz)
			id = sid
        end
    end
    if id then
        return id
    else
        return false
    end
end

function getproxystuffa(ply,distance)
	local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
	for i, v in ipairs (cfg.estufa) do 
		local sid, sx, sy, sz = unpack(v)
		if getDistanceBetweenPoints3D (x, y, z, sx, sy, sz) < dist then
			dist = getDistanceBetweenPoints3D (x, y, z, sx, sy, sz)
			id = sid
        end
    end
    if id then
        return id
    else
        return false
    end
end

--- get next vehicle
function getproxvehmechanic(ply,distance)
	local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
		if ply ~= v then
			if getElementModel(v) == 578 then
				local pX, pY, pZ = getElementPosition (v) 
				if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
					dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
					id = v
				end
			end
        end
    end
    if id then
        return id
    else
        return false
    end
end
--- get next vehicle 2
function getproxveh(ply,distance)
	local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
		if ply ~= v then
			if getElementModel(v) ~= 578 then
				local pX, pY, pZ = getElementPosition (v) 
				if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
					dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
					id = v
				end
			end
        end
    end
    if id then
        return id
    else
        return false
    end
end

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------