----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )


targetdesmanche = false
showdesmanche = false
coldesmancheid = false
local dmctimer = 0
local roubando = false

function dxpressforpaneldesmanche()
    if isElement(targetdesmanche) then
        if not roubando then
            local x, y, z = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-1, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#910808H #d6d6d6PARA INICIAR O DESMANCHE", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    end
end

function onHitdoorcolinfo(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if getElementData(localPlayer,"user_group") ~= "police" then
            if getElementData(source, "iddesmanche") and isElement(getElementData(source, "coldesmanche")) then
                targetdesmanche = source
                showdesmanche = true
                coldesmancheid = getElementData(source,"iddesmanche")
                if not isEventHandlerAdded("onClientRender", root, dxpressforpaneldesmanche) then
                    addEventHandler ("onClientRender", root, dxpressforpaneldesmanche)
                end
            end
        end
	end
end
addEventHandler("onClientColShapeHit", root, onHitdoorcolinfo)

function onLeavedoorcolinfo(hitElement, dim)
    if hitElement ~= localPlayer then return end
    if getElementData(source, "iddesmanche") ~= coldesmancheid then return end
    if dim then
        targetdesmanche = false
        showdesmanche = false
        coldesmancheid = false
        if isEventHandlerAdded("onClientRender", root, dxpressforpaneldesmanche) then
            removeEventHandler ("onClientRender", root, dxpressforpaneldesmanche)
        end
	end
end
addEventHandler("onClientColShapeLeave", root, onLeavedoorcolinfo)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local vehdmc = nil

function dxcountmachineatm()
    if roubando then
        local x, y, z = getElementPosition(localPlayer)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.8, 0.07)
        if (WorldPositionX and WorldPositionY) then
            dxDrawColorText("#d6d6d6AGUARDE #910808"..dmctimer.." #d6d6d6SEGUNDOS, ESTAMOS DESATIVANDO O #910808RASTREADOR #d6d6d6DO VEÍCULO", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end
addEventHandler("onClientRender", getRootElement(), dxcountmachineatm)

function bindstopMachine()
    if isElement(targetdesmanche) then
        if (isPedInVehicle(localPlayer)) then
            if getElementData(localPlayer,"user_group") == "thelost" then 
                if not roubando then
                    local veh = getPedOccupiedVehicle(localPlayer)
                    if veh then
                        roubando = true
                        dmctimer = 30
                        toggleAllControls (false)
                        vehdmc = veh
                    end
                end
            end
        else
            exports.an_infobox:addNotification("Você não está em um <b>veiculo</b>","erro")
        end
    end
end
bindKey("H", "down", bindstopMachine)

function dmctimertread()
    if roubando and dmctimer > 0 then
        dmctimer = dmctimer - 1
        if dmctimer == 0 then
            stopDesmanche()
        end
    end
setTimer(dmctimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), dmctimertread)

toggleAllControls (true)
function stopDesmanche()
    roubando = false
    dmctimer = 0
    toggleAllControls (true)
    triggerServerEvent("stopDmc", localPlayer,localPlayer,vehdmc)
    vehdmc = nil
end

----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
--------------------------------------------------------------------
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
--------------------------------------------------------------------
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