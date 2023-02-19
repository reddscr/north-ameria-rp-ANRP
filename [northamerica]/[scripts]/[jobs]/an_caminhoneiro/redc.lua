-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
-------------------------------------------------------------------------------------------------------
local TruckTable = {
--  id - trailer
    { 1, 435 },
    { 2, 450 },
    { 3, 584 }
}

local lookAtNPCtruck = false
local truckjobStarted = false
local startedlocaltype = nil
local startedlocal = nil
local lookAtFinishpoint = false
local randomtrailertyp = false
-------------------------------------------------------------------------------------------------------
-- SCRIPT
-------------------------------------------------------------------------------------------------------
function checkpoint_emp()
    local proxyply = getproxyonply(1)
    if proxyply then
        for i, v in ipairs (cfg.localemp) do 
            if v[1] == proxyply then
                lookAtNPCtruck = proxyply
                toggleControl ( "enter_passenger", false )
                local x, y, z = getElementPosition(localPlayer)
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    dxDrawColorText("#efe558N #d6d6d6PEGAR UMA CARGA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                end
            end
        end
    else
        if lookAtNPCtruck then
            toggleControl ( "enter_passenger", true )
            lookAtNPCtruck = false
        end
    end
end
addEventHandler("onClientRender", root, checkpoint_emp)

function starttruckmission()
    if not truckjobStarted then
        local proxyply = getproxyonply(1)
        if proxyply then
            if lookAtNPCtruck then
                --[[local rtrailer = math.random(#TruckTable)
                if rtrailer then
                    randomtrailertyp = rtrailer
                    triggerServerEvent("createTrailerandstartmission", localPlayer,localPlayer,TruckTable[rtrailer][2],proxyply)
                end]]
                triggerServerEvent("requestpoint", localPlayer,localPlayer)
            end
        end
    end
end
bindKey( 'n', 'down', starttruckmission)

function checkpoint_emp2()
    if truckjobStarted then
        local proxyply = checkproxylocal(5,startedlocal)
        if proxyply then
            lookAtFinishpoint = true
            toggleControl ( "enter_passenger", false )
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#efe558G #d6d6d6ENTREGAR CARGA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        else
            if lookAtFinishpoint then
                toggleControl ( "enter_passenger", true )
                lookAtFinishpoint = false
            end
        end
    end
end
addEventHandler("onClientRender", root, checkpoint_emp2)

function bindfinishtruckjob()
    if lookAtFinishpoint then
        if truckjobStarted then
            triggerServerEvent("finishTrailerMission", localPlayer,localPlayer)
        end
    end
end
bindKey( 'g', 'down', bindfinishtruckjob)

function startedjobmission(typ)
    if typ then
        if lookAtNPCtruck then
            randomtrailertyp = typ
            triggerServerEvent("createTrailerandstartmission", localPlayer,localPlayer,TruckTable[randomtrailertyp][2],lookAtNPCtruck)
        end
    end
end
addEvent("startedjobmission", true)
addEventHandler("startedjobmission", root, startedjobmission)

function confirmstartMission()
    truckjobStarted = true
    startedlocaltype = TruckTable[randomtrailertyp][1]
    startedlocal = math.random(#cfg.localentregas[startedlocaltype])
    createmkjob()
end
addEvent("confirmstartMission", true)
addEventHandler("confirmstartMission", root, confirmstartMission)

function finishedtruckjob()
    if truckjobStarted then
        truckjobStarted = false
        randomtrailertyp = false
        startedlocal = false
        destroymkjob()
    end
end
addEvent("finishedtruckjob", true)
addEventHandler("finishedtruckjob", root, finishedtruckjob)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
local mkjob = nil
local blipjob = nil
function createmkjob()
    if (not isElement(mkjob)) and (not isElement(blipjob)) then
        if startedlocaltype then
            local jid, x, y, z = unpack(cfg.localentregas[startedlocaltype][startedlocal])
            if jid then
                blipjob = createBlip(x, y, z, 2, 2, 255, 255, 0, 255, 50, 9999999999)
                setElementData( blipjob, "tooltipText",'Truck Driver - Delivery')
                mkjob = createMarker(x,y,z -4, "cylinder", 5, 255, 77, 77, 25)
            end
        end
    end
end

function destroymkjob()
    if (isElement(mkjob)) and (isElement(blipjob)) then
        destroyElement(mkjob)
        destroyElement(blipjob)
    end
end

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (cfg.localemp) do 
        local jid, x, y, z, rotx, roty, rotz = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = jid
        end
    end
    if id then
        return id
    else
        return false
    end
end

function checkproxylocal(distance,localid)
    if startedlocaltype then
        local pX, pY, pZ = getElementPosition (localPlayer) 
        local dist = distance
        local id = false
        local jid, x, y, z = unpack(cfg.localentregas[startedlocaltype][localid])
        if jid then
            if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
                dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
                id = jid
            end
        end
        if id then
            return id
        else
            return false
        end
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------