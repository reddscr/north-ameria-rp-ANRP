-------------------------------------------------------------------------------------------------------
-- SCREEN
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
local startedmission = false
local missiontimer = 0
local missionitens = {
    {107},
    {108}
}
local missionblip = {}
local missionmk = {}

local selecteditem = nil
local selecteditemqtd = 0
local selectedroute = nil

local onLookatmkmission = false
-------------------------------------------------------------------------------------------------------
-- JOB FUNCTIONS
-------------------------------------------------------------------------------------------------------
function geratemission()
    if getElementData(localPlayer,"medictoggle") then
        if not startedmission then
            startedmission = true
            local ritem = math.random(#missionitens)
            local rroute = math.random(#cfg.routes)
            selecteditem = missionitens[ritem][1]
            selecteditemqtd = math.random(7,12)
            selectedroute = {cfg.routes[rroute][1],cfg.routes[rroute][2],cfg.routes[rroute][3],cfg.routes[rroute][4]}
            missionblip[cfg.routes[rroute][1]] = createBlip (cfg.routes[rroute][2],cfg.routes[rroute][3],cfg.routes[rroute][4], 2, 2, 100, 0, 255, 255, 50, 7500)
            missionmk[cfg.routes[rroute][1]] = createMarker(cfg.routes[rroute][2],cfg.routes[rroute][3],cfg.routes[rroute][4]-1, "cylinder", 0.5, 255, 255, 0, 25)
        end
        if startedmission then
            proxy = getproxyonply(2)
            if proxy then
                onLookatmkmission = true
                local itemdb = exports.an_account:getitemtable(selecteditem)
                if itemdb then
                    local jid, x, y, z = unpack(selectedroute)
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x, y, z-0.2, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawColorText("#00e98cN #d6d6d6PEGAR "..selecteditemqtd.."x "..itemdb[5].."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                end
            else
                onLookatmkmission = false
            end
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
end
addEventHandler("onClientRender",root,geratemission)
-------------------------------------------------------------------------------------------------------
-- BIND JOB
-------------------------------------------------------------------------------------------------------
function colectitem()
    if onLookatmkmission then
        local itemdb = exports.an_account:getitemtable(selecteditem)
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
                exports.an_infobox:addNotification("Você pegou "..selecteditemqtd.."x <b>"..itemdb[5].."</b>","sucesso")
            else
                exports.an_infobox:addNotification("A <b>mochila</b> não tem espaço.","erro")
            end
        end
    end
end
bindKey("n","down",colectitem)

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