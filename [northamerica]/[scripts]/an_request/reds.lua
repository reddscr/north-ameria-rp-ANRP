function naquestionrequest(player, id, text, time)
	if isElement(player) then
		triggerClientEvent(player, "naquestionrequest", player, id, text, time)
	end
end

function naremovequestionrequest(player, id)
	if isElement(player) then
		triggerClientEvent(player, "naremovequestionrequest", player, id)
	end
end


