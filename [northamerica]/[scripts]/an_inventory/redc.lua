----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
local itemtb = exports.an_account:getitemtable3()
----------------------------------------------------------------------------------------------------------------
-- ui
----------------------------------------------------------------------------------------------------------------
function createhtmlinv1()
    webBrowser = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    htmlinvpanel = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmlinvpanel, loadinv1)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadinv1()
    loadBrowserURL(htmlinvpanel, "http://mta/local/html/panel.html")
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function createhtmlinv2()
    webBrowser2 = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    htmlinvpanel2 = guiGetBrowser(webBrowser2)
    addEventHandler("onClientBrowserCreated", htmlinvpanel2, loadinv2)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadinv2()
    loadBrowserURL(htmlinvpanel2, "http://mta/local/html/panel2.html")
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function createhtmlinv3()
    webBrowser3 = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    htmlinvpanel3 = guiGetBrowser(webBrowser3)
    addEventHandler("onClientBrowserCreated", htmlinvpanel3, loadinv3)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadinv3()
    loadBrowserURL(htmlinvpanel3, "http://mta/local/html/panel3.html")
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local vehicleonlook = false
local lookAtVehicle = nil
local lookatchest = false

function opneinv()
    if (not isElement(webBrowser)) and (not isElement(webBrowser2)) and (not isElement(webBrowser3)) then
        if getElementData(localPlayer,"openui") == false then
            createhtmlinv1()
            focusBrowser(htmlinvpanel)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    else
        if isElement(webBrowser) then
            guiSetVisible(webBrowser, false)
            destroyElement(webBrowser)
            showCursor(false)
            setElementData(localPlayer,"openui",false)
        end
    end
end
bindKey("k", "down", opneinv)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function opentrunk()
        if (not isPedInVehicle(localPlayer)) then
            if not getElementData(localPlayer,"logado") then return end
              lookAtVehicle = getPedTarget(localPlayer)
                if (lookAtVehicle) and (not (lookatchest)) and (getElementType(lookAtVehicle)=="vehicle")then
                local vx, vy, vz = getElementPosition(lookAtVehicle)
                local px, py, pz = getElementPosition(localPlayer)
                local distplayers = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz);
                if (distplayers < 8) then
                    if (not isElement(webBrowser2)) and (not isElement(webBrowser)) then
                        if getElementData(lookAtVehicle,"mala") then
                            if not isVehicleLocked( lookAtVehicle ) then
                                if getVehicleDoorOpenRatio (lookAtVehicle, 1 ) == 0 then
                                    if getElementData(localPlayer,"openui") == false then
                                        vehicleonlook = lookAtVehicle
                                        createhtmlinv2()
                                        focusBrowser(htmlinvpanel2)
                                        guiSetVisible(webBrowser2, true)
                                        showCursor(true)
                                        setElementFrozen(localPlayer,true)
                                        setElementData(localPlayer,"openui",true)
                                        triggerServerEvent( "abriuptmalafnc", localPlayer,localPlayer,vehicleonlook,1)
                                    end
                                else
                                    exports.an_infobox:addNotification("O <b>porta</b> malas está em uso","erro")
                                end
                            else
                                exports.an_infobox:addNotification("O <b>veiculo</b> está trancado","erro")
                            end
                        else
                            exports.an_infobox:addNotification("Não e possivel usar porta-malas de veiculos <b>alugados</b>","erro")
                        end
                    else
                        if isElement(webBrowser2) then
                            setElementFrozen(localPlayer,false)
                            guiSetVisible(webBrowser2, false)
                            destroyElement(webBrowser2)
                            showCursor(false)
                            setElementData(localPlayer,"openui",false)
                            triggerServerEvent( "abriuptmalafnc", localPlayer,localPlayer,vehicleonlook,2)
                            vehicleonlook = false
                        end
                    end
                end
            end
        end
end
bindKey("i", "down", opentrunk)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function closeinv()
    if (isElement(webBrowser)) and (not isElement(webBrowser2)) then
        guiSetVisible(webBrowser, false)
        destroyElement(webBrowser)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
addEvent ("closeinv", true)
addEventHandler ("closeinv", root, closeinv)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function closetrunk()
    if isElement(webBrowser2) and (not isElement(webBrowser)) then
        setElementFrozen(localPlayer,false)
        guiSetVisible(webBrowser2, false)
        destroyElement(webBrowser2)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        triggerServerEvent( "abriuptmalafnc", localPlayer,localPlayer,vehicleonlook,2)
        vehicleonlook = false
    end
end
addEvent ("closetrunk", true)
addEventHandler ("closetrunk", root, closetrunk)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function requestinvinfo()
    if isElement(webBrowser) and (not isElement(webBrowser2)) then
        execute(string.format("clearallitens()"))
        local plyslot = math.round(getElementData(localPlayer,"MocSlot"))
        local plymslot = getElementData(localPlayer,"MocMSlot")
        execute(string.format("addinvinfos(%s,%s)",toJSON(plyslot),toJSON(plymslot)))
        for i,v in ipairs (itemtb) do
            local getplydata = getElementData(localPlayer, v[2]) or 0
            if getplydata >= 1 then
               -- setTimer(function()
                    if isElement(webBrowser) and (not isElement(webBrowser2)) then
                        execute(string.format("additem(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                    end
               -- end,i*5,1)
            end
        end
    end
end
addEvent ("requestinvinfo", true)
addEventHandler ("requestinvinfo", root, requestinvinfo)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function requestinvinfo2()
    if isElement(webBrowser2) and (not isElement(webBrowser)) then
        execute(string.format("clearallitens2()"))
        execute(string.format("clearallitenstrunk()"))
        for i,v in ipairs (itemtb) do
            local getplydata = getElementData(localPlayer, v[2]) or 0
            if getplydata >= 1 then
                --setTimer(function()
                    if isElement(webBrowser2) then
                        execute(string.format("additemontrunk(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                    end
                --end,i*10,1)
            end
            local getvehdata = getElementData(lookAtVehicle, v[2]) or 0
            if getvehdata >= 1 then
                --setTimer(function()
                    if isElement(webBrowser2) then
                        execute(string.format("opentrunk(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getvehdata),toJSON(v[1]),toJSON(math.round(v[4]*getvehdata,1))))
                    end
                --end,i*10,1)
            end
        end
        local plyslot = tonumber(getElementData(localPlayer,"MocSlot"))
        local plymslot = getElementData(localPlayer,"MocMSlot")
        execute(string.format("addinvinfos2(%s,%s)",toJSON(math.round(plyslot,1)),toJSON(plymslot)))
        local chest = tonumber(getElementData(lookAtVehicle,"usedslots"))
        local chest2 = getElementData(lookAtVehicle,"mala")
        execute(string.format("addinvinfosveh(%s,%s)",toJSON(math.round(chest,1)),toJSON(chest2)))
    end
end
addEvent ("requestinvinfo2", true)
addEventHandler ("requestinvinfo2", root, requestinvinfo2)
----------------------------------------------------------------------------------------------------------------
-- js functions
----------------------------------------------------------------------------------------------------------------
local usertimer = nil
function useritemclient(data,data2)
    if data then
        if data2 then
            for i,v in ipairs (itemtb) do
                if tonumber(data) == v[1] then
                    local getplydata = getElementData(localPlayer, v[2]) or 0
                    if getplydata >= 1 then
                        triggerServerEvent( "useitems", localPlayer,localPlayer,v[1])
                    end
                end
            end
        end
    end
end
addEvent ("useritemclient", true)
addEventHandler ("useritemclient", root, useritemclient)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function dropitemclient(data,data2)
    if data then
        if data2 then
            triggerServerEvent( "soltitem", localPlayer,localPlayer,tonumber(data),tonumber(data2))
        end
    end
end
addEvent ("dropitemclient", true)
addEventHandler ("dropitemclient", root, dropitemclient)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function giveitemclient(data,data2)
    if data then
        if data2 then
            triggerServerEvent( "envitem", localPlayer,localPlayer,tonumber(data),tonumber(data2))
        end
    end
end
addEvent ("giveitemclient", true)
addEventHandler ("giveitemclient", root, giveitemclient)
----------------------------------------------------------------------------------------------------------------
--                                                  TRUNK
----------------------------------------------------------------------------------------------------------------
function colocItemtigger(data,data2)
    if data then
        if data2 then
            if isElement(webBrowser2) then
                triggerServerEvent( "addptmitem", localPlayer,localPlayer,lookAtVehicle,tonumber(getElementData(lookAtVehicle,"id")),tonumber(data),tonumber(data2))
            elseif isElement(webBrowser3) then
                triggerServerEvent( "addchest", localPlayer,localPlayer,lookatchest,tonumber(data),tonumber(data2))
            end
        end
    end
end
addEvent ("colocItemtigger", true)
addEventHandler ("colocItemtigger", root, colocItemtigger)
----------------------------------------------------------------------------------------------------------------
function pegItemtigger(data,data2)
    if data then
        if data2 then
            if  isElement(webBrowser2) then
                triggerServerEvent( "removeptmitem", localPlayer,localPlayer,lookAtVehicle,tonumber(getElementData(lookAtVehicle,"id")),tonumber(data),tonumber(data2))
            elseif  isElement(webBrowser3) then
                triggerServerEvent( "removechest", localPlayer,localPlayer,lookatchest,tonumber(data),tonumber(data2))
            end
        end
    end
end
addEvent ("pegItemtigger", true)
addEventHandler ("pegItemtigger", root, pegItemtigger)
----------------------------------------------------------------------------------------------------------------
-- return js messages
----------------------------------------------------------------------------------------------------------------
function sendmessage(data,typ)
    if typ then
        if data then
            exports.an_infobox:addNotification(data,typ)
        end
    end
end
addEvent ("sendmessage", true)
addEventHandler ("sendmessage", root, sendmessage)
----------------------------------------------------------------------------------------------------------------
--                                                  CHEST
----------------------------------------------------------------------------------------------------------------
function openchest()
    lookatchest = getproxychest(1.4)
    if lookatchest then
        if (not isElement(webBrowser)) and (not isElement(webBrowser2)) and (not isElement(webBrowser3)) then
            if not getElementData(lookatchest,"inuso") then
                if getElementData(localPlayer,"openui") == false then
                    createhtmlinv3()
                    focusBrowser(htmlinvpanel3)
                    guiSetVisible(webBrowser3, true)
                    showCursor(true)
                    setElementData(localPlayer,"openui",true)
                    setElementData(localPlayer,'chest', lookatchest)
                    setElementData(lookatchest,'inuso',true)
                end
            else
                exports.an_infobox:addNotification("<b>Armario</b> em uso","erro")
            end
        else
            if isElement(webBrowser3) then
                guiSetVisible(webBrowser3, false)
                destroyElement(webBrowser3)
                showCursor(false)
                setElementData(localPlayer,"openui",false)
                setElementData(getElementData(localPlayer,"chest"),'inuso', nil)
                setElementData(localPlayer,'chest',nil)
               -- setElementData(lookatchest,'inuso',false)
            end
        end
    end
end
bindKey("i", "down", openchest)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function requestinvinfo3()
    execute(string.format("clearallitens2()"))
    execute(string.format("clearallitenstrunk()"))
    for i,v in ipairs (itemtb) do
        local getplydata = getElementData(localPlayer, v[2]) or 0
        if getplydata >= 1 then
           -- setTimer(function()
                if isElement(webBrowser3) then
                    execute(string.format("additemontrunk(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                end
            --end,i*10,1)
        end
        local getvehdata = getElementData(lookatchest, v[2]) or 0
        if getvehdata >= 1 then
           -- setTimer(function()
                if isElement(webBrowser3) then
                    execute(string.format("opentrunk(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getvehdata),toJSON(v[1]),toJSON(math.round(v[4]*getvehdata,1))))
                end
            --end,i*10,1)
        end
    end
    local plyslot = tonumber(getElementData(localPlayer,"MocSlot"))
    local plymslot = getElementData(localPlayer,"MocMSlot")
    execute(string.format("addinvinfos2(%s,%s)",toJSON(math.round(plyslot,1)),toJSON(plymslot)))
    local chest = tonumber(getElementData(lookAtVehicle,"usedslots"))
    local chest2 = getElementData(lookAtVehicle,"maxslots")
    execute(string.format("addinvinfoschest(%s,%s)",toJSON(math.round(chest,1)),toJSON(chest2)))
end
addEvent ("requestinvinfo3", true)
addEventHandler ("requestinvinfo3", root, requestinvinfo3)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function closechest()
    if isElement(webBrowser3) and (not isElement(webBrowser)) and (not isElement(webBrowser2)) then
        setElementFrozen(localPlayer,false)
        guiSetVisible(webBrowser3, false)
        destroyElement(webBrowser3)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        setElementData(getElementData(localPlayer,"chest"),'inuso', nil)
        setElementData(localPlayer,'chest',nil)
    end
end
addEvent ("closechest", true)
addEventHandler ("closechest", root, closechest)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function getproxychest(distance)
    local x, y, z = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    local players = getElementsByType("object")
    for i, v in ipairs (players) do 
        if getElementData(v,"maxslots") then
            local tmodel = getElementModel(v)
            for i2, v2 in ipairs (cfg.armarioobjecttable) do
                local objid = unpack(v2)
                if tmodel == objid then
                    local pX, pY, pZ = getElementPosition (v)
                    local wpx, wpy, wpz = math.round ( pX, 3 ),math.round ( pY, 3 ),math.round ( pZ, 3 )
                    if getDistanceBetweenPoints3D ( wpx, wpy, wpz, x, y, z) < dist then
                        dist = getDistanceBetweenPoints3D ( wpx, wpy, wpz, x, y, z)
                        id = v
                    end
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
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
function attitem(item,qtd,spec)
    for i,v in ipairs (itemtb) do 
        if item == v[2] then
            if spec == "menos" then
                naitemnotify( v[5], v[1], qtd, '-', v[4])
                setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) - qtd)
                setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") - v[4]*qtd )
                triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                if getElementData(localPlayer,v[2]) <= 0 then
                    setElementData(localPlayer, v[2],0)
                    triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],0,"rem")
                end

            end
            if spec == "mais" then
                if getElementData(localPlayer,v[2]) >= 1 then
                    naitemnotify( v[5], v[1], qtd, '+', v[4])
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                    triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                elseif getElementData(localPlayer,v[2]) <= 0 or getElementData(localPlayer,v[2]) < 0 then
                    naitemnotify( v[5], v[1], qtd, '+', v[4])
                    triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],qtd,"add")
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                end
            end
            if isElement(webBrowser) then
                execute(string.format("clearallitens()"))
                for i,v in ipairs (itemtb) do
                    local getplydata = getElementData(localPlayer, v[2]) or 0
                    if getplydata >= 1 then
                        --setTimer(function()
                            if isElement(webBrowser) then
                                execute(string.format("attitens(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                            end
                        --end,i*10,1)
                    end
                end
                local plyslot = tonumber(getElementData(localPlayer,"MocSlot"))
                local plymslot = getElementData(localPlayer,"MocMSlot")
                execute(string.format("addinvinfos(%s,%s)",toJSON(math.round(plyslot,1)),toJSON(plymslot)))
            end
        end
    end
end
addEvent ("attitem", true)
addEventHandler ("attitem", root, attitem)

function attitem2(item,qtd,spec)
    for i,v in ipairs (itemtb) do 
        if item == v[2] then
            if spec == "menos" then
                setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) - qtd)
                setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") - v[4]*qtd )
                triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                if getElementData(localPlayer,v[2]) <= 0 then
                    setElementData(localPlayer, v[2],0)
                    triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],0,"rem")
                end

            end
            if spec == "mais" then
                if getElementData(localPlayer,v[2]) >= 1 then
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                    triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                elseif getElementData(localPlayer,v[2]) <= 0 or getElementData(localPlayer,v[2]) < 0 then
                    triggerServerEvent( "attitemdbitem", localPlayer,localPlayer,v[1],qtd,"add")
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                end
            end
            if isElement(webBrowser) then
                execute(string.format("clearallitens()"))
                for i,v in ipairs (itemtb) do
                    local getplydata = getElementData(localPlayer, v[2]) or 0
                    if getplydata >= 1 then
                        --setTimer(function()
                            if isElement(webBrowser) then
                                execute(string.format("attitens(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                            end
                       -- end,i*10,1)
                    end
                end
                local plyslot = tonumber(getElementData(localPlayer,"MocSlot"))
                local plymslot = getElementData(localPlayer,"MocMSlot")
                execute(string.format("addinvinfos(%s,%s)",toJSON(math.round(plyslot,1)),toJSON(plymslot)))
            end
        end
    end
end
addEvent ("attitem2", true)
addEventHandler ("attitem2", root, attitem2)
---------------------------------------------------------------------------------------------------------------
-- ATUALIZAR TRUNK ITEM
---------------------------------------------------------------------------------------------------------------
function attitemtrunk(item,qtd,spec)
    for i,v in ipairs (itemtb) do
        if item == v[2] then
            if spec == "menos" then
                naitemnotify( v[5], v[1], qtd, '-', v[4])
                setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) - qtd)
                setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") - v[4]*qtd )
                triggerServerEvent( "attitemdbitemtrunk", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                if getElementData(localPlayer,v[2]) <= 0 then
                    setElementData(localPlayer, v[2],0)
                    triggerServerEvent( "attitemdbitemtrunk", localPlayer,localPlayer,v[1],0,"rem")
                end
            end
            if spec == "mais" then
                if getElementData(localPlayer,v[2]) >= 1 then
                    naitemnotify( v[5], v[1], qtd, '+', v[4])
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                    triggerServerEvent( "attitemdbitemtrunk", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                elseif getElementData(localPlayer,v[2]) <= 0 then
                    naitemnotify( v[5], v[1], qtd, '+', v[4])
                    triggerServerEvent( "attitemdbitemtrunk", localPlayer,localPlayer,v[1],qtd,"add")
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                end

            end
            if isElement(webBrowser2) then
                execute(string.format("clearallitens2()"))
                execute(string.format("clearallitenstrunk()"))
                for i,v in ipairs (itemtb) do
                    local getplydata = getElementData(localPlayer, v[2]) or 0
                    if getplydata >= 1 then
                        --setTimer(function()
                            if isElement(webBrowser2) then
                                execute(string.format("attitens2(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                            end
                        --end,i*10,1)
                    end
                end
                for i,v in ipairs (itemtb) do
                    local getvehdata = getElementData(lookAtVehicle, v[2]) or 0
                    if getvehdata >= 1 then
                        --setTimer(function()
                            if isElement(webBrowser2) then
                                execute(string.format("attitenstrunk(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getvehdata),toJSON(v[1]),toJSON(math.round(v[4]*getvehdata,1))))
                            end
                        --end,i*10,1)
                    end
                end
                local plyslot = tonumber(getElementData(localPlayer,"MocSlot"))
                local plymslot = getElementData(localPlayer,"MocMSlot")
                execute(string.format("addinvinfos2(%s,%s)",toJSON(math.round(plyslot,1)),toJSON(plymslot)))
                local chest = tonumber(getElementData(lookAtVehicle,"usedslots"))
                local chest2 = getElementData(lookAtVehicle,"mala")
                execute(string.format("addinvinfosveh(%s,%s)",toJSON(math.round(chest,1)),toJSON(chest2)))
            end
        end
    end
end
addEvent ("attitemtrunk", true)
addEventHandler ("attitemtrunk", root, attitemtrunk)
---------------------------------------------------------------------------------------------------------------
-- ATUALIZAR TRUNK ITEM
---------------------------------------------------------------------------------------------------------------
function attitemchest(item,qtd,spec)
    for i,v in ipairs (itemtb) do
        if item == v[2] then
            if spec == "menos" then
                naitemnotify( v[5], v[1], qtd, '-', v[4])
                setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) - qtd)
                setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") - v[4]*qtd )
                    triggerServerEvent( "attitemdbitemchest", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                if getElementData(localPlayer,v[2]) <= 0 then
                    setElementData(localPlayer, v[2],0)
                    triggerServerEvent( "attitemdbitemchest", localPlayer,localPlayer,v[1],0,"rem")
                end

            end
            if spec == "mais" then
                if getElementData(localPlayer,v[2]) >= 1 then
                    naitemnotify( v[5], v[1], qtd, '+', v[4])
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                    triggerServerEvent( "attitemdbitemchest", localPlayer,localPlayer,v[1],getElementData(localPlayer, v[2]),"att")
                elseif getElementData(localPlayer,v[2]) <= 0 then
                    naitemnotify( v[5], v[1], qtd, '+', v[4])
                    triggerServerEvent( "attitemdbitemchest", localPlayer,localPlayer,v[1],qtd,"add")
                    setElementData(localPlayer, v[2], getElementData(localPlayer, v[2]) + qtd)
                    setElementData(localPlayer,"MocSlot", getElementData(localPlayer,"MocSlot") + v[4]*qtd )
                end

            end
            if isElement(webBrowser3) then
                execute(string.format("clearallitens2()"))
                execute(string.format("clearallitenstrunk()"))
                for i,v in ipairs (itemtb) do
                    local getplydata = getElementData(localPlayer, v[2]) or 0
                    if getplydata >= 1 then
                        --setTimer(function()
                            if isElement(webBrowser3) then
                                execute(string.format("attitens2(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
                            end
                        --end,i*10,1)
                    end
                end
                for i,v in ipairs (itemtb) do
                    local getvehdata = getElementData(lookAtVehicle, v[2]) or 0
                    if getvehdata >= 1 then
                        if isElement(webBrowser3) then
                            execute(string.format("attitenstrunk(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getvehdata),toJSON(v[1]),toJSON(math.round(v[4]*getvehdata,1))))
                        end
                    end
                end
                local plyslot = tonumber(getElementData(localPlayer,"MocSlot"))
                local plymslot = getElementData(localPlayer,"MocMSlot")
                execute(string.format("addinvinfos2(%s,%s)",toJSON(math.round(plyslot,1)),toJSON(plymslot)))
                local chest = tonumber(getElementData(lookAtVehicle,"usedslots"))
                local chest2 = getElementData(lookAtVehicle,"maxslots")
                execute(string.format("addinvinfoschest(%s,%s)",toJSON(math.round(chest,1)),toJSON(chest2)))
            end
        end
    end
end
addEvent ("attitemchest", true)
addEventHandler ("attitemchest", root, attitemchest)
---------------------------------------------------------------------------------------------------------------
-- DRINK EFFECT
---------------------------------------------------------------------------------------------------------------
local drinkeffecttimer = 0
local drinkeffect = false
function drinkeffect()
    local x,y,z = getElementPosition(localPlayer)
    setWindVelocity(x, y, z)
    drinkeffecttimer = 40
    drinkeffect = true
end
addEvent ("drinkeffect", true)
addEventHandler ("drinkeffect", root, drinkeffect)

function drinkeffecttimertread()
    if drinkeffect and drinkeffecttimer > 0 then
        drinkeffecttimer = drinkeffecttimer - 1
        if drinkeffecttimer <= 0 then
            drinkeffect = false
            setWindVelocity(0, 0, 0)
            triggerServerEvent( "setplydefaul", localPlayer,localPlayer)
        end
    end
setTimer(drinkeffecttimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), drinkeffecttimertread)
---------------------------------------------------------------------------------------------------------------
-- WEEED
---------------------------------------------------------------------------------------------------------------
local weedtimer = 0
local weedstart = false
function weedeffect()
    setSkyGradient( 0, 200, 0, 150, 0, 200 )
    local x,y,z = getElementPosition(localPlayer)
    setWindVelocity(x, y, z)
    setCameraGoggleEffect("nightvision")
    setGameSpeed(0.6)
    toggleControl ( "jump", false )
    weedtimer = 60
    weedstart = true
end
addEvent ("weedeffect", true)
addEventHandler ("weedeffect", root, weedeffect)

function weedtimertread()
    if weedstart and weedtimer > 0 then
        weedtimer = weedtimer - 1
        if weedtimer <= 0 then
            weedstart = false
            setGameSpeed(1)
            toggleControl ( "jump", true )
            resetFarClipDistance()
            setCameraTarget(localPlayer)
            setCameraGoggleEffect("normal")
            setWindVelocity(0, 0, 0)
            resetSkyGradient()
            triggerServerEvent( "setplydefaul", localPlayer,localPlayer)
        end
    end
setTimer(weedtimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), weedtimertread)
----------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------
function createhtmlitemnotify()
    naui = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    htmlnaui = guiGetBrowser(naui)
    addEventHandler("onClientBrowserCreated", htmlnaui, loaditemnotify)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), createhtmlitemnotify)

function loaditemnotify()
    loadBrowserURL(htmlnaui, "http://mta/local/html/inotify.html")
end

function naitemnotify( iname, id, qtd, typ, peso)
    if iname then
        if id then
            if qtd then
                if typ then
                    if typ then
                        notifyexecute(string.format("naitemnotify(%s,%s,%s,%s,%s)",toJSON(iname),toJSON(id),toJSON(qtd),toJSON(typ),toJSON(math.round(peso*qtd,1))))
                    end
                end
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
-- variaveis
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(htmlinvpanel, eval)
    elseif  isElement(webBrowser2) then
        executeBrowserJavascript(htmlinvpanel2, eval)
    elseif  isElement(webBrowser3) then
        executeBrowserJavascript(htmlinvpanel3, eval)
    end
end

function notifyexecute(aval)
    if isElement(naui) then
        executeBrowserJavascript(htmlnaui, aval)
    end
end
----------------------------------------------------------------------------------------------------------------
-- TRADDER
----------------------------------------------------------------------------------------------------------------
local lookattrade = false
local lookattradeType = false
function createtrade()
    naui_trade = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    nauihtml_trade = guiGetBrowser(naui_trade)
    addEventHandler("onClientBrowserCreated", nauihtml_trade, loadui)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadui()
    loadBrowserURL(nauihtml_trade, "http://mta/local/html/trade.html")
end

function toggletradde()
    if ( not isElement(naui_trade)) then
        if getElementData(localPlayer,"openui") == false then
            createtrade()
            focusBrowser(nauihtml_trade)
            guiSetVisible(naui_trade, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    else
        if (isElement(naui_trade)) then
            guiSetVisible(naui_trade, false)
            destroyElement(naui_trade)
            showCursor(false)
            setElementData(localPlayer,"openui",false)
        end
    end
end

function closetrader()
    if (isElement(naui_trade)) then
        guiSetVisible(naui_trade, false)
        destroyElement(naui_trade)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
addEvent ("closetrader", true)
addEventHandler ("closetrader", root, closetrader)


function requestinvtotrade()
    if (isElement(naui_trade)) then
        tradeexecute(string.format("clearallitenstrade()"))
        tradeexecute(string.format("clearallitenstrade2()"))
        for i,v in ipairs (itemtb) do
            local getplydata = getElementData(localPlayer, v[2]) or 0
            if getplydata >= 1 then
                --setTimer(function()
                    if (isElement(naui_trade)) then
                        tradeexecute(string.format("addplyitemtrade(%s,%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1)),toJSON(lookattradeType)))
                    end
                --end,i*10,1)
            end
        end
        for i,v in ipairs (itemtb) do
            for i2,v2 in ipairs (cfg.traderitens[lookattrade].item) do
                if v2.titem == v[2] then
                   -- setTimer(function()
                        if (isElement(naui_trade)) then
                            local itemreq = v2.titemreq.titemreqtext
                            tradeexecute(string.format("additemtrade(%s,%s,%s,%s,%s)",toJSON(v[5]),toJSON(itemreq),toJSON(v[1]),toJSON(v[4]),toJSON(lookattradeType)))
                        end
                    --end,i2*10,1)
                end
            end
        end
        local plyslot = math.round(getElementData(localPlayer,"MocSlot"))
        local plymslot = getElementData(localPlayer,"MocMSlot")
        tradeexecute(string.format("addtradeplyinfo(%s,%s)",toJSON(plyslot),toJSON(plymslot)))
    end
end
addEvent ("requestinvtotrade", true)
addEventHandler ("requestinvtotrade", root, requestinvtotrade)

function sellItemtrader(itemid,amonut)
    if itemid then
        if amonut then
            for i,v in ipairs (itemtb) do
                if tonumber(itemid) == v[1] then
                    for i2,v2 in ipairs (cfg.traderitens[lookattrade].item) do
                        if v2.titem == v[2] then
                            if (getElementData(localPlayer, v[2]) >= tonumber(amonut)) then
                                for _,rq in ipairs (v2.titemreq) do
                                    if rq[1] ~= nil then
                                        attitem(rq[2],rq[1]*amonut,"mais")
                                    end
                                end
                                attitem(v[2],amonut,"menos")
                                requestinvtotrade()
                            end
                        end
                    end
                end
            end
        end
    end
end
addEvent ("sellItemtrader", true)
addEventHandler ("sellItemtrader", root, sellItemtrader)

function buyItemtrader(itemid,amonut)
    if itemid then
        if amonut then
            for i,v in ipairs (itemtb) do
                if tonumber(itemid) == v[1] then
                    for i2,v2 in ipairs (cfg.traderitens[lookattrade].item) do
                        if v2.titem == v[2] then
                            if tonumber(getElementData(localPlayer, "MocSlot")) + tonumber(v[4]*amonut) < tonumber(getElementData(localPlayer, "MocMSlot")) then
                                if v2.titemreq[1][1] ~= nil and v2.titemreq[2][1] ~= nil and v2.titemreq[3][1] ~= nil and v2.titemreq[4][1] ~= nil and v2.titemreq[5][1] ~= nil then
                                    if (getElementData(localPlayer, v2.titemreq[1][2]) >= v2.titemreq[1][1]*amonut) and (getElementData(localPlayer, v2.titemreq[2][2]) >= v2.titemreq[2][1]*amonut) and (getElementData(localPlayer, v2.titemreq[3][2]) >= v2.titemreq[3][1]*amonut) and (getElementData(localPlayer, v2.titemreq[4][2]) >= v2.titemreq[4][1]*amonut) and (getElementData(localPlayer, v2.titemreq[5][2]) >= v2.titemreq[5][1]*amonut) then
                                        for _,rq in ipairs (v2.titemreq) do
                                            if rq[1] ~= nil then
                                                attitem(rq[2],rq[1]*amonut,"menos")
                                            end
                                        end
                                        attitem(v[2],amonut,"mais")
                                        requestinvtotrade()
                                    end
                                elseif v2.titemreq[1][1] ~= nil and v2.titemreq[2][1] ~= nil and v2.titemreq[3][1] ~= nil and v2.titemreq[4][1] ~= nil then
                                    if (getElementData(localPlayer, v2.titemreq[1][2]) >= v2.titemreq[1][1]*amonut) and (getElementData(localPlayer, v2.titemreq[2][2]) >= v2.titemreq[2][1]*amonut) and (getElementData(localPlayer, v2.titemreq[3][2]) >= v2.titemreq[3][1]*amonut) and (getElementData(localPlayer, v2.titemreq[4][2]) >= v2.titemreq[4][1]*amonut) then
                                        for _,rq in ipairs (v2.titemreq) do
                                            if rq[1] ~= nil then
                                                attitem(rq[2],rq[1]*amonut,"menos")
                                            end
                                        end
                                        attitem(v[2],amonut,"mais")
                                        requestinvtotrade()
                                    end
                                elseif v2.titemreq[1][1] ~= nil and v2.titemreq[2][1] ~= nil and v2.titemreq[3][1] ~= nil  then
                                    if (getElementData(localPlayer, v2.titemreq[1][2]) >= v2.titemreq[1][1]*amonut) and (getElementData(localPlayer, v2.titemreq[2][2]) >= v2.titemreq[2][1]*amonut) and (getElementData(localPlayer, v2.titemreq[3][2]) >= v2.titemreq[3][1]*amonut) then
                                        for _,rq in ipairs (v2.titemreq) do
                                            if rq[1] ~= nil then
                                                attitem(rq[2],rq[1]*amonut,"menos")
                                            end
                                        end
                                        attitem(v[2],amonut,"mais")
                                        requestinvtotrade()
                                    end
                                elseif v2.titemreq[1][1] ~= nil and v2.titemreq[2][1] ~= nil  then
                                    if (getElementData(localPlayer, v2.titemreq[1][2]) >= v2.titemreq[1][1]*amonut) and (getElementData(localPlayer, v2.titemreq[2][2]) >= v2.titemreq[2][1]*amonut) then
                                        for _,rq in ipairs (v2.titemreq) do
                                            if rq[1] ~= nil then
                                                attitem(rq[2],rq[1]*amonut,"menos")
                                            end
                                        end
                                        attitem(v[2],amonut,"mais")
                                        requestinvtotrade()
                                    end
                                elseif v2.titemreq[1][1] ~= nil  then
                                    if (getElementData(localPlayer, v2.titemreq[1][2]) >= v2.titemreq[1][1]*amonut) then
                                        for _,rq in ipairs (v2.titemreq) do
                                            if rq[1] ~= nil then
                                                attitem(rq[2],rq[1]*amonut,"menos")
                                            end
                                        end
                                        attitem(v[2],amonut,"mais")
                                        requestinvtotrade()
                                    end
                                end
                            else
                                exports.an_infobox:addNotification("A sua <b>mochila</b> está sem espaço.","aviso")
                            end
                        end
                    end
                end
            end
        end
    end
end
addEvent ("buyItemtrader", true)
addEventHandler ("buyItemtrader", root, buyItemtrader)

function attinventory()
    if (isElement(naui_trade)) then
        tradeexecute(string.format("clearallitenstrade()"))
        tradeexecute(string.format("clearallitenstrade2()"))
        for i,v in ipairs (itemtb) do
            local getplydata = getElementData(localPlayer, v[2]) or 0
            if getplydata >= 1 then
                tradeexecute(string.format("addplyitemtrade(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(math.round(v[4]*getplydata,1))))
            end
        end
        for i,v in ipairs (itemtb) do
            for i2,v2 in ipairs (cfg.traderitens[lookattrade].item) do
                if v2.titem == v[2] then
                    local itemreq = v2.titemreq.titemreqtext
                    tradeexecute(string.format("additemtrade(%s,%s,%s,%s)",toJSON(v[5]),toJSON(itemreq),toJSON(v[1]),toJSON(v[4])))
                end
            end
        end
        local plyslot = math.round(getElementData(localPlayer,"MocSlot"))
        local plymslot = getElementData(localPlayer,"MocMSlot")
        tradeexecute(string.format("addtradeplyinfo(%s,%s)",toJSON(plyslot),toJSON(plymslot)))
    end
end
addEvent ("attinventory", true)
addEventHandler ("attinventory", root, attinventory)
----------------------------------------------------------------------------------------------------------------
-- PROXY SYSTEM
----------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
    local proxyonply = getproxyonply(1)
    if proxyonply then
        for i, v in ipairs (cfg.tradelocals) do
            local id, x, y, z, typ = unpack(v) 
            if id == proxyonply then
                lookattrade = id
                lookattradeType = typ
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z-0.2, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    if getElementData(localPlayer,"openui") == false then
                        dxDrawColorText("#d6d6d6[N] : #3b8ff7ACESSAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                end
            end
        end
    else
        if lookattrade then
            lookattrade = false
            lookattradeType = false
        end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtoggletradde()
    if lookattrade then
        toggletradde()
    end
end
bindKey("n", "down", bindtoggletradde)

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (cfg.tradelocals) do 
        local tid, x, y, z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = tid
        end
    end
    if id then
        return id
    else
        return false
    end
end


function tradeexecute(aval)
    if isElement(naui_trade) then
        executeBrowserJavascript(nauihtml_trade, aval)
    end
end
---------------------------------------------------------------------------------------------------------
-- block key
---------------------------------------------------------------------------------------------------------
addEventHandler("onClientKey", root, 
function (button, press)
  if weedstart then
    if button == "lshift" or button == "rctrl"  then
    	cancelEvent()
    end
  end
end
)
----------------------------------------------------------------------------------------------------------------
-- variaveis
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(htmlinvpanel, eval)
    elseif  isElement(webBrowser2) then
        executeBrowserJavascript(htmlinvpanel2, eval)
    elseif  isElement(webBrowser3) then
        executeBrowserJavascript(htmlinvpanel3, eval)
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
----------------------------------------------------------------------------------------------------------------
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if 
        type( sEventName ) == 'string' and 
        isElement( pElementAttachedTo ) and 
        type( func ) == 'function' 
    then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
  
    return false
end
----------------------------------------------------------------------------------------------------------------
function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY)
  bx, by, color, scale, font = bx or ax, by or ay, color or tocolor(255,255,255,255), scale or 1, font or Font_5
  if alignX then
    if alignX == "center" then
      ax = ax + (bx - ax - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font))/2
    elseif alignX == "right" then
      ax = bx - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
    end
  end
  if alignY then
    if alignY == "center" then
      ay = ay + (by - ay - dxGetFontHeight(scale, font))/2
    elseif alignY == "bottom" then
      ay = by - dxGetFontHeight(scale, font)
    end
  end
   local clip = false
   if dxGetTextWidth(str:gsub("#%x%x%x%x%x%x","")) > bx then clip = true end
  local alpha = string.format("%08X", color):sub(1,2)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  local text = ""
  local broke = false
  while s do
    if cap == "" and col then color = tocolor(getColorFromString("#"..col..alpha)) end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
           if clip then
                local text_ = ""
                 for i = 1,string.len(cap) do
                  if dxGetTextWidth(text,scale,font) < bx then
                  text = text..""..string.sub(cap,i,i)
                  text_ = text_..""..string.sub(cap,i,i)
                  else
                  broke = true
                   break
                  end
                 end
                 cap = text_
                end
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(getColorFromString("#"..col..alpha))
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str and not broke then
    cap = str:sub(last)
                   if clip then
                local text_ = ""
                 for i = 1,string.len(cap) do
                  if dxGetTextWidth(text,scale,font) < bx then
                  text = text..""..string.sub(cap,i,i)
                  text_ = text_..""..string.sub(cap,i,i)
                  else
                  broke = true
                   break
                  end
                 end
                 cap = text_
                end
    dxDrawText(cap, ax, ay, ax + dxGetTextWidth(cap, scale, font), by, color, scale, font)
  end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------