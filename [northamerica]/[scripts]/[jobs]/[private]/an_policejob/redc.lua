-------------------------------------------------------------------------------------------------------
-- SCREEN
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------
-- JOB VARI
-------------------------------------------------------------------------------------------------------
local jobcol = false
local jobmk = {}
local jobblip = {}

local jobroute = 1
----------------------------------------------------------------------------------------------------------------
-- MISSION
----------------------------------------------------------------------------------------------------------------

local plypayment = 0
local destino = 1
local paymentrandom = {40,60}

local motoriastacolpolice = {}
local motoriastamkpolice = {}
local motoriastablippolice = {}

local startedjob = false
function checkpolicejob()
    if getElementData(localPlayer,"policetoggle") then
        if not startedjob then
            startedjob = true
            startmissionmotoriasta()
        end
    else
        if startedjob then
            startedjob = false
            destroymissionmotoriasta()
            destino = 1
            plypayment = 0
            if isElement(motoriastacolpolice) then
                destroyElement(motoriastacolpolice)
                destroyElement(motoriastamkpolice)
                destroyElement(motoriastablippolice)
            end
        end
    end
end
addEventHandler("onClientRender",root,checkpolicejob)

function startmissionmotoriasta()
    local plyid = getElementData(localPlayer,"id")
      if destino == 129 then
        if isElement(motoriastacolpolice) then
          destroyElement(motoriastacolpolice)
          destroyElement(motoriastamkpolice)
          destroyElement(motoriastablippolice)
          if not isElement(motoriastacolpolice) then
            local randomsort = math.random(paymentrandom[1],paymentrandom[2])
            plypayment = plypayment+randomsort
            triggerServerEvent("paymentply_motoristapolice", localPlayer,localPlayer,plypayment)
            destino = 1
            local x,y,z = unpack(cfg.routes[destino])
            exports.an_infobox:addNotification("Você finalizou a <b>rota</b>. e ganhou $<b>"..plypayment.."<b>.","aviso")
            exports.an_infobox:addNotification("Continue seguindo a <b>rota</b>.. ou use <b>/cancel<b> para cancelar.","info")
            plypayment = 0
            motoriastablippolice = createBlip (x,y,z, 2, 2, 200, 200, 200, 255, 50, 7500)
            motoriastacolpolice = createColSphere(x,y,z,3)
            motoriastamkpolice = createMarker(x,y,z-1, "cylinder", 2, 255, 255, 0, 25)
            setElementData(motoriastacolpolice,"motoriastacolpolice",motoriastacolpolice)
            setElementData(motoriastacolpolice,"motoriastacolpoliceowner",plyid)
          end
        end
      else
        if not isElement(motoriastacolpolice) then
          local x,y,z = unpack(cfg.routes[destino])
          destino = 1
          motoriastablippolice = createBlip (x,y,z, 2, 2, 200, 200, 200, 255, 50, 7500)
          motoriastacolpolice = createColSphere(x,y,z,3)
          motoriastamkpolice = createMarker(x,y,z-1, "cylinder", 2, 255, 255, 0, 25)
          setElementData(motoriastacolpolice,"motoriastacolpolice",motoriastacolpolice)
          setElementData(motoriastacolpolice,"motoriastacolpoliceowner",plyid)
        elseif isElement(motoriastacolpolice) then
          destroyElement(motoriastacolpolice)
          destroyElement(motoriastamkpolice)
          destroyElement(motoriastablippolice)
          local randomsort = math.random(paymentrandom[1],paymentrandom[2])
          plypayment = plypayment+randomsort
          destino = destino + 1
          local x,y,z = unpack(cfg.routes[destino])
          exports.an_infobox:addNotification("Continue seguindo a <b>rota</b>.","aviso")
          motoriastablippolice = createBlip (x,y,z, 2, 2, 200, 200, 200, 255, 50, 7500)
          motoriastacolpolice = createColSphere(x,y,z,3)
          motoriastamkpolice = createMarker(x,y,z-1, "cylinder", 2, 255, 255, 0, 25)
          setElementData(motoriastacolpolice,"motoriastacolpolice",motoriastacolpolice)
          setElementData(motoriastacolpolice,"motoriastacolpoliceowner",plyid)
        end
      end
end
addEvent ("startmissionmotoriasta", true)
addEventHandler ("startmissionmotoriasta", root, startmissionmotoriasta)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destroymissionmotoriasta()
    if isElement(motoriastacolpolice) then
        destroyElement(motoriastacolpolice)
        destroyElement(motoriastamkpolice)
        destroyElement(motoriastablippolice)
    end
end
addEvent ("destroymissionmotoriasta", true)
addEventHandler ("destroymissionmotoriasta", root, destroymissionmotoriasta)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- COLHIT/COLLEAVE
local targetcol = nil
function dxpressforpanelblipmotorista()
    if isElement(targetcol) then
        local x, y, z = getElementPosition(targetcol)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.5, 0.07)
        if (WorldPositionX and WorldPositionY) then
            dxDrawRectangle(WorldPositionX - 100, WorldPositionY -10, 185, 20, tocolor(0, 0, 0, 50), false)
            dxDrawColorText("#00e98cH #d6d6d6PARA CONTINUAR A ROTA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end

function onHitshopscol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if not getElementData(source, "motoriastacolpolice") then return end
    if dim then
      if isPedInVehicle(localPlayer) then
        if getElementData(source, "motoriastacolpolice") then
          local plyid = getElementData(localPlayer,"id")
          if getElementData(source,"motoriastacolpoliceowner") == plyid then
            local veh = getPedOccupiedVehicle(localPlayer)
            if getElementData(veh,"rentalveh") and (getElementData(veh,"vehjobdatas") == "vehjobpolice") then
              targetSpeed = math.floor(getFormatSpeed(localPlayer))
              if targetSpeed <= 40 then
                startmissionmotoriasta()
              else
                exports.an_infobox:addNotification("Você está muito <b>rápido</b>. o limite é <b>40 MPH</b>","aviso")
              end
            end
          end
        end
      end
	end
end
addEventHandler("onClientColShapeHit", root, onHitshopscol)

function onLeaveshopscol(hitElement, dim)
  if hitElement ~= localPlayer then return end
  if not getElementData(source, "motoriastacolpolice") then return end
  if dim then
    local plyid = getElementData(localPlayer,"id")
      if getElementData(source,"motoriastacolpoliceowner") == plyid then
        targetcol = nil
        if isEventHandlerAdded("onClientRender", root, dxpressforpanelblipmotorista) then
          removeEventHandler ("onClientRender", root, dxpressforpanelblipmotorista)
        end
      end
  end
end
addEventHandler("onClientColShapeLeave", root, onLeaveshopscol)
-------------------------------------------------------------------------------------------------------
-- VARI
-------------------------------------------------------------------------------------------------------
function getFormatSpeed(ply)
  local speedes = (getVehicleVelocity((getPedOccupiedVehicle(ply)))) * 1.558
  return speedes
end
function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	return relateVelocity((speedx^2 + speedy^2 + speedz^2)^ 0.5 * 100)
end
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
local factor = 0.675
function relateVelocity(speed)
	return factor * speed
end 

function getproxyonply(distance)
    if jobcol then
        local pX, pY, pZ = getElementPosition (localPlayer) 
        local dist = distance
        local id = false
        for i, v in ipairs (cfg.routes) do 
        -- local x, y, z = getElementPosition(v)
            local x, y, z = unpack(v)
            if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z ) < dist then
                dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z )
                id = i
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