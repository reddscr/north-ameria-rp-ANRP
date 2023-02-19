----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local localscfg = cfg.locals
local shopscfg = cfg.shop
local lookatdepartament = false
----------------------------------------------------------------------------------------------------------------
-- HTML SHOP CONFIG
----------------------------------------------------------------------------------------------------------------
function createhtmldepst()
    webBrowser = guiCreateBrowser(0.38, 0.25, 0.5, screenY, true, true, true)
    htmldepartments = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmldepartments, loadinv1)
end
function loadinv1()
    loadBrowserURL(htmldepartments, "http://mta/local/html/panel.html")
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function toggleammushop()
    if not isElement(webBrowser) then
        if getElementData(localPlayer,"openui") == false then
            createhtmldepst()
            focusBrowser(htmldepartments)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end

function closeammushop()
  if isElement(webBrowser) then
      guiSetVisible(webBrowser, false)
      destroyElement(webBrowser)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
  end
end
addEvent ("closeammushop", true)
addEventHandler ("closeammushop", root, closeammushop)


function ammushopfunctions(data,data2,data3)
  if data then
    if data ~= "fechar" then
      if data2 then
        if data3 then
          triggerServerEvent("buyammushop", localPlayer,localPlayer,data,data2,data3)
        end
      end
    elseif data == "fechar" then
      closeammushop()
    end
  end
end
addEvent ("ammushopfunctions", true)
addEventHandler ("ammushopfunctions", root, ammushopfunctions)
----------------------------------------------------------------------------------------------------------------
-- COL SYSTEM
----------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
    local proxyonply = getproxyonply(1)
    if proxyonply then
        for i, v in ipairs (localscfg) do 
            if v.id == proxyonply then
                lookatdepartament = v.id
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(v.x, v.y, v.z-0.2, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    dxDrawColorText("#00e98cN   #d6d6d6ACESSAR A LOJA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                end
            end
        end
    else
        lookatdepartament = false
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtoggleammushop()
    if lookatdepartament then
        toggleammushop()
    end
end
bindKey("n", "down", bindtoggleammushop)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(htmldepartments, eval)
    end
end

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
  local dist = distance
  local id = false
    for i, v in ipairs (localscfg) do 
        --local id,x,y,z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, v.x, v.y, v.z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, v.x, v.y, v.z)
            id = v.id
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
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------