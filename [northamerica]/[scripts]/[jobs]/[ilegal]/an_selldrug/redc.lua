-------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
local lookAtNPCDRUG = false
local startedselling = false
local npcdrugTimer = 0
local drugqtd = 0
local drugselected = false
local Npcstarted = false
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
function checkpoint_emp2()
    local prox = getproxclientply(1.5)
    if prox then
        for i,v in ipairs (cfg.drugtable) do
            local getplydata = getElementData(localPlayer,v[1]) or 0
            if getplydata >= 1 then
                if not isPedInVehicle(localPlayer) then
                    lookAtNPCDRUG = true
                    if not isElement(Npcstarted) then
                        Npcstarted = prox
                    end
                    toggleControl ( "enter_passenger", false )
                    if not startedselling then
                        if not getElementData(prox,'npcbuydrug') and not getElementData(prox,'npcrobbed') then
                            local x, y, z = getElementPosition(prox)
                            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z+0.3, 0.07)
                            if (WorldPositionX and WorldPositionY) then
                                dxDrawColorText("#efe558G #d6d6d6OFERECER DROGAS", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 170), 1, myFont, "center", "center", false, false, false, false, false)
                            end
                        end
                    end
                    if startedselling then
                        local x, y, z = getElementPosition(localPlayer)
                        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.1, 0.07)
                        if (WorldPositionX and WorldPositionY) then
                            dxDrawColorText("#d6d6d6RESTAM #910808"..npcdrugTimer.." #d6d6d6SEGUNDO PARA FINALIZAR A VENDA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        end
                    end
                else
                    if lookAtNPCDRUG then
                        toggleControl ( "enter_passenger", true )
                        lookAtNPCDRUG = false
                        Npcstarted = false
                        if startedselling then
                            startedselling = false
                            Npcstarted = false
                            exports.an_infobox:addNotification("<b>Venda</b> cancelada.","aviso")
                        end
                    end 
                end
            end
        end
    else
        if lookAtNPCDRUG then
            toggleControl ( "enter_passenger", true )
            lookAtNPCDRUG = false
            Npcstarted = false
            if startedselling then
                startedselling = false
                exports.an_infobox:addNotification("<b>Venda</b> cancelada, fique perto do comprador.","aviso")
            end
        end
    end
end
addEventHandler("onClientRender", root, checkpoint_emp2)
 
function calcelselldrug()
    startedselling = false
    Npcstarted = false
end
addEvent ("calcelselldrug", true)
addEventHandler ("calcelselldrug", root, calcelselldrug)

function keyselldrugfornpc()
    if lookAtNPCDRUG then
        if isElement(Npcstarted) then
            if not isPedInVehicle(localPlayer) then
                if not getElementData(Npcstarted,'npcbuydrug') then
                    if not startedselling then
                        drugqtd = math.random(1,3)
                        drugselected = cfg.drugtable[math.random(#cfg.drugtable)][1]
                        local getplydata = getElementData(localPlayer,drugselected) or 0
                        if getplydata >= 1 then
                            if getplydata >= drugqtd then
                                startedselling = true
                                npcdrugTimer = 20
                                triggerServerEvent("policechance", localPlayer, localPlayer, Npcstarted)
                            else
                                setElementData(Npcstarted,'npcbuydrug',true)
                                exports.an_infobox:addNotification("Você não tem a <b>quantidade</b> que eu quero!","erro")
                            end
                        else
                            setElementData(Npcstarted,'npcbuydrug',true)
                            exports.an_infobox:addNotification("Você não tem a <b>droga</b> que eu quero!","erro")
                        end
                    end
                end
            end
        end
    end
end
bindKey( 'g', 'down', keyselldrugfornpc )


function npcdrugTimertread()
    if startedselling and npcdrugTimer > 0 then
        npcdrugTimer = npcdrugTimer - 1
        if npcdrugTimer == 0 then
            npcdrugTimer = 0
            startedselling = false
            setElementData(Npcstarted,'npcbuydrug',true)
            local policests = checkpolice()
            triggerServerEvent("finishiselldrug", localPlayer, localPlayer, Npcstarted, drugselected, drugqtd, policests)
            Npcstarted = false
            drugqtd = 0
            drugselected = false
        end
    end
setTimer(npcdrugTimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), npcdrugTimertread)

function getproxclientply(distance)
	local x, y, z = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    local players = getElementsByType("ped")
    for i, v in ipairs (players) do 
        if not getElementData(v,'npc') then
            if localPlayer ~= v then
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
-------------------------------------------------------------------------------------------------------------------
-- GERAL VARIABLES
-------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------