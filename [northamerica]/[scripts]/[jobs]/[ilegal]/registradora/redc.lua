----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
local registerTimer = 0
local registerStart = false
local onLookatmachineregister = false

local localscfg = {
    { 1, 1311.858, -898.078, 39.7 },
    { 2, 1311.858, -896.147, 39.7 },
    { 3, 888.017, 2001.111, 10.97 },
    { 4, 889.743, 2001.11, 10.97 },
    { 5, -2391.729, -57.377, 35.32 },
    { 6, -2391.729, -59.136, 35.32 }
}----------------------------------------------------------------------------------------------------------------
-- SYSTEM
----------------------------------------------------------------------------------------------------------------
function renderRegister()
    local proxregistermachine = getproxyonply(0.25)
    if proxregistermachine then
        if not registerStart then
            toggleControl("next_weapon",false)
            toggleControl("previous_weapon",false)
            onLookatmachineregister = proxregistermachine
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.1, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#d6d6d6APERTE #910808E #d6d6d6PARA INICIAR O ROUBO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
        if registerStart then
            toggleControl("next_weapon",false)
            toggleControl("previous_weapon",false)
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.1, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#d6d6d6RESTAM #910808"..registerTimer.." #d6d6d6SEGUNDO PARA FINALIZAR O ROUBO EM ANDAMENTO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                dxDrawColorText("#910808N #d6d6d6CANCELAR O ROUBO EM ANDAMENTO", WorldPositionX - 1, WorldPositionY + 50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    else
        if onLookatmachineregister then
            onLookatmachineregister = false
            toggleControl("next_weapon",true)
            toggleControl("previous_weapon",true)
        end
        if registerStart then
            registerStart = false
            registerTimer = 0
        end
    end
end
addEventHandler("onClientRender",root,renderRegister)
----------------------------------------------------------------------------------------------------------------
-- START THEFT
----------------------------------------------------------------------------------------------------------------
function startstealregister()
    if onLookatmachineregister then
        if not registerStart then
            if not isPedInVehicle(localPlayer) then
                triggerServerEvent("requestmachineregister", localPlayer,localPlayer,onLookatmachineregister)
            end
        end
    end
end
bindKey("e","down",startstealregister)

function cancelstealregister()
    if onLookatmachineregister then
        if registerStart then
            registerTimer = 0
            registerStart = false
            toggleAllControls(true)
            triggerServerEvent("stopmachineregister2", localPlayer,localPlayer,onLookatmachineregister)
        end
    end
end
bindKey("n","down",cancelstealregister)
----------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------
function confirmstartmachineregister()
    if not registerStart then
        registerTimer = 30
        registerStart = true
        toggleAllControls(false)
    end
end
addEvent ("confirmstartmachineregister", true)
addEventHandler ("confirmstartmachineregister", root, confirmstartmachineregister)
----------------------------------------------------------------------------------------------------------------
-- MACHINE TIMER
----------------------------------------------------------------------------------------------------------------
function registertimertread()
    if registerStart and registerTimer > 0 then
        registerTimer = registerTimer - 1
        if registerTimer == 0 then
            registerTimer = 0
            registerStart = false
            toggleAllControls(true)
            triggerServerEvent("stopmachineregister", localPlayer,localPlayer,onLookatmachineregister)
        end
    end
setTimer(registertimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), registertimertread)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------






























----------------------------------------------------------------------------------------------------------------
-- FUNCTIONS VARIABLES
----------------------------------------------------------------------------------------------------------------
function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (localscfg) do 
        local mid,x,y,z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z)
            id = mid
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