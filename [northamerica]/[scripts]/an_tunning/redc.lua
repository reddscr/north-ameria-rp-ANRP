----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenW, screenH = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- custom veh
----------------------------------------------------------------------------------------------------------------
local tablecustom = {
  { ['id'] = 1, ['x'] = 2031.884, ['y'] = 2090.694, ['z'] = 10.9,  ['vx'] = 2027.5, ['vy'] = 2090.706, ['vz'] = 11.9, ['vh'] = 270, ['vh2'] = 190, ['gp'] = 'mechanic.permission' },
  { ['id'] = 1, ['x'] = 2484.087, ['y'] =  1229.605, ['z'] = 10.845,  ['vx'] = 2479.0, ['vy'] = 1229.655, ['vz'] = 12, ['vh'] = 270, ['vh2'] = 190, ['gp'] = 'westcoast.permission' },
}

local vehiclecustom = false
local lookatcustomlocal = false
local ontunning = false

local wheeltable = {
  {1073},
  {1074},
  {1075},
  {1076},
  {1077},
}
local wheel = 0
function dxpanel()
  dxDrawColorText("#dc3232*Este painel e temporario!", screenW * 0.3294, screenH * 0.9128, screenW * 0.6698, screenH * 0.9414, tocolor(255, 255, 255, 255), 1.00, myFont, "center", "center", false, false, false, false, false)
  dxDrawColorText("#ededed◀ #3f98deTROCAR RODA #ededed▶         #edededH:#3f98deREMOVER RODA         #edededENTER: #3f98deINSTALAR         G#ededed: #dc3232Sair", screenW * 0.3294, screenH * 0.9414, screenW * 0.6698, screenH * 0.9701, tocolor(255, 255, 255, 255), 1.00, myFont, "center", "center", false, false, false, false, false)
end

function nextwheel()
  if vehiclecustom then
    if isEventHandlerAdded("onClientRender", root, dxpanel) then
      if wheeltable[wheel+1] then
          wheel = wheel+1
      else
        wheel = 1
      end
      triggerServerEvent('prevwheel', localPlayer, localPlayer, vehiclecustom, wheeltable[wheel][1])
    end
  end
end
bindKey('arrow_r','down',nextwheel)

function returnwheel()
  if vehiclecustom then
    if isEventHandlerAdded("onClientRender", root, dxpanel) then
      if wheeltable[wheel-1] then
        wheel = wheel-1
      else
        wheel = #wheeltable
      end
      triggerServerEvent('prevwheel', localPlayer, localPlayer, vehiclecustom, wheeltable[wheel][1])
    end
  end
end
bindKey('arrow_l','down',returnwheel)

function buywheel()
  if vehiclecustom then
    if isEventHandlerAdded("onClientRender", root, dxpanel) then
      if getElementData(localPlayer,"Money") >= 2000 then
        triggerServerEvent('savetunningonveh', localPlayer, localPlayer, vehiclecustom, wheeltable[wheel][1])
        exports.an_inventory:attitem("Money",2000,"menos")
      else
        exports.an_infobox:addNotification("Você não tem $ <b>2000</b>.","erro")
      end
    end
  end
end
bindKey('enter','down',buywheel)

function buywheel()
  if vehiclecustom then
    if isEventHandlerAdded("onClientRender", root, dxpanel) then
      triggerServerEvent('resetvehiclewheel', localPlayer, localPlayer, vehiclecustom, wheeltable)
    end
  end
end
bindKey('h','down',buywheel)

function startcustomvehicle()
  if isPedInVehicle(localPlayer) then
    local proxyonply = proxymech(4)
    if proxyonply then
      if exports.an_account:hasPermission(proxyonply.gp) then
        if not vehiclecustom then
          ontunning = proxyonply
          lookatcustomlocal = proxyonply
          local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(proxyonply.x, proxyonply.y, proxyonply.z-0.2, 0.07)
          if (WorldPositionX and WorldPositionY) then
            if getElementData(localPlayer,"openui") == false then
              dxDrawColorText("#00e98cG #d6d6d6ACESSAR OFICINA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
          end
        end
      end
      
    else
      if lookatcustomlocal then
        lookatcustomlocal = false
      end
    end
  end
end
addEventHandler("onClientRender", root, startcustomvehicle)

function bindtogglemechanictunning()
  if lookatcustomlocal and not vehiclecustom and ontunning then
    if isPedInVehicle(localPlayer) then
      if getPedOccupiedVehicleSeat (localPlayer) == 0 then
        local vehpos = toJSON({ontunning.vx, ontunning.vy, ontunning.vz})
        local vehinpos = getproxveh(vehpos, 2)
        if not vehinpos then
          veh = getPedOccupiedVehicle (localPlayer)
          if (veh) then
            vehiclecustom = veh
            setElementFrozen(veh, true)
            toggleAllControls(false)
            toggleControl("voiceptt", true)
            setElementData(localPlayer, 'ontunningveh', veh)
            setElementData(localPlayer, 'ontunninglocal', toJSON({ontunning.x, ontunning.y, ontunning.z, ontunning.vh2}))
            setElementPosition(veh,ontunning.vx, ontunning.vy, ontunning.vz)
            setElementRotation(veh, 0, 0, ontunning.vh)
            addEventHandler("onClientRender",getRootElement(),dxpanel)
          end
        else
          exports.an_infobox:addNotification(ply,"Há um <b>veiculo</b> na vaga","aviso") 
        end
      end
    end
  elseif vehiclecustom and ontunning then
    if isPedInVehicle(localPlayer) then
      setElementPosition(vehiclecustom, ontunning.x, ontunning.y, ontunning.z)
      setElementRotation(vehiclecustom, 0, 0, ontunning.vh2)
      setElementFrozen(vehiclecustom, false)
      setElementData(localPlayer, 'ontunningveh', false)
      setElementData(localPlayer, 'ontunninglocal', false)
      toggleAllControls(true)
      triggerServerEvent('exittunningveh', localPlayer, localPlayer, vehiclecustom)
      vehiclecustom = false
      ontunning = false
      removeEventHandler("onClientRender",getRootElement(),dxpanel)
    end
  end
end
bindKey("g", "down", bindtogglemechanictunning)

------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
------------------------------------------------------------------------------------------------------------------
function getproxveh(cord, d)
	local poss = fromJSON(cord)
	local dist = d
	local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
          local pX, pY, pZ = getElementPosition (v) 
          if getDistanceBetweenPoints3D (poss[1],poss[2],poss[3], pX, pY, pZ) < dist then
              dist = getDistanceBetweenPoints3D (poss[1],poss[2],poss[3], pX, pY, pZ)
              id = v
          end
    end
    if id then
        return id
    else
        return false
    end
end

function proxymech(distance)
  local pX, pY, pZ = getElementPosition (localPlayer) 
  local dist = distance
  local id = false
  for i, v in ipairs (tablecustom) do 
      if getDistanceBetweenPoints3D ( pX, pY, pZ, v.x, v.y, v.z) < dist then
          dist = getDistanceBetweenPoints3D ( pX, pY, pZ, v.x, v.y, v.z)
          id = v
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
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------