----------------------------------------------------------------------------------------------------------------------------------
-- debug
----------------------------------------------------------------------------------------------------------------------------------
function startmapdebug()
    setOcclusionsEnabled( false )
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), startmapdebug)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------