local tunningquest = {}
local tunningquestcount = 0
local tunningPlayer = {}
local tunningTimer = {}
function tunningrequeststart(ply2)
    if ply2 then
        tunningquestcount = tunningquestcount + 1
        tunningquest[tunningquestcount] = tunningquestcount
        tunningPlayer[tunningquestcount] = ply2
        exports.an_request:naquestionrequest(tunningquestcount,"Você realmente quer remover a tunagem deste <b>veiculo</b>? <center>Você pode aceitar ou recusar</center>",10)
        destroyPingreq(tunningquestcount)
    end
end
addEvent ("tunningrequeststart", true)
addEventHandler ("tunningrequeststart", root, tunningrequeststart)

function destroyPingreq(id)
    if id then
        if tunningquest[id] then
            tunningTimer[id] = setTimer(function()
                tunningquest[id] = nil
                tunningPlayer[id] = nil
                tunningTimer[id] = nil
                tunningquestcount = tunningquestcount - 1
                exports.an_request:naremovequestionrequest(id)
            end,1000*10, 1)
        end
    end
end

function tablerequests_()
  if tunningquest then
    for k, v in next, tunningquest do
        return v
    end
  end
end

function aceptrequest()
    if tunningquest then
        local rid = tablerequests_()
        if rid then
            tunningquest[rid] = nil
            tunningquestcount = tunningquestcount - 1
            exports.an_request:naremovequestionrequest(rid)
            triggerServerEvent( "remTunningAcept", localPlayer, localPlayer, tunningPlayer[rid])
            tunningPlayer[rid] = nil
            if isTimer(tunningTimer[rid]) then killTimer(tunningTimer[rid]) tunningTimer[rid] = nil end
        end
    end
end
bindKey("y", "down", aceptrequest)

function denyrequest()
    if tunningquest then
        local rid = tablerequests_()
        if rid then
            tunningquest[rid] = nil
            tunningPlayer[rid] = nil
            tunningquestcount = tunningquestcount - 1
            exports.an_request:naremovequestionrequest(rid)
            if isTimer(tunningTimer[rid]) then killTimer(tunningTimer[rid]) tunningTimer[rid] = nil end
        end
    end
end
bindKey("u", "down", denyrequest)