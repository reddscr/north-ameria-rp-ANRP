-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
-------------------------------------------------------------------------------------------------------
-- Panel
-------------------------------------------------------------------------------------------------------
function createhtmlcaminhoneiro()
    naui = guiCreateBrowser( 0, 0, screenX, screenY, true, true, true)
    htmlnaui = guiGetBrowser(naui)
    addEventHandler("onClientBrowserCreated", htmlnaui, load)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), createhtmlcaminhoneiro)

function load()
    loadBrowserURL(htmlnaui, "http://mta/local/html/panel.html")
end

function naquestionrequest(id,text,time)
  if text then
    if time then
      if id then
        local timer = 1000*time
        execute(string.format("requests(%s,%s,%s)",toJSON(id),toJSON(text),toJSON(timer)))
      end
    end
  end
end

function naremovequestionrequest(id)
  if id then
    execute(string.format("removerequest(%s)",toJSON(id)))
  end
end

addEvent("naremovequestionrequest", true)
addEventHandler("naremovequestionrequest", root, function(id)
  if id then
    execute(string.format("removerequest(%s)",toJSON(id)))
  end
end)

addEvent("naquestionrequest", true)
addEventHandler("naquestionrequest", root, function(id,text,time)
  if text then
    if time then
      if id then
        local timer = 1000*time
        execute(string.format("requests(%s,%s,%s)",toJSON(id),toJSON(text),toJSON(timer)))
      end
    end
  end
end)

function isCursorShowing ()
  if not getElementData(localPlayer,"openui") then
    if isElement(naui) then
      if isBrowserFocused(htmlnaui) then
        showCursor(false)
      end
    end
  end
  setTimer(isCursorShowing,1000,1)
end
isCursorShowing ()
-------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-------------------------------------------------------------------------------------------------------
function execute(eval)
  executeBrowserJavascript(htmlnaui, eval)
end

function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
--------------------------------------------------------------------
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
--------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------



