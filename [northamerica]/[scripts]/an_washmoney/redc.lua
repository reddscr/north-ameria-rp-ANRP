----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
    if isElement(targetcolwhashmoney) then
        local x, y, z = getElementPosition(targetcolwhashmoney)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+1, 0.07)
        if (WorldPositionX and WorldPositionY) then
            dxDrawRectangle(WorldPositionX - 40, WorldPositionY -10, 80, 20, tocolor(0, 0, 0, 50), false)
            dxDrawColorText("#b9b9b9/wash [valor]", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end
----------------------------------------------------------------------------------------------------------------
function onHitwhashmoneycol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if (not isPedInVehicle(localPlayer)) then
            if getElementData(source, "idwhashmoney") and isElement(getElementData(source, "colwhashmoney")) then
                targetcolwhashmoney = source
                showcolwhashmoney = true
                colwhashmoneyid = getElementData(source,"idwhashmoney")
                if not isEventHandlerAdded("onClientRender", root, dxpressforpanel) then
                    addEventHandler ("onClientRender", root, dxpressforpanel)
                end
                setElementData(localPlayer,"nawhashmoneym",true)
            end
        end
	end
end
addEventHandler("onClientColShapeHit", root, onHitwhashmoneycol)
----------------------------------------------------------------------------------------------------------------
function onLeavewhashmoneycol(hitElement, dim)
	if hitElement ~= localPlayer then return end
    if dim then
        if isEventHandlerAdded("onClientRender", root, dxpressforpanel) then
            removeEventHandler ("onClientRender", root, dxpressforpanel)
        end
        targetcolwhashmoney = false
        showcolwhashmoney = false
        colwhashmoneyid = false
        setElementData(localPlayer,"nawhashmoneym",false)
	end
end
addEventHandler("onClientColShapeLeave", root, onLeavewhashmoneycol)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
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