----------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )


----------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
----------------------------------------------------------------------------------------------------------------
local cartable = cfg.cars
local biketable = cfg.bikes
local trucktable = cfg.truck
local vehiclestable = cfg.vehicles
----------------------------------------------------------------------------------------------------------------
-- NUI
----------------------------------------------------------------------------------------------------------------
function createhtmlnui()
    wnui = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlnui = guiGetBrowser(wnui)
    addEventHandler("onClientBrowserCreated", htmlnui, load_dealership)
end

function load_dealership ()
    loadBrowserURL(htmlnui, "http://mta/local/nui/dealership/nui.html")  
end

function dxpressforpanel()
    local proxyonply = getproxyonply(1.3)
    if proxyonply then
        for i, v in ipairs (cfg.localshop) do 
          local id, x, y, z = unpack(v)
            if id == proxyonply then
                lookatDealership = id
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.1, 0.07)
                if (WorldPositionX and WorldPositionY) then
                  if getElementData(localPlayer,"openui") == false then
                    dxDrawColorText("#efe558N #d6d6d6ACESSAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                  end
                end
            end
        end
    else
      if lookatDealership then
        lookatDealership = false
      end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function toggleDealership()
    if not isElement(wnui) then
        if getElementData(localPlayer,"openui") == false then
            createhtmlnui()
            focusBrowser(htmlnui)
            guiSetVisible(wnui, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end

function bindtoggleDealership()
  if lookatDealership then
    if not isPedInVehicle(localPlayer) then
        triggerServerEvent( "getdealershipvehicles", localPlayer,localPlayer)
        triggerServerEvent( "getplyvehicles", localPlayer,localPlayer)
        toggleDealership()
    end
  end
end
bindKey("n", "down", bindtoggleDealership)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function requestcars()
    if (isElement(wnui)) then
        for _,r in next, vehiclestable do 
            for _,v in next, cartable do
                if r.id == v.id then
                    local vehicles = getElementData(localPlayer,"dealershipvehicles")
                    local i=0 
                    if vehicles and type(vehicles) == "table" then
                        for _,de in ipairs (vehicles) do
                            if tonumber(r.id) == de["Model"] then
                                i=i+1
                                if i <= 0 then
                                    i = 0
                                end
                            end
                        end
                    end
                    local stockcount = r.stock-i
                    if stockcount <= 0 then
                        stockcount = 0
                    end
                    executeBrowserJavascript(htmlnui,string.format("loadcars(%s,%s,%s,%s,%s,%s)",toJSON(r.id),toJSON(r.name),toJSON(r.value),toJSON(r.trunk),toJSON(stockcount),toJSON(r.tax)))
                end
            end
        end
    end
end
addEvent ("requestcars", true)
addEventHandler ("requestcars", root, requestcars)

function requestbikes()
    if (isElement(wnui)) then
        for _,r in next, vehiclestable do 
            for _,v in next, biketable do
                if r.id == v.id then
                    local vehicles = getElementData(localPlayer,"dealershipvehicles")
                    local i=0 
                    if vehicles and type(vehicles) == "table" then
                        for _,de in ipairs (vehicles) do
                            if tonumber(r.id) == de["Model"] then
                                i=i+1
                                if i <= 0 then
                                    i = 0
                                end
                            end
                        end
                    end
                    local stockcount = r.stock-i
                    if stockcount <= 0 then
                        stockcount = 0
                    end
                    executeBrowserJavascript(htmlnui,string.format("loadcars(%s,%s,%s,%s,%s,%s)",toJSON(r.id),toJSON(r.name),toJSON(r.value),toJSON(r.trunk),toJSON(stockcount),toJSON(r.tax)))
                end
            end
        end
    end
end
addEvent ("requestbikes", true)
addEventHandler ("requestbikes", root, requestbikes)

function requesttruck()
    if (isElement(wnui)) then
        for _,r in next, vehiclestable do 
            for _,v in next, trucktable do
                if r.id == v.id then
                    local vehicles = getElementData(localPlayer,"dealershipvehicles")
                    local i=0 
                    if vehicles and type(vehicles) == "table" then
                        for _,de in ipairs (vehicles) do
                            if tonumber(r.id) == de["Model"] then
                                i=i+1
                                if i <= 0 then
                                    i = 0
                                end
                            end
                        end
                    end
                    local stockcount = r.stock-i
                    if stockcount <= 0 then
                        stockcount = 0
                    end
                    executeBrowserJavascript(htmlnui,string.format("loadcars(%s,%s,%s,%s,%s,%s)",toJSON(r.id),toJSON(r.name),toJSON(r.value),toJSON(r.trunk),toJSON(stockcount),toJSON(r.tax)))
                end
            end
        end
    end
end
addEvent ("requesttruck", true)
addEventHandler ("requesttruck", root, requesttruck)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function requestuserveh()
    if (isElement(wnui)) then
        local vehicles = getElementData(localPlayer,"playervehicles")
        if vehicles and type(vehicles) == "table" then
            for i,v in ipairs (vehicles) do
                local data = getVehicleData(v["Model"])
                local id = tonumber(v["id"])
                local Arrested = v["Arrested"]
                local value = math.percent(80,data.value)
                if data then
                    if Arrested <= 0 then
                        executeBrowserJavascript(htmlnui,string.format("loaduserveh(%s,%s,%s)",toJSON(id),toJSON(data.name),toJSON(value)))
                    end
                end
            end
        end
    end
end
addEvent ("requestuserveh", true)
addEventHandler ("requestuserveh", root, requestuserveh)
----------------------------------------------------------------------------------------------------------------
-- CLOSe
----------------------------------------------------------------------------------------------------------------
function closenewdealership()
    if (isElement(wnui)) then
        guiSetVisible(wnui, false)
        destroyElement(wnui)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
addEvent ("closenewdealership", true)
addEventHandler ("closenewdealership", root, closenewdealership)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function buynewvehicleintheshop(data)
    if tonumber(data) then
        triggerServerEvent( "buyvehicleondealership", localPlayer,localPlayer,tonumber(data))
    end
end
addEvent ("buynewvehicleintheshop", true)
addEventHandler ("buynewvehicleintheshop", root, buynewvehicleintheshop)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function sellmyvehfortheshop(data)
    local vdata = tostring(data)
    if vdata then
        triggerServerEvent( "sellvehindealership", localPlayer,localPlayer,tonumber(vdata))
    end
end
addEvent ("sellmyvehfortheshop", true)
addEventHandler ("sellmyvehfortheshop", root, sellmyvehfortheshop)
----------------------------------------------------------------------------------------------------------------
-- GERENCIAMENTO
----------------------------------------------------------------------------------------------------------------
function chatevehgerencipanel()
    webBrowservehgerenci = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlvehgerenci = guiGetBrowser(webBrowservehgerenci)
    addEventHandler("onClientBrowserCreated", htmlvehgerenci, loadvehgerenci)
end

function loadvehgerenci()
    loadBrowserURL(htmlvehgerenci, "http://mta/local/nui/gerenc/nui.html")
end

function openvehgerenciament()
    if (not isElement(webBrowservehgerenci)) then
        if getElementData(localPlayer,"openui") == false then
            chatevehgerencipanel()
            focusBrowser(htmlvehgerenci)
            guiSetVisible(webBrowservehgerenci, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end
addEvent ("openvehgerenciament", true)
addEventHandler ("openvehgerenciament", root, openvehgerenciament)

function closebindvehgerenci()
    if isElement(webBrowservehgerenci) then
        executeBrowserJavascript(htmlvehgerenci,string.format("close()"))
        guiSetVisible(webBrowservehgerenci, false)
        destroyElement(webBrowservehgerenci)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
bindKey("n", "down", closebindvehgerenci)

function closevehgerenci()
    if (isElement(webBrowservehgerenci)) then
        executeBrowserJavascript(htmlvehgerenci,string.format("close()"))
        guiSetVisible(webBrowservehgerenci, false)
        destroyElement(webBrowservehgerenci)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
addEvent ("closevehgerenci", true)
addEventHandler ("closevehgerenci", root, closevehgerenci)

function addcarsvehgerenci()
    executeBrowserJavascript(htmlvehgerenci,string.format("clearallvehgerenci2()"))
    local vehicles = getElementData(localPlayer,"playervehicles")
    if vehicles and type(vehicles) == "table" then
        for i,v in ipairs (vehicles) do
            local data = getVehicleData(v["Model"])
            local id = tonumber(v["id"])
            local vmaladt = tonumber(v["Mala"]) or 0
            local usedvmaladt = tonumber(v["usedslots"]) or 0
            local vehplate = v["Number"]
            local vehtax = v["vehtaxstatus"]
            if vehtax then
                if vehtax >= 1 then
                    tax = 'pendente'
                else
                    tax = 'pago'
                end
            else
                tax = 'pago'
            end
            local Arrested = tonumber(v["Arrested"])
            if Arrested >= 1 then
                ARE = 'Veículo <s>apreendido</s>'
            else
                ARE = ' '
            end
            executeBrowserJavascript(htmlvehgerenci,string.format("addvehgerencicars(%s,%s,%s,%s,%s,%s)",toJSON(id),toJSON(data.name),toJSON(tostring((math.round(usedvmaladt).."/"..vmaladt))),toJSON(tax),toJSON(vehplate),toJSON(ARE)))
        end
    end
end
addEvent ("addcarsvehgerenci", true)
addEventHandler ("addcarsvehgerenci", root, addcarsvehgerenci)
----------------------------------------------------------------------------------------------------------------
-- GARAGE
----------------------------------------------------------------------------------------------------------------
local housegarageid = false
function chategaragepanel()
    webBrowsergarage = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlgarage = guiGetBrowser(webBrowsergarage)
    addEventHandler("onClientBrowserCreated", htmlgarage, loadgarage)
end

function loadgarage()
    loadBrowserURL(htmlgarage, "http://mta/local/nui/garage/nui.html")
end

function opengarage()
    if (not isElement(webBrowsergarage)) then
        if getElementData(localPlayer,"openui") == false then
            triggerServerEvent( "getplyvehicles", localPlayer,localPlayer)
            chategaragepanel()
            focusBrowser(htmlgarage)
            guiSetVisible(webBrowsergarage, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end

function closebindgarage()
    if isElement(webBrowsergarage) then
        execute(string.format("close()"))
        guiSetVisible(webBrowsergarage, false)
        destroyElement(webBrowsergarage)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        housegarageid = false
    end
end
bindKey("n", "down", closebindgarage)

function closegarage()
    if (isElement(webBrowsergarage)) then
        guiSetVisible(webBrowsergarage, false)
        destroyElement(webBrowsergarage)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        housegarageid = false
    end
end
addEvent ("closegarage", true)
addEventHandler ("closegarage", root, closegarage)

function addcarsgarage()
    executeBrowserJavascript(htmlgarage,string.format("clearallgarage2()"))
    local vehicles = getElementData(localPlayer,"playervehicles")
    if vehicles and type(vehicles) == "table" then
        for i,v in ipairs (vehicles) do
            local data = getVehicleData(v["Model"])
            local id = tonumber(v["id"])
            local vmaladt = tonumber(v["Mala"]) or 0
            local usedvmaladt = tonumber(v["usedslots"]) or 0
            local vehplate = v["Number"]
            local vehtax = v["vehtaxstatus"]
            local gr = v["garageid"]
            local Arrested = v["Arrested"]
            if vehtax and vehtax >= 1 then
                tax = 'pendente'
            else
                tax = 'pago'
            end
            local veh = findVeh(id)
            if not isElement(veh) then
                if Arrested <= 0 then
                    executeBrowserJavascript(htmlgarage,string.format("addgaragecars(%s,%s,%s,%s,%s)",toJSON(id),toJSON(data.name),toJSON(tostring((math.round(usedvmaladt).."/"..vmaladt))),toJSON(tax),toJSON(vehplate)))
                end
            end
        end
    end
end
addEvent ("addcarsgarage", true)
addEventHandler ("addcarsgarage", root, addcarsgarage)

function pegvehgarage(id,name)
    if id then
        if name then
            if housegarageid then
                local gdata = exports.an_house:getDataHouseGarage(housegarageid)
                if gdata then
                    local vehpos = toJSON({gdata[6],gdata[7],gdata[8],gdata[9]})
                    triggerServerEvent( "retirarvehicle", localPlayer,localPlayer,tonumber(id),name,housegarageid,vehpos)
                end
            elseif lookatgarage then
                local gdata = getDataGarage(lookatgarage)
                if gdata then
                    local vehpos = toJSON({gdata[6],gdata[7],gdata[8],gdata[9]})
                    triggerServerEvent( "retirarvehicle", localPlayer,localPlayer,tonumber(id),name,lookatgarage,vehpos)
                end
            end
        end
    end
end
addEvent ("pegvehgarage", true)
addEventHandler ("pegvehgarage", root, pegvehgarage)

function guavehgarage()
    if housegarageid then
        triggerServerEvent( "guavehgaragesv",localPlayer,localPlayer,housegarageid,tonumber(0))
    elseif lookatgarage then
        triggerServerEvent( "guavehgaragesv",localPlayer,localPlayer,lookatgarage,tonumber(THEgaragepprice))
    end
end
addEvent ("guavehgarage", true)
addEventHandler ("guavehgarage", root, guavehgarage)

function openhousegarage(gid)
    housegarageid = gid
    THEgaragepprice = 0
    if (not isElement(webBrowsergarage)) then
        if getElementData(localPlayer,"openui") == false then
            setElementData(localPlayer,"openui",true)
            chategaragepanel()
            focusBrowser(htmlgarage)
            guiSetVisible(webBrowsergarage, true)
            showCursor(true)
        end
    end
end
addEvent ("openhousegarage", true)
addEventHandler ("openhousegarage", root, openhousegarage)


function dxpressforpanel()
    local proxyonply = getproxyonplygarage(2)
    if proxyonply then
        if not isPedInVehicle(localPlayer) then
            for i, v in ipairs (cfg.localgarages) do 
                local hgid, x, y, z, garageprice = unpack(v)
                if hgid == proxyonply then
                    lookatgarage = hgid
                    THEgaragepprice = garageprice
                    toggleControl ( "next_weapon", false )
                    toggleControl ( "previous_weapon", false )
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z-0.2, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        if getElementData(localPlayer,"openui") == false then
                            dxDrawColorText("#efe558E #d6d6d6ACESSAR A GARAGEM", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        end
                    end
                end
            end
        else
            if lookatgarage then
                toggleControl ( "next_weapon", true )
                toggleControl ( "previous_weapon", true )
                THEgaragepprice = false
                lookatgarage = false
            end
        end  
    else
        if lookatgarage then
            toggleControl ( "next_weapon", true )
            toggleControl ( "previous_weapon", true )
            THEgaragepprice = false
            lookatgarage = false
        end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtoggleHgarage()
    if getElementData(localPlayer,"openui") == false then
        if lookatgarage then
            if THEgaragepprice then
                opengarage()
            end
        end
    end
end
bindKey("E", "down", bindtoggleHgarage)

function getproxyonplygarage(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
    local dist = distance
    local id = false
    for i,v in ipairs (cfg.localgarages) do
        local hgid, x, y, z, garageid = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = hgid
        end
    end
    if id then
        return id
    else
        return false
    end
end
----------------------------------------------------------------------------------------------------------------
-- VEH FUNCTIONS
----------------------------------------------------------------------------------------------------------------
function lockmyvehicle ()
  if not getElementData(localPlayer,"logado") then return end
    triggerServerEvent( "lockVehicle",  localPlayer )
end
bindKey("l", "down", lockmyvehicle) 

function lightmyvehicle ()
  if not getElementData(localPlayer,"logado") then return end
  if ( isPedInVehicle(localPlayer)) then
    triggerServerEvent( "lightonvehicle",  localPlayer )
  end
end
bindKey("n", "down", lightmyvehicle)

function engineonvehicle ()
  if not getElementData(localPlayer,"logado") then return end
  if ( isPedInVehicle(localPlayer)) then
    triggerServerEvent( "engineonvehicle",localPlayer,localPlayer )
  end
end
bindKey("m", "down", engineonvehicle)
----------------------------------------------------------------------------------------------------------------
-- TURN ALARM SOUND
----------------------------------------------------------------------------------------------------------------
local soundalarm = {}
function turnalarmsound(vehicl,typ)
    if typ == 1 then
        if not isElement(soundalarm[vehicl]) then
            local x, y, z = getElementPosition(vehicl)
            soundalarm[vehicl] = playSound3D("files/turnalarm.ogg", x, y, z, true)
            setElementDimension(soundalarm[vehicl], getElementDimension(vehicl))
            setElementDimension(soundalarm[vehicl], getElementDimension(vehicl))
            setSoundMinDistance(soundalarm[vehicl], 10)
            setSoundMaxDistance(soundalarm[vehicl], 50)
            setSoundVolume(soundalarm[vehicl], 0.1)
            attachElements(soundalarm[vehicl],vehicl)
            setTimer(function()
                if isElement(soundalarm[vehicl]) then
                    stopSound(soundalarm[vehicl])
                end
            end,700,1)
        end
    elseif typ == 2 then
        if not isElement(soundalarm[vehicl]) then
            local x, y, z = getElementPosition(vehicl)
            soundalarm[vehicl] = playSound3D("files/turnalarm2.ogg", x, y, z, true)
            setElementDimension(soundalarm[vehicl], getElementDimension(vehicl))
            setElementDimension(soundalarm[vehicl], getElementDimension(vehicl))
            setSoundMinDistance(soundalarm[vehicl], 10)
            setSoundMaxDistance(soundalarm[vehicl], 50)
            setSoundVolume(soundalarm[vehicl], 0.1)
            attachElements(soundalarm[vehicl],vehicl)
            setTimer(function()
                if isElement(soundalarm[vehicl]) then
                    stopSound(soundalarm[vehicl])
                end
            end,600,1)
        end
    end
end
addEvent ("turnalarmsound", true)
addEventHandler ("turnalarmsound", root, turnalarmsound)
----------------------------------------------------------------------------------------------------------------
-- SELL TO PLY
----------------------------------------------------------------------------------------------------------------
function sellmyveh(id,name,price)
  if id then
      if name then
          triggerServerEvent( "sellvehicle", localPlayer,localPlayer,tonumber(id),name,tonumber(price))
      end
  end
end
addEvent ("sellmyveh", true)
addEventHandler ("sellmyveh", root, sellmyveh)
----------------------------------------------------------------------------------------------------------------
-- SELL REQUEST FOR PLY
----------------------------------------------------------------------------------------------------------------
local sellvehforply = {}
local sellvehforplycount = 0
local sellvehforplyPlayer = {}
local sellvehforplyVeh = {}
local sellvehforplyVehPrice = {}
local sellvehforplyTimer = {}
function startsellvehicle(ply,veh,price)
    if ply then
        sellvehforplycount = sellvehforplycount + 1
        sellvehforply[sellvehforplycount] = sellvehforplycount
        sellvehforplyPlayer[sellvehforplycount] = ply
        sellvehforplyVeh[sellvehforplycount] = veh
        sellvehforplyVehPrice[sellvehforplycount] = price
        local plyname = getElementData(ply,"Nome")
        local plysname = getElementData(ply,"SNome")
        local tveh = findVeh(veh)
        local tvdata = getVehicleData(getElementData(tveh,"Model"))
        exports.an_request:naquestionrequest(sellvehforplycount,"Você quer compra o veículo <b>"..tvdata.name.."</b> de "..plyname.." "..plysname.." por $"..price.."?",10)
        destroysellforply(sellvehforplycount)
    end
end
addEvent ("startsellvehicle", true)
addEventHandler ("startsellvehicle", root, startsellvehicle)

function destroysellforply(id)
    if id then
        if sellvehforply[id] then
            sellvehforplyTimer[id] = setTimer(function()
                sellvehforply[id] = nil
                sellvehforplyPlayer[id] = nil
                sellvehforplyVeh[id] = nil
                sellvehforplyVehPrice[id] = nil
                sellvehforplyTimer[id] = nil
                sellvehforplycount = sellvehforplycount - 1
                exports.an_request:naremovequestionrequest(id)
            end,1000*10, 1)
        end
    end
end

function tablerequests_sellply()
  if sellvehforply then
    for k, v in next, sellvehforply do
        return v
    end
  end
end

function aceptrequestsellforply()
    if sellvehforply then
        local rid = tablerequests_sellply()
        if rid then
            sellvehforply[rid] = nil
            sellvehforplycount = sellvehforplycount - 1
            exports.an_request:naremovequestionrequest(rid)
            triggerServerEvent( "aceptvehicleonsell", localPlayer,localPlayer,sellvehforplyPlayer[rid],sellvehforplyVeh[rid],sellvehforplyVehPrice[rid])
            sellvehforplyPlayer[rid] = nil
            sellvehforplyVeh[rid] = nil
            sellvehforplyVehPrice[rid] = nil
            if isTimer(sellvehforplyTimer[rid]) then killTimer(sellvehforplyTimer[rid]) sellvehforplyTimer[rid] = nil end
        end
    end
end
bindKey("y", "down", aceptrequestsellforply)

function denyrequestsellforply()
    if sellvehforply then
        local rid = tablerequests_sellply()
        if rid then
            sellvehforply[rid] = nil
            sellvehforplyPlayer[rid] = nil
            sellvehforplyVeh[rid] = nil
            sellvehforplyVehPrice[rid] = nil
            sellvehforplycount = sellvehforplycount - 1
            exports.an_request:naremovequestionrequest(rid)
            if isTimer(sellvehforplyTimer[rid]) then killTimer(sellvehforplyTimer[rid]) sellvehforplyTimer[rid] = nil end
        end
    end
end
bindKey("u", "down", denyrequestsellforply)
----------------------------------------------------------------------------------------------------------------
-- PREViEW
----------------------------------------------------------------------------------------------------------------
local onlookvehdealership = false
local ShowvehDealership = false
function showDealershipvehprev(data)
  if not onlookvehdealership then
    local data = getVehicleData(data)
    if data then
        ShowvehDealership = createVehicle(data.id, 1061.317, 1727.314, 11.108, 0, 0, 353.482)
    end
    closenewdealership()
    setElementData(localPlayer,'removeHud',true)
    toggleAllControls(false)
    onlookvehdealership = true
    fadeCamera(true, 5)
    setCameraMatrix(1067.05, 1731.432, 13.013, 1061.294, 1727.153, 11.108)
  end
end
addEvent ("showDealershipvehprev", true)
addEventHandler ("showDealershipvehprev", root, showDealershipvehprev)

function dxVehPrev()
    if onlookvehdealership then
        dxDrawColorText("#ffea4cB #f0f0f0ABRIR PORTAS - #ffea4cV #f0f0f0LIGAR LUZES", screenX * 0.3294, screenY * 0.8000, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
        dxDrawColorText("#ffea4c◀ ▶ #f0f0f0ROTACIONAR - #ffea4cC #f0f0f0COR", screenX * 0.3294, screenY * 0.8500, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
        dxDrawColorText("#f0f0f0PRESSIONE #ffea4cN #f0f0f0PARA SAIR", screenX * 0.3294, screenY * 0.9000, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
    end
end
addEventHandler("onClientRender", root, dxVehPrev)

function EndDealershipvehprev()
  if onlookvehdealership then
    if ShowvehDealership then
        destroyElement(ShowvehDealership)
        ShowvehDealership = false
    end
    toggleAllControls(true)
    onlookvehdealership = false
    setCameraTarget (localPlayer, localPlayer)
    fadeCamera(true, 2.0)
    setElementData(localPlayer,'removeHud',false)
  end
end
bindKey("n", "down", EndDealershipvehprev)

function Rotatevehy(key, state )
    if onlookvehdealership then
        if ShowvehDealership then
            if getKeyState("arrow_l") then
                local x, r, z = getElementRotation(ShowvehDealership)
                setElementRotation(ShowvehDealership,x, r, z+2)
            elseif getKeyState("arrow_r") then
                local x, r, z = getElementRotation(ShowvehDealership)
                setElementRotation(ShowvehDealership,x, r, z-2)
            end
        end
    end
end
addEventHandler("onClientRender", root, Rotatevehy)

function Openportesvehdealershipprev()
    if onlookvehdealership then
        if ShowvehDealership then
            if getVehicleDoorOpenRatio (ShowvehDealership, 2 ) == 0 then
                setVehicleDoorOpenRatio(ShowvehDealership, 2, 1, 1500)
            else
                setVehicleDoorOpenRatio(ShowvehDealership, 2, 0, 1500)
            end
            if getVehicleDoorOpenRatio (ShowvehDealership, 3 ) == 0 then
                setVehicleDoorOpenRatio(ShowvehDealership, 3, 1, 1500)
            else
                setVehicleDoorOpenRatio(ShowvehDealership, 3, 0, 1500)
            end
            if getVehicleDoorOpenRatio (ShowvehDealership, 4 ) == 0 then
                setVehicleDoorOpenRatio(ShowvehDealership, 4, 1, 1500)
            else
                setVehicleDoorOpenRatio(ShowvehDealership, 4, 0, 1500)
            end
            if getVehicleDoorOpenRatio (ShowvehDealership, 5 ) == 0 then
                setVehicleDoorOpenRatio(ShowvehDealership, 5, 1, 1500)
            else
                setVehicleDoorOpenRatio(ShowvehDealership, 5, 0, 1500)
            end
        end
    end
end
bindKey("b", "down", Openportesvehdealershipprev)

function startlightvehdealershipprev()
    if onlookvehdealership then
        if ShowvehDealership then
            if ( getVehicleOverrideLights ( ShowvehDealership ) ~= 2 ) then
                setVehicleOverrideLights ( ShowvehDealership, 2 )
            else
                setVehicleOverrideLights ( ShowvehDealership, 1 )
            end
        end
    end
end
bindKey("v", "down", startlightvehdealershipprev)

local colors = {
    {255,255,255},
    {0,0,0},
    {0,0,255},
    {255,0,0},
    {0,255,0},
    {0,80,0},
    {20,0,0},
    {0,0,80},
    {100,0,255},
}

function Colorvehdealershipprev()
    if onlookvehdealership then
        if ShowvehDealership then
            local rd = math.random(#colors)
            setVehicleColor(ShowvehDealership,colors[rd][1],colors[rd][2],colors[rd][3],colors[rd][1],colors[rd][2],colors[rd][3])
        end
    end 
end
bindKey("c", "down", Colorvehdealershipprev)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
local garagesblips = {}
function startcreateblip()
    for i,v in ipairs (cfg.localgarages) do
        local id, x, y, z = unpack(v)
        garagesblips[id] = createBlip(x, y, z, 5, 2, 255, 255, 255, 255, 50, 100)
        setElementData( garagesblips[id], "tooltipText",'Garagem - '..id)
        setElementData( garagesblips[id], "farshow", true)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), startcreateblip)

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i ,v in pairs(cfg.localshop) do
        local bid, x, y, z, pedx, pedy, pedz, pedrz = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z ) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z )
            id = bid
        end
    end
    if id then
        return id
    else
        return false
    end
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end

function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

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