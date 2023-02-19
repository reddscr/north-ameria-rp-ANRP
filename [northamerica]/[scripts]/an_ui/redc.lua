----------------------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local PlayerFPS = 0
local showPlayerStats = nil

local staminarequest = false
local stamina = 0
----------------------------------------------------------------------------------------------------------------------------------
-- WEB NUI
----------------------------------------------------------------------------------------------------------------------------------
webBrowser = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
htmlanui = guiGetBrowser(webBrowser)
addEventHandler("onClientBrowserCreated", webBrowser,
function ()
    loadBrowserURL(htmlanui, "http://mta/local/html/panel.html")  
end
)
addEventHandler("onClientBrowserDocumentReady", htmlanui,
function ()
    hudstats()
end
)
----------------------------------------------------------------------------------------------------------------------------------
-- HUD SYSTEM
----------------------------------------------------------------------------------------------------------------------------------
function hudstats()
    if not isBrowserLoading(htmlanui) then  
        if isElement(webBrowser) then
            if htmlanui then
                if getElementData(localPlayer,"logado") then
                    if not getElementData(localPlayer, "ondownload") then
                        if not getElementData(localPlayer, "removeHud") then
                            if not getElementData(localPlayer, 'offhud') then
                                if not guiGetVisible(webBrowser) then
                                    guiSetVisible(webBrowser, true)
                                end
                            end
                            local timehour, timeminute = getTime()
                            local stats = ""..timehour.."<b>:</b>"..timeminute..""
                            stats2 = ""
                            vehstats = ""
                            local x, y, z = getElementPosition(localPlayer)
                            zone = getZoneName(x, y, z)
                            city = getZoneName(x, y, z, true)
                            local veh = getPedOccupiedVehicle(localPlayer)
                            if veh then
                                local fuel = math.floor(getElementData(veh, "fuel" ) or 0)
                                local nitro = math.floor(getElementData(veh, "Nitrous" ) or 0)
                                local speed = math.floor(getFormatSpeed(localPlayer))
                                if getElementData(localPlayer,"seatbelt") then
                                    belt = "<g>Cinto</g>"
                                else
                                    belt = "<r>Cinto</r>"
                                end
                                if getElementData(localPlayer,"falando") then
                                    if nitro >= 1 then
                                        vehstats = '<b>'..belt..'</b>  :  <g>N</g> <b>'..nitro..'</b>%  :  <l>G</l> <b>'..fuel..'</b>%  :  <l>MPH</l> <b>'..speed..'</b>'
                                    else
                                        vehstats = '<b>'..belt..'</b>  :  <l>G</l> <b>'..fuel..'</b>%  :  <l>MPH</l> <b>'..speed..'</b>'
                                    end
                                else
                                    if nitro >= 1 then
                                        vehstats = '<b>'..belt..'</b>  :  <g>N</g> <b>'..nitro..'</b>%  :  <l>G</l> <b>'..fuel..'</b>%  :  <l>MPH</l> <b>'..speed..'</b>'
                                    else
                                        vehstats = '<b>'..belt..'</b>  :  <l>G</l> <b>'..fuel..'</b>%  :  <l>MPH</l> <b>'..speed..'</b>'
                                    end
                                end
                            end
                            stats2 = ""..city.."<l>  :    <l>"..zone.."<l>"
                            local voiceactiv = 'false'
                            if getElementData(localPlayer,"falando") then
                                voiceactiv = 'true'
                            else
                                voiceactiv = 'false'
                            end
                            local vida1 = math.floor(getElementHealth ( localPlayer ))
                            local colete = math.floor(getPedArmor(localPlayer))
                            local food = getElementData(localPlayer,"foodstats")
                            local wather = getElementData(localPlayer,"watherstats")
                            plystats = ""
                            local voice = getElementData(localPlayer, "range") or 0
                            PlayerFPS = getElementData(localPlayer,"fps")
                            local ping = getPlayerPing(getLocalPlayer())
                            if PlayerFPS and ping then
                                plystats = "<l>FPS: "..PlayerFPS.." - PING: "..ping.."</l>"
                            end
                            if plystats and vehstats and stats and stats2 and vida1 and colete and food and wather and stamina then
                                executeBrowserJavascript(htmlanui,string.format("updateuistats(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",toJSON(stats),toJSON(stats2),toJSON(vida1),toJSON(colete),toJSON(food),toJSON(wather),toJSON(plystats),toJSON(vehstats),toJSON(stamina),toJSON(voice),toJSON(voiceactiv)))
                            end
                        else
                            if guiGetVisible(webBrowser) then
                                guiSetVisible(webBrowser, false)
                            end
                        end
                    else
                        if guiGetVisible(webBrowser) then
                            guiSetVisible(webBrowser, false)
                        end
                    end
                else
                    if guiGetVisible(webBrowser) then
                        guiSetVisible(webBrowser, false)
                    end
                end
            end
        end
    end
    setTimer(hudstats,200,1)
end
----------------------------------------------------------------------------------------------------------------------------------
-- TOGGLE
----------------------------------------------------------------------------------------------------------------------------------
function togglehud()
    if isElement(webBrowser) then
        if guiGetVisible(webBrowser) then
            guiSetVisible(webBrowser, false)
            setElementData(localPlayer, 'offhud', true)
        else
            guiSetVisible(webBrowser, true)
            setElementData(localPlayer, 'offhud', nil)
        end
    end
end
addEvent ("togglehud", true)
addEventHandler ("togglehud", root, togglehud)
----------------------------------------------------------------------------------------------------------------------------------
-- SHOW STATS
----------------------------------------------------------------------------------------------------------------------------------
function showPlayerStats()
    if isElement(webBrowser) then
        if not showPlayerStats then
            showPlayerStats = true
            execute(string.format("updateplyhud2(%s)",toJSON("hide")))
        else
            showPlayerStats = nil
            execute(string.format("updateplyhud2(%s)",toJSON("show")))
        end
    end
end
addEvent ("showPlayerStats", true)
addEventHandler ("showPlayerStats", root, showPlayerStats)
----------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        if isElement(htmlanui) then
            executeBrowserJavascript(htmlanui, eval)
        end
    end
end

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


function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100 * 1.609344)
        end
    else
        return false
    end
end


local framesPerSecond = 0 
local framesDeltaTime = 0 
local lastRenderTick = false 
  
addEventHandler("onClientRender", root, 
    function () 
        local currentTick = getTickCount() 
        lastRenderTick = lastRenderTick or currentTick 
        framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick) 
        lastRenderTick = currentTick 
        framesPerSecond = framesPerSecond + 1 
         
        if framesDeltaTime >= 1000 then 
            setElementData(localPlayer, "fps", framesPerSecond) 
            framesDeltaTime = framesDeltaTime - 1000 
            framesPerSecond = 0 
        end 
    end 
) 
----------------------------------------------------------------------------------------------------------------------------------
-- STAMINA
----------------------------------------------------------------------------------------------------------------------------------
toggleControl("sprint",true)
function chackplaystamina()
    if getElementData(localPlayer,"logado") then
        if not getElementData(localPlayer, "ondownload") then
            if isElementMoving(localPlayer) and getElementSpeed(localPlayer) > 4 then
                if not getPedOccupiedVehicle(localPlayer) then
                    if stamina < 100 then
                        stamina = stamina + 0.10
                        if staminarequest then 
                            toggleControl("sprint",true)
                            staminarequest = false
                        end
                    else
                        if not staminarequest then 
                            staminarequest = true
                            toggleControl("sprint",false)
                        end
                    end
                end
            else
                if stamina > 30 then
                    if not staminarequest then
                        toggleControl("sprint",false)
                        staminarequest = true
                    end
                    stamina = stamina - 0.10
                else
                    if stamina > 1 then 
                        stamina = stamina - 0.10
                        if staminarequest then
                            staminarequest = false
                            toggleControl("sprint",true)
                        end
                    end
                end
                if stamina > 100 then
                    stamina = 100
                end
            end
            if getElementData(localPlayer, 'Energyeffect') then
                stamina = 0
            end
        end
    end
end
addEventHandler("onClientRender", root, chackplaystamina, true, "low")

function isElementMoving ( theElement )
    if isElement ( theElement ) then                    
        local x, y, z = getElementVelocity( theElement ) 
        return x ~= 0 or y ~= 0 or z ~= 0      
    end
 
    return false
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------