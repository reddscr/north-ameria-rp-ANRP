---------------------------------------------------------------------------------------------------------
-- SCREEN AND FONT
---------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
---------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
---------------------------------------------------------------------------------------------------------
local entregatable = cfg.localsentrega


local startedMission = false
local onlookFinishPoint = false
local missionPoint = false
local missionMilkqtd = 0


local missionMK = nil
local missionBlip = nil
local timerMission = nil
---------------------------------------------------------------------------------------------------------
-- SCRIPT
---------------------------------------------------------------------------------------------------------
function threadMissions()
    if getElementData(localPlayer, "logado") then
        if getElementData(localPlayer, "Garrafacleite") >= 1 then
            if not startedMission then
                if not isTimer(timerMission) then
                    timerMission = setTimer(function()
                        local randompoint = math.random(#entregatable)
                        startedMission = randompoint
                        createMK(randompoint)
                        local randomm = math.random(1,3)
                        missionMilkqtd = randomm
                    end, 1000*10, 1)
                end
            elseif startedMission then
                local proxy = checkproxylocal(2)
                if proxy then
                    onlookFinishPoint = true
                    local x, y, z = getElementPosition(localPlayer)
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawColorText("#efe558N #d6d6d6ENTREGAR O LEITE", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                else
                    if onlookFinishPoint then
                        onlookFinishPoint = false
                    end
                    dxDrawColorText("#d6d6d6ENTREGUE #efe558"..missionMilkqtd.." #d6d6d6GARRAFA DE LEITE(S)", screenX * 1.250, screenY * 0.8448, screenX * 0.5644, screenY * 0.7786, tocolor(255, 255, 255, 255), 1.00, myFont, "center", "center", false, false, false, false, false)
                    dxDrawColorText("#d6d6d6APERTE #910808F2 #d6d6d6PARA CANCELAR", screenX * 1.250, screenY * 0.8948, screenX * 0.5644, screenY * 0.7786, tocolor(255, 255, 255, 255), 1.00, myFont, "center", "center", false, false, false, false, false)
                end
                
            end
        elseif startedMission then
            if startedMission then
                destroyMK()
            end
        end
    end
end
addEventHandler( "onClientRender", root, threadMissions )

function BindFinishjob()
    if onlookFinishPoint then
        triggerServerEvent("finishLeiteiroJob", localPlayer, localPlayer, missionMilkqtd)
        destroyMK()
    end
end
bindKey('n','down', BindFinishjob)

function BindCanceljob()
    if startedMission then
        destroyMK()
    end
end
bindKey('f2','down', BindCanceljob)

function createMK(mission)
    if mission then
        if not isElement(missionMK) then
            missionBlip = createBlip(entregatable[mission][2],entregatable[mission][3],entregatable[mission][4], 2, 2, 255, 255, 0, 255, 50, 9999999999)
            setElementData( missionBlip, "tooltipText",'Milk mission')
            --missionBlip = exports.an_radar:createCustomBlip( entregatable[mission][2],entregatable[mission][3],entregatable[mission][4], "blips/mark.png", true, 9999, 15, tocolor(255, 255, 0, 200), "Milk mission")
            missionMK = createMarker(entregatable[mission][2],entregatable[mission][3],entregatable[mission][4]-1, "cylinder", 0.5, 200, 200, 0, 25)
            --exports.an_radar:makeRoute(entregatable[mission][2],entregatable[mission][3],true) 
        end
    end
end

function destroyMK()
    if isElement(missionMK) then
        destroyElement(missionMK)
        --exports.an_radar:deleteCustomBlip(missionBlip)
        destroyElement(missionBlip)
        missionMK = nil
        missionBlip = nil
        startedMission = false
        onlookFinishPoint = false
        missionMilkqtd = 0
    end
end

---------------------------------------------------------------------------------------------------------
-- VARIABLES
---------------------------------------------------------------------------------------------------------
function checkproxylocal(distance)
    if startedMission then
        local pX, pY, pZ = getElementPosition (localPlayer) 
        local dist = distance
        local id = false
        local jid, x, y, z = unpack(entregatable[startedMission])
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
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------