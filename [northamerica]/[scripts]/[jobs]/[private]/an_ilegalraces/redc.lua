----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local targetcolilegalraces = false
local showcolilegalraces = false
local colilegalracesid = false

function createpanelilegalrace()
  webBrowserilegalrace = guiCreateBrowser(0.4, 0.25, 0.5, screenY, true, true, true)
  htmlilegalrace = guiGetBrowser(webBrowserilegalrace)
  addEventHandler("onClientBrowserCreated", htmlilegalrace, loadilegalrace)
end

function loadilegalrace()
  loadBrowserURL(htmlilegalrace, "http://mta/local/html/ilegalrace.html")
end

function theilegalracefunctions(data)
  if data then
      if data ~= "fechar" then
          triggerServerEvent("ilracefuncs", localPlayer,localPlayer,data)
      end
      if data == "fechar" then
          closeilegalrace()
      end
  end
end
addEvent ("theilegalracefunctions", true)
addEventHandler ("theilegalracefunctions", root, theilegalracefunctions)

function openilegalrace()
  if isElement(targetcolilegalraces) then
    if (not isElement(webBrowserilegalrace)) then
        if getElementData(localPlayer,"openui") == false then
            createpanelilegalrace()
            focusBrowser(htmlilegalrace)
            guiSetVisible(webBrowserilegalrace, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
  end
end
addEvent ("openilegalrace", true)
addEventHandler ("openilegalrace", root, openilegalrace)

function closeilegalrace()
  if isElement(webBrowserilegalrace) then
      guiSetVisible(webBrowserilegalrace, false)
      destroyElement(webBrowserilegalrace)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
  end
end
addEvent ("closeilegalrace", true)
addEventHandler ("closeilegalrace", root, closeilegalrace)



function dxpressforpanel()
    if isElement(targetcolilegalraces) then
        local x, y, z = getElementPosition(targetcolilegalraces)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-1, 0.07)
        if (WorldPositionX and WorldPositionY) then
          --  dxDrawRectangle(WorldPositionX - 40, WorldPositionY -10, 80, 20, tocolor(0, 0, 0, 50), false)
            dxDrawColorText("#b9b9b9/shop", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end
----------------------------------------------------------------------------------------------------------------
function onHitilegalracescol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if (not isPedInVehicle(localPlayer)) then
            if getElementData(source, "idilegalraces") and isElement(getElementData(source, "colilegalraces")) then
                targetcolilegalraces = source
                showcolilegalraces = true
                colilegalracesid = getElementData(source,"idilegalraces")
                if not isEventHandlerAdded("onClientRender", root, dxpressforpanel) then
                    addEventHandler ("onClientRender", root, dxpressforpanel)
                end
                setElementData(localPlayer,"nailegalracesm",true)
            end
        end
	end
end
addEventHandler("onClientColShapeHit", root, onHitilegalracescol)
----------------------------------------------------------------------------------------------------------------
function onLeaveilegalracescol(hitElement, dim)
	if hitElement ~= localPlayer then return end
    if dim then
        if isEventHandlerAdded("onClientRender", root, dxpressforpanel) then
            removeEventHandler ("onClientRender", root, dxpressforpanel)
        end
        targetcolilegalraces = false
        showcolilegalraces = false
        colilegalracesid = false
        setElementData(localPlayer,"nailegalracesm",false)
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveilegalracescol)

----------------------------------------------------------------------------------------------------------------
local targetcolracerdoor = false
local showracerdoor = false
local colracerdoorid = false

function bindkeyracerdoor()
  if getElementData(localPlayer,"user_group") == "dk" then
    if isElement(targetcolracerdoor) then
      triggerServerEvent("openorcloseracerdoor", localPlayer,localPlayer)
    end
  end 
end
bindKey("N", "down", bindkeyracerdoor)

function onHitilegalracesdoorcol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
      if getElementData(source, "idracerdoor") and isElement(getElementData(source, "colracerdoor")) then
        targetcolracerdoor = source
        showracerdoor = true
        colracerdoorid = getElementData(source,"idracerdoor")
      end
	  end
end
addEventHandler("onClientColShapeHit", root, onHitilegalracesdoorcol)
----------------------------------------------------------------------------------------------------------------
function onLeaveilegalracesdoorcol(hitElement, dim)
	if hitElement ~= localPlayer then return end
    if dim then
      targetcolracerdoor = false
      showracerdoor = false
      colracerdoorid = false
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveilegalracesdoorcol)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function execute(eval)
  if isElement(webBrowserilegalrace) then
      executeBrowserJavascript(htmlilegalrace, eval)
  end
end

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