-------------------------------------------------------------------------------------------------------
-- SCREEN
-------------------------------------------------------------------------------------------------------
local screenW, screenH = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
local startedmission = false
local missiontimer = 0
local missionitens = {
    {"Copper"},
    {"Steel"},
    {"Plastic"},
    {"Iron"},
    {"Circuit"},
    {"Aluminum"},
    {"Gunpowder"}
}
local missionblip = {}
local missionmk = {}

local selecteditem = nil
local selecteditemqtd = 0
local selectedroute = nil

local onLookatmkmission = false

local onLookStarter = false
local StartedpickupJob = false
local timerMission = nil

local onLookStarter2 = false
local StartedpickupJob2 = false

local startedMission = false
local onlookFinishPoint = false
local missionPoint = false
local missionDelyqtd = 0
local selecteditem2 = nil
local missionitens2 = {
    {"pistolammu"},
    {"AK103ammu"},
    {"winchester22ammu"}
}
local entregatable = cfg.routes

local missionMK = nil
local missionBlip = nil
local timerMission2 = nil
-------------------------------------------------------------------------------------------------------
-- JOB FUNCTIONS
-------------------------------------------------------------------------------------------------------
function geratemission()
    if StartedpickupJob then
        if not startedmission then
            if not isTimer(timerMission) then
                timerMission = setTimer(function()
                    startedmission = true
                    local ritem = math.random(#missionitens)
                    local rroute = math.random(#cfg.routes)
                    selecteditem = missionitens[ritem][1]
                    selecteditemqtd = math.random(3,10)
                    selectedroute = {cfg.routes[rroute][1],cfg.routes[rroute][2],cfg.routes[rroute][3],cfg.routes[rroute][4]}
                    missionblip[cfg.routes[rroute][1]] = createBlip (cfg.routes[rroute][2],cfg.routes[rroute][3],cfg.routes[rroute][4], 2, 2, 100, 0, 255, 255, 50, 7500)
                    local itemdb = exports.an_account:getitemtable2client(selecteditem)
                    if itemdb then
                        setElementData( missionblip[cfg.routes[rroute][1]], "tooltipText",'Tool - '..selecteditemqtd..'x '..itemdb[5]..'')
                    end
                    missionmk[cfg.routes[rroute][1]] = createMarker(cfg.routes[rroute][2],cfg.routes[rroute][3],cfg.routes[rroute][4]-1, "cylinder", 0.5, 255, 255, 0, 25)
                end, 1000*10, 1)
            end
        end
        if startedmission then
            --[[proxy = getproxyonply(2)
            if proxy then]]
                --onLookatmkmission = true
                local itemdb = exports.an_account:getitemtable2client(selecteditem)
                if itemdb then
                    --[[local jid, x, y, z = unpack(selectedroute)
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z-0.2, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawColorText("#00e98cN #d6d6d6PEGAR "..selecteditemqtd.."x "..itemdb[5].."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end]]

                    local pX, pY, pZ = getElementPosition(localPlayer)
                    local jid, x, y, z = unpack(selectedroute)
                    if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) >= 2 then
                        if onLookatmkmission then
                            onLookatmkmission = false
                        end
                        if not isPedInVehicle(localPlayer) then
                            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
                            if (WorldPositionX and WorldPositionY) then
                                dxDrawColorText("#3b8ff7LOCAL #d6d6d6: ENCOMENDA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                            end
                        end
                    elseif getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < 2 then
                        if not isPedInVehicle(localPlayer) then
                            onLookatmkmission = true
                            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
                            if (WorldPositionX and WorldPositionY) then
                                dxDrawColorText("#3b8ff7[N] #d6d6d6: RECOLHER "..selecteditemqtd.."x "..itemdb[5].."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                            end
                        end
                    end

                end
           -- else
             --   onLookatmkmission = false
          --  end
        end
    else
        if startedmission then
            startedmission = false
            local jid, x, y, z = unpack(selectedroute)
            if isElement(missionblip[jid]) then
                destroyElement(missionblip[jid])
                destroyElement(missionmk[jid])
                missionblip[jid] = nil
                missionmk[jid] = nil
                startedmission = false
            end
        end
    end
    local proxyonply = getproxyonplyStarter(1.5)
    if proxyonply then
        for i, v in ipairs (cfg.localStarter) do
            local id, x, y, z = unpack(v) 
            if id == proxyonply then
                onLookStarter = id
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z-0.2, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    if getElementData(localPlayer,"openui") == false then
                        if not StartedpickupJob then
                            dxDrawColorText("#3b8ff7[N] #d6d6d6: INICIAR BUSCA POR MATERIAIS", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        else
                            dxDrawColorText("#910808[N] #d6d6d6: ENCERRAR BUSCA POR MATERIAIS", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        end
                    end
                end
            end
        end
    else
        if onLookStarter then
            onLookStarter = false
        end
    end
    local proxyonply2 = getproxyonplyStarter2(1.5)
    if proxyonply2 then
        for i, v in ipairs (cfg.localStarter2) do
            local id, x, y, z = unpack(v) 
            if id == proxyonply2 then
                onLookStarter2 = id
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z-0.2, 0.07)
                if (WorldPositionX and WorldPositionY) then
                    if getElementData(localPlayer,"openui") == false then
                        if not StartedpickupJob2 then
                            dxDrawColorText("#3b8ff7[N] #d6d6d6: INICIAR VENDA DE MUNIÇÂO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        else
                            dxDrawColorText("#910808[N] #d6d6d6: ENCERRAR VENDA DE MUNIÇÂO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        end
                    end
                end
            end
        end
    else
        if onLookStarter2 then
            onLookStarter2 = false
        end
    end
end
addEventHandler("onClientRender",root,geratemission)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function togglePickup()
    if onLookStarter then
        if not StartedpickupJob then
            StartedpickupJob = true
        else
            StartedpickupJob = false
        end
    elseif onLookStarter2 then
        if not StartedpickupJob2 then
            StartedpickupJob2 = true
        else
            StartedpickupJob2 = false
        end
    end
end
bindKey("n","down",togglePickup)
-------------------------------------------------------------------------------------------------------
-- BIND JOB
-------------------------------------------------------------------------------------------------------
function colectitem()
    if onLookatmkmission then
        local itemdb = exports.an_account:getitemtable2client(selecteditem)
        if itemdb then
            if getElementData(localPlayer,"MocSlot") + itemdb[4]*selecteditemqtd < getElementData(localPlayer,"MocMSlot") then
                onLookatmkmission = false
                local jid, x, y, z = unpack(selectedroute)
                if isElement(missionblip[jid]) then
                    destroyElement(missionblip[jid])
                    destroyElement(missionmk[jid])
                    missionblip[jid] = nil
                    missionmk[jid] = nil
                    startedmission = false
                end
                exports.an_inventory:attitem(itemdb[2],selecteditemqtd,"mais")
            else
                exports.an_infobox:addNotification("A <b>mochila</b> não tem espaço.","erro")
            end
        end
    end
end
bindKey("n","down",colectitem)
-------------------------------------------------------------------------------------------------------
-- SELL JOB
-------------------------------------------------------------------------------------------------------
function threadMissions()
    if StartedpickupJob2 then
        if not startedMission then
            if not isTimer(timerMission2) then
                timerMission2 = setTimer(function()
                    local randomm = math.random(2,5)
                    missionDelyqtd = randomm
                    local ritem = math.random(#missionitens2)
                    selecteditem2 = missionitens2[ritem][1]
                    local randompoint = math.random(#entregatable)
                    startedMission = randompoint
                    createMK(randompoint)
                end, 1000*10, 1)
            end
         elseif startedMission then
            local pX, pY, pZ = getElementPosition(localPlayer)
            local jid, x, y, z = unpack(entregatable[startedMission])
            if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) >= 2 then
                if onlookFinishPoint then
                    onlookFinishPoint = false
                end
                if not isPedInVehicle(localPlayer) then
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawColorText("#3b8ff7LOCAL #d6d6d6: ENTREGA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                end
            elseif getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < 2 then
                if not isPedInVehicle(localPlayer) then
                    onlookFinishPoint = true
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawColorText("#3b8ff7[N] #d6d6d6: ENTREGAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                end
            end
        end
    elseif startedMission then
        destroyMK()
    end
end
addEventHandler( "onClientRender", root, threadMissions )

function BindFinishjob()
    if onlookFinishPoint then
        triggerServerEvent("finishMafiadelJob", localPlayer, localPlayer, missionDelyqtd, selecteditem2)
        destroyMK()
    end
end
bindKey('n','down', BindFinishjob)

function createMK(mission)
    if mission then
        if not isElement(missionMK) then
            missionBlip = createBlip(entregatable[mission][2],entregatable[mission][3],entregatable[mission][4], 2, 2, 255, 255, 0, 255, 50, 9999999999)
            local itemdb = exports.an_account:getitemtable2client(selecteditem2)
            if itemdb then
                setElementData(missionBlip, "tooltipText",'Sell - '..missionDelyqtd..'x '..itemdb[5]..'')
            end
            missionMK = createMarker(entregatable[mission][2],entregatable[mission][3],entregatable[mission][4]-1, "cylinder", 0.5, 200, 200, 0, 25)
        end
    end
end

function destroyMK()
    if isElement(missionMK) then
        destroyElement(missionMK)
        destroyElement(missionBlip)
        missionMK = nil
        missionBlip = nil
        startedMission = false
        onlookFinishPoint = false
        selecteditem2 = nil
        missionDelyqtd = 0
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

-------------------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------------------
function getproxyonply(distance)
    if startedmission then
        local pX, pY, pZ = getElementPosition (localPlayer) 
        local dist = distance
        local id = false
        if selectedroute then
            local jid, x, y, z = unpack(selectedroute)
            if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z ) < dist then
                dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z )
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

function getproxyonplyStarter(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
    local dist = distance
    local id = false
    for i, v in ipairs (cfg.localStarter) do 
        local tid, x, y, z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = tid
        end
    end
    if id then
        return id
    else
        return false
    end
end

function getproxyonplyStarter2(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
    local dist = distance
    local id = false
    for i, v in ipairs (cfg.localStarter2) do 
        local tid, x, y, z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = tid
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
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------