---------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
---------------------------------------------------------------------------------------------------------------------------------------
local configtable = cfg.locals
local objects = {}
local objects2 = {}
local timerrepos = {}
local repostimer = 60
local timertorobb = 120
local recent = false
---------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN OBJ
---------------------------------------------------------------------------------------------------------------------------------------
function startandspawnobj()
    for _, v in pairs(configtable) do
        objects[v.ID] = createObject(2332 , v.OBJX, v.OBJY, v.OBJZ, 0, 0, v.OBJR)
    end
end
addEventHandler('onResourceStart',root, startandspawnobj)

function requeststartrobbloja(ply, loja)
    if loja then
        local policeinservice = exports.an_police:getpoliceinservicesv()
        if policeinservice >= 0 then
				print('1')
            if isElement(objects[loja.ID]) and not isElement(objects2[loja.ID]) then
				print('2')
                if not isTimer(recent) then
				print('3')
                    triggerClientEvent( ply, 'startrobloja', ply, loja)
                    recent = setTimer(function()
                    end,1000*timertorobb,1)
                else
                    exports.an_infobox:addNotification(ply, "Este cofre não tem <b>dinheiro</b>", "aviso", 100)
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>policiais</b> no momento","aviso")
        end
    end
end
addEvent("requeststartrobbloja", true)
addEventHandler('requeststartrobbloja', root, requeststartrobbloja)

function robblojaalert(ply, loja, typ)
    if loja then
        if typ == 1 then
            local plyid = getElementData(ply, 'id')
            exports.an_emergencycall:createemgblipsv(plyid,loja.OBJX, loja.OBJY, loja.OBJZ,"Estão <b>tentando</b> invadir o sistema da <b>loja "..loja.ID.."</b>, <br>vá até o local e verifique.")
        elseif typ == 2 then
            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** `Está roubando a loja "..loja.ID.."`!")
            exports.an_wanted:setplywanted(ply,30)
            local plyid = getElementData(ply, 'id')
            exports.an_emergencycall:createemgblipsv(plyid,loja.OBJX, loja.OBJY, loja.OBJZ,"O sistema da <b>loja "..loja.ID.."</b> foi invadido, <br>vá até o local e verifique.")
        end
    end
end
addEvent("robblojaalert", true)
addEventHandler('robblojaalert', root, robblojaalert)

---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
function startrobbloja(ply, loja)
    if loja then
        destroyElement(objects[loja.ID])
        objects2[loja.ID] = createObject(1829 , loja.OBJREP, loja.OBJREP2, loja.OBJZ, 0, 0, loja.OBJR)
        local x, y ,z = unpack(loja.MONEY)
        triggerEvent("drop2", ply, ply, toJSON({x, y ,z}), 'Money', math.random(9000,14000))
        timertorobloja(loja)
    end
end
addEvent("startrobbloja", true)
addEventHandler('startrobbloja', root, startrobbloja)

function timertorobloja(loja)
    if loja then
        timerrepos[loja.ID] = setTimer(function()
            if isElement(objects2[loja.ID]) then
                destroyElement(objects2[loja.ID])
                objects[loja.ID] = createObject(2332 , loja.OBJX, loja.OBJY, loja.OBJZ, 0, 0, loja.OBJR)
            end
        end,60000*repostimer,1)
    end
end
---------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------
