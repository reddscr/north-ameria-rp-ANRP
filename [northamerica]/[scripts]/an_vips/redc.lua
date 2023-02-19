-------------------------------------------------------------------------------------------------------
-- Pay 
-------------------------------------------------------------------------------------------------------
timer = nil
function payvip()
    if not isTimer(timer) then
        if isTimer(timer) then killTimer(timer) end
        timer = setTimer(function()
            triggerServerEvent("paymoneyplyvip", localPlayer,localPlayer)
        end,1000*1800,0)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), payvip)


