----------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
----------------------------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local localscfg = cfg.locals

function getFreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_arrestedvehs ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
----------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
----------------------------------------------------------------------------------------------------------------------------------
addCommandHandler("arrestveh",
function(ply,cmd,value)
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        local plyid = getElementData (ply, 'id')
        if plyid then
            local tagertveh = exports.an_player:getproxveh(ply, 5)
            local targetpatio = getproxyonply(ply, 5)
            if tagertveh and targetpatio then
                if value and value ~= nil then
                    local model = getElementData ( tagertveh, "Model" )
                    local data = exports.an_vehicles:getVehicleData(model)
                    if data then
                        local rid = getFreeid()
                        if getElementData(tagertveh, "owner") ~= plyid then
                            exports.an_inventory:sattitem(ply, "Money", 1000,"mais")
                        end
                        setElementData(tagertveh, "Arrested", true)
                        dbExec(connection, "INSERT INTO an_arrestedvehs SET id = ?,Owner = ?,Vehid = ?,Value = ?",rid,getElementData (tagertveh,"owner"),getElementData (tagertveh, "id" ),value)
                        exports.an_vehicles:saveVehicle (tagertveh)
                        exports.an_infobox:addNotification(ply,"Veículo apreendido com sucesso! valor da multa: $ <b>"..value.."</b>","aviso")
                        triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** apreendeu o veículo **"..data.name.."** do **"..getElementData ( tagertveh, "owner" ).." - "..getElementData ( tagertveh, "Nome" ).." "..getElementData ( tagertveh, "Snome" ).."** valor da multa: $**"..value.."**")
                        triggerEvent("sendnorthamericaloganpd", ply, ply,"O veículo **"..data.name.."** do **"..getElementData ( tagertveh, "Nome" ).." "..getElementData ( tagertveh, "Snome" ).."** foi apreendido, valor da multa: $**"..value.."**")
                        destroyElement(tagertveh)
                    end
                end
            end
        end
    end
end
)

function requestMulta(ply)
    local plyid = getElementData(ply,'id')
    if plyid then
        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_arrestedvehs WHERE Owner = ?", plyid), -1)
        if type(result) == "table" then
            setElementData(ply, "arrestedvehprices", result)
        end
    end
end
addEvent ("requestMulta", true)
addEventHandler ("requestMulta", root, requestMulta)

function arrestcarspegandpay(ply, vehid, vehame, value, vehpos)
    print("*.")
    local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", vehid), -1)[1]
    if data then
        print("*.")
        local plyid = getElementData(ply,'id')
        if plyid then
            local veh = findVeh(vehid)
            if not isElement(veh) then
                print("*")
                local vehproxy = getproxveh(ply,vehpos)
                if not vehproxy then
                    exports.an_inventory:sattitem(ply, "Money", value,"menos")
                    exports.an_infobox:addNotification(ply,"Você tirou o veiculo <b>"..vehame.."</b> do pátio","info") 
                    triggerClientEvent( ply, "closearrestcars", ply)
                    dbExec(connection, "UPDATE an_vehicle SET Arrested = ? WHERE id = ?", 0, vehid)
                    dbExec(connection, "DELETE FROM an_arrestedvehs WHERE Vehid = ? AND Owner = ?", vehid, plyid)
                    triggerEvent ("Createcarandload", ply, ply, vehid, vehpos)
                else
                    exports.an_infobox:addNotification(ply,"Há um <b>veiculo</b> perto da vaga","aviso") 
                end
            end
        end
    end
end
addEvent ("arrestcarspegandpay", true)
addEventHandler ("arrestcarspegandpay", root, arrestcarspegandpay)
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local ped = {}
function createmksshops()
    for i,v in ipairs (cfg.locals) do
        local id, x, y, z, rx, ry, rz = unpack(v)
        ped[id] = createPed(71, x, y, z)
        setElementRotation(ped[id], rx , ry, rz)
        setElementFrozen(ped[id],true)
		setElementData(ped[id],"npc",true)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksshops)


function findVeh(id)
	local vehicles = getElementsByType("vehicle")
	for k,v in pairs(vehicles) do
		if getElementData(v,"id") == id then
			return v
		end
	end
	return false
end

function getproxveh(ply,cord)
	local poss = fromJSON(cord)
	local dist = 6
	local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
        if ply ~= v then
            local pX, pY, pZ = getElementPosition (v) 
            if getDistanceBetweenPoints3D (poss[1],poss[2],poss[3], pX, pY, pZ) < dist then
                dist = getDistanceBetweenPoints3D (poss[1],poss[2],poss[3], pX, pY, pZ)
                id = v
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end

function getproxyonply(ply, distance)
    local pX, pY, pZ = getElementPosition (ply) 
	local dist = distance
	local id = false
    for i, v in ipairs (localscfg) do 
        local bid, x, y, z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z ) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z )
            id = bid
        end
    end
    if id then
        return id
    else
        return false
    end
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------