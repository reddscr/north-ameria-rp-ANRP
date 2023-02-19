---------------------------------------------------------------------------------------------------------
-- ANIMATION
---------------------------------------------------------------------------------------------------------
function fuellinganim(ply,typ)
	if typ then
		if typ == "stop" then
			setPedAnimation(ply,nil)
			setElementData(ply,"emacao",false)
		elseif typ == "start" then
			setPedAnimation(ply, "ped", "jetpack_idle", -1, true, false, false )
			setTimer ( setPedAnimationProgress, 100, 1, ply, "jetpack_idle", 1.7)
			setTimer ( setPedAnimationSpeed, 100, 1, ply, "jetpack_idle", 0)
			setElementData(ply,"emacao",true)
		end
	end
end
addEvent("fuellinganim",true)
addEventHandler ( "fuellinganim", getRootElement(), fuellinganim)
---------------------------------------------------------------------------------------------------------
-- DISABLE ON QUIT
---------------------------------------------------------------------------------------------------------
function fechaptmalasonquit()
    if getElementData(source,"fueling") then
		setElementData(getElementData(source,"fueling"),"fueling",nil)
    end
end
addEventHandler ("onPlayerQuit", root, fechaptmalasonquit)
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
















