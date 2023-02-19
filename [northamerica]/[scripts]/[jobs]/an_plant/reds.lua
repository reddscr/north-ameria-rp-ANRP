-------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-------------------------------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
-------------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
-------------------------------------------------------------------------------------------------------------------------------------
function getFreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_weedplant ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end

local plant = {}
local plantobj = {}
local plantpot = {}
local plantcfgprogress = {}
local usertimer = {}
-------------------------------------------------------------------------------------------------------------------------------------
-- CREATE CANABIS PLANT
-------------------------------------------------------------------------------------------------------------------------------------
function createcanabisplant(ply)
    local x, y, z = getElementPosition(ply)
    local rx, ry, rz = getElementRotation(ply)
    local id = getFreeid()
    plant[id] = createColSphere( x, y, z-0.5,1)
    plantobj[id] = createObject ( 2250, x, y, z-0.65, rx, ry, rz )
    setObjectScale(plantobj[id],0)
    plantpot[id] = createObject ( 2242, x, y, z-0.8, rx, ry, rz )
    setElementData(plant[id],'weedid',id)
    setElementData(plant[id],'weedcol',plant[id])
    setElementData(plant[id],'weedprogress',0)
    local weedpos = toJSON({ ["pos"] = {x, y, z}, ["rot"] = {rx, ry, rz}})
    dbExec(connection, "INSERT INTO an_weedplant SET id = ?,pos = ?,progress = ?",id,weedpos,'0')
    plantcfgprogress[id] = setTimer(function()end,5*60000,1)
end
-------------------------------------------------------------------------------------------------------------------------------------
-- RESTORE WEED
-------------------------------------------------------------------------------------------------------------------------------------
function restoreweedplant()
    local accountplyQ = dbQuery(connection,"SELECT * FROM an_weedplant")
	local accountplyH,vehszam = dbPoll(accountplyQ,-1)
	if accountplyH then
		for k,v in ipairs(accountplyH) do
            weedid = v["id"]
            weeddata = fromJSON(v["pos"])
            weedprog = v["progress"]
            local x, y, z = unpack(weeddata.pos)
            local rx, ry, rz = unpack(weeddata.rot)
            plant[weedid] = createColSphere( x, y, z-0.5,1)
            plantobj[weedid] = createObject ( 2250, x, y, z-0.65, rx, ry, rz )
            setObjectScale(plantobj[weedid],tonumber(weedprog))
            plantpot[weedid] = createObject ( 2242, x, y, z-0.8, rx, ry, rz )
            setElementData(plant[weedid],'weedid',weedid)
            setElementData(plant[weedid],'weedcol',plant[weedid])
            setElementData(plant[weedid],'weedprogress',tonumber(weedprog))
            plantcfgprogress[weedid] = setTimer(function()end,5*60000,1)
        end
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), restoreweedplant)
-------------------------------------------------------------------------------------------------------------------------------------
-- DESTROY WEED
-------------------------------------------------------------------------------------------------------------------------------------
function Destroyandgiveplant(ply,plt)
    if plt then
        if isElement(plant[plt]) then
            if getElementData(plant[plt],'weedprogress') >= 1 then
                if not isTimer(usertimer[ply]) then
                    setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                    setElementData(ply,"emacao",true)
                    destroyElement(plant[plt])
                    plant[plt] = nil
                    usertimer[ply] = setTimer(function()
                        local qtd = math.random(1,3)
                        destroyElement(plantobj[plt])
                        destroyElement(plantpot[plt])
                        plantobj[plt] = nil
                        plantpot[plt] = nil
                        dbExec(connection, "DELETE FROM an_weedplant WHERE id = ?",plt)
                        local idata = exports.an_account:servergetitemtable2('Weedleaf')
                        if idata then
                            if getElementData(ply, "MocSlot") + idata[4]*qtd < getElementData(ply, "MocMSlot") then
                                exports.an_inventory:sattitem(ply,idata[2],qtd,"mais")
                                exports.an_infobox:addNotification(ply,"Colhido "..qtd.."x <b>"..idata[5].."</b>","sucesso")
                            else
                                triggerEvent ("drop", ply, ply,idata[2],qtd)
                                exports.an_infobox:addNotification(ply,"1x <b>"..idata[5].."</b> caiu no chão.","info")
                            end
                        end
                        local idata2 = exports.an_account:servergetitemtable2('Plantpot')
                        if idata2 then
                            if getElementData(ply, "MocSlot") + idata2[4]*1 < getElementData(ply, "MocMSlot") then
                                exports.an_inventory:sattitem(ply,idata2[2],1,"mais")
                            else
                                triggerEvent ("drop", ply, ply,idata2[2],1)
                                exports.an_infobox:addNotification(ply,"1x <b>"..idata2[5].."</b> caiu no chão.","info")
                            end
                        end
                        setPedAnimation( ply, nil )
                        setElementData(ply,"emacao",false)
                    end,5000,1)
                end
            elseif getElementData(plant[plt],'weedprogress') < 1 then
                if not isTimer(usertimer[ply]) then
                    setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                    setElementData(ply,"emacao",true)
                    destroyElement(plant[plt])
                    plant[plt] = nil
                    usertimer[ply] = setTimer(function()
                        destroyElement(plantobj[plt])
                        destroyElement(plantpot[plt])
                        plantobj[plt] = nil
                        plantpot[plt] = nil
                        dbExec(connection, "DELETE FROM an_weedplant WHERE id = ?",plt)
                        local idata = exports.an_account:servergetitemtable2('Canabisseed')
                        if idata then
                            if getElementData(ply, "MocSlot") + idata[4]*1 < getElementData(ply, "MocMSlot") then
                                exports.an_inventory:sattitem(ply,idata[2],1,"mais")
                                exports.an_infobox:addNotification(ply,"Você pegou 1x <b>"..idata[5].."</b>","sucesso")
                            else
                                triggerEvent ("drop", ply, ply,idata[2],1)
                                exports.an_infobox:addNotification(ply,"1x <b>"..idata[5].."</b> caiu no chão.","info")
                            end
                        end
                        local idata2 = exports.an_account:servergetitemtable2('Plantpot')
                        if idata2 then
                            if getElementData(ply, "MocSlot") + idata2[4]*1 < getElementData(ply, "MocMSlot") then
                                exports.an_inventory:sattitem(ply,idata2[2],1,"mais")
                            else
                                triggerEvent ("drop", ply, ply,idata2[2],1)
                                exports.an_infobox:addNotification(ply,"1x <b>"..idata2[5].."</b> caiu no chão.","info")
                            end
                        end
                        setPedAnimation( ply, nil )
                        setElementData(ply,"emacao",false)
                    end,5000,1)
                end
            end
        end
    end
end
addEvent("Destroyandgiveplant", true)
addEventHandler("Destroyandgiveplant", root, Destroyandgiveplant)
-------------------------------------------------------------------------------------------------------------------------------------
-- TREAD
-------------------------------------------------------------------------------------------------------------------------------------
function plantprogress()
	local weedplant = dbPoll(dbQuery(connection, "SELECT * FROM an_weedplant"), -1)
	if not weedplant then return end
    if weedplant then
        for k,v in pairs(weedplant) do
            id = v["id"]
            if not isTimer(plantcfgprogress[id]) then
                if isElement(plant[id]) then
                    local plantp = getObjectScale(plantobj[id])
                    if math.round(plantp,1) < 1 then
                        plantcfgprogress[id] = setTimer(function()end,5*60000,1)
                        setObjectScale(plantobj[id],math.round(plantp,1)+0.1)
                        setElementData(plant[id],'weedprogress',math.round(plantp,1)+0.1)
                        dbExec(connection, "UPDATE an_weedplant SET progress = ? WHERE id = ?",math.round(plantp,1)+0.1,id)
                    end
                end
            end
        end
    end
    setTimer(plantprogress,5000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), plantprogress)
-------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-------------------------------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------