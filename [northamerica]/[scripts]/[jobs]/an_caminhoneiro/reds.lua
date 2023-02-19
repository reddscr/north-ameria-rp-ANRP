-------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
-------------------------------------------------------------------------------------------------------
local paytable = {
    [435] = { 500, 1700},
    [450] = { 700, 2000},
    [584] = { 800, 2500}
}

local Trailer = {}
local centralcaminhped ={}

local EntrgPoint = false
local TruckTable = {
--  id - trailer
    { 1, 435 },
    { 2, 450 },
    { 3, 584 }
}

function randompointcfg()
    local rtrailer = math.random(#TruckTable)
    if rtrailer then
        EntrgPoint = rtrailer
    end
setTimer(randompointcfg,180000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), randompointcfg)


function requestpoint(ply)
    if EntrgPoint then
        triggerClientEvent( ply,"startedjobmission", ply, EntrgPoint)
    end
end
addEvent("requestpoint", true)
addEventHandler("requestpoint", root, requestpoint)
-------------------------------------------------------------------------------------------------------
-- SCRIPT
-------------------------------------------------------------------------------------------------------
function createTrailerandstartmission(ply,trailer,spawnid)
    if trailer then
        if spawnid then
            local x, y, z, rx, ry, rz = unpack(cfg.localsspawn[spawnid])
            local cord = toJSON({x,y,z})
            local chckpos = checkproxveh(ply,cord)
            if not isElement(Trailer[ply]) then
                if not chckpos then
                    Trailer[ply] = createVehicle(trailer, x, y, z+0.5, rx, ry, rz) 
                    local plyid = getElementData(ply,'id')
                    setElementData(Trailer[ply],'owner',plyid)
                    setElementData(Trailer[ply],'trailermission',true)
                    triggerClientEvent( ply,"confirmstartMission", ply)
                    exports.an_infobox:addNotification(ply,"<b>Caminhoneiro</b><br><br>Entregue a carga para receber o pagamento!</b><br><br>para cancelar use <b>/cancel</b><br>será cobrado uma taxa de $ 350 <br>no <b>cancelamento</b>.","info",17000)
                else
                    exports.an_infobox:addNotification(ply,"A <b>garagem</b> está ocupado! aguarde ela ficar livre.","aviso")
                end
            else
                exports.an_infobox:addNotification(ply,"Você tem um frete <b>pendente</b>","aviso")
            end
        end
    end
end
addEvent("createTrailerandstartmission", true)
addEventHandler("createTrailerandstartmission", root, createTrailerandstartmission)

function finishTrailerMission(ply)
    if isElement(Trailer[ply]) then
        if not isPedInVehicle(ply) then
            local elemodel = getElementModel(Trailer[ply])
            if elemodel then
                local proxt = checkproxtrailer(ply, 5)
                if proxt then
                    destroyElement(Trailer[ply])
                    local payment = math.random(paytable[elemodel][1],paytable[elemodel][2])
                    triggerClientEvent( ply,"finishedtruckjob", ply)
                    exports.an_infobox:addNotification(ply,"<b>Caminhoneiro</b><br><br>Carga entregue com sucesso!<br><br>você recebeu $ <b>"..payment.."</b>!","sucesso",15000) 
                    exports.an_inventory:sattitem(ply,"Money",payment,"mais")
                else
                    exports.an_infobox:addNotification(ply,"Você está muito <b>distante</b> da carga!","aviso") 
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Você deve estar fora do <b>caminhão</b> para tirar o trailer.","aviso") 
        end
    end
end
addEvent("finishTrailerMission", true)
addEventHandler("finishTrailerMission", root, finishTrailerMission)

addCommandHandler("cancel",
function(ply,cmd)
    if isElement(Trailer[ply]) then
        destroyElement(Trailer[ply])
        triggerClientEvent( ply,"finishedtruckjob", ply)
        exports.an_inventory:sattitem(ply,"Money","350","menos")
        exports.an_infobox:addNotification(ply,"Você cancelou a carga, foi cobrado uma taxa de <b>$ 350</b>","info")
    end
end
)

function destroyTrailerMissionOnQuit()
    if isElement(Trailer[source]) then
        destroyElement(Trailer[source])
    end
end
addEventHandler("onPlayerQuit",getRootElement(),destroyTrailerMissionOnQuit)
-------------------------------------------------------------------------------------------------------
-- CREATE PED
-------------------------------------------------------------------------------------------------------
function createmksshops()
    for i,v in ipairs (cfg.localemp) do
        local id, x, y, z, rx, ry, rz = unpack(v)
        centralcaminhped[id] = createPed(307, x, y, z)
        setElementRotation(centralcaminhped[id], rx , ry, rz)
        setElementFrozen(centralcaminhped[id],true)
		setElementData(centralcaminhped[id],"npc",true)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksshops)
-------------------------------------------------------------------------------------------------------
-- SYNC TRAILER
-------------------------------------------------------------------------------------------------------
function reattachTrailer(theTruck)
    attachTrailerToVehicle(theTruck, source)
end
addEventHandler("onTrailerDetach", getRootElement(), reattachTrailer)
-------------------------------------------------------------------------------------------------------
-- VARIABLES
-------------------------------------------------------------------------------------------------------
function checkproxtrailer(ply, dist)
    local x, y, z = getElementPosition(ply)
    local id = false
    local vehs = getElementsByType("vehicle")
    for i, v in ipairs (vehs) do 
        if getElementData(v,'trailermission') then
            if ply ~= v then
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

function checkproxveh(ply,cord)
    local poss = fromJSON(cord)
    if poss then
        local dist = 6
        local id = false
        local vehs = getElementsByType("vehicle")
        for i, v in ipairs (vehs) do 
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
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------