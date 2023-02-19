---------------------------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
---------------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
---------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
---------------------------------------------------------------------------------------------------------------------------------------
local configtable = cfg.locals
local loja = false
local robloja = false
local lojatime = 200
local timer = 0
local timerstarted = false
local requestrob = false
local startedminigame = false
---------------------------------------------------------------------------------------------------------------------------------------
-- DRAW TO ROBB
---------------------------------------------------------------------------------------------------------------------------------------
function dxtext()
    local prox = getproxclientply(1)
    if prox then
        if not robloja then
            if getElementData(localPlayer, 'Pendrive') >= 1 then
                loja = prox
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(prox.OBJX, prox.OBJY, prox.OBJZ+0.3, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    dxDrawRectangle(WorldPositionX - 130, WorldPositionY -35, 260, 20, tocolor(0, 0, 0, 115), false)
                    dxDrawColorText("#e3e3e3PRESSIONE #ff7775N #e3e3e3PARA HACKEAR O COFRE", WorldPositionX - 1, WorldPositionY -50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                end
            end
        end
    else
        if loja then
            loja = false
        end
    end
end
addEventHandler('onClientRender', root, dxtext)

function bind()
    if loja then
        if not robloja then
            if not startedminigame then
                triggerServerEvent('requeststartrobbloja', localPlayer, localPlayer, loja)
            end
        end
    end
end
bindKey('n','down', bind)

addEvent("toresponserobloja", true)
addEventHandler("toresponserobloja", root, function()
    if not robloja then
        robloja = requestrob
        timer = lojatime
        timerstarted = true
        startedminigame = false
        exports.an_infobox:addNotification("<b>Sistema invadido</b> com sucesso!","sucesso",500)
        triggerServerEvent('robblojaalert', localPlayer, localPlayer, robloja, 2)
    end
end)

addEvent("toresponseroblojarror", true)
addEventHandler("toresponseroblojarror", root, function()
    requestrob = false
    startedminigame = false
    local sort = math.random(0,100)
    if sort <= 10 then
        exports.an_infobox:addNotification("O seu <b>pendrive</b> parou de funcionar","aviso",500)
        exports.an_inventory:attitem( 'Pendrive', 1, "menos" )
        loja = false
        triggerServerEvent('robblojaalert', localPlayer, localPlayer, robloja, 1)
    else
        exports.an_infobox:addNotification("<b>Erro</b> ao invadir o sistema!","erro",500)
    end
end)

function startrobloja(id)
    if not robloja then
        requestrob = id
        startedminigame = true
        exports.an_sortbar:narequestsort('toresponserobloja','toresponseroblojarror',5)
    end
end
addEvent('startrobloja', true)
addEventHandler('startrobloja', root, startrobloja)
---------------------------------------------------------------------------------------------------------------------------------------
-- DRAW
---------------------------------------------------------------------------------------------------------------------------------------
function dxcountmachineatm()
    if robloja then
        local prox = getproxclientply(7)
        if prox then
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(robloja.OBJX,robloja.OBJY,robloja.OBJZ, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawRectangle(WorldPositionX - 130, WorldPositionY -35, 260, 20, tocolor(0, 0, 0, 115), false)
                dxDrawColorText("#e3e3e3RESTAM #ff7775"..timer.." #e3e3e3SEGUNDOS PARA TERMINAR", WorldPositionX - 1, WorldPositionY -50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                dxDrawRectangle(WorldPositionX - 130, WorldPositionY -15, 260, 20, tocolor(0, 0, 0, 115), false)
                dxDrawColorText("#e3e3e3PRESSIONE #ff7775N #e3e3e3PARA CANCELAR", WorldPositionX - 1, WorldPositionY -10, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        else
            if robloja then
                stoprobloja()
                exports.an_infobox:addNotification("Roubo <b>cancelado</b>! você saiu do local.","aviso",500)
            end
        end
    end
end
addEventHandler("onClientRender", getRootElement(), dxcountmachineatm)

function machinetimertread()
    if timerstarted and timer > 0 then
        timer = timer - 1
        if timer == 0 then
            triggerServerEvent('startrobbloja', localPlayer, localPlayer, robloja)
            stoprobloja()
        end
    end
setTimer(machinetimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), machinetimertread)

function bind2()
    if loja then
        if robloja then
            stoprobloja()
        end
    end
end
bindKey('n','down', bind2)

function stoprobloja()
    robloja = false
    timer = 0
    timerstarted = false
    requestrob = false
    startedminigame = false
end
---------------------------------------------------------------------------------------------------------------------------------------
-- GERAL VARIABLES
---------------------------------------------------------------------------------------------------------------------------------------
function getproxclientply(distance)
	local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for _, v in pairs(configtable) do
        if getDistanceBetweenPoints3D (v.OBJX, v.OBJY, v.OBJZ, pX, pY, pZ) < dist then
            dist = getDistanceBetweenPoints3D (v.OBJX, v.OBJY, v.OBJZ, pX, pY, pZ)
            id = v
        end
    end
    if id then
        return id
    else
        return false
    end
end

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