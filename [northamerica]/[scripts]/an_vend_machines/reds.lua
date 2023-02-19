------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
------------------------------------------------------------------------------------------------------------------------
local objects = {
    {955, 'Sprunk', 50},
    {1775, 'Sprunk', 50},
    {2452, 'Sprunk', 50},
    {2500, 'Sprunk', 50},
    {1776, 'Cerealbar', 40},
}
------------------------------------------------------------------------------------------------------------------------
-- COMMAND
------------------------------------------------------------------------------------------------------------------------
addCommandHandler("buy",
function(ply,cmd,am)
    local machine = getProxyMachine(ply,3)
    if machine then
        local amount = 1
        if am then
            amount = am
        end
        if getElementData(ply, 'Money') >= objects[machine][3]*amount then
            local idata = exports.an_account:servergetitemtable2(objects[machine][2])
            if idata then
                if getElementData(ply, "MocSlot") + idata[4]*amount < getElementData(ply, "MocMSlot") then
                    exports.an_inventory:sattitem(ply, idata[2], amount, "mais")
                    exports.an_inventory:sattitem(ply, 'Money', objects[machine][3]*amount, "menos")
                else
                    exports.an_infobox:addNotification(ply, "<b>Mochila</b> sem espaço", "aviso", 500)
                end
            end
        else
            exports.an_infobox:addNotification(ply, "Você não tem $<b>"..objects[machine][3]*amount.."</b>", "aviso", 500)
        end
    end
end
)
------------------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
------------------------------------------------------------------------------------------------------------------------
function getProxyMachine(ply,distance)
    local px, py, pz = getElementPosition (ply) 
	local dist = distance
    local id = false
    for _, v in ipairs (getElementsByType('Object')) do 
        local model = getElementModel(v)
        local x, y, z = getElementPosition(v)
        for i, vobj in ipairs (objects) do 
            if model == vobj[1] then
                local objid = unpack(vobj)
                if getDistanceBetweenPoints3D ( x, y, z, px, py, pz ) < dist then
                    dist = getDistanceBetweenPoints3D ( x, y, z, px, py, pz )
                    id = i
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
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------