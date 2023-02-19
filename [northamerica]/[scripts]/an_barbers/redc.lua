----------------------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local LookAtChair = false
local onBarbers = false
local ObjectBarbersChair = false
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

function closeBarbers()
    if (isElement(webnui)) then
        guiSetVisible(webnui, false)
        destroyElement(webnui)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        triggerServerEvent("closeBarbers", localPlayer, localPlayer)
        toggleAllControls(true)
        setCameraTarget (localPlayer, localPlayer)
        fadeCamera(true, 2.0)
        triggerServerEvent("stopBarbersAnim", localPlayer, localPlayer)
        onBarbers = false
        setElementData(localPlayer, 'onbarber', false)
        ObjectBarbersChair = false
    end
end
addEvent ("closeBarbers", true)
addEventHandler ("closeBarbers", root, closeBarbers)

function requestBarbers()
    if (isElement(webnui)) then
        for i,v in ipairs (cfg.barbesTable) do
            executeBrowserJavascript(htmlnui,string.format("loadBarbers(%s,%s,%s)",toJSON(v.ID),toJSON(v.Name),toJSON(v.Price)))
        end
    end
end
addEvent ("requestBarbers", true)
addEventHandler ("requestBarbers", root, requestBarbers)

function OpenBarbers(char, chaid)
    if not getElementData(localPlayer,"wanted") then
        if getElementData(localPlayer,"openui") == false then
            ObjectBarbersChair = char
            createhtmlnui()
            focusBrowser(htmlnui)
            guiSetVisible(webnui, true)
            showCursor(true)
            setElementData(localPlayer, "openui",true)
            toggleAllControls(false)
            onBarbers = chaid
            local x, y, z = getElementPosition(localPlayer)
            local chx, chy, chz = getElementPosition(localPlayer)
            fadeCamera(true, 5)
            setCameraMatrix(cfg.Barbers[onBarbers].CAMX, cfg.Barbers[onBarbers].CAMY, cfg.Barbers[onBarbers].CAMZ, cfg.Barbers[onBarbers].X, cfg.Barbers[onBarbers].Y, cfg.Barbers[onBarbers].Z+0.6)
            --setElementCollisionsEnabled(ObjectBarbersChair, false)
            setElementData( localPlayer, 'emacao', true)
            setElementData(localPlayer, 'onbarber', true)
        end
    else
        exports.an_infobox:addNotification("Você esta sendo procurado! a policia foi alertada.","aviso")
        triggerServerEvent("callclothingpolice", localPlayer, localPlayer)
    end
end
addEvent ("OpenBarbers", true)
addEventHandler ("OpenBarbers", root, OpenBarbers)

function buyBarbers(data)
    local id = tonumber(data)
    if id then
        for i,v in ipairs (cfg.barbesTable) do
            if v.ID == id then
                if getElementData(localPlayer,"Money") >= v.Price then
                    triggerServerEvent("buyBarbers", localPlayer, localPlayer, id)
                    exports.an_inventory:attitem("Money",v.Price,"menos")
                else
                    exports.an_infobox:addNotification("Você não tem $ <b>"..v.Price.."</b>.","erro")
                end
            end
        end
    end
end
addEvent ("buyBarbers", true)
addEventHandler ("buyBarbers", root, buyBarbers)

function showBarbers(data)
    local id = tonumber(data)
    if id then
        triggerServerEvent("previewBarbers", localPlayer, localPlayer, data)
    end
end
addEvent ("showBarbers", true)
addEventHandler ("showBarbers", root, showBarbers)
----------------------------------------------------------------------------------------------------------------------------------
-- Barber's shop Proxy
----------------------------------------------------------------------------------------------------------------------------------
function dxText()
    local proxyChair = getProxyChair(1.2)
    if proxyChair then
        LookAtChair = proxyChair
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(cfg.Barbers[LookAtChair].X, cfg.Barbers[LookAtChair].Y, cfg.Barbers[LookAtChair].Z+0.5, 0.07)
        if (WorldPositionX and WorldPositionY) then
            if getElementData(localPlayer,"openui") == false then
                dxDrawColorText("#d6d6d6[N] : #3b8ff7ACESSAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    else
        if LookAtChair then
            LookAtChair = false
        end
    end
end
addEventHandler('onClientRender', root, dxText)

function acessbarbersChair()
    if LookAtChair then
        --OpenBarbers()
        triggerServerEvent("startChairBarbers", localPlayer, localPlayer, LookAtChair)
    end
end
bindKey('N','down', acessbarbersChair)
----------------------------------------------------------------------------------------------------------------------------------
-- Barber's shop Chairs
----------------------------------------------------------------------------------------------------------------------------------



function RotateChair()
    if ObjectBarbersChair then
        if onBarbers then
            if LookAtChair then
                dxDrawColorText("#ffea4c◀ ▶ #f0f0f0ROTACIONAR", screenX * 0.3294, screenY * 0.8500, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
                --if getKeyState("arrow_l") then
                 --   triggerServerEvent("rotateBarbersObjects", localPlayer, localPlayer, 1, ObjectBarbersChair)
                        --[[local _, _, rz = getElementRotation(ObjectBarbersChair)
                        setElementRotation(ObjectBarbersChair, 0, 0, rz+5)
                        local rx, ry, rz = getElementRotation(ObjectBarbersChair)
                        setElementRotation(localPlayer, rx, ry, rz-85)]]
               -- elseif getKeyState("arrow_r") then
                  --  triggerServerEvent("rotateBarbersObjects", localPlayer, localPlayer, 1, ObjectBarbersChair)
                        --[[local _, _, rz = getElementRotation(ObjectBarbersChair)
                        setElementRotation(ObjectBarbersChair, 0, 0, rz-5)
                        local rx, ry, rz = getElementRotation(ObjectBarbersChair)
                        setElementRotation(localPlayer, rx, ry, rz-85)]]
                --end
            end
        end
    end
end
addEventHandler('onClientRender', root, RotateChair)

function rotatex( key, state )
    if ObjectBarbersChair then
        if onBarbers then
            triggerServerEvent("rotateObjBarb", localPlayer, localPlayer, 1, ObjectBarbersChair)
        end
    end
end
bindKey( "arrow_l", "both", rotatex )

function rotatey( key, state )
    if ObjectBarbersChair then
        if onBarbers then
            if onBarbers then
                triggerServerEvent("rotateObjBarb", localPlayer, localPlayer, 2, ObjectBarbersChair)
            end
        end
    end
end
bindKey( "arrow_r", "both", rotatey )
----------------------------------------------------------------------------------------------------------------------------------
-- BARBERS ANIM
----------------------------------------------------------------------------------------------------------------------------------
function animcoma()
  if not getElementData(localPlayer,"logado") then return end
    for k, v in ipairs(getElementsByType("player")) do
        if getElementData(v,"onbarber") then
            local block, animation = getPedAnimation(v)
            if animation ~= "seat_lr" then
                setPedAnimation(v, "misc", "seat_lr", -1, true, false, false )
            end
            setPedAnimationProgress(v, 'seat_lr', 500)
        end
    end
end
addEventHandler("onClientRender", root, animcoma)
----------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
function getProxyChair(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (cfg.Barbers) do 
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
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------