-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
weapons = {
  {"AK-47","AK103","AK-103","AK103ammu"},
  {"M4","M4A1","M4A1","M4A1ammu"},
  {"Colt 45","pistol","M1911","pistolammu"},
  {"Deagle","glock","Glock 19","glockammu"},
  {"Rifle","winchester22","Winchester 22","winchester22ammu"},
  {"Shotgun","remington870","Remington 870","remington870ammu"},
  {"Knife","faca","Faca","faca"},
} 
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
local theftStarted = false
function verifydistance()
    local prox = getproxclientply(2)
    if prox then
        local wpon = getPedWeapon(localPlayer)
        if getWeaponNameFromID (wpon) ~= 'Uzi' and getWeaponNameFromID (wpon) ~= 'Fist' then
            for i,v in ipairs (weapons) do
                local getplydata = getElementData(localPlayer, v[2]) or 0
                if getplydata >= 1 then
                    if getElementData(localPlayer,"logado") then
                        if not isPedInVehicle(localPlayer) then
                            if not getElementData(localPlayer,"emacao") then
                                if getPedControlState ( 'aim_weapon' ) then
                                    if not theftStarted then
                                        if not getElementData(prox,'npcrobbed') then
                                            local target = getPedTarget(localPlayer)
                                            if target and target == prox then
                                                theftStarted = prox
                                                triggerServerEvent("startrobnpc", localPlayer, localPlayer, prox)
                                                setElementData(prox,'npcrobbed',true)
                                            end
                                        end
                                    end
                                else
                                    if theftStarted then
                                        triggerServerEvent("cancelorverifyrobnpc", localPlayer, localPlayer, theftStarted)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        if theftStarted then
            triggerServerEvent("cancelorverifyrobnpc", localPlayer, localPlayer, theftStarted)
        end
    end
end
addEventHandler("onClientRender", root, verifydistance)

function finisedrobnpc()
    if theftStarted then
        theftStarted = false
    end
end
addEvent("finisedrobnpc", true)
addEventHandler("finisedrobnpc", root, finisedrobnpc)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function getproxclientply(distance)
	local x, y, z = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    local players = getElementsByType("ped")
    for i, v in ipairs (players) do 
        if not getElementData(v,'npc') then
            if localPlayer ~= v then
                local pX, pY, pZ = getElementPosition (v) 
                if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
                    dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
                    id = v
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
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------