function addNotification(player, text, type,time)
	if isElement(player) then
		triggerClientEvent(player, "addNotification", player, text, type,time)
	end
end
