---------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
---------------------------------------------------------------------------------------------------------
local objecttable = cfg.locals

local CowObject = {}
---------------------------------------------------------------------------------------------------------
-- SCRIPT
---------------------------------------------------------------------------------------------------------
function servergetjobleiteirotable()
	return objecttable
end

function createCowObject()
    for _, v in ipairs (cfg.locals) do 
        local id, x, y, z, rx, ry, rz = unpack(v)
        CowObject[id] = createObject(16442, x, y, z)
        setObjectScale(CowObject[id],0.5)
        setElementCollisionsEnabled(CowObject[id], false)
        setElementRotation(CowObject[id], rx, ry, rz)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createCowObject)


function finishLeiteiroJob(ply,qtd)
    if qtd then
        local idata = exports.an_account:servergetitemtable2("Garrafacleite")
        if idata then
            if getElementData(ply,idata[2]) >= qtd then
                local pay = math.random( 100, 300 )
                exports.an_inventory:sattitem(ply,idata[2],qtd,"menos")
                exports.an_inventory:sattitem(ply,"Money",pay*qtd,"mais")
            else
                exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x <b>"..idata[5].."</b>","erro")
            end
        end
    end
end
addEvent("finishLeiteiroJob", true)
addEventHandler("finishLeiteiroJob", root, finishLeiteiroJob)
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------