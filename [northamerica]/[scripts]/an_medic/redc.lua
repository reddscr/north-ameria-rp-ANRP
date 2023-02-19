------------------------------------------------------------------------------------------------------------------
--get screen
------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
------------------------------------------------------------------------------------------------------------------
local lookatmaca = false
local inmaca = false
local intratament = false

local macas = {
  { 1, 1436.57, 2325.927, 12.393, 1436.523, 2324.733, 13.08, 0, 0, 270.831},
  { 2, 1442.701, 2325.93, 12.4, 1442.621, 2324.706, 13.08, 0, 0, 270.831},
  { 3, 1437.267, 2330.648, 12.4, 1436.379, 2330.553, 13.08, 0, 0, 270.831},
  { 4, 1441.852, 2330.487, 12.4, 1442.722, 2330.53, 13.08, 0, 0, 270.831},
  { 5, 1437.479, 2341.267, 12.4, 1436.595, 2341.132, 13.08, 0, 0, 270.831},
  { 6, 1441.773, 2341.19, 12.4, 1442.55, 2341.103, 13.08, 0, 0, 270.831},
  { 7, 1436.395, 2334.729, 12.4, 1436.313, 2333.303, 13.08, 0, 0, 270.831},
  { 8, 1442.573, 2334.729, 12.4, 1442.659, 2333.132, 13.08, 0, 0, 270.831},
  { 9, 1459.081, 2334.63, 12.4, 1459.004, 2333.212, 13.08, 0, 0, 270.831},
  { 10, 1459.165, 2325.93, 12.4, 1459.078, 2324.493, 13.08, 0, 0, 270.831},
  { 11, 1447.553, 2325.93, 12.4, 1447.486, 2324.449, 13.08, 0, 0, 270.831},
  { 12, 1447.275, 2334.729, 12.4, 1447.292, 2333.277, 13.08, 0, 0, 270.831},
}
------------------------------------------------------------------------------------------------------------------
-- TRATAMENT
------------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
  local proxyonply = getproxyonply(1)
  if proxyonply then
      for i, v in ipairs (macas) do 
        local id, x, y, z, x2, y2, z2, rx, ry, rz = unpack(v)
          if id == proxyonply then
            lookatmaca = id
            toggleControl ( "enter_passenger", false )
            toggleControl ( "next_weapon", false )
            toggleControl ( "previous_weapon", false )
              local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.2, 0.07)
              if (WorldPositionX and WorldPositionY) then
                  dxDrawColorText("#efe558E #d6d6d6 DEITAR    #efe558G #d6d6d6 TRATAMENTO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
              end
          end
      end
  else
    if lookatmaca then
      toggleControl ( "enter_passenger", true )
      toggleControl ( "next_weapon", true )
      toggleControl ( "previous_weapon", true )
      lookatmaca = false
    end
  end
  if inmaca then
    local x,y,z = getElementPosition(localPlayer)
    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.2, 0.07)
    if (WorldPositionX and WorldPositionY) then
      dxDrawColorText("#efe558E #d6d6d6 SAIR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
    end
    local block, animation = getPedAnimation(localPlayer)
    if animation ~= "crckdeth2" then
      triggerServerEvent ("tratamentanimation", localPlayer,localPlayer,"start") 
    end
  end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindinitmacaanim()
  if not inmaca then
    if lookatmaca then
      exports.an_infobox:addNotification("Você deitou na <b>maca</b>.","info")
      for i, v in ipairs (macas) do 
        local id, x, y, z, x2, y2, z2, rx, ry, rz = unpack(v)
        if lookatmaca == id then
          inmaca = true
          setElementData(localPlayer,"inmaca",true)
          setElementPosition(localPlayer,x2, y2, z2)
          setElementRotation(localPlayer,rx, ry, rz)
          triggerServerEvent ("tratamentanimation", localPlayer,localPlayer,"start") 
        end
      end
    end
  else
    intratament = false
    inmaca = false
    setElementData(localPlayer,"inmaca",nil)
    triggerServerEvent ("tratamentanimation", localPlayer,localPlayer,"stop") 
    toggleControl ( "walk", true )
    toggleControl ( "jump", true )
  end
end
bindKey("e", "down", bindinitmacaanim)

function bindinitmacaanim()
  if not inmaca then
    if lookatmaca then
      local medicon = exports.an_police:getmedicinservice()
      if medicon == 0 then
        exports.an_infobox:addNotification("Tratamento <b>iniciado</b>.","sucesso")
        for i, v in ipairs (macas) do 
          local id, x, y, z, x2, y2, z2, rx, ry, rz = unpack(v)
          if lookatmaca == id then
            inmaca = true
            intratament = true
            setElementData(localPlayer,"inmaca",true)
            setElementPosition(localPlayer,x2, y2, z2)
            setElementRotation(localPlayer,rx, ry, rz)
            triggerServerEvent ("tratamentanimation", localPlayer,localPlayer,"start")
          end
        end
      end
    end
  end
end
bindKey("g", "down", bindinitmacaanim)

function medicstarttratament()
  intratament = true
end
addEvent ("medicstarttratament", true)
addEventHandler ("medicstarttratament", root, medicstarttratament)

function tratament()
  if intratament then
    local pHealth = getElementHealth (localPlayer)
    if pHealth < 100 then
      setElementHealth(localPlayer,pHealth+2)
    else
      exports.an_infobox:addNotification("Você não precisa de <b>tratamento</b>.","aviso")
    end    
  end
  setTimer(tratament,2000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), tratament)

function getproxyonply(distance)
  local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i,v in ipairs (macas) do 
        local mid, x, y, z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = mid
        end
    end
    if id then
        return id
    else
        return false
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function animcoma()
  if not getElementData(localPlayer,"logado") then return end
    for k, v in ipairs(getElementsByType("player")) do
      if getElementData(v,"intratament") or getElementData(v,"incoma") then
        local block, animation = getPedAnimation(v)
        if animation ~= "crckdeth2" then
          setPedAnimation(v, "crack", "crckdeth2", -1, true, false, false )
        end
          setPedAnimationProgress(v, 'crckdeth2', 500)
      end
    end
end
addEventHandler("onClientRender", root, animcoma)
----------------------------------------------------------------------------------------------------------------------------------
-- COMA SYSTEM
----------------------------------------------------------------------------------------------------------------------------------
local deathTimer = 0
local deathStarted = false
local deathTimerFinised = false

function RequestDeathTimer(data)
  if data then
    if not deathStarted then
      deathTimer = data
      deathStarted = true
      deathTimerFinised = false
    else
      triggerServerEvent ("killPlayeronDeath", localPlayer,localPlayer)
      deathTimer = 0
      deathStarted = false
      deathTimerFinised = false
    end
  end
end
addEvent ("RequestDeathTimer", true)
addEventHandler ("RequestDeathTimer", root, RequestDeathTimer)

function RemoveDeathTimer()
  deathTimer = 0
  deathStarted = false
  deathTimerFinised = false
end
addEvent ("RemoveDeathTimer", true)
addEventHandler ("RemoveDeathTimer", root, RemoveDeathTimer)

function startRequestDeathorlife()
  triggerServerEvent ("requestdeath", localPlayer,localPlayer)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), startRequestDeathorlife)

function tresdDxTextinComa()
  if deathStarted then
    local x, y, z = getElementPosition(localPlayer)
    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z-0.2, 0.07)
    if (WorldPositionX and WorldPositionY) then
      if deathTimer > 0 then
        dxDrawRectangle( 0, 0 , screenX, screenY, tocolor(0, 0, 0, 240), false) 
        dxDrawColorText("#f0f0f0AGUARDE #ffea4c"..deathTimer.." #f0f0f0SEGUNDOS OU CHAME OS #ffea4cPARAMÉDICOS", screenX * 0.3294, screenY * 0.9414, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
      elseif deathTimer == 0 or deathTimerFinised then
        dxDrawRectangle( 0, 0 , screenX, screenY, tocolor(0, 0, 0, 240), false)
        dxDrawColorText("#f0f0f0PRESSIONE #ffea4cG #f0f0f0PARA RENASCER", screenX * 0.3294, screenY * 0.9414, screenX * 0.6698, screenY * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
      end
    end
  end
end
addEventHandler("onClientRender", root, tresdDxTextinComa)

function bindRespawn()
  if deathTimerFinised or deathTimer == 0 and deathStarted then
    triggerServerEvent ("killPlayeronDeath", localPlayer,localPlayer)
    deathTimer = 0
    deathStarted = false
    deathTimerFinised = false
  end
end
bindKey("g", "down", bindRespawn)
----------------------------------------------------------------------------------------------------------------------------------
-- THREAD - COMA
----------------------------------------------------------------------------------------------------------------------------------
function deathThread()
  if deathStarted and deathTimer > 0 then
    deathTimer = deathTimer - 1
    if deathTimer == 0 then
      deathTimerFinised = true
    end
  end
  setTimer(deathThread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), deathThread)
----------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------
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

function cursorPosition(x, y, w, h)
if (not isCursorShowing()) then
  return false
end
local mx, my = getCursorPosition()
local fullx, fully = guiGetScreenSize()
cursorx, cursory = mx*fullx, my*fully
if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
  return true
else
  return false
end
end

function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "id") == id then
			v = player
			break
		end
	end
	return v
end