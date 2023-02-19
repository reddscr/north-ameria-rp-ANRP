-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()

myFont = dxCreateFont( "files/robotb.ttf", 9 )
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
local targetdoor = false
local showdoor = false
local coldoorid = false
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
function dxpressforpanelhouse()
    if isElement(targetdoor) then
        local x, y, z = getElementPosition(targetdoor)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+1, 0.07)
        if (WorldPositionX and WorldPositionY) then
            local dorstartus = getElementData(targetdoor,"groupdoorstats")
            if dorstartus == "Fechado" then
                dxDrawColorText("#00d2a7N   #ff5f61"..dorstartus.."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            elseif dorstartus == "Aberto" then
                dxDrawColorText("#00d2a7N   #ffffff"..dorstartus.."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    end
end

function initdoorkey()
if getElementData(localPlayer,"openui") == false then
    if isEventHandlerAdded("onClientRender", root, dxpressforpanelhouse) then
        local getdoorgroup = getElementData(targetdoor,"groupdoor")
        if getdoorgroup then
          if exports.an_account:hasPermission(getdoorgroup) then
            if getElementData(targetdoor,"groupdoorstats") == "Fechado" then
              triggerServerEvent( "openandclosedoorgroup", localPlayer,localPlayer,"open",targetdoor)
            elseif getElementData(targetdoor,"groupdoorstats") == "Aberto" then
              triggerServerEvent( "openandclosedoorgroup", localPlayer,localPlayer,"close",targetdoor)
            end
          end
        end
    end
end
end
bindKey("N", "down", initdoorkey)

function onHitdoorcol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
      if getElementData(source, "groupdoorid") and isElement(getElementData(source, "colgroupgroupdoor")) then
        targetdoor = source
        showdoor = true
        coldoorid = getElementData(source,"groupdoorid")
        if not isEventHandlerAdded("onClientRender", root, dxpressforpanelhouse) then
          addEventHandler ("onClientRender", root, dxpressforpanelhouse)
        end
      end
	end
end
addEventHandler("onClientColShapeHit", root, onHitdoorcol)

function onLeavedoorcol(hitElement, dim)
  if hitElement ~= localPlayer then return end
  if getElementData(source, "groupdoorid") ~= coldoorid then return end
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

-------------------------------------------------------------------------------------------------------
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