----------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
----------------------------------------------------------------------------------------------------------------
local localscfg = cfg.locals
local lookatdepartament = false

local fishingblipsell = false


local fishconfig = {
    {"Baiacu",40},
    {"Sardinha",45},
    {"Atum",100},
    {"Anchova",80},
    {"Salmao",155},
    {"Garoupa",105},
    {"Robalo",85},
    {"Redsnapper",65},
}
----------------------------------------------------------------------------------------------------------------
-- SELL FISHING UI AND SCRIPT
----------------------------------------------------------------------------------------------------------------
function createhtmlpescador()
    showCursor(true)
    webBrowser = guiCreateBrowser(0.4, 0.25, 0.5, screenY, true, true, true)
    vendapescahtml = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", vendapescahtml, load)
end

function load()
    loadBrowserURL(vendapescahtml, "http://mta/local/html/panel.html")
end

function thepescadorfunctions(data)
    if data then
        if data ~= "fechar" then
            local idata = exports.an_account:getitemtable3()
            for i, v in ipairs (idata) do 
                if v[2] == data then
                    local getitemqtd = getElementData(localPlayer,v[2])
                    if getitemqtd >= 1 then
                        for i2, v2 in ipairs (fishconfig) do 
                            if v2[1] == data then
                                exports.an_inventory:attitem(v[2],getitemqtd,"menos")
                                exports.an_inventory:attitem("Money",v2[2]*getitemqtd,"mais")
                                exports.an_infobox:addNotification("Vendido "..getitemqtd.."x <b>"..v[5].."</b>.","info")
                            end
                        end
                    else
                        exports.an_infobox:addNotification("Você não tem <b>"..v[5].."</b>.","aviso")
                    end
                end
            end
        end
        if data == "fechar" then
            hiddenmenupescador()
        end
    end
end
addEvent ("thepescadorfunctions", true)
addEventHandler ("thepescadorfunctions", root, thepescadorfunctions)

function hiddenmenupescador()
  if isElement(webBrowser) then
      guiSetVisible(webBrowser, false)
      destroyElement(webBrowser)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
  end
end
addEvent ("hiddenmenupescador", true)
addEventHandler ("hiddenmenupescador", root, hiddenmenupescador)

function togglesellfishing()
    if not isElement(webBrowser) then
        if getElementData(localPlayer,"openui") == false then
            createhtmlpescador()
            focusBrowser(vendapescahtml)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end

function dxpressforpanel()
    local proxyonply = getproxyonplysell(1)
    if proxyonply then
        for i, v in ipairs (localscfg) do 
            local jid, x, y, z, rotx, roty, rotz = unpack(v)
            if jid == proxyonply then
                lookatdepartament = jid
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z+0.2, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    dxDrawColorText("#efe558N #d6d6d6ACESSAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                end
            end
        end
    else
        lookatdepartament = false
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtogglesellfishing()
    if lookatdepartament then
        togglesellfishing()
    end
end
bindKey("n", "down", bindtogglesellfishing)
----------------------------------------------------------------------------------------------------------------
-- FISHING JOB
----------------------------------------------------------------------------------------------------------------
local onLookFishingPoint = false
local fishingStart = false
local fishingtimer = 0
local onfish = false
local fishtime = 0
local fishinterv = nil
function checkpointfishing()
    local plyproxypoint = getproxyonply(4)
    if plyproxypoint then
        toggleControl ( "enter_passenger", false )
        if not fishingStart then
            onLookFishingPoint = true
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#efe558N #d6d6d6COMEÇAR A PESCAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    else
        if onLookFishingPoint then
            onLookFishingPoint = false
            toggleControl ( "enter_passenger", true )
            if fishingStart then
                fishingStart = false
                onfish = false
                triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'stop')
                if isTimer(fishinterv) then killTimer(fishinterv) end
            end
        end
    end
    if fishingStart then
        local x, y, z = getElementPosition(localPlayer)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
        if (WorldPositionX and WorldPositionY) then
            dxDrawColorText("#efe558N #d6d6d6PARAR DE PESCAR", WorldPositionX - 1, WorldPositionY + 200, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
        if onfish then
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#efe558G #d6d6d6FISGAR O PEIXE", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                dxDrawColorText("#efe558"..fishtime, WorldPositionX - 1, WorldPositionY + 50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
        if getElementData(localPlayer,"Isca") <= 0 then
            fishingStart = false
            onfish = false
            triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'stop')
            exports.an_infobox:addNotification("Você não tem <b>iscas</b>.","aviso")
            if isTimer(fishinterv) then killTimer(fishinterv) end
        elseif getElementData(localPlayer,"Varadpesca") <= 0 then
            fishingStart = false
            onfish = false
            triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'stop')
            exports.an_infobox:addNotification("Você não tem <b>vara de pesca</b>.","aviso")
            if isTimer(fishinterv) then killTimer(fishinterv) end
        end
        if isPedInVehicle(localPlayer) then
            fishingStart = false
            onfish = false
            triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'stop')
            if isTimer(fishinterv) then killTimer(fishinterv) end
        end
    end
end
addEventHandler("onClientRender", root, checkpointfishing)


function bindforinitjobprision()
    if onLookFishingPoint then
        if not isPedInVehicle(localPlayer) then
            if getElementData(localPlayer,"Isca") >= 1 then
                if getElementData(localPlayer,"Varadpesca") >= 1 then
                    if not fishingStart then
                        fishingStart = true
                        fishingtimer = math.random(5,40)
                    --  print(fishingtimer)
                        triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'start')
                    elseif fishingStart then
                        fishingStart = false
                        onfish = false
                        triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'stop')
                    end
                else
                    exports.an_infobox:addNotification("Você não tem <b>vara de pesca</b>.","aviso") 
                end
            else
                exports.an_infobox:addNotification("Você não tem <b>iscas</b>.","aviso") 
            end
        end
    end
end
bindKey("N", "down", bindforinitjobprision)

function bindfishing()
    if fishingStart then
        if not isPedInVehicle(localPlayer) then
            if onfish then
                onfish = false
                finishfishing()
                triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'stop')
                fishinterv = setTimer(function()
                    fishingtimer = math.random(5,40)
                    triggerServerEvent ("fishingjobanimation", localPlayer,localPlayer,'start')
                end,600,1)
            end
        end
    end
end
bindKey("G", "down", bindfishing)

function finishfishing()
    onfish = false
    local fish = fishconfig[math.random(#fishconfig)][1]
    local idata = exports.an_account:getitemtable3()
    for i, v in ipairs (idata) do 
        if v[2] == fish then
            if getElementData(localPlayer, "MocSlot") + v[4]*1 < getElementData(localPlayer, "MocMSlot") then
                exports.an_inventory:attitem(v[2],"1","mais")
                exports.an_inventory:attitem("Isca","1","menos")
                exports.an_infobox:addNotification("Você pescou 1x <b>"..v[5].."</b>.","sucesso")
            else
                exports.an_inventory:attitem("Isca","1","menos")
                triggerServerEvent("drop", localPlayer,localPlayer,v[2],1)
                exports.an_infobox:addNotification("A <b>mochila</b> está sem espaço, 1x <b>"..v[5].."</b> caiu no chão!","aviso")
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
-- TIMER TREAD
----------------------------------------------------------------------------------------------------------------
function fishingtread1()
    if fishingStart then
        if fishingtimer > 0 then
            fishingtimer = fishingtimer - 1
            if fishingtimer == 0 then
                onfish = true
                fishtime = math.random(3,10)
            end
        end
        if fishtime > 0 then
            fishtime = fishtime - 1
            if fishtime == 0 then
                onfish = false
                fishingtimer = math.random(5,40)
            end
        end
    end
setTimer(fishingtread1,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), fishingtread1)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function getproxyonplysell(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (localscfg) do 
        local jid, x, y, z, rotx, roty, rotz = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = jid
        end
    end
    if id then
        return id
    else
        return false
    end
end

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i,v in ipairs (cfg.fishinglocals) do 
        local x ,y ,z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x ,y ,z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x ,y ,z)
            id = true
        end
    end
    if id then
        return id
    else
        return false
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