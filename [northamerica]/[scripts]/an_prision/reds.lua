--------------------------------------------------------------------------------------------------------------------
-- CONNECTION
--------------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()

local vassoura = {}
--------------------------------------------------------------------------------------------------------------------
-- VERIFY JAIL JOB's
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("jail",
function(ply,cmd)
    if getElementData(ply,"injail") then
        local plyid = getElementData(ply,"id")
        local accountplyQ = dbQuery(connection,"SELECT * FROM an_prision WHERE plyid=?",plyid)
        local accountplyH,vehszam = dbPoll(accountplyQ,-1)
        if accountplyH then
            for k,v in ipairs(accountplyH) do
                time = v["time"]
                if time then
                    exports.an_infobox:addNotification(ply,"Ainda restam <b>"..time.."</b> serviços comunitários.","info")
                end
            end
        end
    end
end
)
--------------------------------------------------------------------------------------------------------------------
-- SET PLY PRISION
--------------------------------------------------------------------------------------------------------------------
function setplyjail(ply,timeprision,prision)
    if timeprision then
        if prision == 1 then
            if getElementData(ply,"injail") then
                local plyid = getElementData(ply,"id")
                local accountplyQ = dbQuery(connection,"SELECT * FROM an_prision WHERE plyid=?",plyid)
                local accountplyH,vehszam = dbPoll(accountplyQ,-1)
                if accountplyH then
                    for k,v in ipairs(accountplyH) do
                        time = v["time"]
                        if time >= 0 then
                            setElementData(ply,"injail",true)
                            setElementData(ply,"prision",1)
                            exports.an_infobox:addNotification(ply,"A sua <b>sentença</b> foi atualizada para <b>"..timeprision+time.."</b> serviços comunitários.","info")
                            dbExec(connection, "UPDATE an_prision SET time=? WHERE plyid=?",timeprision+time,plyid)
                        end
                    end
                end
            elseif not getElementData(ply,"injail") then
                local plyid = getElementData(ply,"id")
                setElementData(ply,"injail",true)
                setElementData(ply,"prision",1)
                setElementData(ply,"necessarigps",true)
                exports.an_wanted:removeplywanted(ply)
                dbExec(connection, "INSERT INTO an_prision SET plyid = ?,time = ?,prision = ?",plyid,timeprision,prision)
                exports.an_infobox:addNotification(ply,"Você foi sentenciado em <b>"..timeprision.."</b> serviços comunitários.","info")
            end
        else
            if getElementData(ply,"injail") then
                local plyid = getElementData(ply,"id")
                local accountplyQ = dbQuery(connection,"SELECT * FROM an_prision WHERE plyid=?",plyid)
                local accountplyH,vehszam = dbPoll(accountplyQ,-1)
                if accountplyH then
                    for k,v in ipairs(accountplyH) do
                        time = v["time"]
                        if time >= 0 then
                            setElementData(ply,"injail",true)
                            setElementData(ply,"prision",2)
                            exports.an_infobox:addNotification(ply,"A sua <b>sentença</b> foi atualizada para <b>"..timeprision+time.."</b> serviços comunitários.","info")
                            dbExec(connection, "UPDATE an_prision SET time=? WHERE plyid=?",timeprision+time,plyid)
                        end
                    end
                end
            elseif not getElementData(ply,"injail") then
                local plyid = getElementData(ply,"id")
                setElementData(ply,"injail",true)
                setElementData(ply,"prision",2)
                setElementData(ply,"necessarigps",true)
                setElementPosition(ply,-1334.485, 2492.051, 96.1+2.2)
                exports.an_wanted:removeplywanted(ply)
                dbExec(connection, "INSERT INTO an_prision SET plyid = ?,time = ?,prision = ?",plyid,timeprision,prision)
                exports.an_infobox:addNotification(ply,"Você foi sentenciado em <b>"..timeprision.."</b> serviços comunitários.","info")
            end
        end
    end
end
--------------------------------------------------------------------------------------------------------------------
-- REMOVE PLY ON PRISION
--------------------------------------------------------------------------------------------------------------------
function removeplyjail(ply)
    if getElementData(ply,"injail") then
        local prision = getElementData(ply,'prision')
        if prision == 1 then
            local plyid = getElementData(ply,"id")
            setElementData(ply,"injail",nil)
            setElementData(ply,"necessarigps",nil)
            setElementData(ply,"prision",nil)
            dbExec(connection, "DELETE FROM an_prision WHERE plyid = ?",plyid)
            triggerClientEvent(ply, "deleteplyprisionjob", ply)
            setanimprisionjob(ply,2)
            exports.an_infobox:addNotification(ply,"Você foi liberado(a) da <b>prisão</b>.","sucesso")
        else
            local plyid = getElementData(ply,"id")
            setElementData(ply,"injail",nil)
            setElementData(ply,"necessarigps",nil)
            setElementData(ply,"prision",nil)
            dbExec(connection, "DELETE FROM an_prision WHERE plyid = ?",plyid)
            triggerClientEvent(ply, "deleteplyprisionjob", ply)
            setanimprisionjob(ply,2)
            setElementPosition(ply,-1342.383, 2418.791, 96.295+2.2)
            exports.an_infobox:addNotification(ply,"Você foi liberado(a) da <b>prisão</b>.","sucesso")
        end
    end
end
--------------------------------------------------------------------------------------------------------------------
-- SET PLY PRISION ON JAIL
--------------------------------------------------------------------------------------------------------------------
function chacktimerjailed()
    local prisionArray = dbPoll(dbQuery(connection, "SELECT * FROM an_prision"), -1)
    if not prisionArray then return end
    for k,v in pairs(prisionArray) do
        time = v["time"]
        plyid = v["plyid"]
        prisi = v["prision"]
        if time >= 0 then
            for pk,pv in pairs(getElementsByType("player")) do
                if getElementData(pv,"id") == plyid then
                    setElementData(pv,"injail",true)
                    setElementData(pv,"prision",prisi)
                    setElementData(pv,"necessarigps",true)
                    exports.an_infobox:addNotification(pv,"Você está <b>preso</b> e ainda restam <b>"..time.."</b> serviços comunitários.","aviso")
                end
            end
        end
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), chacktimerjailed)
--------------------------------------------------------------------------------------------------------------------
-- CHECK FREE PLY
--------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------
-- LOAD PLY PRISION
--------------------------------------------------------------------------------------------------------------------
function loadjailed(ply)
    local plyid = getElementData(ply,"id")
	local playeQ = dbQuery(connection,"SELECT * FROM an_prision WHERE plyid = ?",plyid)
	local playeH,playeHm = dbPoll(playeQ,-1)
	if playeH then
		for k,v in ipairs(playeH) do
            plyid = v["plyid"]
            timep = v["time"]
            prisi = v["prision"]
            if getElementData(ply,"id") == plyid then
                setElementData(ply,"injail",true)
                setElementData(ply,"prision",prisi)
                setElementData(ply,"necessarigps",true)
                exports.an_infobox:addNotification(ply,"Você está <b>preso</b> e ainda restam <b>"..timep.."</b> serviços comunitários.","aviso")
			end
		end
    end
end
--------------------------------------------------------------------------------------------------------------------
-- PRISION PERIMETER
--------------------------------------------------------------------------------------------------------------------
function returnplyprision(ply)
    if getElementData(ply,"injail") then
        local prision = getElementData(ply,'prision')
        if prision == 1 then
            if isPedInVehicle(ply) then
                removePedFromVehicle (ply)
            end
            setElementPosition(ply,1403.151, -1610.754, 13.6+2.2)
            exports.an_infobox:addNotification(ply,"Não saia do perimetro do <b>departamento</b>!","aviso")
        else
            if isPedInVehicle(ply) then
                removePedFromVehicle (ply)
            end
            setElementPosition(ply,-1334.485, 2492.051, 96.1+2.2)
            exports.an_infobox:addNotification(ply,"Não saia do perimetro da <b>prisão</b>!","aviso")
        end
    end
end
addEvent ("returnplyprision", true)
addEventHandler ("returnplyprision", root, returnplyprision)

local colprision = {}
function startprisioncol()
	colprision[1] = createColCuboid(1376.654, -1642.909, 13.6-10,43,40,30)
	setElementData(colprision[1],"prisioncol",colprision[1])
	colprision[2] = createColCuboid(-1401.766, 2397.739, 88.431-10,140,130,30)
	setElementData(colprision[2],"prisioncol2",colprision[2])
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), startprisioncol)

function decreasesjail(ply)
    local plyid = getElementData(ply,"id")
    if plyid then
        local accountplyQ = dbQuery(connection,"SELECT * FROM an_prision WHERE plyid=?",plyid)
        local accountplyH,vehszam = dbPoll(accountplyQ,-1)
        if accountplyH then
            for k,v in ipairs(accountplyH) do
                time = v["time"]
                prisi = v["prision"]
                if time then
                    dbExec(connection, "UPDATE an_prision SET time = ? WHERE plyid = ?",math.percent(1,time), plyid)
                    if math.percent(1,time) >= 1 then
                        exports.an_infobox:addNotification(ply,"Ainda restam <b>"..math.percent(1,time).."</b> serviços comunitários.","aviso")
                    else
                        if getElementData(ply,"id") == v["plyid"] then
                            dbExec(connection, "DELETE FROM an_prision WHERE plyid = ?",v["plyid"])
                            setElementData(ply,"injail",nil)
                            setElementData(ply,"necessarigps",nil)
                            setElementData(ply,"prision",nil)
                            exports.an_infobox:addNotification(ply,"Você foi liberado(a) da <b>prisão</b>! espero não ter que ver você novamente.","sucesso")
                            setanimprisionjob(ply,2)
                            if isElement(vassoura[ply]) then
                                exports["bone_attach"]:detachElementFromBone(vassoura[ply])
                                destroyElement(vassoura[ply])
                                vassoura[ply] = nil
                            end
                            if prisi == 2 then
                                setElementPosition(ply,-1342.383, 2418.791, 96.295+2.2)
                            end
                        end
                    end
                end
            end
        end
    end
end
addEvent ("decreasesjail", true)
addEventHandler ("decreasesjail", root, decreasesjail)

function setanimprisionjob(ply,typ,anim,anim2)
    if typ == 1 then
        if anim then
            if anim == "CASINO" then
                local obj = createObject(2237, 0, 0, 0)
                vassoura[ply] = obj
                exports["bone_attach"]:attachElementToBone(vassoura[ply], ply, 12, 0, 0.05, 0, 80, 80, 180)
                setObjectScale(vassoura[ply], 1)
            end
            setPedAnimation(ply, anim,anim2, -1, true, false, false )
        end
    elseif typ == 2 then
        if isElement(vassoura[ply]) then
            exports["bone_attach"]:detachElementFromBone(vassoura[ply])
            destroyElement(vassoura[ply])
            vassoura[ply] = nil
        end
        setPedAnimation(ply,nil)
    end
end
addEvent ("setanimprisionjob", true)
addEventHandler ("setanimprisionjob", root, setanimprisionjob)

function onquitseprision()
    if isElement(vassoura[source]) then
        exports["bone_attach"]:detachElementFromBone(vassoura[source])
        destroyElement(vassoura[source])
        vassoura[source] = nil
    end
end
addEventHandler ("onPlayerQuit", root, onquitseprision)
--------------------------------------------------------------------------------------------------------------------
-- VARIABLES
--------------------------------------------------------------------------------------------------------------------
function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)-1
    end
    return false
end
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------