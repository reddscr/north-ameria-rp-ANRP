-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- CHECK PLY IN PRISION
----------------------------------------------------------------------------------------------------------------
function onLeaveprisioncol(hitElement, dim)
    if hitElement ~= localPlayer then return end
    if not getElementData(source, "prisioncol") then return end
    if dim then
        if getElementData(localPlayer,"injail") then
            triggerServerEvent ("returnplyprision", localPlayer,localPlayer)
        end
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveprisioncol)

function onLeaveprisioncol2(hitElement, dim)
    if hitElement ~= localPlayer then return end
    if not getElementData(source, "prisioncol2") then return end
    if dim then
        if getElementData(localPlayer,"injail") then
            triggerServerEvent ("returnplyprision", localPlayer,localPlayer)
        end
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveprisioncol2)
----------------------------------------------------------------------------------------------------------------
-- PRISION JOB
----------------------------------------------------------------------------------------------------------------
local prisionjobstart = false
local prisionjobblip = {}
local prisionjobmk = {}
local jobtimer = nil
local prisionobtyp = false
local prisionlocals = false
local onlookatobmk = false
function checkplyonprision()
    if getElementData(localPlayer,"injail") then
        local prision = getElementData(localPlayer,"prision")
        if prision then
            if not isTimer(jobtimer) then
                if not prisionjobstart then
                    prisionjobstart = true
                    local jobtyp = math.random(1,#cfg.typesjobprision[prision])
                    local typ = unpack(cfg.typesjobprision[prision][jobtyp])
                    local joblocals = math.random(1,#cfg.prisionjob[prision][typ])
                    local id,x,y,z,anim,anim2,typtext = unpack(cfg.prisionjob[prision][typ][joblocals])
                    if x and y and z then
                        prisionobtyp = typ
                        prisionlocals = id
                        prisionjobblip = createBlip (x,y,z, 2, 2, 255, 255, 0, 255, 50, 700)
                        setElementData( prisionjobblip, "tooltipText",'Chamado para '..typtext..'')
                        prisionjobmk = createMarker(x,y,z-1, "cylinder", 0.5, 255, 255, 0, 25)
                        exports.an_infobox:addNotification("Você foi chamado para <b>"..typtext.."</b>.","aviso")
                    end
                end
            end
        end
        if prisionjobstart then
            local prision = getElementData(localPlayer,"prision")
            local proxyonply = getproxyonply(1)
            if proxyonply then
                for i, v in ipairs (cfg.prisionjob[prision][prisionobtyp]) do 
                    if v[1] == proxyonply then
                        onlookatobmk = proxyonply
                        local jid,x,y,z,anim,anim2,typtext = unpack(v)
                        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.2, 0.07)
                        if (WorldPositionX and WorldPositionY) then
                            dxDrawColorText("#efe558N #d6d6d6"..prisionobtyp.."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        end
                    end
                end
            else
                onlookatobmk = false
            end
        end
    else
        if prisionjobstart then
            prisionjobstart = false
            onlookatobmk = false
            prisionobtyp = false
            if isElement(prisionjobmk) then
                destroyElement(prisionjobmk)
            end
            if isElement(prisionjobblip) then
                destroyElement(prisionjobblip)
            end
        end
    end
end
addEventHandler("onClientRender", root, checkplyonprision)

function bindforinitjobprision()
    if getElementData(localPlayer,"injail") then
        if onlookatobmk then
            local prision = getElementData(localPlayer,"prision")
            for i, v in ipairs (cfg.prisionjob[prision][prisionobtyp]) do 
                if v[1] == onlookatobmk then
                    local jid,x,y,z,anim,anim2,typtext = unpack(v)
                    if jid then
                        toggleAllControls(false)
                        destroyElement(prisionjobmk)
                        destroyElement(prisionjobblip)
                        prisionjobstart = false
                        onlookatobmk = false
                        prisionobtyp = false
                        setElementData(localPlayer,"emacao",true)
                        triggerServerEvent ("setanimprisionjob", localPlayer,localPlayer,1,anim,anim2)
                        jobtimer = setTimer(function()
                            toggleAllControls(true)
                            setElementData(localPlayer,"emacao",false)
                            triggerServerEvent ("setanimprisionjob", localPlayer,localPlayer,2)
                            triggerServerEvent ("decreasesjail", localPlayer,localPlayer)
                        end,10000,1)

                    end
                end
            end
        end
    end
end
bindKey("N", "down", bindforinitjobprision)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    local prision = getElementData(localPlayer,"prision")
    if prision then
        for i, v in ipairs (cfg.prisionjob[prision][prisionobtyp]) do 
            if v[1] == prisionlocals then
                local jid,x,y,z,anim,anim2,typtext = unpack(v)
                if getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z) < dist then
                    dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z)
                    id = jid
                end
            end
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
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------