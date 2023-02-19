function onPlayerRequestEmerlight(ply,value)
	triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), ply, value)
end
addEvent("requestEmerlightChangeState", true)
addEventHandler("requestEmerlightChangeState", getRootElement(), onPlayerRequestEmerlight)

function SirenSinc(ply,siren)
	if ply then
		if siren then
			triggerClientEvent(getRootElement(), "setsongemerg", getRootElement(), ply, siren)
		end
	end
end
addEvent("SirenSinc", true)
addEventHandler("SirenSinc", getRootElement(), SirenSinc) 