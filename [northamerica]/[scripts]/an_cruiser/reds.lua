function lossHealthOnHurt ( loss  ) 
    if ( getVehicleController ( source ) ) then 
        local player = getVehicleController ( source ) 
        if player then
            triggerClientEvent( player,"stopanddebugscruiser", player)
        end
    end 
end 
addEventHandler( "onVehicleDamage", getRootElement (), lossHealthOnHurt ) 