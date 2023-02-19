----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local desmanche = {}
local desmanchecol = {}
function createmksdesmanche()
    for i,v in ipairs (cfg.dsmchelocal) do
        local id,x,y,z = unpack(v)
        desmanche = createMarker(x,y,z -3.5, "cylinder", 3, 255, 77, 77, 50)
        desmanchecol[v] = createColSphere(x,y,z-0.5,2)
		setElementData(desmanchecol[v],"iddesmanche",id)
        setElementData(desmanchecol[v],"coldesmanche",desmanchecol[v])
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksdesmanche)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function stopDmc(ply,veh)
    if veh then
        local getvehdata = getDMCVehicleData(getElementModel(veh))
        if getvehdata then
            if getElementData(veh,"mala") then
                local vehpricedmc = math.percent(10,getvehdata[3])
                local vehtaxarray = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id=?", getElementData(veh,"id")), -1)
                for k,v in pairs(vehtaxarray) do
                    ownerveh = v["Account"]
                    if ownerveh then
                        local plyow = getPlayerID(tonumber(ownerveh))
                        if plyow then
                            exports.an_vehicles:updatevehicle(plyow)
                            print("desmanchado o veiculo do "..getElementData(plyow,"Nome").." "..getElementData(plyow,"SNome").."")
                        end
                    end
                end
                dbExec(connection, "DELETE FROM an_vehicle WHERE id = ?", getElementData(veh,"id"))
                destroyElement(veh)
                exports.an_inventory:sattitem(ply,"DirtyMoney",math.round(vehpricedmc),"mais")
                exports.an_infobox:addNotification(ply,"<b>Veiculo</b> desmanchado com sucesso!","sucesso")
            else
                exports.an_infobox:addNotification(ply,"Não e possivel desmanchar veiculos <b>alugados</b>","erro")
            end
        else
            exports.an_infobox:addNotification(ply,"Este <b>veiculo</b> não pode ser desmanchado, pois tem um sistema de proteção <b>avançada</b>","erro")
        end
    end
end
addEvent ("stopDmc", true)
addEventHandler ("stopDmc", root, stopDmc)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "id") == id then
			v = player
			break
		end
	end
	return v
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------