

---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------
function stopplyanim ()
    if getElementData(localPlayer,"fazendoplyanims") == true then
        triggerServerEvent ("stopplyanimsv",localPlayer,localPlayer)
    end
end
bindKey("f6","down",stopplyanim)
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
function animdeitadofunc()
  if not getElementData(localPlayer,"logado") then return end
    for k, v in ipairs(getElementsByType("player")) do
      if getElementData(v,"animdeitado") then
        local block, animation = getPedAnimation(v)
        if animation ~= "crckdeth2" then
          setPedAnimation(v, "crack", "crckdeth2", -1, true, false, false, true)
        end
          setPedAnimationProgress(v, 'crckdeth2', 100)
      end
    end
end
addEventHandler("onClientRender", root, animdeitadofunc)
---------------------------------------------------------------------------------------------------------
------- HAND UP
---------------------------------------------------------------------------------------------------------


local handup = false
function handupanimation()
	if not getElementData(localPlayer,"logado") then return end
	if getElementData(localPlayer,"fazendoplyanims") then return end
	if not isPedInVehicle(localPlayer) then
		if not getElementData(localPlayer,"emacao") then
			if not handup then
				handup = true
				triggerServerEvent("starthandup", localPlayer, localPlayer)
			elseif handup then
				triggerServerEvent("stophandup", localPlayer, localPlayer)
				handup = false
			end
		end
	end
end
bindKey("x","both",handupanimation)
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
local onanimaim = false
function toggleNOS( key, state )
	if getElementData(localPlayer,"fazendoplyanims") then return end
	if getElementData(localPlayer,"logado") then
		if not isPedInVehicle(localPlayer) then
			if not getElementData(localPlayer,"emacao") then
				if state == "up" then
					if onanimaim then
						triggerServerEvent("removerApontar", localPlayer, localPlayer)
						onanimaim = false
					end
				else
					if not onanimaim then
						onanimaim = true
						toggleControl('fire',false)
						toggleControl('action',false)
						toggleControl('aim_weapon',false)
						triggerServerEvent("addApontar", localPlayer, localPlayer)
					end
				end
			end
		end
	end
end
bindKey( "b", "both", toggleNOS )
---------------------------------------------------------------------------------------------------------
-- block key
---------------------------------------------------------------------------------------------------------
addEventHandler("onClientKey", root, 
function (button, press)
  if getElementData(localPlayer,"fazendoplyanimsobj") or onanimaim then
    if button == "mouse1" or button == "mouse2" or button == "lshift" or button == "space" then
    	cancelEvent()
    end
  end
end
)
---------------------------------------------------------------------------------------------------------
-- WPN
---------------------------------------------------------------------------------------------------------
txd = engineLoadTXD("anim/wpn.txd", 352)
engineImportTXD(txd, 352 )
dff = engineLoadDFF("anim/wpn.dff", 352)
engineReplaceModel(dff, 352 )
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------