----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- MISSION
----------------------------------------------------------------------------------------------------------------
local plypayment = 0
local destino = 1
local paymentrandom = {40,60}

local motoriastacol = nil
local motoriastamk = nil
local motoriastablip = nil

--[[missionBlip = exports.an_radar:createCustomBlip( entregatable[mission][2],entregatable[mission][3],entregatable[mission][4], "blips/mark.png", true, 9999, 15, tocolor(255, 255, 0, 200), "Milk mission")
exports.an_radar:deleteCustomBlip(missionBlip)]]
function startmissionmotoriasta()
    local plyid = getElementData(localPlayer,"id")
      if destino == 48 then
        if isElement(motoriastacol) then
          destroyElement(motoriastacol)
          destroyElement(motoriastamk)
          destroyElement(motoriastablip)
          if not isElement(motoriastacol) then
            local randomsort = math.random(paymentrandom[1],paymentrandom[2])
            plypayment = plypayment+randomsort
           -- print("Final Money "..plypayment)
            triggerServerEvent("paymentply_motorista", localPlayer,localPlayer,plypayment)
            destino = 1
            local x,y,z = unpack(cfg.rota[destino])
           -- print(destino.."  "..x,y,z)
            exports.an_infobox:addNotification("Você finalizou a <b>rota</b>. e ganhou $<b>"..plypayment.."<b>.","sucesso")
            exports.an_infobox:addNotification("Continue seguindo a <b>rota</b>.. ou use <b>/cancel<b> para cancelar.","info")
            plypayment = 0
            motoriastablip = createBlip (x,y,z, 2, 2, 255, 255, 0, 255, 50, 999999)
            setElementData( motoriastablip, "tooltipText",'Bus Driver - Route')
            motoriastacol = createColSphere(x,y,z,3)
            motoriastamk = createMarker(x,y,z-1, "cylinder", 2, 255, 255, 0, 25)
            setElementData(motoriastacol,"motoriastacol",motoriastacol)
            setElementData(motoriastacol,"motoriastacolowner",plyid)
          end
        end
      else
        if not isElement(motoriastacol) then
          local x,y,z = unpack(cfg.rota[destino])
          destino = 1
       --   print(destino.."  "..x,y,z)
         -- print("Money "..plypayment)
          motoriastablip = createBlip (x,y,z, 2, 2, 255, 255, 0, 255, 50, 7500)
          setElementData( motoriastablip, "tooltipText",'Bus Driver - Route')
          motoriastacol = createColSphere(x,y,z,3)
          motoriastamk = createMarker(x,y,z-1, "cylinder", 2, 255, 255, 0, 25)
          setElementData(motoriastacol,"motoriastacol",motoriastacol)
          setElementData(motoriastacol,"motoriastacolowner",plyid)
        elseif isElement(motoriastacol) then
          destroyElement(motoriastacol)
          destroyElement(motoriastamk)
          destroyElement(motoriastablip)
          local randomsort = math.random(paymentrandom[1],paymentrandom[2])
          plypayment = plypayment+randomsort
          destino = destino + 1
          local x,y,z = unpack(cfg.rota[destino])
         -- print(destino.."  "..x,y,z)
         -- print("Money "..plypayment)
          exports.an_infobox:addNotification("Continue seguindo a <b>rota</b>.","info")
          motoriastablip = createBlip (x,y,z, 2, 2, 255, 255, 0, 255, 50, 7500)
          setElementData( motoriastablip, "tooltipText",'Bus Driver - Route')
          motoriastacol = createColSphere(x,y,z,3)
          motoriastamk = createMarker(x,y,z-1, "cylinder", 2, 255, 255, 0, 25)
          setElementData(motoriastacol,"motoriastacol",motoriastacol)
          setElementData(motoriastacol,"motoriastacolowner",plyid)
        end
      end
end
addEvent ("startmissionmotoriasta", true)
addEventHandler ("startmissionmotoriasta", root, startmissionmotoriasta)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destroymissionmotoriasta()
    if isElement(motoriastacol) then
        destroyElement(motoriastacol)
        destroyElement(motoriastamk)
        destroyElement(motoriastablip)
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

function inittratamentkey()
    if getElementData(localPlayer,"openui") == false then
        if isEventHandlerAdded("onClientRender", root, dxpressforpanelblipmotorista) then
            if isPedInVehicle(localPlayer) then
                local plyid = getElementData(localPlayer,"id")
                if getElementData(targetcol,"motoriastacolowner") == plyid then
                    if isElement(targetcol) then
                        local veh = getPedOccupiedVehicle(localPlayer)
                        --if (getElementData(veh,"owner") == plyid) and getElementData(veh,"rentalveh") and (getElementData(veh,"vehjobdatas") == "vehjobbus") then
                        if getElementData(veh,"rentalveh") and (getElementData(veh,"vehjobdatas") == "vehjobbus") then
                            if isPedInVehicle (localPlayer) then
                               -- if getPedOccupiedVehicleSeat (localPlayer) == 0 then
                                  targetSpeed = math.floor(getFormatSpeed(localPlayer))
                                  if targetSpeed <= 40 then
                                    --print("velo "..targetSpeed)
                                    startmissionmotoriasta()
                                  else
                                    exports.an_infobox:addNotification("Você está muito <b>rápido</b>. o limite é <b>40 MPH</b>","aviso")
                                  end
                                end
                                if isEventHandlerAdded("onClientRender", root, dxpressforpanelblipmotorista) then
                                    removeEventHandler ("onClientRender", root, dxpressforpanelblipmotorista)
                                end
                           -- end
                        end
                    end
                end
            end
        end
    end
end
bindKey("H", "down", inittratamentkey)

function onHitshopscol(hitElement, dim)
if hitElement ~= localPlayer then return end
    if not getElementData(source, "motoriastacol") then return end
    if dim then
        if isPedInVehicle(localPlayer) then
            if getElementData(source, "motoriastacol") then
                local plyid = getElementData(localPlayer,"id")
                if getElementData(source,"motoriastacolowner") == plyid then
                    targetcol = source
                    if not isEventHandlerAdded("onClientRender", root, dxpressforpanelblipmotorista) then
                        addEventHandler ("onClientRender", root, dxpressforpanelblipmotorista)
                    end
                end
            end
        end
	end
end
addEventHandler("onClientColShapeHit", root, onHitshopscol)

function onLeaveshopscol(hitElement, dim)
  if hitElement ~= localPlayer then return end
  if not getElementData(source, "motoriastacol") then return end
  if dim then
      local plyid = getElementData(localPlayer,"id")
      if getElementData(source,"motoriastacolowner") == plyid then
          targetcol = nil
          if isEventHandlerAdded("onClientRender", root, dxpressforpanelblipmotorista) then
              removeEventHandler ("onClientRender", root, dxpressforpanelblipmotorista)
          end
      end
end
end
addEventHandler("onClientColShapeLeave", root, onLeaveshopscol)
----------------------------------------------------------------------------------------------------------------
-- job motorista
----------------------------------------------------------------------------------------------------------------
targetcolmotorista = false
showcolmotorista = false
colmotoristasid = false

function dxpressforpanelmotoriasta2()
    if isElement(targetcolmotorista) then
        local x, y, z = getElementPosition(targetcolmotorista)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.5, 0.07)
        if (WorldPositionX and WorldPositionY) then
          dxDrawRectangle(WorldPositionX - 95, WorldPositionY -10, 185, 20, tocolor(0, 0, 0, 50), false)
          dxDrawColorText("#00e98cN #d6d6d6PARA PEGAR UMA ROTA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end
---------------------------------------------------------------------
setElementData(localPlayer,"comrota",nil)
function inittratamentkey2()
if getElementData(localPlayer,"openui") == false then
    if isEventHandlerAdded("onClientRender", root, dxpressforpanelmotoriasta2) then
        if (not isPedInVehicle(localPlayer)) then
            if not getElementData(localPlayer,"comrota")  then
                triggerEvent ("timerprogbar", localPlayer,1000,"BUSCANDO ROTA")
                exports.an_infobox:addNotification("Você pegou uma <b>rota</b> finalize ela para receber o pagamento<br> ou use <b>/cancel</b> para cancelar.","sucesso")
                startmissionmotoriasta()
                setElementData(localPlayer,"comrota",true)
            else
              exports.an_infobox:addNotification("Você ja esta com uma <b>rota</b>.","erro")
            end
        end
    end
end
end
bindKey("N", "down", inittratamentkey2)
---------------------------------------------------------------------
function onHitshopscol2(hitElement, dim)
if hitElement ~= localPlayer then return end
  if dim then
    if (not isPedInVehicle(localPlayer)) then
      if getElementData(source, "idcentralmotorista") and isElement(getElementData(source, "colcentralmotorista")) then
        targetcolmotorista = source
        showcolmotorista = true
        colmotoristasid = getElementData(source,"idcentralmotorista")
        if not isEventHandlerAdded("onClientRender", root, dxpressforpanelmotoriasta2) then
          addEventHandler ("onClientRender", root, dxpressforpanelmotoriasta2)
        end
      end
    end
	end
end
addEventHandler("onClientColShapeHit", root, onHitshopscol2)
------------------------------------------------------------
function onLeaveshopscol2(hitElement, dim)
if hitElement ~= localPlayer then return end
if getElementData(source, "idcentralmotorista") ~= colmotoristasid then return end
  if dim then
    if isEventHandlerAdded("onClientRender", root, dxpressforpanelmotoriasta2) then
      removeEventHandler ("onClientRender", root, dxpressforpanelmotoriasta2)
    end
      targetcolmotorista = false
      showcolmotorista = false
      colmotoristasid = false
	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveshopscol2)
----------------------------------------------------------------------------------------------------------------
-- VARIAEIS
----------------------------------------------------------------------------------------------------------------
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