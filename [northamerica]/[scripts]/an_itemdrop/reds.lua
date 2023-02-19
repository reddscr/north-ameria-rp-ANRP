----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local itemdrop = {}
local objitemdrop = {}
--addCommandHandler("drop",
function drop(p,item,qtd)
    if item then
        if qtd then
            local itemdata = exports.an_account:servergetitemtable2(item)
            if itemdata then
                if getElementData(p,itemdata[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x<b> "..itemdata[5].."</b>","erro") end
                local x, y, z = getElementPosition(p)
                local rx,ry,rz = getElementRotation(p)
                local dim = getElementDimension(p)
                local int = getElementInterior(p)
                itemdrop[p] = createColSphere(x,y,z,0.6)
                objitemdrop[p] = createObject (2060,x,y,z-0.9,rx,ry,rz)
                attachElements(objitemdrop[p], itemdrop[p], 0, 0, -0.9)
                setElementData(itemdrop[p], "attachitemdrop", objitemdrop[p])
                setObjectScale(objitemdrop[p], 0.5)
                setElementCollisionsEnabled (objitemdrop[p], false)
                setElementDimension(itemdrop[p], dim)
                setElementInterior(itemdrop[p], int)
                setElementData(itemdrop[p], "itemdrop", itemdata[1])
                setElementData(itemdrop[p], "qtditemdrop", qtd)
                setElementData(itemdrop[p], "itemdropp", true)
                setElementData(itemdrop[p], "itemdroppcol", itemdrop[p])
                destroytimerelementdrop(itemdrop[p],objitemdrop[p])
            end
        end
    end
end
addEvent("drop", true)
addEventHandler("drop", root, drop)

function drop2(p,pos,item,qtd)
    if item then
        if qtd then
            if pos then
                local itemdata = exports.an_account:servergetitemtable2(item)
                if itemdata then
                    local dt = fromJSON(pos)
                    itemdrop[p] = createColSphere(dt[1],dt[2],dt[3],0.6)
                    objitemdrop[p] = createObject (2060,dt[1],dt[2],dt[3]-0.9)
                    attachElements(objitemdrop[p], itemdrop[p], 0, 0, -0.9)
                    setElementData(itemdrop[p], "attachitemdrop", objitemdrop[p])
                    setObjectScale(objitemdrop[p], 0.5)
                    setElementCollisionsEnabled (objitemdrop[p], false)
                    setElementData(itemdrop[p], "itemdrop", itemdata[1])
                    setElementData(itemdrop[p], "qtditemdrop", qtd)
                    setElementData(itemdrop[p], "itemdropp", true)
                    setElementData(itemdrop[p], "itemdroppcol", itemdrop[p])
                    destroytimerelementdrop(itemdrop[p],objitemdrop[p])
                end
            end
        end
    end
end
addEvent("drop2", true)
addEventHandler("drop2", root, drop2)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destroytimerelementdrop(drop,obj)
    if isElement(drop) then
        timerprogbr = setTimer(
        function()
            if isElement(drop) then
                destroyElement(drop)
                destroyElement(obj)
            end
        end,600000,1)
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function giveanddestroyobjdropsv(thePlayer,coltarget,item,qtd)
    local itemdata = exports.an_account:servergetitemtable(item)
    if isElement(coltarget) then
        if item then
            --for i,v in ipairs (cfg.items) do
                if item == itemdata[1] then
                    if getElementData(thePlayer, "MocSlot") + itemdata[4]*qtd < getElementData(thePlayer, "MocMSlot") then
                        local getattach = getElementData(coltarget, "attachitemdrop")
                        destroyElement(getattach)
                        destroyElement(coltarget)
                        exports.an_inventory:sattitem(thePlayer,itemdata[2],qtd,"mais")
                        triggerEvent("sendnorthamericalog", thePlayer, thePlayer,"**"..getElementData ( thePlayer, "id" ).." - "..getElementData ( thePlayer, "Nome" ).." "..getElementData ( thePlayer, "SNome" ).."** pegou "..qtd.."x "..itemdata[5].." do chão")
                    else
                        exports.an_infobox:addNotification(thePlayer,"A <b>mochila</b> está sem espaço","erro")
                    end
                end
           -- end
        end
    end
end
addEvent("giveanddestroyobjdropsv", true)
addEventHandler("giveanddestroyobjdropsv", root, giveanddestroyobjdropsv)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------