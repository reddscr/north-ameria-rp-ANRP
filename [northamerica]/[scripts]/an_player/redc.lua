
----------------------------------------------------------------------------------------------------------------
-- Voice key
----------------------------------------------------------------------------------------------------------------
function rangecfg()
  if getElementData(localPlayer,"range") == 10 then
    setElementData(localPlayer, "range", 20)  
  elseif getElementData(localPlayer,"range") == 20 then
    setElementData(localPlayer, "range", 5)  
  elseif getElementData(localPlayer,"range") == 5 then
    setElementData(localPlayer, "range", 10)  
  end
end
bindKey("'", "down", rangecfg)
----------------------------------------------------------------------------------------------------------------
-- ITEMS FUNCTIONS
----------------------------------------------------------------------------------------------------------------
setElementData(localPlayer, "lockpick", false)  
function uselockpick()
  triggerEvent ("timerprogbar", localPlayer,15000,"ROUBANDO")
    if isTimer ( timer ) then return end
    timer = setTimer(
    function()
      triggerServerEvent ("lockpick1", localPlayer,localPlayer)
    end,15000,1)
end
addEvent ("uselockpick", true)
addEventHandler ("uselockpick", root, uselockpick)

setElementData(localPlayer, "inrepairkit", false)  
function userepairkit()
  triggerEvent ("timerprogbar", localPlayer,15000,"REPARANDO VEICULO")
    if isTimer ( timer ) then return end
    timer = setTimer(
    function()
      triggerServerEvent ("inrepairkit", localPlayer,localPlayer)
    end,15000,1)
end
addEvent ("userepairkit", true)
addEventHandler ("userepairkit", root, userepairkit)

setElementData(localPlayer, "nitrous", false)  
function usenitrous()
  triggerEvent ("timerprogbar", localPlayer,15000,"COLOCANDO NITROUS")
    if isTimer ( timer ) then return end
    timer = setTimer(
    function()
      triggerServerEvent ("nitrous1", localPlayer,localPlayer)
    end,15000,1)
end
addEvent ("usenitrous", true)
addEventHandler ("usenitrous", root, usenitrous)
----------------------------------------------------------------------------------------------------------------
-- USE _ BANDAGEM
----------------------------------------------------------------------------------------------------------------
setElementData(localPlayer,"bandagem",false)
function usebandagem()
  triggerEvent ("timerprogbar2", localPlayer,10000,"USANDO BANDAGEM")
  if isTimer ( timer ) then return end
  timer = setTimer(
  function()
      triggerServerEvent ("bandagem1", localPlayer,localPlayer)
  end,10000,1)
end
addEvent ("usebandagem", true)
addEventHandler ("usebandagem", root, usebandagem)
----------------------------------------------------------------------------------------------------------------
-- USE _ ENERGETICO
----------------------------------------------------------------------------------------------------------------
setElementData(localPlayer,"usingenercetic",false)
setElementData(localPlayer,"inenergectefect",false)
function useenegetc()
  triggerEvent ("timerprogbar2", localPlayer,3000,"BEBENDO ENERGETICO")
  if isTimer ( timer ) then return end
  timer = setTimer(
  function()
    triggerServerEvent ("useenegetc1", localPlayer,localPlayer)
end
,3000,1)
end
addEvent ("useenegetc", true)
addEventHandler ("useenegetc", root, useenegetc)
----------------------------------------------------------------------------------------------------------------
-- perder item na agua
----------------------------------------------------------------------------------------------------------------
local itensdestroiveis = {
  {"Money"},
  {"Bandaid"},
  {"Alianca"},
  {"Isca"},
  {"Lockpick"},
  {"Pendrive"},
  {"taser"},
  {"Baiacu"},
  {"Sardinha"},
  {"Atum"},
  {"Anchova"},
  {"Salmao"},
  {"Garoupa"},
  {"Robalo"},
  {"Redsnapper"},
  {"Mask"},
  {"DirtyMoney"},
  {"Phone"},
  {"Raceticket"},
  {"Marijuana"},
  {"Weedleaf"},
  {"Fermentedmarijuana"},
  {"Canabisseed"},
  {"Paper"},
  {"Cloth"},
  {"Pills"},
}

function verifyplyinwater()
    if isElementInWater( localPlayer ) then
      --print(getElementData(localPlayer,"Nome"))
      for i,v in ipairs (itensdestroiveis) do 
        --if tonumber(data) == v[1] then
        local getplydata = getElementData(localPlayer, v[1]) or 0
        if getplydata >= 1 then
          triggerServerEvent ("removeplyitemonwaterhit", localPlayer,localPlayer,v[1],getplydata)
        end
       -- end
      end
    end
  setTimer(verifyplyinwater,1000,1)
end 
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), verifyplyinwater)

----------------------------------------------------------------------------------------------------------------
-- BLOCK CORRER AND SET SKY
----------------------------------------------------------------------------------------------------------------
function blockcorre()
  if not ( getPedControlState ( localPlayer, "walk" ) ) then 
    toggleControl("walk",false)
    triggerServerEvent ("funcaosoandar", localPlayer)
  end
setTimer(blockcorre,50,1)
end 
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), blockcorre)

----------------------------------------------------------------------------------------------------------------
-- ferido
----------------------------------------------------------------------------------------------------------------
local timerferiments = false
local ferimentsgrave = false
function verifyferiments()
  if getElementData(localPlayer,"logado") then
    if not getElementData(localPlayer,"inmaca") then
      local pHealth = getElementHealth (localPlayer)
      if pHealth < 35 and pHealth > 0 then
        if not isTimer (timerferiments) then
          exports.an_infobox:addNotification("Você está com ferimentos <b>graves</b> vá para o hospital!","erro")
          timerferiments = setTimer(function()
          end,15000,1)
        end
        ferimentsgrave = true
        toggleControl("sprint",false)
        toggleControl("jump",false)
        if getPedWalkingStyle(localPlayer) ~= 123 then
          triggerServerEvent ("setplyferidoanim", localPlayer,localPlayer,1)
        end
      else
        if ferimentsgrave then 
          if isTimer (timerferido) then
            killTimer(timerferido)
          end
          ferimentsgrave = false
          toggleControl("sprint",true)
          toggleControl("jump",true)
          if getPedWalkingStyle(localPlayer) ~= getElementData(localPlayer,"walkstyle") then
            triggerServerEvent ("setplyferidoanim", localPlayer,localPlayer,2) 
          end
        end
      end
    end
  end
  setTimer(verifyferiments,50,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), verifyferiments)

function ferimentstimer()
  if ferimentsgrave then
    local pHealth = getElementHealth (localPlayer)
    if pHealth < 100 then
      setElementHealth(localPlayer,pHealth-0.1)
    end
  end
  setTimer(ferimentstimer,2000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), ferimentstimer)


local losstimer = nil
function packetLossCheck()
	local loss = getNetworkStats()["packetlossLastSecond"]
  if (loss >= 70.0) then
    if not isTimer(losstimer) then
      exports.an_infobox:addNotification("<b>Perda</b> de pacotes detectada! você está prestes a ser desconectado(a)","erro")
      losstimer = setTimer(function()
        triggerServerEvent("kickplyloss", localPlayer,localPlayer)
      end,5000,1)
    end
  else
    if isTimer(losstimer) then 
      exports.an_infobox:addNotification("Pacotes <b>estabilizados</b> você não será mais desconectado(a)!","erro") 
      killTimer(losstimer) 
    end
	end
  setTimer(packetLossCheck,50,1)
end 
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), packetLossCheck)

timerpay = nil
function paysalarie()
    if not isTimer(timerpay) then
        if isTimer(timerpay) then killTimer(timerpay) end
        timerpay = setTimer(function()
            triggerServerEvent("paymoneyply", localPlayer,localPlayer)
        end,1000*1800,0)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), paysalarie)
----------------------------------------------------------------------------------------------------------------
-- NITROUS SCRIPT
----------------------------------------------------------------------------------------------------------------
local nitroussound = {}
local nitroussoundtimer = {}
local nitroussound2 = {}
local nitroussoundtimer2 = {}
local nitroussound3 = {}
local nitroussoundtimer3 = {}
local nitroussound4 = {}
local nitroussound5 = {}
local nitroussoundtimer5 = {}

local nitro = false
function toggleNOS( key, state )
	local veh = getPedOccupiedVehicle( localPlayer )
  if veh then
    if getPedOccupiedVehicleSeat (localPlayer) == 0 then
      local x, y, z = getElementPosition(veh)
      local nitrous = getElementData(veh,'Nitrous') or 0
      if nitrous >= 1 then
        if state == "up" then
          nitro = false
          removeVehicleUpgrade( veh, 1010 )
          setVehicleNitroActivated (veh, false)
          local speed = math.floor(getFormatSpeed(localPlayer))
          if speed >= 5 then
            triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 3)
          else
            triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 5)
          end
        else
          if not nitro then
            local speed = math.floor(getFormatSpeed(localPlayer))
            if speed >= 5 then
              triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 1)
            end
            nitro = true
          end
          addVehicleUpgrade( veh, 1010 )
          setVehicleNitroActivated (veh, true)
        end
      end
    end
	end
end
bindKey( "b", "both", toggleNOS )

function checknitrous()
  local veh = getPedOccupiedVehicle( localPlayer )
  if veh then
    local x, y, z = getElementPosition(veh)
    local nitrous = getElementData(veh,'Nitrous') or 0
    if nitro and nitrous <= 0 then
      nitro = false
      removeVehicleUpgrade( veh, 1010 )
      setVehicleNitroActivated (veh, false)
      setElementData(veh,'Nitrous', 0)
      local speed = math.floor(getFormatSpeed(localPlayer))
      if speed >= 5 then
        triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 3)
      else
        triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 'stop')
      end
    end
    if nitro and nitrous >= 1 then
      local speed = math.floor(getFormatSpeed(localPlayer))
      if speed >= 5 then
        triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 2)
      elseif speed < 5 then
        triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 4)
      end
    end
  end
end
addEventHandler("onClientRender", getRootElement(), checknitrous)

function nitroustimertread()
  local veh = getPedOccupiedVehicle( localPlayer )
  if veh then
    local x, y, z = getElementPosition(veh)
    local nitrous = getElementData(veh,'Nitrous') or 0
    if nitro and nitrous > 0 then
        setVehicleNitroLevel (veh, 1.0)
        setElementData(veh,'Nitrous', (nitrous - 1))
        if nitrous == 0 then
          nitro = false
          setVehicleNitroActivated (veh, false)
          removeVehicleUpgrade( veh, 1010 )
          setElementData(veh,'Nitrous', 0)
          local speed = math.floor(getFormatSpeed(localPlayer))
          if speed >= 5 then
            triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 3)
          else
            triggerServerEvent("sincnitroussound", localPlayer, localPlayer, 'stop')
          end
        end
    end
  end
setTimer(nitroustimertread,500,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), nitroustimertread)

function startnitroussound(veh,typ)
  if typ == 1 then
    local x, y, z = getElementPosition(veh)
    if not isElement(nitroussound[veh]) then
      nitroussound[veh] = playSound3D("files/nitrous.mp3", x, y, z, true)
      setElementDimension(nitroussound[veh], getElementDimension(veh))
      setElementDimension(nitroussound[veh], getElementDimension(veh))
      setSoundMinDistance(nitroussound[veh], 40)
      setSoundMaxDistance(nitroussound[veh], 80)
      setSoundVolume(nitroussound[veh],0.05)
      attachElements(nitroussound[veh],veh)
      nitroussoundtimer[veh] = setTimer(function() 
        if isElement(nitroussound[veh]) then
          stopSound(nitroussound[veh])
        end
      end, 1200, 1)
    end
  elseif typ == 2 then
    local x, y, z = getElementPosition(veh)
    if not isElement(nitroussound2[veh]) then
      nitroussound2[veh] = playSound3D("files/nitroef2.ogg", x, y, z, true)
      setElementDimension(nitroussound2[veh], getElementDimension(veh))
      setElementDimension(nitroussound2[veh], getElementDimension(veh))
      setSoundMinDistance(nitroussound2[veh], 40)
      setSoundMaxDistance(nitroussound2[veh], 80)
      setSoundVolume(nitroussound2[veh],0.05)
      attachElements(nitroussound2[veh],veh)
    end
    if isElement(nitroussound3[veh]) then stopSound(nitroussound3[veh]) end
    if isTimer(nitroussoundtimer3[veh]) then killTimer(nitroussoundtimer3[veh]) end
    if isElement(nitroussound4[veh]) then stopSound(nitroussound4[veh]) end
  elseif typ == 3 then
    local x, y, z = getElementPosition(veh)
    if not isElement(nitroussound3[veh]) then
      nitroussound3[veh] = playSound3D("files/nitroef3.ogg", x, y, z, true)
      setElementDimension(nitroussound3[veh], getElementDimension(veh))
      setElementDimension(nitroussound3[veh], getElementDimension(veh))
      setSoundMinDistance(nitroussound3[veh], 40)
      setSoundMaxDistance(nitroussound3[veh], 80)
      setSoundVolume(nitroussound3[veh],0.05)
      attachElements(nitroussound3[veh],veh)
      nitroussoundtimer3[veh] = setTimer(function() 
        if isElement(nitroussound3[veh]) then
          stopSound(nitroussound3[veh])
        end
      end, 1200, 1)
    end
    if isElement(nitroussound[veh]) then stopSound(nitroussound[veh]) end
    if isTimer(nitroussoundtimer[veh]) then killTimer(nitroussoundtimer[veh]) end
    if isElement(nitroussound2[veh]) then stopSound(nitroussound2[veh]) end
    if isTimer(nitroussoundtimer2[veh]) then killTimer(nitroussoundtimer2[veh]) end
    if isElement(nitroussound4[veh]) then stopSound(nitroussound4[veh]) end
  elseif typ == 4 then
    local x, y, z = getElementPosition(veh)
    if not isElement(nitroussound4[veh]) then
      nitroussound4[veh] = playSound3D("files/nitroef0.ogg", x, y, z, true)
      setElementDimension(nitroussound4[veh], getElementDimension(veh))
      setElementDimension(nitroussound4[veh], getElementDimension(veh))
      setSoundMinDistance(nitroussound4[veh], 40)
      setSoundMaxDistance(nitroussound4[veh], 80)
      setSoundVolume(nitroussound4[veh],0.1)
      attachElements(nitroussound4[veh],veh)
    end
    if isElement(nitroussound[veh]) then stopSound(nitroussound[veh]) end
    if isTimer(nitroussoundtimer[veh]) then killTimer(nitroussoundtimer[veh]) end
    if isElement(nitroussound2[veh]) then stopSound(nitroussound2[veh]) end
    if isTimer(nitroussoundtimer2[veh]) then killTimer(nitroussoundtimer2[veh]) end
    if isElement(nitroussound3[veh]) then stopSound(nitroussound3[veh]) end
    if isTimer(nitroussoundtimer3[veh]) then killTimer(nitroussoundtimer3[veh]) end
  elseif typ == 5 then
    local x, y, z = getElementPosition(veh)
    if not isElement(nitroussound5[veh]) then
      nitroussound5[veh] = playSound3D("files/nitroef00.mp3", x, y, z, true)
      setElementDimension(nitroussound5[veh], getElementDimension(veh))
      setElementDimension(nitroussound5[veh], getElementDimension(veh))
      setSoundMinDistance(nitroussound5[veh], 40)
      setSoundMaxDistance(nitroussound5[veh], 80)
      setSoundVolume(nitroussound5[veh],0.05)
      attachElements(nitroussound5[veh],veh)
      nitroussoundtimer5[veh] = setTimer(function() 
        if isElement(nitroussound5[veh]) then
          stopSound(nitroussound5[veh])
        end
      end, 800, 1)
    end
    if isElement(nitroussound[veh]) then stopSound(nitroussound[veh]) end
    if isTimer(nitroussoundtimer[veh]) then killTimer(nitroussoundtimer[veh]) end
    if isElement(nitroussound2[veh]) then stopSound(nitroussound2[veh]) end
    if isTimer(nitroussoundtimer2[veh]) then killTimer(nitroussoundtimer2[veh]) end
    if isElement(nitroussound4[veh]) then stopSound(nitroussound4[veh]) end
    if isElement(nitroussound3[veh]) then stopSound(nitroussound3[veh]) end
    if isTimer(nitroussoundtimer3[veh]) then killTimer(nitroussoundtimer3[veh]) end
  elseif typ == 'stop' then
    if isElement(nitroussound[veh]) then stopSound(nitroussound[veh]) end
    if isTimer(nitroussoundtimer[veh]) then killTimer(nitroussoundtimer[veh]) end
    if isElement(nitroussound2[veh]) then stopSound(nitroussound2[veh]) end
    if isTimer(nitroussoundtimer2[veh]) then killTimer(nitroussoundtimer2[veh]) end
    if isElement(nitroussound3[veh]) then stopSound(nitroussound3[veh]) end
    if isTimer(nitroussoundtimer3[veh]) then killTimer(nitroussoundtimer3[veh]) end
    if isElement(nitroussound4[veh]) then stopSound(nitroussound4[veh]) end
    if isElement(nitroussound5[veh]) then stopSound(nitroussound5[veh]) end
    if isTimer(nitroussoundtimer5[veh]) then killTimer(nitroussoundtimer5[veh]) end
  end
end
addEvent("startnitroussound", true)
addEventHandler("startnitroussound", root, startnitroussound)

addEventHandler("onClientVehicleExplode", getRootElement(), function()
  if nitro then
    nitro = false
    removeVehicleUpgrade( source, 1010 )
    setVehicleNitroActivated (source, false)
    triggerServerEvent("sincnitroussound2", localPlayer, source, 'stop')
  end
end)

addEventHandler("onClientVehicleExit", getRootElement(),
  function(thePlayer, seat)
    if thePlayer == localPlayer then
      if (seat==0) then
        if nitro then
          nitro = false
          removeVehicleUpgrade( source, 1010 )
          setVehicleNitroActivated (source, false)
          triggerServerEvent("sincnitroussound2", localPlayer, source, 'stop')
        end
      end
    end
  end
)
----------------------------------------------------------------------------------------------------------------
-- Drift mode
----------------------------------------------------------------------------------------------------------------
local driftmode = false
function toggleNOS( key, state )
	local veh = getPedOccupiedVehicle( localPlayer )
  if veh then
    if (getVehicleType(veh) == "Automobile") then
      if state == "up" then
        driftmode = false
        triggerServerEvent("reloadHandlings", localPlayer, veh)
      else
        if not driftmode then
          driftmode = true
          triggerServerEvent("startdrifmode", localPlayer, veh)
        end
      end
    end
	end
end
bindKey( "lshift", "both", toggleNOS )

----------------------------------------------------------------------------------------------------------------
-- VOICE
----------------------------------------------------------------------------------------------------------------




----------------------------------------------------------------------------------------------------------------
-- an modulos
----------------------------------------------------------------------------------------------------------------
-- npc protection
addEventHandler("onClientPedDamage",  getRootElement(), function()
	if (getElementData(source, "npc")) then
		cancelEvent() 
	end
end)
--- get next player
function getproxclientply(distance)
	local x, y, z = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    local players = getElementsByType("player")
    for i, v in ipairs (players) do 
        if localPlayer ~= v then
            local pX, pY, pZ = getElementPosition (v) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
                dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
                id = v
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end
--- get next vehicle
function getproxclientveh(distance)
	local x, y, z = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
        if localPlayer ~= v then
            local pX, pY, pZ = getElementPosition (v) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
                dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
                id = v
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end

function removesmaxspeedonRoads()
  setAmbientSoundEnabled( "gunfire", false )
  setBirdsEnabled(false)
  setWorldSpecialPropertyEnabled( "extraairresistance", false)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), removesmaxspeedonRoads)


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
