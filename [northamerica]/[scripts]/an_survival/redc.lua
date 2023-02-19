-------------------------------------------------------------------------------------------------------
-- Variables
-------------------------------------------------------------------------------------------------------
local ontimerSurvivalfood = nil
local ontimerSurvivalwather = nil
local foodSurvivalconfig = 1
local watherSuvivalconfig = 2
local ontimerSurvivaldeath1 = nil
local ontimerSurvivaldeath2 = nil
function survival()
    if getElementData(localPlayer,"logado") then
        if not getElementData(localPlayer, "ondownload") then
            local food = getElementData(localPlayer,"foodstats")
            local wather = getElementData(localPlayer,"watherstats")
            if not isTimer(ontimerSurvivalfood) then 
                if food > 0 then
                    ontimerSurvivalfood = setTimer(function()
                        local food = getElementData(localPlayer,"foodstats")
                        setElementData(localPlayer,"foodstats",food-foodSurvivalconfig)
                    end,75000,1)
                end
            end
            if not isTimer(ontimerSurvivalwather) then 
                if wather > 0 then
                    ontimerSurvivalwather = setTimer(function()
                        local wather = getElementData(localPlayer,"watherstats")
                        setElementData(localPlayer,"watherstats",wather-watherSuvivalconfig)
                    end,71000,1)
                end
            end
            if not isTimer(ontimerSurvivaldeath1) then 
                if not getElementData(localPlayer,"incoma") then
                    if food == 0 then
                        local pHealth = getElementHealth (localPlayer) 
                        setElementHealth(localPlayer,pHealth-3)
                        exports.an_infobox:addNotification("Você está morrendo de <b>fome</b>...","erro")
                        ontimerSurvivaldeath1 = setTimer(function()
                        end,15000,1)
                    else
                        if isTimer(ontimerSurvivaldeath1) then
                            killTimer(ontimerSurvivaldeath1)
                        end
                    end
                end
            end
            if not isTimer(ontimerSurvivaldeath2) then 
                if not getElementData(localPlayer,"incoma") then
                    if wather == 0 then
                        local pHealth = getElementHealth (localPlayer) 
                        setElementHealth(localPlayer,pHealth-3)
                        exports.an_infobox:addNotification("Você está morrendo de <b>sede</b>...","erro")
                        ontimerSurvivaldeath2 = setTimer(function()
                        end,15000,1)
                    else
                        if isTimer(ontimerSurvivaldeath2) then
                            killTimer(ontimerSurvivaldeath2)
                        end
                    end
                end
            end
            if food < 0 then
                setElementData(localPlayer,"foodstats",0)
            elseif wather < 0 then
                setElementData(localPlayer,"watherstats",0)
            elseif food > 100 then
                setElementData(localPlayer,"foodstats",100)
            elseif wather > 100 then
                setElementData(localPlayer,"watherstats",100)
            end
        end
    end
end
addEventHandler("onClientRender", root, survival)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------