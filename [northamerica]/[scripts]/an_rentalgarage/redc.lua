-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()

myFont = dxCreateFont( "files/robotb.ttf", 9 )

targetcolcentralreantalgarage = false
showcolcentralreantalgarage = false
colcentralreantalgaragesid = false

local garagesblips = {}
function startcreateblip()
    for i,v in ipairs (cfg.localreantalgarages) do
        local id, x, y, z = unpack(v)
        garagesblips[id] = createBlip(x, y, z, 5, 2, 0, 100, 255, 255, 50, 10)
        setElementData( garagesblips[id], "tooltipText",'Garagem de aluguel - '..id)
        setElementData( garagesblips[id], "farshow", true)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), startcreateblip)
----------------------------------------------------------------------------------------------------------------
-- reantalgarage
----------------------------------------------------------------------------------------------------------------
function chatereantalgaragepanel()
    webBrowserreantalgarage = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlreantalgarage = guiGetBrowser(webBrowserreantalgarage)
    addEventHandler("onClientBrowserCreated", htmlreantalgarage, loadreantalgarage)
end

function loadreantalgarage()
    loadBrowserURL(htmlreantalgarage, "http://mta/local/html/panelg.html")
end

function openreantalgarage()
    if (not isElement(webBrowserreantalgarage)) then
        if getElementData(localPlayer,"openui") == false then
            chatereantalgaragepanel()
            focusBrowser(htmlreantalgarage)
            guiSetVisible(webBrowserreantalgarage, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end
    
function closebindreantalgarage()
    if isElement(webBrowserreantalgarage) then
        execute(string.format("close()"))
        guiSetVisible(webBrowserreantalgarage, false)
        destroyElement(webBrowserreantalgarage)
        showCursor(false)
        setElementData(localPlayer,"openui",false)

        setElementData(targetcolcentralreantalgarage,"centralreantalgaragedisp",false)
        setElementData(localPlayer,"nacentralreantalgarage",false)
        setElementData(localPlayer,"centralreantalgarage",nil)
        targetcolcentralreantalgarage = false
        showcolcentralreantalgarage = false
        colcentralreantalgaragesid = false
    end
end
bindKey("n", "down", closebindreantalgarage)

function closereantalgarage()
    if (isElement(webBrowserreantalgarage)) then
        guiSetVisible(webBrowserreantalgarage, false)
        destroyElement(webBrowserreantalgarage)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        setElementData(targetcolcentralreantalgarage,"centralreantalgaragedisp",false)
        setElementData(localPlayer,"nacentralreantalgarage",false)
        setElementData(localPlayer,"centralreantalgarage",nil)
        targetcolcentralreantalgarage = false
        showcolcentralreantalgarage = false
        colcentralreantalgaragesid = false
    end
end
addEvent ("closereantalgarage", true)
addEventHandler ("closereantalgarage", root, closereantalgarage)

function addcarsreantalgarage()
    execute(string.format("clearallreantalgarage2()"))
    local rgaragetyp = getElementData(targetcolcentralreantalgarage,"rentalgaragetype")
    --print(rgaragetyp)
    if rgaragetyp then
        for i,v in ipairs (cfg.garagetype[rgaragetyp]) do
            execute(string.format("addreantalgaragecars(%s,%s,%s)",toJSON(v[2]),toJSON(v[1]),toJSON(v[3])))
        end
    end
end
addEvent ("addcarsreantalgarage", true)
addEventHandler ("addcarsreantalgarage", root, addcarsreantalgarage)

function pegvehreantalgarage(id,name,price)
    if id then
        if name then
            if price then
                triggerServerEvent( "pegvehreantalgarage", localPlayer,localPlayer,tonumber(id),name,targetcolcentralreantalgarage,tonumber(price))
            end
        end
    end
end
addEvent ("pegvehreantalgarage", true)
addEventHandler ("pegvehreantalgarage", root, pegvehreantalgarage)

function guavehreantalgarage()
    triggerServerEvent( "guavehreantalgaragesv",localPlayer,localPlayer,targetcolcentralreantalgarage)
end
addEvent ("guavehreantalgarage", true)
addEventHandler ("guavehreantalgarage", root, guavehreantalgarage)
----------------------------------------------------------------------------------------------------------------
-- col and hit reantalgarage
----------------------------------------------------------------------------------------------------------------
function dxpressforpanelreantalgarage()
    if isElement(targetcolcentralreantalgarage) then
        local x, y, z = getElementPosition(targetcolcentralreantalgarage)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.5, 0.07)
        if (WorldPositionX and WorldPositionY) then
            dxDrawRectangle(WorldPositionX - 50, WorldPositionY -10, 97, 20, tocolor(0, 0, 0, 50), false)
            dxDrawColorText("#00e98cN #d6d6d6PARA ABRIR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end
---------------------------------------------------------------------
function inittratamentkey()
if getElementData(localPlayer,"openui") == false then
    if isEventHandlerAdded("onClientRender", root, dxpressforpanelreantalgarage) then
        if (not isPedInVehicle(localPlayer)) then
            if getElementData(targetcolcentralreantalgarage,"centralreantalgaragedisp") == false then
                if getElementData(targetcolcentralreantalgarage,"rentalgaragegroup") ~= "desempregado" then
                    if exports.an_account:hasPermission(getElementData(targetcolcentralreantalgarage,"rentalgaragegroup")) then
                        openreantalgarage()
                        setElementData(targetcolcentralreantalgarage,"centralreantalgaragedisp",true)
                        if isEventHandlerAdded("onClientRender", root, dxpressforpanelreantalgarage) then
                            removeEventHandler ("onClientRender", root, dxpressforpanelreantalgarage)
                        end
                    end
                else
                    openreantalgarage()
                    setElementData(targetcolcentralreantalgarage,"centralreantalgaragedisp",true)
                    if isEventHandlerAdded("onClientRender", root, dxpressforpanelreantalgarage) then
                        removeEventHandler ("onClientRender", root, dxpressforpanelreantalgarage)
                    end
                end
            else
                exports.an_infobox:addNotification("Local ocupado","aviso")    
            end
        end
    end
end
end
bindKey("N", "down", inittratamentkey)
---------------------------------------------------------------------
function onHitshopscol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if (not isPedInVehicle(localPlayer)) then
            if getElementData(source, "idcentralreantalgarage") and isElement(getElementData(source, "colcentralreantalgarage")) then
                targetcolcentralreantalgarage = source
                showcolcentralreantalgarage = true
                colcentralreantalgaragesid = getElementData(source,"idcentralreantalgarage")
                if not isEventHandlerAdded("onClientRender", root, dxpressforpanelreantalgarage) then
                    addEventHandler ("onClientRender", root, dxpressforpanelreantalgarage)
                end
                setElementData(localPlayer,"nacentralreantalgarage",true)
                setElementData(localPlayer,"centralreantalgarage",getElementData(source, "colcentralreantalgarage"))
            end
        end
  end
end
addEventHandler("onClientColShapeHit", root, onHitshopscol)
------------------------------------------------------------
function onLeaveshopscol(hitElement, dim)
  if hitElement ~= localPlayer then return end
    if dim then
        if isEventHandlerAdded("onClientRender", root, dxpressforpanelreantalgarage) then
            removeEventHandler ("onClientRender", root, dxpressforpanelreantalgarage)
        end
        if (not isElement(webBrowserreantalgarage)) then
            targetcolcentralreantalgarage = false
            showcolcentralreantalgarage = false
            colcentralreantalgaragesid = false
            setElementData(source,"centralreantalgaragedisp",false)
            setElementData(localPlayer,"nacentralreantalgarage",false)
            setElementData(localPlayer,"centralreantalgarage",nil)
        end
  end
end
addEventHandler("onClientColShapeLeave", root, onLeaveshopscol)

----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowserreantalgarage) then
        executeBrowserJavascript(htmlreantalgarage, eval)
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
-------------------------------------------------------------------------------------------------------