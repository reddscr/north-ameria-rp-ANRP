local connection = exports.an_connect:getConnection()

function addVehiclePaintJob(veh, model, id)
	if id > 0 then
		triggerClientEvent("addVehiclePaintJob", root, veh, model, id)
	else
		triggerClientEvent("destroyShaderCache", root, veh)
	end
	if getElementData(veh, "id") then
		dbExec(connection, "UPDATE an_vehicle SET Paintjob = ? WHERE id = ?", id, getElementData(veh, "id"))
	end
end
addEvent("addVehiclePaintJob", true)
addEventHandler("addVehiclePaintJob", getRootElement(), addVehiclePaintJob)


