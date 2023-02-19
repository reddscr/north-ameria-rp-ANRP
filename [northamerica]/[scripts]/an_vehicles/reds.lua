----------------------------------------------------------------------------------------------------------------
-- CONNECT
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
local itemtb = exports.an_account:servergetitemtable3()
----------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
----------------------------------------------------------------------------------------------------------------
local centralconcemk = {}
local centralconceped = {}
local colconce = {}
local centralgaragemk = {}

local numberSymbols =
{
	'A',
	'B',
	'C',
	'Y',
	'O',
	'P',
	'T',
	'E',
	'X',
	'M',
	'H',
	'K'
}

function getPlayervehicleCount(ply)
	local plyid = getElementData(ply,"id")
	local result = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE Account = ?", plyid), -1)
	if result and type(result) == "table" then
		return #result
	end
end


function getPlayervehiclesinsv(vehid)
	local result = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE Model = ?", vehid), -1)
	if result and type(result) == "table" then
		return #result
	end
end

function getFreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_vehicle ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
function getFreeid2(ply)
	local plyid = getElementData(ply,"id")
	local result = dbPoll(dbQuery(connection, "SELECT veicid FROM an_vehicle WHERE Account = ?",plyid), -1)
	newid = false
	for i, id in pairs (result) do
		if id["veicid"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end


function getplyvehslots(ply)
	local plyid = getElementData(ply,"id")
	local result = dbPoll(dbQuery(connection, "SELECT house_vehslot FROM an_houses WHERE id_owner = ?",plyid), -1)
	hvehslot = false
	for k,v in ipairs(result) do
		homevehslot = v["house_vehslot"]
		if homevehslot ~= nil then
			hvehslot = tonumber(homevehslot)
		end
	end
	if hvehslot then 
		return hvehslot + 1  
	else 
		return 2 
	end
end

function getdealershipvehicles(ply)
    if ply then
        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle"), -1)
        if type(result) == "table" then
            setElementData(ply,"dealershipvehicles",result)
        end
    end
end
addEvent ("getdealershipvehicles", true)
addEventHandler ("getdealershipvehicles", root, getdealershipvehicles)

function getplyvehicles(ply)
    if ply then
        local plyid = getElementData(ply, 'id')
        if plyid then
            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE Account = ?", plyid), -1)
            if type(result) == "table" then
                setElementData(ply,"playervehicles",result)
            end
        end
    end
end
addEvent ("getplyvehicles", true)
addEventHandler ("getplyvehicles", root, getplyvehicles)

function updatevehicle(ply)
    if ply then
        local plyid = getElementData(ply, 'id')
        if plyid then
            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE Account = ?", plyid), -1)
            if type(result) == "table" then
                setElementData(ply,"playervehicles",result)
            end
        end
    end
end
addEvent ("updatevehicle", true)
addEventHandler ("updatevehicle", root, updatevehicle)

function saveVehicleUpgrades(veh)
	local id = getElementData(veh,"id")
    local upgrade = ""
    for _, upgradee in ipairs (getVehicleUpgrades(veh)) do
        if upgrade == "" then
            upgrade = upgradee
        else
            upgrade = upgrade..","..upgradee
        end
    end
    setElementData(veh, 'upgrades', getVehicleUpgrades(veh))
    dbExec(connection, "UPDATE an_vehicle SET Upgrades = ? WHERE id = ?", upgrade, id)
end
addEvent("saveVehicleUpgrades",true)
addEventHandler("saveVehicleUpgrades",root,saveVehicleUpgrades)

addCommandHandler("supgrade",
function(ply,cmd)
if not (getElementData(ply, "Admin", true)) then return end
    local vehicl = exports.an_player:getproxveh(ply,15)
    if vehicl then
        exports.an_vehicles:saveVehicleUpgrades(vehicl)
    end
end
)

function saveVehicle(veh)
	local id = getElementData(veh,"id")
	local owner = getElementData(veh,"owner")
	local nome = getElementData(veh,"Nome")
	local snome = getElementData(veh,"Snome")
	local x,y,z = getElementPosition(veh)
	local _,_,rz = getElementRotation(veh)
	local c1,c2,c3,r1,r2,r3 = getVehicleColor(veh,true)
	local color = toJSON({c1,c2,c3,r1,r2,r3})
	local cl1,cl2,cl3 = getVehicleHeadLightColor(veh)
    local colorligt = toJSON({cl1,cl2,cl3})
    local upgrade = ""
    if getElementData(veh, 'upgrades') then
        for _, upgradee in ipairs (getElementData(veh, 'upgrades')) do
            if upgrade == "" then
				upgrade = upgradee
			else
				upgrade = upgrade..","..upgradee
			end
        end
    end
	local hp = getElementHealth(veh)
	local handlings = toJSON(getVehicleHandling( veh ))
	local fuel = getElementData(veh,"fuel")
	local int = getElementInterior(veh)
	local dim = getElementInterior(veh)
	local number = getElementData(veh,"number:plate")
	local toner = toJSON(getElementData(veh,"toner")) or false
	local Variant = getElementData(veh,"Variant")
	local Mala = getElementData(veh,"mala") or 0
	local tpaintjob = getElementData(veh,"PaintJob") or 0
	local Malaslots = getElementData(veh,"usedslots") or 0
	local nitrous = getElementData(veh,"Nitrous") or 0
	arrestedv = 0
	if getElementData(veh,"Arrested") then
		arrestedv = 1
	end
	dbExec(connection, "UPDATE an_vehicle SET X = ?, Y = ?, Z = ?, RotZ = ?, interior = ?, dimension = ?, Colors = ?,lightColor = ?, Upgrades = ?, Paintjob = ?, HP = ?,Mala = ?, Handlings = ?, Fuel = ?, Number = ?, Toner = ?, Variant = ?,usedslots = ?,Nome = ?,Snome = ?,Nitrous = ?,Arrested=? WHERE id = ?",x,y,z,rz,int,dim,color,colorligt,upgrade,tpaintjob,hp,Mala,handlings,fuel,number,toner,Variant,Malaslots,nome,snome,nitrous,arrestedv,id)
end
addEvent("saveVehicle",true)
addEventHandler("saveVehicle",root,saveVehicle)
----------------------------------------------------------------------------------------------------------------
-- buy to dealership
----------------------------------------------------------------------------------------------------------------
function buyvehicleondealership(ply,vdata)
    if ply then
        local plyid = getElementData(ply, 'id')
        if plyid then
            local id = getFreeid()
            local veicid = getFreeid2(ply) 
            local plyid = getElementData( ply, 'id')
            local data = getVehicleData(vdata)
            local nome = getElementData(ply,"Nome")
            local snome = getElementData(ply,"SNome")
            if data then
                local plyvehqtd = getPlayervehicleCount(ply)
                local plyhouseslot = getplyvehslots(ply) 
                local vehiclestock = getPlayervehiclesinsv(data.id)
                if tonumber(vehiclestock) < tonumber(data.stock) then
                    if plyhouseslot then
                        if tonumber(plyvehqtd) < plyhouseslot then
                            if getElementData(ply, 'Money') >= tonumber(data.value) then
                                exports.an_inventory:sattitem(ply,"Money",tonumber(data.value),"menos")
                                if data.id == '522' or data.id == '521' or data.id == '461' or data.id == '586' or data.id == '468' or data.id == '462' or data.id == '463' or data.id == '581' then
                                    local s1 = numberSymbols[math.random(1,#numberSymbols)]
                                    local s2 = numberSymbols[math.random(1,#numberSymbols)]
                                    local num = math.random(1000,9999)
                                    local words = math.random(1,1)
                                    if words == 1 then
                                        region = "1"
                                    end
                                    placa = "NA "..num..""..s2..""..region..""
                                else
                                    local s1 = numberSymbols[math.random(1,#numberSymbols)]
                                    local s2 = numberSymbols[math.random(1,#numberSymbols)]
                                    local s3 = numberSymbols[math.random(1,#numberSymbols)]
                                    local num = math.random(100,999)
                                    local words = math.random(1,1)
                                    if words == 1 then
                                        region = "1"
                                    end
                                    placa = "NA "..num..""..s2..""..s3..""..region..""
                                end
                                local rgb1 = (math.random(0,255))
                                local rgb2 = (math.random(0,255))
                                local rgb3 = (math.random(0,255))
                                local color = toJSON({rgb1,rgb2,rgb3,rgb1,rgb2,rgb3})
                                dbExec(connection, "INSERT INTO an_vehicle SET id = ?,veicid = ?,Account = ?,Model = ?,X = ?,Y = ?,Z = ?,RotZ = ?,Colors = ?,lightColor = ?,Upgrades = ?,Paintjob = ?,HP = ?,Mala = ?,Fuel = ?,Number = ?,Toner = ?,Variant = ?,usedslots = ?,Nome = ?,Snome = ?", id,veicid, plyid, data.id,0,0,0,0,color,"","",0,1000,data.trunk,100,placa,"",255,0,nome,snome)
                                getplyvehicles(ply)
                                exports.an_infobox:addNotification(ply,"Você comprou o veículo: <b>"..data.name.."</b><br> e ja pode tirar o mesmo em uma garagem.","info", 20000)
                            else
                                exports.an_infobox:addNotification(ply,"Você não tem $ <b>"..data.value.."</b> em mãos.","erro") 
                            end
                        else
                            if plyhouseslot <= 2 then
                                exports.an_infobox:addNotification(ply,"Você não possui <b>casa</b> para comprar mais de dois <b>veiculo</b>.","erro")
                            elseif plyhouseslot >= 3 then
                                exports.an_infobox:addNotification(ply,"Você não possui <b>vagas</b> na <b>garagem</b> para comprar mais <b>veiculos</b>.","erro")
                            end 
                        end
                    end
                else
                    exports.an_infobox:addNotification(ply,"Não tem este <b>veiculo</b> no estoque!","aviso") 
                end
            end
        end
    end
end
addEvent ("buyvehicleondealership", true)
addEventHandler ("buyvehicleondealership", root, buyvehicleondealership)

addCommandHandler("createcar",
function(theply,cmd,plyid,vdata)
if not (getElementData(theply, "Admin", true)) then return end
	if plyid then
		local ply = getPlayerID(tonumber(plyid))
        if ply then
            local id = getFreeid()
            local veicid = getFreeid2(ply) 
            local plyid = getElementData( ply, 'id')
            local data = getVehicleData(vdata)
            local nome = getElementData(ply,"Nome")
            local snome = getElementData(ply,"SNome")
            if data then
                if data.id == '522' or data.id == '521' or data.id == '461' or data.id == '586' or data.id == '468' or data.id == '462' or data.id == '463' or data.id == '581' then
                    local s1 = numberSymbols[math.random(1,#numberSymbols)]
                    local s2 = numberSymbols[math.random(1,#numberSymbols)]
                    local num = math.random(1000,9999)
                    local words = math.random(1,1)
                    if words == 1 then
                        region = "1"
                    end
                    placa = "NA "..num..""..s2..""..region..""
                else
                    local s1 = numberSymbols[math.random(1,#numberSymbols)]
                    local s2 = numberSymbols[math.random(1,#numberSymbols)]
                    local s3 = numberSymbols[math.random(1,#numberSymbols)]
                    local num = math.random(100,999)
                    local words = math.random(1,1)
                    if words == 1 then
                        region = "1"
                    end
                    placa = "NA "..num..""..s2..""..s3..""..region..""
                end
                local rgb1 = (math.random(0,255))
                local rgb2 = (math.random(0,255))
                local rgb3 = (math.random(0,255))
                local color = toJSON({rgb1,rgb2,rgb3,rgb1,rgb2,rgb3})
                dbExec(connection, "INSERT INTO an_vehicle SET id = ?,veicid = ?,Account = ?,Model = ?,X = ?,Y = ?,Z = ?,RotZ = ?,Colors = ?,lightColor = ?,Upgrades = ?,Paintjob = ?,HP = ?,Mala = ?,Fuel = ?,Number = ?,Toner = ?,Variant = ?,usedslots = ?,Nome = ?,Snome = ?", id,veicid, plyid, data.id,0,0,0,0,color,"","",0,1000,data.trunk,100,placa,"",255,0,nome,snome)
                getplyvehicles(ply)
                exports.an_infobox:addNotification(ply,"Você recebeu o veículo: <b>"..data.name.."</b><br> e ja pode tirar o mesmo em uma garagem.","info", 20000)
                exports.an_infobox:addNotification(theply,"Veiculo <b>"..data.name.."</b> criado.","info")
            end
		else
			exports.an_infobox:addNotification(theply,"<b>Player</b> não encontrado.","aviso")
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- Sell to dealership
----------------------------------------------------------------------------------------------------------------
function sellvehindealership(ply,vdata)
    if vdata then
        local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", vdata), -1)[1]
        if data then
            local veh = findVeh(vdata)
            if isElement(veh) then
                local x, y, z = getElementPosition (ply) 
                local pX, pY, pZ = getElementPosition (veh) 
                if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < 50 then
                    local thevehdata = getVehicleData(getElementModel(veh))
                    destroyElement(veh)
                    if thevehdata then
                        local value = math.percent(80,thevehdata.value)
                        dbExec(connection, "DELETE FROM an_vehicle WHERE id = ?", vdata)
                        exports.an_inventory:destroyVehicleData(vdata)
                        exports.an_inventory:sattitem(ply,"Money",math.round(value),"mais")
                        getplyvehicles(ply)
                        exports.an_infobox:addNotification(ply,"Você vendeu o veículo por $ <b>"..math.round(value).."</b>!","sucesso",1000)
                    end
                else
                    exports.an_infobox:addNotification(ply,"Veículo muito <b>distante</b>","erro",500)
                end
            else
                local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", vdata), -1)[1]
                if data then
                    if data['Arrested'] <= 0 then 
                        local thevehdata = getVehicleData(data['Model'])
                        if thevehdata then
                            local value = math.percent(80,thevehdata.value)
                            dbExec(connection, "DELETE FROM an_vehicle WHERE id = ?", vdata)
                            exports.an_inventory:destroyVehicleData(vdata)
                            exports.an_inventory:sattitem(ply,"Money",math.round(value),"mais")
                            getplyvehicles(ply)
                            exports.an_infobox:addNotification(ply,"Você vendeu o veículo por $ <b>"..math.round(value).."</b>!","sucesso",1000)
                        end
                    else
                        exports.an_infobox:addNotification(ply,"Este veículo está <b>apreendido</b>","erro",500)
                    end
                end
            end
            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_arrestedvehs WHERE Vehid = ?", vdata), -1)
            if result then
                dbExec(connection, "DELETE FROM an_arrestedvehs WHERE Vehid = ?", vdata)
            end
        end
    end
end
addEvent ("sellvehindealership", true)
addEventHandler ("sellvehindealership", root, sellvehindealership)
----------------------------------------------------------------------------------------------------------------
-- Gerenciamento
----------------------------------------------------------------------------------------------------------------
addCommandHandler("vehs",
function(ply,cmd)
    updatevehicle(ply)
    triggerClientEvent (ply, "openvehgerenciament", ply,ply)
end)
----------------------------------------------------------------------------------------------------------------
-- Sell to ply
----------------------------------------------------------------------------------------------------------------
function aceptvehicleonsell(plyacept,ply,vehid,vehprice)
	if isElement(plyacept) then
	    local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", vehid), -1)[1]
		if data then
            local plyid1 = getElementData(ply,"id")
            local plyid2 = getElementData(plyacept,"id")
            local plyquantidadeveh = getPlayervehicleCount(plyacept)
            local plyhousevehslot = getplyvehslots(plyacept) 
            local veh = findVeh(vehid)
            if isElement(veh) then
                local x, y, z = getElementPosition (ply) 
                local pX, pY, pZ = getElementPosition (veh) 
                if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < 50 then
                    if tonumber(plyquantidadeveh) < plyhousevehslot then
                        if data["Account"] == plyid1 then
                            local plyname = getElementData(plyacept,"Nome")
                            local plysname = getElementData(plyacept,"SNome")
                            dbExec(connection, "UPDATE an_vehicle SET Account = ?, Nome = ?, Snome = ? WHERE id = ?",plyid2,plyname,plysname, vehid)
                            exports.an_inventory:sattitem(plyacept,"Money",vehprice,"menos")
                            exports.an_inventory:sattitem(ply,"Money",vehprice,"mais")
                            exports.an_infobox:addNotification(ply,"<b>Veiculo</b> vendido com sucesso!","sucesso")
                            exports.an_infobox:addNotification(plyacept,"<b>Veiculo</b> comprado com sucesso!","sucesso")
                            setElementData(veh,"owner",plyid2)
							setElementData(veh,"Nome",plyname)
							setElementData(veh,"Snome",plysname)
                            getplyvehicles(ply)
                            getplyvehicles(plyacept)
                        end
                    else
                        if plyhousevehslot <= 1 then
                            exports.an_infobox:addNotification(plyacept,"Você não possui <b>casa</b> para comprar mais de um <b>veiculo</b>.","erro")
                        elseif plyhousevehslot >= 2 then
                            exports.an_infobox:addNotification(plyacept,"Você não possui <b>vagas</b> na <b>garagem</b> para comprar mais <b>veículos</b>.","erro")
                        end 
                    end
                else
                    exports.an_infobox:addNotification(ply,"Veículo muito <b>distante</b>","erro",500)
                end
            else
                exports.an_infobox:addNotification(ply,"Tire o veículo da <b>garagem</b>","erro",500)
            end
        end
	end
end
addEvent("aceptvehicleonsell",true)
addEventHandler("aceptvehicleonsell",root,aceptvehicleonsell)

function sellvehicle(ply,vehid,vehname,price)
    local tagertply = exports.an_player:getproxply(ply,1.5) 
    if tagertply then
        if vehid then
            if vehname then
                if price then
                    local veh = findVeh(vehid)
                    if isElement(veh) then
                    
                        local vehdata = getVehicleData(getElementModel(veh))
                        if vehdata then
                            if getElementData(tagertply, "Money") >= price then
                                if vehdata.donate == "nodonate" then 
                                    triggerClientEvent( tagertply, "startsellvehicle", tagertply, ply, vehid,price)
                                    exports.an_infobox:addNotification(ply,"<b>Aguarde</b> a confirmação.","aviso")
                                else
                                    exports.an_infobox:addNotification(ply,"<b>Veículos</b> de doações não podem ser vendidos.","erro")
                                end
                            else
                                exports.an_infobox:addNotification(ply,"A pessoa não tem <b>dinheiro</b> suficiente para comprar.","erro")
                            end
                        end

                    else
                        exports.an_infobox:addNotification(ply,"Tire o veículo da <b>garagem</b>","erro",500)
                    end
                end
            end
        end
    else
        exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
    end
end
addEvent("sellvehicle",true)
addEventHandler("sellvehicle",root,sellvehicle)
----------------------------------------------------------------------------------------------------------------
--SCRIPT
----------------------------------------------------------------------------------------------------------------
function bildconcecol ()
	local x,y,z,rx,ry,rz= unpack(cfg.locationcoll[1])
	colconce = createColCuboid(x,y,z-1,rx,ry,rz)
	setElementData(colconce,"concecol",colconce)
	for i,v in ipairs (cfg.localshop) do
        local id,x,y,z,px,py,pz,prz = unpack(v)
        centralconcemk[id] = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
        centralconceped[id] = createPed(302,px,py,pz)
        setElementRotation(centralconceped[id],0,0,prz)
        setElementFrozen(centralconceped[id],true)
        setElementData(centralconceped[id],"npc",true)
        setTimer(function()
            setPedAnimation(centralconceped[id], "misc", "seat_talk_01", -1, true, false, false )
        end,1000,1)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), bildconcecol)
----------------------------------------------------------------------------------------------------------------
-- LOAD VEHICLE
----------------------------------------------------------------------------------------------------------------
function Createcarandload(ply, vehid, pos)
    local poss = fromJSON(pos)
    if poss then
        local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", vehid), -1)[1]
        if data then
            id = data["id"]
            veicid = data["veicid"]
            model = data["Model"]
            acc =  data["Account"]
            nome = data["Nome"]
            snome = data["Snome"]
            x = data["X"]
            y = data["Y"]
            z = data["Z"]
            rotz = data["RotZ"]
            int = data["interior"]
            dim = data["dimension"]
            color = fromJSON(data["Colors"])
            lightColor = fromJSON(data["lightColor"])
            upg = split(tostring(data["Upgrades"]), ',')
            paintjob = data["Paintjob"]
            hp = data["HP"]
            dtmala = data["Mala"]
            hand = data["Handlings"]
            Fuel = data["Fuel"]
            number = data["Number"]
            Toner = data["Toner"]
            Variant = data["Variant"]
            garageid = data["garageid"]
            malaslots = data["usedslots"]
            vehstatus = data["vehtaxstatus"]
            nitrous = data["Nitrous"]
            arrest = data["Arrested"]
            veh = createVehicle(model, poss[1], poss[2], poss[3], 0, 0, poss[4])
            if veh then
                setElementPosition(veh, poss[1], poss[2], poss[3])
                setElementRotation(veh, 0, 0, poss[4])
                setElementInterior(veh, 0) 
                setElementDimension(veh, 0) 
                setVehicleColor(veh,color[1],color[2],color[3], color[4], color[5], color[6])
                if lightColor then 
                    setVehicleHeadLightColor(veh, lightColor[1], lightColor[2], lightColor[3])
                end
                if hp <= 0 then
                    fixVehicle(veh)
                else
                    setElementHealth(veh,hp)
                end
                setVehicleLocked(veh, true)
                setElementData(veh,"vehlocked",true)
                if vehstatus ~= "Pendente" then
                    setElementData(veh,"vehtaxstatus","Pago")
                else
                    setElementData(veh,"vehtaxstatus","Pendente")
                end
                setElementData(veh,"id",id)
                setElementData(veh,"veicid",veicid)
                setElementData(veh,"thegaragevheid",garageid)
                setElementData(veh,"Model",model)
                setElementData(veh,"owner",acc)
                setElementData(veh,"Nome",nome)
                setElementData(veh,"Snome",snome)
                setElementData(veh,"fuel",Fuel)
                setElementData(veh,"mala",dtmala)
                setElementData(veh,"usedslots",malaslots)
                setVehicleOverrideLights ( veh, 1 )
                setElementData(veh,"PaintJob", paintjob)
                setElementData(veh,"Nitrous", nitrous)
                if arrest >= 1 then
                    setElementData(veh ,"Arrested", true)
                end
                if number then
                    setElementData(veh,"number:plate",number)
                end
                if Variant then
                    setVehicleVariant(veh, Variant, Variant)
                    setElementData(veh, "Variant", Variant)
                end
                for i, upgrade in ipairs(upg) do
                    addVehicleUpgrade(veh, upgrade)
                end
                exports.an_inventory:loadvehicletrunk(veh)
                exports.an_vehicles:saveVehicle (veh)
            end
        end
    end
end
addEvent("Createcarandload",true)
addEventHandler("Createcarandload",root,Createcarandload)

function retirarvehicle(ply,id,vehname,plygarageid,vehpos)
    local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", id), -1)[1]
    if data then
        if plygarageid then
            local veh = findVeh(id)
            if not isElement(veh) then
                local vehproxy = getproxveh(ply,vehpos)
                if not vehproxy then
                    id = data["id"]
                    veicid = data["veicid"]
                    model = data["Model"]
                    acc =  data["Account"]
                    nome = data["Nome"]
                    snome = data["Snome"]
                    x = data["X"]
                    y = data["Y"]
                    z = data["Z"]
                    rotz = data["RotZ"]
                    color = fromJSON(data["Colors"])
                    lightColor = fromJSON(data["lightColor"])
                    upg = split(tostring(data["Upgrades"]), ',')
                    paintjob = data["Paintjob"]
                    hp = data["HP"]
                    dtmala = data["Mala"]
                    hand = data["Handlings"]
                    Fuel = data["Fuel"]
                    number = data["Number"]
                    Toner = data["Toner"]
                    Variant = data["Variant"]
                    malaslots = data["usedslots"]
                    vehstatus = data["vehtaxstatus"]
                    nitrous = data["Nitrous"]
                    arrest = data["Arrested"]
                    local poss = fromJSON(vehpos)
                    veh = createVehicle(model, poss[1], poss[2], poss[3], 0, 0, poss[4])
                    if veh then
                        setElementPosition(veh, poss[1], poss[2], poss[3])
                        setElementRotation(veh, 0, 0, poss[4])
                        setElementInterior(veh, 0) 
                        setElementDimension(veh, 0) 
                        setVehicleColor(veh,color[1],color[2],color[3], color[4], color[5], color[6])
                        if lightColor then 
                            setVehicleHeadLightColor(veh, lightColor[1], lightColor[2], lightColor[3])
                        end
                        if hp <= 0 then
                            fixVehicle(veh)
                        else
                            setElementHealth(veh,hp)
                        end
                        setVehicleLocked(veh, true)
                        setElementData(veh,"vehlocked",true)
                        if vehstatus ~= "Pendente" then
                            setElementData(veh,"vehtaxstatus","Pago")
                        else
                            setElementData(veh,"vehtaxstatus","Pendente")
                        end
                        setElementData(veh,"id",id)
                        setElementData(veh,"veicid",veicid)
                        setElementData(veh,"Model",model)
                        setElementData(veh,"owner",acc)
                        setElementData(veh,"Nome",nome)
                        setElementData(veh,"Snome",snome)
                        setElementData(veh,"fuel",Fuel)
                        setElementData(veh,"mala",dtmala)
                        setElementData(veh,"usedslots",malaslots)
                        setElementData(veh,"upgrades",upg)
                        setVehicleOverrideLights ( veh, 1 )
                        setElementData(veh,"PaintJob", paintjob)
                        setElementData(veh,"Nitrous", nitrous)
                        if arrest >= 1 then
                            setElementData(veh ,"Arrested", true)
                        end
                        if number then
                            setElementData(veh,"number:plate",number)
                        end
                        if Variant then
                            setVehicleVariant(veh, Variant, Variant)
                            setElementData(veh, "Variant", Variant)
                        end
                        for i, upgrade in ipairs(upg) do
                            addVehicleUpgrade(veh, upgrade)
                        end
                        exports.an_inventory:loadvehicletrunk(veh)
                        triggerClientEvent (ply, "addcarsgarage", ply)
                        saveVehicle(veh)
                    end
                else
                    exports.an_infobox:addNotification(ply,"Há um <b>veiculo</b> perto da vaga","aviso") 
                end
            end
        end
    end
end
addEvent("retirarvehicle",true)
addEventHandler("retirarvehicle",root,retirarvehicle)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GUARDAR
-----------------------------------------------------------------------------------------------------------------------------------------
function guavehgaragesv(ply,plygarageid)
    local plyid = getElementData(ply,"id")
    if ply then
        if plygarageid then
            local vehicl = exports.an_player:getproxveh(ply,9)
            if vehicl then
                if getElementData(vehicl, "owner") == plyid then
                    saveVehicle(vehicl)
                    destroyElement(vehicl)
                    triggerClientEvent (ply, "addcarsgarage", ply)
                    exports.an_infobox:addNotification(ply,"<b>Veículos</b> guardado!","info")
                end
            else
                exports.an_infobox:addNotification(ply,"Não há <b>veículos</b> próximo.","erro") 
            end
        end
    end
end
addEvent("guavehgaragesv",true)
addEventHandler("guavehgaragesv",root,guavehgaragesv)
----------------------------------------------------------------------------------------------------------------
-- VEH FUNCTIONS
----------------------------------------------------------------------------------------------------------------
function lockVehicle()
local plyid = getElementData(source,"id")
local vehicl = exports.an_player:getproxveh(source,9)
    if (vehicl) then
        if getElementData(vehicl, "owner") == plyid then
            setVehicleLocked( vehicl, not isVehicleLocked( vehicl ) )
            if isVehicleLocked( vehicl ) then
				exports.an_infobox:addNotification(source,"Veiculo <b>trancado</b> com sucesso","info")
				triggerClientEvent(getRootElement(), "turnalarmsound", getRootElement(), vehicl, 1)
                setVehicleOverrideLights ( vehicl, 2 )
				setTimer(setVehicleOverrideLights, 100, 1, vehicl,1)
				setTimer(setVehicleOverrideLights, 200, 1, vehicl,2)
				setTimer(setVehicleOverrideLights, 300, 1, vehicl,1)
				setVehicleEngineState(vehicl,false)
				setElementData(vehicl,"vehlocked",true)
            else
                setVehicleOverrideLights ( vehicl, 2 )
                setTimer(setVehicleOverrideLights, 200, 1, vehicl,1)
				setElementData(vehicl,"vehlocked",false)
                exports.an_infobox:addNotification(source,"Veiculo <b>destrancado</b> com sucesso","info")
				triggerClientEvent(getRootElement(), "turnalarmsound", getRootElement(), vehicl, 2)
            end
        end
    end
end
addEvent("lockVehicle",true)
addEventHandler("lockVehicle",root,lockVehicle)

function lightonvehicle()
	theVehicle = getPedOccupiedVehicle ( source )
	if ( theVehicle ) then
		if ( getVehicleOverrideLights ( theVehicle ) ~= 2 ) then
			setVehicleOverrideLights ( theVehicle, 2 )
		else
			setVehicleOverrideLights ( theVehicle, 1 )
		end
	end
end
addEvent("lightonvehicle",true)
addEventHandler("lightonvehicle",root,lightonvehicle)


function engineonvehicle(ply)
local veh = getPedOccupiedVehicle(ply)
	if veh then
		if not getElementData(veh,"vehlocked") then
			if getVehicleController(veh) == ply then
				if getVehicleEngineState(veh) == true then
				setVehicleEngineState(veh,false)
				setElementData(veh,"vehengineon",false)
				else
					if getElementData(veh,"fuel") then
						local fuelveh = getElementData(veh,"fuel")
						if tonumber(fuelveh) >= 1 then
							if getElementHealth(veh) >= 551 then
								setVehicleEngineState(veh,true)
								setElementData(veh,"vehengineon",true)
							end
						else
							exports.an_infobox:addNotification(ply,"<b>Veículo</b> sem combustível!","erro")
						end
					end
				end
			end
		else
			setElementData(veh,"vehengineon",false)
			setVehicleEngineState(veh,false)
			exports.an_infobox:addNotification(ply,"Este <b>veiculo</b> está travado","erro")
		end
	end
end
addEvent("engineonvehicle",true)
addEventHandler("engineonvehicle",root,engineonvehicle)

addEventHandler ( "onPlayerVehicleEnter", getRootElement(), function(veh,seat)
	if getElementHealth(veh) <= 550 then
		setVehicleEngineState(veh,false)
	end
end)

function doBreakdown()
	local health = getElementHealth(source)
	if health <= 350 then
		setElementHealth(source, 250)
		setVehicleDamageProof(source, true)
        setVehicleEngineState(source, false)
        saveVehicle(source)
    else
		setVehicleDamageProof(source, false)
	end
end
addEventHandler("onVehicleDamage", getRootElement(), doBreakdown)

local timerfordelete = {}
function quitPlayer()
local plyid = getElementData(source,"id")
	for k,v in pairs(getElementsByType("vehicle")) do
		if getElementData(v,"owner") == plyid then
            saveVehicle(v)
            if not isTimer(timerfordelete[plyid]) then
                timerfordelete[plyid] = setTimer(function()
                    for k,v in pairs(getElementsByType("vehicle")) do
                        if getElementData(v,"owner") == plyid then
                            saveVehicle(v)
                            destroyElement(v)
                        end
                    end
                end,60000*30,1)
            end
		end
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer)

function resettimerdeleteveh(id)
    if isTimer(timerfordelete[id]) then
        killTimer(timerfordelete[id])
    end
end
addEvent ("resettimerdeleteveh", true)
addEventHandler ("resettimerdeleteveh", root, resettimerdeleteveh)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function bildgaragecol ()
	for i,v in ipairs (cfg.localgarages) do
        local id,x,y,z,garageprice = unpack(v)
        centralgaragemk[id] = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), bildgaragecol)

function openplyhousegarage(ply,gid)
    triggerClientEvent( ply, "openhousegarage", ply, gid)
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

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------