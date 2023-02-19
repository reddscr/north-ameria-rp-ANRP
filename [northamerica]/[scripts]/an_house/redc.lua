--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()

myFont = dxCreateFont( "robotb.ttf", 9 )
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
targethome = false
showhome = false
colhomeid = false

function onHitdoorcolinfo(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if getElementData(source, "houseid") and isElement(getElementData(source, "housecol")) then
            targethome = source
            showhome = true
            colhomeid = getElementData(source,"houseid")
            setElementData(localPlayer,"inhouse",true)
            setElementData(localPlayer,"inhousecolid",colhomeid)
        end
	end
end
addEventHandler("onClientColShapeHit", root, onHitdoorcolinfo)

function onLeavedoorcolinfo(hitElement, dim)
    if hitElement ~= localPlayer then return end
    if getElementData(source, "houseid") ~= colhomeid then return end
    if dim then
        targethome = false
        showhome = false
        colhomeid = false
        setElementData(localPlayer,"inhouse",nil)
        setElementData(localPlayer,"inhousecolid",nil)
	end
end
addEventHandler("onClientColShapeLeave", root, onLeavedoorcolinfo)
--------------------------------------------------------------------------------------------------------------------
-- House Commands
--------------------------------------------------------------------------------------------------------------------
function houseinfos()
    if targethome then 
        triggerServerEvent ("returnhouseinfo", localPlayer,localPlayer,targethome)
    end
end
addEvent ("houseinfos", true)
addEventHandler ("houseinfos", root, houseinfos)

function buyhouse()
    if targethome then 
        local houseprice = getElementData(targethome,"houseprice")
        local plymoney = getElementData(localPlayer,"Money") or 0
        if houseprice ~= "donate" then
            if plymoney >= tonumber(houseprice) then
                triggerServerEvent ("buythehouse", localPlayer,localPlayer,targethome,houseprice)
            else
                exports.an_infobox:addNotification("Dinheiro <b>insuficiente</b>.","erro")
            end        
        else
            exports.an_infobox:addNotification("Esta casa é <b>premium</b>.","info")
        end
    end
end
addEvent ("buyhouse", true)
addEventHandler ("buyhouse", root, buyhouse)
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

targetdoor = false
showdoor = false
coldoorid = false

function dxpressforpanelhouse()
    if isElement(targetdoor) then
        local x, y, z = getElementPosition(targetdoor)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+1, 0.07)
        if (WorldPositionX and WorldPositionY) then
            --dxDrawRectangle(WorldPositionX - 30, WorldPositionY -10, 56, 20, tocolor(0, 0, 0, 50), false)
            local dorstartus = getElementData(targetdoor,"doorstats")
            if dorstartus == "Fechado" then
                dxDrawColorText("#00d2a7N   #ff5f61"..dorstartus.."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            elseif dorstartus == "Aberto" then
                dxDrawColorText("#00d2a7N   #ffffff"..dorstartus.."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
            --#ff5f61
            --#00d2a7
        end
    end
end

function initdoorkey()
if getElementData(localPlayer,"openui") == false then
    if isEventHandlerAdded("onClientRender", root, dxpressforpanelhouse) then
        --if (not isPedInVehicle(localPlayer)) then
            if getElementData(targetdoor,"doorstats") == "Fechado" then
                triggerServerEvent( "openandclosedoor", localPlayer,localPlayer,"open",targetdoor)
            elseif getElementData(targetdoor,"doorstats") == "Aberto" then

                triggerServerEvent( "openandclosedoor", localPlayer,localPlayer,"close",targetdoor)
            end
        --end
    end
end
end
bindKey("N", "down", initdoorkey)

function onHitdoorcol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        --if (not isPedInVehicle(localPlayer)) then
            if getElementData(source, "doorhouseid") and isElement(getElementData(source, "coldoors")) then
                targetdoor = source
                showdoor = true
                coldoorid = getElementData(source,"doorhouseid")
                --print(getElementData(source,"doorhouseid"))
                if not isEventHandlerAdded("onClientRender", root, dxpressforpanelhouse) then
                    addEventHandler ("onClientRender", root, dxpressforpanelhouse)
                end
            end
       -- end
	end
end
addEventHandler("onClientColShapeHit", root, onHitdoorcol)

function onLeavedoorcol(hitElement, dim)
    if hitElement ~= localPlayer then return end
    if getElementData(source, "doorhouseid") ~= coldoorid then return end
    if dim then
        if isEventHandlerAdded("onClientRender", root, dxpressforpanelhouse) then
            removeEventHandler ("onClientRender", root, dxpressforpanelhouse)
        end
        targetdoor = false
        showdoor = false
        coldoorid = false
	end
end
addEventHandler("onClientColShapeLeave", root, onLeavedoorcol)

--------------------------------------------------------------------------------------------------------------------
-- GARAGE
--------------------------------------------------------------------------------------------------------------------
local lookatgarage = false
local Homegarageid = false
function dxpressforpanel()
    local proxyonply = getproxyonply(2)
    if proxyonply then
        if not isPedInVehicle(localPlayer) then
            for i, v in ipairs (cfg.housesgarage) do 
                local hgid, x, y, z, garageid = unpack(v)
                if hgid == proxyonply then
                    lookatgarage = hgid
                    Homegarageid = garageid
                    toggleControl ( "next_weapon", false )
                    toggleControl ( "previous_weapon", false )
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z-0.2, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawColorText("#efe558E #d6d6d6ACESSAR A GARAGEM", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                end
            end
        else
            if lookatgarage then
                toggleControl ( "next_weapon", true )
                toggleControl ( "previous_weapon", true )
                Homegarageid = false
                lookatgarage = false
            end
        end  
    else
        if lookatgarage then
            toggleControl ( "next_weapon", true )
            toggleControl ( "previous_weapon", true )
            Homegarageid = false
            lookatgarage = false
        end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtoggleHgarage()
    if getElementData(localPlayer,"openui") == false then
        if lookatgarage then
            if Homegarageid then
                triggerServerEvent( "requesthousegarage", localPlayer,localPlayer,lookatgarage,Homegarageid)
            end
        end
    end
end
bindKey("E", "down", bindtoggleHgarage)

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
    local dist = distance
    local id = false
    for i,v in ipairs (cfg.housesgarage) do
       -- local hgid, x, y, z, garageid = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, v[2], v[3], v[4]) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, v[2], v[3], v[4])
            id = v[1]
        end
    end
    if id then
        return id
    else
        return false
    end
end
----------------------------------------------------------------------------------------------------------------
-- sell house
----------------------------------------------------------------------------------------------------------------
local emgplyid = nil
local plyhouse = nil
local plyprice = nil
local timerconfirmhousebuy = nil
function openconfirmbuyhouse(plyid,house,price)
    if plyid then
        if house then
            if price then
                emgplyid = plyid
                plyhouse = house
                plyprice = price
                playSoundFrontEnd ( 44 )
                exports.an_infobox:addNotification("Você quer comprar esta <b>casa</b>?  <br><br><b>Y</b> sim <b>U</b> não.","info")
                timerconfirmhousebuy = setTimer(function()
                    emgplyid = nil
                    plyhouse = nil
                    plyprice = nil
                end,9000,1)
            end
        end
    end
end
addEvent ("openconfirmbuyhouse", true)
addEventHandler ("openconfirmbuyhouse", root, openconfirmbuyhouse)

function aceptbuyhouse()
    if emgplyid then
        triggerServerEvent("sussefulsellhouse", localPlayer,localPlayer,emgplyid,plyhouse,plyprice)
        emgplyid = nil
        plyhouse = nil
        plyprice = nil
        if isTimer(timerconfirmhousebuy) then killTimer(timerconfirmhousebuy) end
    end
end
bindKey("y", "down", aceptbuyhouse)

function rejectbuyhouse()
    if emgplyid then
        emgplyid = nil
        plyhouse = nil
        plyprice = nil
        exports.an_infobox:addNotification("Você recusou a <b>compra</b>.","aviso")
        if isTimer(timerconfirmhousebuy) then killTimer(timerconfirmhousebuy) end
    end
end
bindKey("u", "down", rejectbuyhouse)
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

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