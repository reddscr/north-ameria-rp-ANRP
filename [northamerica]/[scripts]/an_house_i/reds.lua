----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
local itemtb = exports.an_account:servergetitemtable3()
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local theObject = {}
local objcolhouse = {}

local objbuycol = {}
local objbuyobj = {}


function onstarthouseobjects()
    for i,v in ipairs (cfg.localbuymoveis) do
        local id,objname,objprice,objid,x,y,z,rx,ry,rz,colx,coly,colz,objdata = unpack(v)
        objbuyobj[id] = createObject(objid,x,y,z)
        setElementRotation(objbuyobj[id],rx,ry,rz)
    end
    local objectsQ = dbQuery(connection,"SELECT * FROM an_houseobjects")
    local objectsH,vehszam = dbPoll(objectsQ,-1)
    if objectsH then
		for k,v in ipairs(objectsH) do
			id = v["id"]
			objid = v["ObjID"]
            Pos = fromJSON(v["Pos"])
            ownerid = v["Owner"]
            theObject[id] = createObject(objid,Pos[1],Pos[2],Pos[3])
            for i,v in ipairs (cfg.localbuymoveis) do 
                if v[4] == objid then
                    if theObject[id] then
                        objcolhouse[id] = createColSphere(Pos[1],Pos[2],Pos[3]+0.5,1)
                        setElementData(objcolhouse[id],"objecthouseid",id)
                        setElementData(objcolhouse[id],"objecthousename",v[2])
                        setElementData(objcolhouse[id],"objecthousenamedata",v[14])
                        setElementData(objcolhouse[id],"objecthousecol",objcolhouse[id])
                        setElementData(objcolhouse[id],"objowner",ownerid)
                        setElementRotation(theObject[id],Pos[4],Pos[5],Pos[6])
                        setElementData(theObject[id],"Owner",ownerid)
                        setElementData(theObject[id],"id",id)
                        if v[15] == "Bau" then
                            local objectsQ = dbQuery(connection,"SELECT * FROM an_chests WHERE id=?",id)
                            local objectsH,vehszam = dbPoll(objectsQ,-1)
                            if objectsH then
                                for k,v in ipairs(objectsH) do
                                    did = v["id"]
                                    usedslots = v["usedslots"]
                                    maxslots = v["maxslots"]
                                    if did then
                                        setElementData(theObject[id],'maxslots',maxslots)
                                        setElementData(theObject[id],'usedslots',usedslots)
                                    end
                                end
                            end
                            exports.an_inventory:loadchestitem(theObject[id])
                        end
                    end
                end
            end
        end
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), onstarthouseobjects)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local usertimer = {}
addCommandHandler("buy",
function(ply,cmd,val)
    if not isTimer(usertimer[ply]) then
        if getElementData(ply,"housemid") then
            local housemid = getElementData(ply,"housemid")
            for i,v in ipairs (cfg.localbuymoveis) do
                local id,objname,objprice,objid,x,y,z,rx,ry,rz,colx,coly,colz,objdata = unpack(v)
                if id == housemid then
                    if getElementData(ply,"Money") >= tonumber(objprice) then
                        local itemdata = exports.an_account:servergetitemtable2(objdata)
                        if itemdata then
                            if getElementData(ply, "MocSlot") + itemdata[4]*1 < getElementData(ply, "MocMSlot") then
                                exports.an_inventory:sattitem(ply,"Money",objprice,"menos")
                                exports.an_inventory:sattitem(ply,itemdata[2],"1","mais")
                                exports.an_infobox:addNotification(ply,"Você comprou 1x <b>"..itemdata[5].."</b>","sucesso")
                                usertimer[ply] = setTimer(function()
                                end,1000,1)
                            else
                                exports.an_infobox:addNotification(ply,"A <b>mochila</b> está sem espaço","erro")
                            end
                        end
                    else
                        exports.an_infobox:addNotification(ply,"Você não tem $<b>"..objprice.."</b>","erro")
                    end
                end
            end
        end
    end
end
)

function startobjectposition(ply,object)
    local plyid = getElementData(ply,"id")
    if getElementData(ply,"inhouse") then
        local hid = getElementData(ply,"inhousecolid")
        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?",hid), -1)
        for k,v in ipairs(result) do
            homeowner = v["id_owner"]
            if plyid == homeowner then
                for i,v in ipairs (cfg.localbuymoveis) do 
                    if v[14] == object then
                        triggerClientEvent (ply,"openpoliceanmoveis",ply,v[4])
                    end
                end
            else
                exports.an_infobox:addNotification(ply,"Esta <b>casa</b> não pertence a você.","erro")
            end
        end
    else
        exports.an_infobox:addNotification(ply,"Você precisa estar em uma <b>casa</b>.","erro")
    end
end

function startobjectposition2(ply,object,mx, my, mz,mrx, mry, mrz)
    local plyid = getElementData(ply,"id")
    if getElementData(ply,"inhouse") then
        local hid = getElementData(ply,"inhousecolid")
        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?",hid), -1)
        for k,v in ipairs(result) do
            homeowner = v["id_owner"]
            if plyid == homeowner then
                for i,v in ipairs (cfg.localbuymoveis) do 
                    if v[14] == object then
                        triggerClientEvent (ply,"openpoliceanmoveis2",ply,v[4],mx, my, mz,mrx, mry, mrz)
                    end
                end
            else
                exports.an_infobox:addNotification(ply,"Esta <b>casa</b> não pertence a você.","erro")
            end
        end
    else
        exports.an_infobox:addNotification(ply,"Você precisa estar em uma <b>casa</b>.","erro")
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function getFreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_houseobjects ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
----------------------------------------------------------------------------------------------------------------
function createtheobjectinhouse(ply,x,y,z,rx,ry,rz,object)
    if ply then
        if x then
            if rz then
                if object then
                    local objfreeid = getFreeid()
                    local pos = toJSON({x,y,z,rx,ry,rz})
                    theObject[objfreeid] = createObject(object,x,y,z)
                    for i,v in ipairs (cfg.localbuymoveis) do 
                        if v[4] == object then
                            if theObject then
                                local plyid = getElementData(ply,"id")
                                objcolhouse[objfreeid] = createColSphere(x,y,z+0.5,1)
                                setElementData(objcolhouse[objfreeid],"objecthouseid",objfreeid)
                                setElementData(objcolhouse[objfreeid],"objecthousename",v[2])
                                setElementData(objcolhouse[objfreeid],"objecthousenamedata",v[14])
                                setElementData(objcolhouse[objfreeid],"objecthousecol",objcolhouse[objfreeid])
                                setElementData(objcolhouse[objfreeid],"objowner",plyid)
                                setElementRotation(theObject[objfreeid],rx,ry,rz)
                                setElementData(theObject[objfreeid],"id",objfreeid)
                                setElementData(theObject[objfreeid],"Owner",getElementData(ply,"id"))
                                dbExec(connection, "INSERT INTO an_houseobjects SET id = ?,Pos = ?,ObjID = ?,Owner = ?",objfreeid,pos,object,getElementData(ply,"id"))
                                if v[15] == "Bau" then
                                    dbExec(connection, "INSERT INTO an_chests SET id = ?,pos = ?,usedslots = ?,maxslots = ?,owner = ?",objfreeid,pos,0,300,getElementData(ply,"id"))
                                    setElementData(theObject[objfreeid],'maxslots',300)
                                    setElementData(theObject[objfreeid],'usedslots',0)
                                    for vai,val in ipairs (itemtb) do
                                        local dbid2 = tonumber(getElementData(theObject[objfreeid], val[2]))
                                        if dbid2 == nil then
                                            setElementData(theObject[objfreeid],val[2],0)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
addEvent("createtheobjectinhouse",true)
addEventHandler ( "createtheobjectinhouse", getRootElement(), createtheobjectinhouse)
----------------------------------------------------------------------------------------------------------------
addCommandHandler("remove",
function(ply,cmd)
    local proxy = getproxyonply(ply,5)
    if proxy then
        if isElement(objcolhouse[proxy]) then
            local objidc = getElementData(objcolhouse[proxy],"objecthouseid")
            local objname = getElementData(objcolhouse[proxy],"objecthousenamedata")
            local objowner = getElementData(objcolhouse[proxy],"objowner")
            local plyid = getElementData(ply,"id")
            if objowner == plyid or getElementData(ply,"Admin") then
                for i,v in ipairs (cfg.localbuymoveis) do
                    if v[14] == objname then
                        local itemdata = exports.an_account:servergetitemtable2(v[14])
                        if getElementData(ply, "MocSlot") + itemdata[4]*1 < getElementData(ply, "MocMSlot") then
                            local id,objname,objprice,objid,x,y,z,rx,ry,rz,colx,coly,colz,objdata = unpack(v)
                            if isElement(theObject[objidc]) then
                                destroyElement(objcolhouse[objidc])
                                destroyElement(theObject[objidc])
                                objcolhouse[objidc] = {}
                                exports.an_inventory:sattitem(ply,objdata,"1","mais")
                                dbExec(connection, "DELETE FROM an_houseobjects WHERE id = ? AND Owner = ?",objidc,objowner)
                                if v[15] == "Bau" then
                                    dbExec(connection, "DELETE FROM an_chests WHERE id = ? AND owner = ?",objidc,objowner)
                                    exports.an_inventory:destroyChestidData(objidc)
                                end
                                setElementData(ply,"inobjecthouse",nil)
                                exports.an_infobox:addNotification(ply,"Você pegou o <b>móvel</b>","info")
                            end
                        else
                            exports.an_infobox:addNotification(ply,"A <b>mochila</b> está sem espaço","erro")
                        end
                    end
                end
            end
        end
    end
end)
----------------------------------------------------------------------------------------------------------------
addCommandHandler("ajust",
function(ply,cmd)
    local proxy = getproxyonply(ply,5)
    if proxy then
        if isElement(objcolhouse[proxy]) then
            local objidc = getElementData(objcolhouse[proxy],"objecthouseid")
            local objname = getElementData(objcolhouse[proxy],"objecthousenamedata")
            local objowner = getElementData(objcolhouse[proxy],"objowner")
            local plyid = getElementData(ply,"id")
            if objowner == plyid or getElementData(ply,"Admin") then
                for i,v in ipairs (cfg.localbuymoveis) do
                    if v[14] == objname then
                        local itemdata = exports.an_account:servergetitemtable2(v[14])
                        if getElementData(ply, "MocSlot") + itemdata[4]*1 < getElementData(ply, "MocMSlot") then
                            local id,objname,objprice,objid,x,y,z,rx,ry,rz,colx,coly,colz,objdata = unpack(v)
                            if isElement(theObject[objidc]) then
                                local mx, my, mz = getElementPosition(theObject[objidc])
                                local mrx, mry, mrz = getElementRotation(theObject[objidc])
                                startobjectposition2(ply,objdata,mx, my, mz,mrx, mry, mrz)
                                destroyElement(objcolhouse[objidc])
                                destroyElement(theObject[objidc])
                                objcolhouse[objidc] = {}
                                exports.an_inventory:sattitem(ply,objdata,"1","mais")
                                dbExec(connection, "DELETE FROM an_houseobjects WHERE id = ? AND Owner = ?",objidc,objowner)
                                if v[15] == "Bau" then
                                    dbExec(connection, "DELETE FROM an_chests WHERE id = ? AND owner = ?",objidc,objowner)
                                    exports.an_inventory:destroyChestidData(objidc)
                                end
                                setElementData(ply,"inobjecthouse",nil)
                                exports.an_infobox:addNotification(ply,"Você pegou o <b>móvel</b>","info")
                            end
                        else
                            exports.an_infobox:addNotification(ply,"A <b>mochila</b> está sem espaço","erro")
                        end
                    end
                end
            end
        end
    end
end)
----------------------------------------------------------------------------------------------------------------
function getproxyonply(ply,distance)
    local pX, pY, pZ = getElementPosition (ply) 
	local dist = distance
    local obtarget = false
    local objectsQ = dbQuery(connection,"SELECT * FROM an_houseobjects")
    local objectsH,vehszam = dbPoll(objectsQ,-1)
    if objectsH then
		for k,v in ipairs(objectsH) do
            id = v["id"]
            objid = v["ObjID"]
            Pos = fromJSON(v["Pos"])
            ownerid = v["Owner"]
            if getDistanceBetweenPoints3D ( pX, pY, pZ, Pos[1], Pos[2], Pos[3]) < dist then
                dist = getDistanceBetweenPoints3D ( pX, pY, pZ, Pos[1], Pos[2], Pos[3])
                obtarget = id
            end
        end
    end
    if obtarget then
        return obtarget
    else
        return false
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------