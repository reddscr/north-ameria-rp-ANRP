------------------------------------------------------------------------------------------------------------------------
-- SIST
------------------------------------------------------------------------------------------------------------------------
local tunningtable = {
    [527] = { 
        [0] = {['Plastic'] = 10, ['Steel'] = 5, ['Iron'] = 2, ['Copper'] = 5},

    },
    [559] = { 
        [0] = {['Plastic'] = 3, ['Steel'] = 2, ['Iron'] = 1, ['Copper'] = 2},
        [1] = {['Plastic'] = 3, ['Steel'] = 2, ['Iron'] = 1, ['Copper'] = 2},
    },
    [565] = { 
        [0] = {['Plastic'] = 2, ['Steel'] = 1, ['Iron'] = 2, ['Copper'] = 3},
        [1] = {['Plastic'] = 4, ['Steel'] = 3, ['Iron'] = 2, ['Copper'] = 3},
        [2] = {['Plastic'] = 3, ['Steel'] = 3, ['Iron'] = 2, ['Copper'] = 3},
    },
    [541] = { 
        [0] = {['Plastic'] = 10, ['Steel'] = 5, ['Iron'] = 2, ['Copper'] = 5},
        [1] = {['Plastic'] = 4, ['Steel'] = 3, ['Iron'] = 2, ['Copper'] = 3},
        [2] = {['Plastic'] = 3, ['Steel'] = 3, ['Iron'] = 2, ['Copper'] = 3},
    },
    [415] = { 
        [0] = {['Plastic'] = 3, ['Steel'] = 3, ['Iron'] = 2, ['Copper'] = 3},
    },
    [506] = { 
        [0] = {['Plastic'] = 3, ['Steel'] = 3, ['Iron'] = 2, ['Copper'] = 3},
    },
    [555] = { 
        [0] = {['Plastic'] = 4, ['Steel'] = 1, ['Iron'] = 1, ['Copper'] = 1},
    },
    [562] = { 
        [0] = {['Plastic'] = 3, ['Steel'] = 2, ['Iron'] = 1, ['Copper'] = 2},
        [1] = {['Plastic'] = 10, ['Steel'] = 5, ['Iron'] = 2, ['Copper'] = 5},
    },
    [558] = { 
        [0] = {['Plastic'] = 3, ['Steel'] = 2, ['Iron'] = 1, ['Copper'] = 2},
    },
    [587] = { 
        [0] = {['Plastic'] = 3, ['Steel'] = 4, ['Iron'] = 2, ['Copper'] = 2},
    },

}

local userobject = {}
local usertimer = {}
addCommandHandler("body",
function(ply, cmd, numb)
    if exports.an_account:hasPermission( ply, 'westcoast.permission') then
        local proxy = getproxymechanic(ply,5)
        if proxy then
            local vehicl = exports.an_player:getproxveh(ply,3)
            if vehicl then
                local var1, var2 = getVehicleVariant(vehicl)
                local model = getElementModel(vehicl)
                if tunningtable[model] then
                    if numb then
                        local variant = tonumber(numb)
                        if var1 ~= variant and var1 ~= variant then
                            if tunningtable[model][variant] then
                                if (getElementData(ply, 'Plastic') >= tunningtable[model][variant].Plastic) and (getElementData(ply, 'Steel') >= tunningtable[model][variant].Steel) and (getElementData(ply, 'Iron') >= tunningtable[model][variant].Iron) and (getElementData(ply, 'Copper') >= tunningtable[model][variant].Copper) then
                                    exports.an_inventory:sattitem(ply,"Plastic",tunningtable[model][variant].Plastic,"menos")
                                    exports.an_inventory:sattitem(ply,"Steel",tunningtable[model][variant].Steel,"menos")
                                    exports.an_inventory:sattitem(ply,"Iron",tunningtable[model][variant].Iron,"menos")
                                    exports.an_inventory:sattitem(ply,"Copper",tunningtable[model][variant].Copper,"menos")
                                    setElementData(ply,"emacao",true)
                                    setPedAnimation( ply, "cop_ambient", "copbrowse_loop",-1,true,false,false,false)
                                    usertimer[ply] = setTimer(function()
                                        setPedAnimation( ply, nil)
                                        setElementData(ply,"emacao",false)
                                        setVehicleVariant( vehicl, variant, variant)
                                        setElementData( vehicl, "Variant", variant)
                                        exports.an_infobox:addNotification(ply,"Body kit aplicado no <b>Veículo</b>!","sucesso")
                                    end,1000*30,1)
                                else
                                    exports.an_infobox:addNotification(ply,"Você precisa ter <br><br>"..tunningtable[model][variant].Plastic.."x <b>Plastico</b><br>"..tunningtable[model][variant].Steel.."x <b>Aço</b><br>"..tunningtable[model][variant].Iron.."x <b>Ferro</b><br>"..tunningtable[model][variant].Copper.."x <b>Cobre</b><br><br>para colocar este body kit","aviso")
                                end
                            else
                                exports.an_infobox:addNotification(ply,"Body kit <b>indisponível</b>!","erro")
                            end
                        else
                            exports.an_infobox:addNotification(ply,"O veiculo ja está com este <b>body kit</b>!","erro")
                        end
                    else
                        triggerClientEvent( ply, "tunningrequeststart", ply, vehicl)
                    end
                end
            else
                exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
            end
        else
            exports.an_infobox:addNotification(ply,"Você precisa estar na <b>oficina</b>.","aviso")
        end
    end
end
)
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
function remTunningAcept(ply,veh)
    if veh then
        local variant = 255
        local var1, var2 = getVehicleVariant(veh)
        if var1 ~= variant and var1 ~= variant then
            setElementData(ply,"emacao",true)
            setPedAnimation( ply, "cop_ambient", "copbrowse_loop",-1,true,false,false,false)
            usertimer[ply] = setTimer(function()
                setPedAnimation( ply, nil)
                setElementData(ply,"emacao",false)
                
                setVehicleVariant( veh, variant, variant)
                setElementData( veh, "Variant", variant)
            end,1000*30,1)
        else
            exports.an_infobox:addNotification(ply,"Este <b>veiculo</b> não tem body kit!","erro")
        end
    end
end
addEvent ("remTunningAcept", true)
addEventHandler ("remTunningAcept", root, remTunningAcept)
------------------------------------------------------------------------------------------------------------------------
-- ATTACH
------------------------------------------------------------------------------------------------------------------------
function destroyAttachetobj(ply)
    if isElement(userobject[ply]) then
        exports.bone_attach:detachElementFromBone(userobject[ply])
        destroyElement(userobject[ply])
        userobject[ply] = nil
    end
end

function destroyOnQuit()
    if isElement(userobject[source]) then
        exports.bone_attach:detachElementFromBone(userobject[source])
        destroyElement(userobject[source])
        userobject[source] = nil
    end
end
addEventHandler ("onPlayerQuit", root, destroyOnQuit)
------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
------------------------------------------------------------------------------------------------------------------------
function getproxymechanic(ply,distance)
    local x, y, z = getElementPosition (ply) 
    local dist = distance
    local id = false
    for i, v in ipairs (cfg.mechaniclocal) do 
        local sid, sx, sy, sz = unpack(v)
        if getDistanceBetweenPoints3D (x, y, z, sx, sy, sz) < dist then
            dist = getDistanceBetweenPoints3D (x, y, z, sx, sy, sz)
            id = sid
        end
    end
    if id then
        return id
    else
        return false
    end
end

--- get next vehicle 2
function getproxveh(ply,distance)
    local x, y, z = getElementPosition (ply) 
    local dist = distance
    local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
        if ply ~= v then
            if getElementModel(v) ~= 578 then
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
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------