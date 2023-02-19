----------------------------------------------------------------------------------------------------------------
-- entrega bus
----------------------------------------------------------------------------------------------------------------
local centralmotoristaped = {}
local centralmotoristamk = {}
local centralmotoristacol = {}

local pegrotamotoristaped = {}
local pegrotamotoristamk = {}
local pegrotamotoristacol = {}

function createmksshops()
    for i,v in ipairs (cfg.localcentral) do
        local id,x,y,z,px,py,pz,prx,pry,prz = unpack(v)
        centralmotoristamk[id] = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
        centralmotoristaped[id] = createPed(302,px,py,pz)
        setElementRotation(centralmotoristaped[id],prx,pry,prz)
        setElementFrozen(centralmotoristaped[id],true)
		setElementData(centralmotoristaped[id],"npc",true)
        centralmotoristacol[id] = createColSphere(x,y,z-0.5,1)
		setElementData(centralmotoristacol[id],"idcentralmotorista",id)
        setElementData(centralmotoristacol[id],"colcentralmotorista",centralmotoristacol[id])
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksshops)
----------------------------------------------------------------------------------------------------------------
-- job motorista
----------------------------------------------------------------------------------------------------------------
function paymentply_motorista(ply,payment)
    if payment then
        exports.an_inventory:sattitem(ply,"Money",payment,"mais")
    end
end
addEvent ("paymentply_motorista", true)
addEventHandler ("paymentply_motorista", root, paymentply_motorista)

addCommandHandler("cancel",
function(ply,cmd)
    if getElementData(ply,"comrota") then
        setElementData(ply,"comrota",nil)
        triggerClientEvent(ply, "destroymissionmotoriasta", ply)
        exports.an_infobox:addNotification(ply,"Você cancelou a <b>rota</b>","info")
    end
end
)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------