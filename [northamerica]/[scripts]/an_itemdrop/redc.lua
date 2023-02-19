----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local screenW,screenH = guiGetScreenSize()
myFont2 = dxCreateFont( "robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- DROP
----------------------------------------------------------------------------------------------------------------
local showdropeditem = false
local itemtarget = false
local itemtargetqtd = false
local coltarget = false
function dxdropsplayer ()
  local itemdata = exports.an_account:getitemtable(itemtarget)
  if itemtarget == itemdata[1] then
    local x, y, z = getElementPosition(coltarget)
    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.5, 0.07)
    if (WorldPositionX and WorldPositionY) then
      dxDrawColorText("#d6d6d6[N] : "..itemtargetqtd.."x #3b8ff7"..itemdata[5], WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont2, "center", "center", false, false, false, false, false)
    end
  end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function onHitDeathPlayerCol(hitElement, dim)
	if hitElement ~= localPlayer then return end
  if dim then
    if (not isPedInVehicle(localPlayer)) then
      if getElementData(source, "itemdropp") and isElement(getElementData(source, "itemdroppcol")) then
        if not isEventHandlerAdded("onClientRender", root, dxdropsplayer) then 
          showdropeditem = true
          coltarget = getElementData(source, "itemdroppcol")
          itemtarget = getElementData(source,"itemdrop")
          itemtargetqtd =  getElementData(source,"qtditemdrop")
          addEventHandler ("onClientRender", root, dxdropsplayer)
        end
      end
    end
  end
end
addEventHandler("onClientColShapeHit", root, onHitDeathPlayerCol)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function onLeaveDeathPlayerCol(hitElement, dim)
  if hitElement ~= localPlayer then return end
	if dim then
		if getElementData(source, "itemdropp") and isElement(getElementData(source, "itemdroppcol")) then
		  showdropeditem = false
      itemtarget = false
      itemtargetqtd = false
      coltarget = false
      if isEventHandlerAdded("onClientRender", root, dxdropsplayer) then 
        removeEventHandler("onClientRender", root, dxdropsplayer)
      end
		end
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveDeathPlayerCol)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function giveanddestroyobjdrop()
  if isEventHandlerAdded("onClientRender", root, dxdropsplayer) then
    if showdropeditem and itemtarget then
      triggerServerEvent( "giveanddestroyobjdropsv", localPlayer,localPlayer,coltarget,itemtarget,itemtargetqtd)
      showdropeditem = false
      itemtarget = false
      itemtargetqtd = false
      coltarget = false 
      if isEventHandlerAdded("onClientRender", root, dxdropsplayer) then 
        removeEventHandler("onClientRender", root, dxdropsplayer)
      end
    end
  end
end
bindKey("N", "down", giveanddestroyobjdrop)
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