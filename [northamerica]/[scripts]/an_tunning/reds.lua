local connection = exports["an_connect"]:getConnection()

function savetunningonveh(ply, veh, wh)
    if veh then
        addVehicleUpgrade ( veh, wh)
        local id = getElementData(veh,"id")
        local upgrade = ""
        for _, upgradee in ipairs (getVehicleUpgrades(veh)) do
            if upgrade == "" then
                upgrade = upgradee
            else
                upgrade = upgrade..","..upgradee
            end
        end
        setElementData(veh, 'upgrades', getVehicleUpgrades(veh))
        dbExec(connection, "UPDATE an_vehicle SET Upgrades = ? WHERE id = ?", upgrade, id)
        exports.an_infobox:addNotification(ply, "Roda instalada com sucesso!","sucesso")
    end
end
addEvent("savetunningonveh",true)
addEventHandler("savetunningonveh",root,savetunningonveh)

function resetvehiclewheel(ply,veh,tb)
    if veh then
        if tb then
            for i, v in ipairs (tb) do 
                removeVehicleUpgrade ( veh, v[1])
            end
        end
        exports.an_vehicles:saveVehicleUpgrades(veh)
    end
end
addEvent("resetvehiclewheel",true)
addEventHandler("resetvehiclewheel",root,resetvehiclewheel)

function prevwheel(ply, veh, wh)
    if veh then
        addVehicleUpgrade ( veh, wh)
    end
end
addEvent("prevwheel",true)
addEventHandler("prevwheel",root,prevwheel)

function exittunningveh(ply, veh)
    if veh then
        local idv = getElementData(veh,'id')
        local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", idv), -1)[1]
        if data then
            upg = split(tostring(data["Upgrades"]), ',')
            setElementData(veh,"upgrades",upg)
            for i, upgrade in ipairs(upg) do
                addVehicleUpgrade(veh, upgrade)
            end
        end
    end
end
addEvent("exittunningveh",true)
addEventHandler("exittunningveh",root,exittunningveh)

function debugonquit()
    if getElementData(source,'ontunningveh') and getElementData(source,'ontunninglocal') then
        local locals = fromJSON(getElementData(source,'ontunninglocal'))
        setElementFrozen(getElementData(source,'ontunningveh'), false)
        setElementPosition(getElementData(source,'ontunningveh'), locals[1], locals[2], locals[3])
        setElementRotation(getElementData(source,'ontunningveh'), 0, 0, locals[4])
    end
end
addEventHandler ("onPlayerQuit", root, debugonquit)
