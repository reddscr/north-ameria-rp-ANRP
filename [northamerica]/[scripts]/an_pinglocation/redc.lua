----------------------------------------------------------------------------------------------------------------
-- PING CONFIRMATION
----------------------------------------------------------------------------------------------------------------
local pingquest = {}
local pingquestcount = 0
local pingPlayer = {}
local pingTimer = {}
function pingrequeststart(ply2)
    if ply2 then
        pingquestcount = pingquestcount + 1
        pingquest[pingquestcount] = pingquestcount
        pingPlayer[pingquestcount] = ply2
        exports.an_request:naquestionrequest(pingquestcount,"O número <b>"..getElementData(ply2, 'phonenumber').."</b> solicitou a sua localização!<br> <center>Você pode aceitar ou recusar</center>",100)
        destroyPingreq(pingquestcount)
    end
end
addEvent ("pingrequeststart", true)
addEventHandler ("pingrequeststart", root, pingrequeststart)

function destroyPingreq(id)
    if id then
        if pingquest[id] then
            pingTimer[id] = setTimer(function()
                pingquest[id] = nil
                pingPlayer[id] = nil
                pingTimer[id] = nil
                pingquestcount = pingquestcount - 1
                exports.an_request:naremovequestionrequest(id)
            end,1000*100, 1)
        end
    end
end

function tablerequests_()
  if pingquest then
    for k, v in next, pingquest do
        return v
    end
  end
end

function aceptrequest()
    if pingquest then
        local rid = tablerequests_()
        if rid then
            if not getElementData(localPlayer,"incoma") then
                if not getElementData(localPlayer,"emacao") then
                    pingquest[rid] = nil
                    pingquestcount = pingquestcount - 1
                    exports.an_request:naremovequestionrequest(rid)
                    triggerServerEvent( "Pingacepted", localPlayer, localPlayer, pingPlayer[rid])
                    pingPlayer[rid] = nil
                    if isTimer(pingTimer[rid]) then killTimer(pingTimer[rid]) pingTimer[rid] = nil end
                else
                    exports.an_infobox:addNotification("Você está em <b>ação</b>!","aviso")
                    pingquest[rid] = nil
                    pingquestcount = pingquestcount - 1
                    exports.an_request:naremovequestionrequest(rid)
                    pingPlayer[rid] = nil
                    if isTimer(pingTimer[rid]) then killTimer(pingTimer[rid]) pingTimer[rid] = nil end
                end
            else
                exports.an_infobox:addNotification("Você está em <b>coma</b>!","aviso")
                pingquest[rid] = nil
                pingquestcount = pingquestcount - 1
                exports.an_request:naremovequestionrequest(rid)
                pingPlayer[rid] = nil
                if isTimer(pingTimer[rid]) then killTimer(pingTimer[rid]) pingTimer[rid] = nil end
            end
        end
    end
end
bindKey("y", "down", aceptrequest)

function denyrequest()
    if pingquest then
        local rid = tablerequests_()
        if rid then
            pingquest[rid] = nil
            pingPlayer[rid] = nil
            pingquestcount = pingquestcount - 1
            exports.an_request:naremovequestionrequest(rid)
            if isTimer(pingTimer[rid]) then killTimer(pingTimer[rid]) pingTimer[rid] = nil end
        end
    end
end
bindKey("u", "down", denyrequest)

local PingBlip = {}
function startPingLocation(ply)
    local plyid = tonumber(getElementData(ply, 'id'))
    if isElement(PingBlip[plyid]) then
        destroyElement(PingBlip[plyid])
        PingBlip[plyid] = nil
    end
    local x, y, z = getElementPosition(ply)
    PingBlip[plyid] = createBlip (x, y, z, 0, 2, 200, 0, 0, 255, 50, 200000)
    setElementData( PingBlip[plyid], "tooltipText",'Pinged - '..getElementData(ply, "Nome")..' '..getElementData(ply, "SNome"))
    setTimer(function()
        if isElement(PingBlip[plyid]) then
            destroyElement(PingBlip[plyid])
            PingBlip[plyid] = nil
        end
    end,1000*25,1)
end
addEvent ("startPingLocation", true)
addEventHandler ("startPingLocation", root, startPingLocation)


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------