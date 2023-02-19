----------------------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local LookAttatoo = false
local onTatoos = false
----------------------------------------------------------------------------------------------------------------------------------
-- WEB NUI
----------------------------------------------------------------------------------------------------------------------------------
function createhtmlnui()
    webnui = guiCreateBrowser(0*screenX, 0*screenX, screenX, screenY, true, true, true)
    htmlnui = guiGetBrowser(webnui)
    addEventHandler("onClientBrowserCreated", htmlnui, loadnui)
end
function loadnui()
    loadBrowserURL(htmlnui, "http://mta/local/nui/nui.html")  
end

function OpenTatoos(tatooid)
    if not getElementData(localPlayer,"wanted") then
        if getElementData(localPlayer,"openui") == false then
            onTatoos = true
            createhtmlnui()
            focusBrowser(htmlnui)
            guiSetVisible(webnui, true)
            showCursor(true)
            setElementData(localPlayer, "openui",true)
            toggleAllControls(false)
            fadeCamera(true, 5)
            setCameraMatrix(cfg.tatoos[tatooid].CAMX, cfg.tatoos[tatooid].CAMY, cfg.tatoos[tatooid].CAMZ, cfg.tatoos[tatooid].X, cfg.tatoos[tatooid].Y, cfg.tatoos[tatooid].Z)
            setElementData( localPlayer, 'emacao', true)
        end
    else
        exports.an_infobox:addNotification("Você esta sendo procurado! a policia foi alertada.","aviso")
        triggerServerEvent("callTatoossonpolice", localPlayer, localPlayer)
    end
end
addEvent ("OpenTatoos", true)
addEventHandler ("OpenTatoos", root, OpenTatoos)

function closeTatoo()
    if (isElement(webnui)) then
        onTatoos = false
        guiSetVisible(webnui, false)
        destroyElement(webnui)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        triggerServerEvent("closeTatoos", localPlayer, localPlayer)
        toggleAllControls(true)
        setCameraTarget (localPlayer, localPlayer)
        fadeCamera(true, 2.0)
    end
end
addEvent ("closeTatoo", true)
addEventHandler ("closeTatoo", root, closeTatoo)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
function requestTatoo()
    if (isElement(webnui)) then
        for i,v in ipairs (cfg.tatoosTable) do
            executeBrowserJavascript(htmlnui,string.format("loadTatoo(%s,%s,%s,%s)",toJSON(v.ID),toJSON(v.Name),toJSON(v.Price),toJSON(v.Typ)))
        end
    end
end
addEvent ("requestTatoo", true)
addEventHandler ("requestTatoo", root, requestTatoo)

function TatooPreview(data,data2)
    if data then
        if data2 then
            triggerServerEvent('previewTatoos', localPlayer, localPlayer, tonumber(data), tonumber(data2))
        end
    end
end
addEvent('TatooPreview', true)
addEventHandler('TatooPreview', root, TatooPreview)

function TatooBuying(data,data2)
    if data then
        if data2 then
            for i,v in ipairs (cfg.tatoosTable) do
                if v.ID == tonumber(data) and v.Typ == tonumber(data2) then
                    if getElementData(localPlayer,"Money") >= v.Price then
                        triggerServerEvent('buyTatoos', localPlayer, localPlayer, tonumber(data), tonumber(data2))
                        exports.an_inventory:attitem("Money",v.Price,"menos")
                    else
                        exports.an_infobox:addNotification("Você não tem $ <b>"..v.Price.."</b>.","erro")
                    end
                end
            end
        end
    end
end
addEvent('TatooBuying', true)
addEventHandler('TatooBuying', root, TatooBuying)
----------------------------------------------------------------------------------------------------------------------------------
-- PROXY
----------------------------------------------------------------------------------------------------------------------------------
function dxText()
    local proxytatoo = getProxytatoo(2)
    if proxytatoo then
        LookAttatoo = proxytatoo
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(cfg.tatoos[LookAttatoo].X, cfg.tatoos[LookAttatoo].Y, cfg.tatoos[LookAttatoo].Z+0.1, 0.07)
        if (WorldPositionX and WorldPositionY) then
            if getElementData(localPlayer,"openui") == false then
                dxDrawColorText("#d6d6d6[N] : #3b8ff7ACESSAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    else
        if LookAttatoo then
            LookAttatoo = false
        end
    end
    if onTatoos then
        dxDrawColorText("#ffea4c◀ ▶ #f0f0f0ROTACIONAR", screenX * 0.3294, screenY * 0.8500, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
        if getKeyState("arrow_l") then
            local rotX, rotY, rotZ = getElementRotation(localPlayer)
            setElementRotation(localPlayer,0,0,rotZ+5,"default",true)
        elseif getKeyState("arrow_r") then
            local rotX, rotY, rotZ = getElementRotation(localPlayer)
            setElementRotation(localPlayer,0,0,rotZ-5,"default",true)
        end
    end
end
addEventHandler('onClientRender', root, dxText)

function acessbarberstatoo()
    if LookAttatoo then
        OpenTatoos(LookAttatoo)
    end
end
bindKey('N','down', acessbarberstatoo)
----------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
function getProxytatoo(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (cfg.tatoos) do 
        if getDistanceBetweenPoints3D ( pX, pY, pZ, v.X, v.Y, v.Z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, v.X, v.Y, v.Z)
            id = v.ID
        end
    end
    if id then
        return id
    else
        return false
    end
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