-------------------------------------------------------------------------------------------------------------------------------------
-- SCREEN VARIABLES
-------------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------------------------------------
-- NUI
-------------------------------------------------------------------------------------------------------------------------------------
local onLookPlant = false
function checkProxPlant()
    if isElement(onLookPlant) then
        local x, y, z = getElementPosition(onLookPlant)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
        if (WorldPositionX and WorldPositionY) then
            if getElementData(onLookPlant,'weedprogress') < 1 then
                dxDrawColorText("#efe558EM CRESCIMENTO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                dxDrawColorText("#efe558N #d6d6d6REMOVER", WorldPositionX - 1, WorldPositionY + 50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            elseif getElementData(onLookPlant,'weedprogress') >= 1 then
                dxDrawColorText("#2dfc95PRONTA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                dxDrawColorText("#efe558N #d6d6d6COLHER", WorldPositionX - 1, WorldPositionY + 50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    end
end

function giveWeed()
    if isElement(onLookPlant) then
        if getElementData(onLookPlant,'weedprogress') then
            triggerServerEvent("Destroyandgiveplant", localPlayer,localPlayer,getElementData(onLookPlant,'weedid'))
            onLookPlant = false
        end
    end
end
bindKey('n','down',giveWeed)

function onHitshopscol2(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if (not isPedInVehicle(localPlayer)) then
            if getElementData(source, "weedid") and isElement(getElementData(source, "weedcol")) then
                onLookPlant = source
                if not isEventHandlerAdded("onClientRender", root, checkProxPlant) then
                    addEventHandler ("onClientRender", root, checkProxPlant)
                end      
            end
        end
	end
end
addEventHandler("onClientColShapeHit", root, onHitshopscol2)
------------------------------------------------------------
function onLeaveshopscol2(hitElement, dim)
	if hitElement ~= localPlayer then return end
    if dim then
        if getElementData(source, "weedid") and isElement(getElementData(source, "weedcol")) then
            onLookPlant = false
            if isEventHandlerAdded("onClientRender", root, checkProxPlant) then
                removeEventHandler ("onClientRender", root, checkProxPlant)
            end      
        end
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveshopscol2)
-------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-------------------------------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------------------------------------
-- IMPORT TXD OBJECT
-------------------------------------------------------------------------------------------------------------------------------------
addEventHandler('onClientResourceStart',resourceRoot,function () 
    txd = engineLoadTXD( 'files/weed.txd' ) 
    engineImportTXD( txd, 2250) 
end)
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------