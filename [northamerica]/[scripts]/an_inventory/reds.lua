----------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
local itemtb = exports.an_account:servergetitemtable3()

local userobject = {}
local usertimer = {}
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local dist = 9.0
local lookAtVehicle = nil
function useitems (ply,n)
    if n then
    local food = getElementData(ply,"foodstats")
    local wather = getElementData(ply,"watherstats")
    local idata = exports.an_account:servergetitemtable(n)
    local plyx, plyy, plyz = getElementPosition(ply)
            if idata[2] == "Bandage" then
                local pHealth = getElementHealth ( ply ) 
                if pHealth >= 99 then exports.an_infobox:addNotification(ply,"Você não esta <b>ferido</b>","erro") return end
                if pHealth <= 98 then
                    if getElementData(ply,"muitoferido") == false then
                        if getElementData(ply,"bandagem") == false then
                            triggerClientEvent (ply,"usebandagem",ply)
                            setElementData(ply, "bandagem", true)
                        end
                    else
                        exports.an_infobox:addNotification(ply,"Você está muito <b>ferido</b> vá até um <b>hospital</b>","erro")
                    end
                end
            elseif idata[2] == "Smallbackpack" then
                if getElementData(ply,"MocMSlot") == 5 then
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                    local plyid = getElementData(ply,"id")
                    local MocStats = "20"
                    local updatemoc = dbExec(connection, "UPDATE an_character SET MocStats=? WHERE id =?",MocStats,plyid)
                    setElementData(ply, "MocMSlot", 20 )
                    --exports.an_infobox:addNotification(ply,"você usou 1x <b>"..idata[5].."</b>","sucesso")
                elseif getElementData(ply,"MocMSlot") == 50 then
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                    triggerClientEvent( ply,"attitem", ply,"Largebackpack","1","mais")
                    local plyid = getElementData(ply,"id")
                    local MocStats = "20"
                    local updatemoc = dbExec(connection, "UPDATE an_character SET MocStats=? WHERE id =?",MocStats,plyid)
                    setElementData(ply, "MocMSlot", 20 )
                    --exports.an_infobox:addNotification(ply,"você usou 1x <b>"..idata[5].."</b> e recebeu 1x <b>Mochila grande</b>","sucesso")
                elseif getElementData(ply,"MocMSlot") == 20 then
                    exports.an_infobox:addNotification(ply,"você não pode usar <b>"..idata[5].."</b>","erro")
                end
            elseif idata[2] == "Largebackpack" then
                if getElementData(ply,"MocMSlot") == 5 then
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                    local plyid = getElementData(ply,"id")
                    local MocStats = "50"
                    local updatemoc = dbExec(connection, "UPDATE an_character SET MocStats=? WHERE id =?",MocStats,plyid)
                    setElementData(ply, "MocMSlot", 50 )
                    --exports.an_infobox:addNotification(ply,"você usou 1x <b>"..idata[5].."</b>","sucesso")
                elseif getElementData(ply,"MocMSlot") == 20 then
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                    triggerClientEvent( ply,"attitem", ply,"Smallbackpack","1","mais")
                    local plyid = getElementData(ply,"id")
                    local MocStats = "50"
                    local updatemoc = dbExec(connection, "UPDATE an_character SET MocStats=? WHERE id =?",MocStats,plyid)
                    setElementData(ply, "MocMSlot", 50 )
                   --exports.an_infobox:addNotification(ply,"você usou 1x <b>"..idata[5].."</b> e recebeu 1x <b>Mochila</b>","sucesso")
                elseif getElementData(ply,"MocMSlot") == 50 then
                    exports.an_infobox:addNotification(ply,"você não pode usar <b>"..idata[5].."</b>","erro")
                end
            elseif idata[2] == "Lockpick" then
                if getElementData(ply,idata[2]) < 1 then return exports.an_infobox:addNotification(ply,"você não tem "..idata[5].."","erro") end
                if not getElementData(ply,"lockpick") == false then return end
                if (not isPedInVehicle(ply)) then
                    lookAtVehicle = getPedTarget(ply)
                    if (lookAtVehicle) and (getElementType(lookAtVehicle) == "vehicle" ) then
                        local vx, vy, vz = getElementPosition(lookAtVehicle)
                        if getDistanceBetweenPoints3D ( plyx, plyy, plyz, vx, vy, vz) < 5 then
                            if not getElementData(lookAtVehicle,"apreendido") then
                                local policeinservice = exports.an_police:getpoliceinservicesv()
                                if policeinservice >= 2 then
                                    if isVehicleLocked( lookAtVehicle ) then
                                        triggerClientEvent (ply,"uselockpick",ply)
                                        setElementData(ply, "lockpick", true)
                                        setPedAnimation(ply, "BD_fire", "wash_up")
                                        setTimer(setPedAnimation, 15000, 1, ply, nil)     
                                        setTimer(setElementData, 15000, 1, ply, "lockpick",false)       
                                    else
                                        exports.an_infobox:addNotification(ply,"este <b>veículo</b> não esta trancado","aviso")
                                        setElementData(ply, "lockpick", false)  
                                    end
                                else
                                    exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>policiais</b> no momento","aviso")
                                end
                            end
                        end
                    end
                end
            elseif idata[2] == "Nitro" then
                if not isTimer(usertimer[ply]) then
                    if not isPedInVehicle(ply) then
                        local vehproxy = exports.an_player:getproxveh(ply,3)
                        if vehproxy then
                            triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                            setPedAnimation( ply, "BD_fire", "wash_up", -1, true, false, false )
                            setElementData(ply,"emacao",true)
                            toggleControl(ply,"fire", false)
                            toggleControl(ply,"jump", false)
                            usertimer[ply] = setTimer(function()
                                setPedAnimation( ply, nil )
                                setElementData(ply,"emacao",false)
                                setElementData(vehproxy,'Nitrous',100)
                                toggleControl(ply,"fire", true)
                                toggleControl(ply,"jump", true)
                                --exports.an_infobox:addNotification(ply,"Você instalou <b>nitrous</b> no <b>veiculo</b>!","sucesso")
                            end,15000,1)
                        end
                    end
                else
                    exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
                end
            elseif idata[2] == "meteorite" then
                if not getElementData(ply,"anvip") then
                    --exports.an_infobox:addNotification(ply,"Você usou 1x <b>"..idata[5].."</b>","sucesso")
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")  
                    triggerClientEvent( ply,"attitem", ply,"Money","50000","mais")  
                    exports.an_vips:seplyvip(ply,idata[5])
                else
                    exports.an_infobox:addNotification(ply,"Você ja tem um vip <b>ativo</b>","erro")
                end
            elseif idata[2] == "planet" then
                    if not getElementData(ply,"anvip") then
                        --exports.an_infobox:addNotification(ply,"Você usou 1x <b>"..idata[5].."</b>","sucesso")
                        triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")    
                        triggerClientEvent( ply,"attitem", ply,"Money","100000","mais")  
                        exports.an_vips:seplyvip(ply,idata[5])
                    else
                        exports.an_infobox:addNotification(ply,"Você ja tem um vip <b>ativo</b>","erro")
                    end
            elseif idata[2] == "star" then
                if not getElementData(ply,"anvip") then
                    --exports.an_infobox:addNotification(ply,"Você usou 1x <b>"..idata[5].."</b>","sucesso")
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")  
                    triggerClientEvent( ply,"attitem", ply,"Money","150000","mais")  
                    exports.an_vips:seplyvip(ply,idata[5])
                else
                    exports.an_infobox:addNotification(ply,"Você ja tem um vip <b>ativo</b>","erro")
                end
            elseif idata[2] == "space" then
                if not getElementData(ply,"anvip") then
                    --exports.an_infobox:addNotification(ply,"Você usou 1x <b>"..idata[5].."</b>","sucesso")
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")  
                    triggerClientEvent( ply,"attitem", ply,"Money","200000","mais") 
                    exports.an_vips:seplyvip(ply,idata[5])
                else
                    exports.an_infobox:addNotification(ply,"Você ja tem um vip <b>ativo</b>","erro")
                end
            elseif idata[2] == "Repairkit" then
                if not isTimer(usertimer[ply]) then
                    if not isPedInVehicle(ply) then
                        lookAtVehicle = getPedTarget(ply)
                        if (lookAtVehicle) and (getElementType(lookAtVehicle) == "vehicle" ) then
                            local vx, vy, vz = getElementPosition(lookAtVehicle)
                            if getDistanceBetweenPoints3D ( plyx, plyy, plyz, vx, vy, vz) < 5 then
                                local vehicleHealth = getElementHealth ( lookAtVehicle ) / 10
                                if vehicleHealth >= 50 then
                                    if getVehicleDoorOpenRatio (lookAtVehicle, 0 ) == 1 then
                                        triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                                        setPedAnimation( ply, "BD_fire", "wash_up", -1, true, false, false )
                                        setElementData(ply,"emacao",true)
                                        toggleControl(ply,"fire", false)
                                        toggleControl(ply,"jump", false)
                                        usertimer[ply] = setTimer(function()
                                            setPedAnimation( ply, nil )
                                            setElementData(ply,"emacao",false)
                                            fixVehicle(lookAtVehicle)
                                            setVehicleDoorOpenRatio(lookAtVehicle, 0, 1, 0)
                                            toggleControl(ply,"fire", true)
                                            toggleControl(ply,"jump", true)
                                            --if isVehicleDamageProof(lookAtVehicle) then
                                                setVehicleDamageProof(lookAtVehicle, false)
                                            --end
                                            --exports.an_infobox:addNotification(ply,"Veiculo <b>reparado</b> com sucesso!","sucesso")
                                        end,15000,1)
                                    else
                                        exports.an_infobox:addNotification(ply,"Abra o <b>capô</b> do <b>veiculo</b>.","aviso")
                                    end
                                else
                                    exports.an_infobox:addNotification(ply,"Este <b>veiculo</b> está muito danificado.","aviso")
                                end
                            end
                        end
                    else
                        exports.an_infobox:addNotification(ply,"Saia do <b>veiculo</b>","aviso")
                    end
                else
                    exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
                end
-----------------------------------------------------------------------------------------------------------------------------
-- WEAPOM
-----------------------------------------------------------------------------------------------------------------------------
            elseif idata[2] == "faca" then
                giveWeapon ( ply, 4, 1 )
                setWeaponAmmo(ply, 4, 1) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "pistol" then
                giveWeapon ( ply, 22, 9999999 )
                setWeaponAmmo(ply, 22, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "glock" then
                giveWeapon ( ply, 24, 9999999 )
                setWeaponAmmo(ply, 24, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "M4A1" then
                giveWeapon ( ply, 31, 9999999 )
                setWeaponAmmo(ply, 31, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "AK103" then
                giveWeapon ( ply, 30, 9999999 )
                setWeaponAmmo(ply, 30, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "winchester22" then
                giveWeapon ( ply, 33, 9999999 )
                setWeaponAmmo(ply, 33, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "remington870" then
                giveWeapon ( ply, 25, 9999999 )
                setWeaponAmmo(ply, 25, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
            elseif idata[2] == "colete" then
                if getPedArmor(ply) <= 50 then
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                    setPedArmor(ply,100)
                    --exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
                else
                    exports.an_infobox:addNotification(ply,"O seu <b>colete</b> ainda esta em bom estado","erro")
                end
            elseif idata[2] == "taser" then
                giveWeapon ( ply, 23, 9999999 )
                setWeaponAmmo(ply, 23, 9999999) 
                exports.an_infobox:addNotification(ply,"Equipado <b>"..idata[5].."</b>.","sucesso")
-----------------------------------------------------------------------------------------------------------------------------
-- FOOD AND DRINK
-----------------------------------------------------------------------------------------------------------------------------
        elseif idata[2] == "Burguer" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                setPedAnimation( ply, "food", "eat_burger", -1, true, false, false )
                setElementData(ply,"emacao",true)
                userobject[ply] = createObject(2880, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 12, 0.03,0.12,0.15,260,-0,-130)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"foodstats",food+35)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    destroyAttachetobj(ply)
                    --exports.an_infobox:addNotification(ply,"Você comeu um <b>"..idata[5].."</b>.","sucesso")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Cerealbar" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                setPedAnimation( ply, "food", "eat_burger", -1, true, false, false )
                setElementData(ply,"emacao",true)
                userobject[ply] = createObject(2769, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 12, 0.02,0.01,0.05,260,-0,-0)
                usertimer[ply] = setTimer(function()
                    setElementData( ply, "foodstats", food+40)
                    setPedAnimation( ply, nil )
                    setElementData( ply, "emacao", false)
                    destroyAttachetobj(ply)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Donut" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                setPedAnimation( ply, "food", "eat_burger", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"foodstats",food+10)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    --exports.an_infobox:addNotification(ply,"Você comeu um <b>"..idata[5].."</b>.","sucesso")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Taco" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                setPedAnimation( ply, "food", "eat_burger", -1, true, false, false )
                setElementData(ply,"emacao",true)
                userobject[ply] = createObject(2769, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 12, 0.02,0.01,0.05,260,-0,-0)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"foodstats",food+20)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    destroyAttachetobj(ply)
                    --exports.an_infobox:addNotification(ply,"Você comeu um <b>"..idata[5].."</b>.","sucesso")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Hotdog" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                setPedAnimation( ply, "food", "eat_burger", -1, true, false, false )
                setElementData(ply,"emacao",true)
                userobject[ply] = createObject(2769, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 12, 0.02,0.01,0.05,260,-0,-0)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"foodstats",food+25)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    destroyAttachetobj(ply)
                    --exports.an_infobox:addNotification(ply,"Você comeu um <b>"..idata[5].."</b>.","sucesso")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Waterbottle" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                userobject[ply] = createObject(1484, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 11, -0.01,0.12,0.15,260,-0,-130)
                setPedAnimation( ply, "vending", "vend_drink2_p", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"watherstats",wather+45)
                    destroyAttachetobj(ply)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    --exports.an_infobox:addNotification(ply,"Você bebeu <b>"..idata[5].."</b>.","sucesso")
                    triggerClientEvent( ply,"attitem", ply,"Garrafa","1","mais")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Sprunk" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                userobject[ply] = createObject(1546, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 11, 0.0,0.07,0.1,280,-0,-120)
                setPedAnimation( ply, "vending", "vend_drink2_p", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"watherstats",wather+70)
                    destroyAttachetobj(ply)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    triggerClientEvent( ply,"attitem", ply,"Can","1","mais")
                    setElementData(ply, 'Energyeffect', true)
                    setTimer(function()
                        setElementData(ply, 'Energyeffect', false)
                    end,1000*10,1)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Garrafacleite" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                userobject[ply] = createObject(1484, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 11, -0.01,0.12,0.15,260,-0,-130)
                setPedAnimation( ply, "vending", "vend_drink2_p", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"watherstats",wather+85)
                    destroyAttachetobj(ply)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    --exports.an_infobox:addNotification(ply,"Você bebeu <b>"..idata[5].."</b>.","sucesso")
                    triggerClientEvent( ply,"attitem", ply,"Garrafa","1","mais")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Energeticdrink" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                userobject[ply] = createObject(1546, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 11, 0.0,0.07,0.1,280,-0,-120)
                setPedAnimation( ply, "vending", "vend_drink2_p", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"watherstats",wather+25)
                    destroyAttachetobj(ply)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    setElementData(ply, 'Energyeffect', true)
                    setTimer(function()
                        setElementData(ply, 'Energyeffect', false)
                    end,1000*35,1)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Cerveja" or idata[2] == "Tequila" or idata[2] == "Vodka" or idata[2] == "Whisky" then
            if not isTimer(usertimer[ply]) then
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                userobject[ply] = createObject(1484, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone (userobject[ply], ply, 11, -0.01,0.12,0.15,260,-0,-130)
                setPedAnimation( ply, "vending", "vend_drink2_p", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setElementData(ply,"watherstats",wather+7)
                    triggerClientEvent(ply,"drinkeffect", ply)
                    destroyAttachetobj(ply)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                    setPedWalkingStyle(ply,126) 
                    setElementData(ply,"walkstyle",126)
                    --exports.an_infobox:addNotification(ply,"Você bebeu <b>"..idata[5].."</b>.","sucesso")
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
-----------------------------------------------------------------------------------------------------------------------------
-- ETC
-----------------------------------------------------------------------------------------------------------------------------
        elseif idata[2] == "Fuelgallon" then
            local vehproxy = exports.an_player:getproxveh(ply,3)
            if vehproxy then
                if not isTimer(usertimer[ply]) then
                    if not isPedInVehicle(ply) then
                        if tonumber(getElementData(vehproxy,"fuel")) <= 99 then
                            triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                            setPedAnimation(ply, "ped", "jetpack_idle", -1, true, false, false )
                            setTimer ( setPedAnimationProgress, 100, 1, ply, "jetpack_idle", 1.7)
                            setTimer ( setPedAnimationSpeed, 100, 1, ply, "jetpack_idle", 0)
                            setElementData(ply,"emacao",true)
                            usertimer[ply] = setTimer(function()
                                setPedAnimation( ply, nil )
                                setElementData(ply,"emacao",false)
                                setElementData(vehproxy,"fuel",100)
                                --exports.an_infobox:addNotification(ply,"Veiculo <b>abastecido</b> com sucesso!","sucesso")
                            end,5000,1)
                        else
                            exports.an_infobox:addNotification(ply,"O tanque do <b>veiculo</b> esta cheio","aviso") 
                        end
                    else
                        exports.an_infobox:addNotification(ply,"Saia do <b>veiculo</b>","aviso")
                    end
                else
                    exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
                end
            end
        elseif idata[2] == "Garrafa" then
            if not isTimer(usertimer[ply]) then
                local jobleiteiro = getproxyplyonjob(ply,1.4)
                if getproxyonply(ply,1.4) then
                    triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                    userobject[ply] = createObject(1484, plyx, plyy, plyz)
                    setElementCollisionsEnabled(userobject[ply], false)
                    exports.bone_attach:attachElementToBone(userobject[ply],ply, 11, -0.01,0.12,0.15,260,-0,-130)
                    setPedAnimation(ply, "ped", "jetpack_idle", -1, true, false, false )
                    setTimer ( setPedAnimationProgress, 100, 1, ply, "jetpack_idle", 1.7)
                    setTimer ( setPedAnimationSpeed, 100, 1, ply, "jetpack_idle", 0)
                    setElementData(ply,"emacao",true)
                    usertimer[ply] = setTimer(function()
                        triggerClientEvent( ply,"attitem", ply,"Waterbottle","1","mais")
                        destroyAttachetobj(ply)
                        setPedAnimation( ply, nil )
                        setElementData(ply,"emacao",false)
                    end,5000,1)
                elseif jobleiteiro and (not getproxyonply(ply,1.4)) then
                    local id, x, y, z = unpack(jobleiteiro)
                    if id then
                        if getElementData(ply, "MocSlot") + idata[4]*1 < getElementData(ply, "MocMSlot") then
                            triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                            setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                            setElementData(ply,"emacao",true)
                            usertimer[ply] = setTimer(function()
                                triggerClientEvent( ply,"attitem", ply,"Garrafacleite","1","mais")
                                destroyAttachetobj(ply)
                                setPedAnimation( ply, nil )
                                setElementData(ply,"emacao",false)
                            end,2500,1)
                        else
                            exports.an_infobox:addNotification(ply,"<b>Mochila</b> sem espaço!","aviso")
                        end
                    end
                end
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Canabisseed" then
            if not isTimer(usertimer[ply]) then
                if getElementData(ply,"Plantpot") < 1 then exports.an_infobox:addNotification(ply,"Você não tem <b>vaso de plantas</b>.","aviso") return end
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                triggerClientEvent( ply,"attitem", ply,"Plantpot","1","menos")
                setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    exports.an_plant:createcanabisplant(ply)
                    setPedAnimation( ply, nil )
                    setElementData(ply,"emacao",false)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Weedleaf" then
            if not isTimer(usertimer[ply]) then
                if getElementData(ply,"Yeast") < 1 then exports.an_infobox:addNotification(ply,"Você não tem <b>fermento</b>.","aviso") return end
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                triggerClientEvent( ply,"attitem", ply,"Yeast","1","menos")
                setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    triggerClientEvent( ply,"attitem", ply,"Fermentedmarijuana","1","mais")
                    --exports.an_infobox:addNotification(ply,"Você fez 1x <b>Marijuana fermentada</b>","sucesso")
                    setPedAnimation( ply, nil )
                    setElementData( ply,"emacao",false)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Bandaid" then
            if not isTimer(usertimer[ply]) then
                if getElementData(ply, idata[2]) < 1 then exports.an_infobox:addNotification(ply,"Você não tem <b>banda id</b>.","aviso") return end
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    local pHealth = getElementHealth ( ply ) 
                    setElementHealth(ply,pHealth+25)
                    setPedAnimation( ply, nil )
                    setElementData( ply,"emacao",false)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Fermentedmarijuana" then
            if not isTimer(usertimer[ply]) then
                if getElementData(ply,"Paper") < 1 then exports.an_infobox:addNotification(ply,"Você não tem <b>papel</b>.","aviso") return end
                triggerClientEvent( ply,"attitem", ply,idata[2],"1","menos")
                triggerClientEvent( ply,"attitem", ply,"Paper","1","menos")
                setPedAnimation(ply, "bomber", "bom_plant", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    triggerClientEvent( ply,"attitem", ply,"Marijuana","2","mais")
                    --exports.an_infobox:addNotification(ply,"Você fez 1x <b>Marijuana</b>","sucesso")
                    setPedAnimation( ply, nil )
                    setElementData( ply,"emacao",false)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
        elseif idata[2] == "Marijuana" then
            if not isTimer(usertimer[ply]) then
                if getElementData(ply,idata[2]) < 1 then exports.an_infobox:addNotification(ply,"Você não tem <b>"..idata[5].."</b>.","aviso") return end
                triggerClientEvent( ply,"attitem", ply,"Marijuana","1","menos")
                userobject[ply] = createObject(1485, plyx, plyy, plyz)
                setElementCollisionsEnabled(userobject[ply], false)
                exports.bone_attach:attachElementToBone(userobject[ply],ply, 12, 0.04,0.12,0.07,160,30,-130)
                setPedAnimation(ply, "gangs", "smkcig_prtl", -1, true, false, false )
                setElementData(ply,"emacao",true)
                usertimer[ply] = setTimer(function()
                    setPedWalkingStyle(ply,126) 
                    setElementData(ply,"walkstyle",126)
                    triggerClientEvent(ply,"weedeffect", ply)
                    setElementData(ply,"foodstats",food-20)
                    destroyAttachetobj(ply)
                    setPedAnimation( ply, nil )
                    setElementData( ply,"emacao",false)
                end,5000,1)
            else
                exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
            end
-----------------------------------------------------------------------------------------------------------------------------
-- Moveis
-----------------------------------------------------------------------------------------------------------------------------
        elseif idata[1] == 300 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 301 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 302 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 303 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 304 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 305 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 306 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 307 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 308 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 309 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 310 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 311 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 312 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 313 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 314 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 315 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 316 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 317 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 318 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 319 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 320 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 321 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 322 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 323 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 324 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 325 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 326 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[1] == 327 then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Largbed" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Largbed2" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Toilet" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Toilet2" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Toilet3" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Bath" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Bath2" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Bath3" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Sink" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        elseif idata[2] == "Sink2" then
            exports.an_house_i:startobjectposition(ply,idata[2])
        end
    end	
end
addEvent("useitems",true)
addEventHandler ( "useitems", getRootElement(), useitems )

function setplydefaul(ply)
    setPedWalkingStyle(ply,0) 
    setElementData(ply,"walkstyle",0)
end
addEvent("setplydefaul",true)
addEventHandler ( "setplydefaul", getRootElement(), setplydefaul )
----------------------------------------------------------------------------------------------------------------
-- soltar
----------------------------------------------------------------------------------------------------------------
function soltitem (ply,itid,qtd)
    if not isPedInVehicle(ply) then
        if itid then
            for i,v in ipairs (itemtb) do
                if tonumber(itid) == v[1] then
                    if not isTimer(usertimer[ply]) then
                        if getElementData(ply,v[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x<b> "..v[5].."</b>","erro") end
                        triggerClientEvent( ply,"attitem", ply,v[2],qtd,"menos")
                        setPedAnimation(ply, "MISC", "case_pickup")
                        triggerEvent ("drop", ply,ply,v[2],qtd)
                        setTimer(setPedAnimation, 1000, 1, ply, nil)
                        setPedAnimation(ply, "MISC", "case_pickup")
                        setTimer(setPedAnimation, 1000, 1, ply, nil)
                        --exports.an_infobox:addNotification(ply,"você jogou "..qtd.."x <b>"..v[5].."</b> no chão","info")
                        triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** jogou "..qtd.."x "..v[5].."")
                    else
                        exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
                    end
                end
            end
        end	
    else
        exports.an_infobox:addNotification(ply,"Saia do veículo para jogar o <b>item</b> fora.","aviso")
    end
end
addEvent("soltitem",true)
addEventHandler ( "soltitem", getRootElement(), soltitem )
----------------------------------------------------------------------------------------------------------------
-- enviar
----------------------------------------------------------------------------------------------------------------
function envitem (ply,n,qtd)
    if n then
        local tagertply = exports.an_player:getproxply(ply,1.5) 
        if tagertply then
            for i,v in ipairs (itemtb) do
                if n == v[1] then
                    if not isTimer(usertimer[ply]) then
                        if getElementData(ply,v[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x<b> "..v[5].."</b>","erro") end
                        if getElementData(tagertply, "MocSlot") + v[4]*qtd < getElementData(tagertply, "MocMSlot") then
                            triggerClientEvent( ply,"attitem", ply,v[2],qtd,"menos")
                            triggerClientEvent( tagertply,"attitem", tagertply,v[2],qtd,"mais")
                            setPedAnimation(ply, "CRIB", "CRIB_Use_Switch")
                            setTimer(setPedAnimation, 1000, 1, ply, nil)
                            setPedAnimation(tagertply, "CRIB", "CRIB_Use_Switch")
                            setTimer(setPedAnimation, 1000, 1, tagertply, nil)
                            --exports.an_infobox:addNotification(ply,"Você enviou "..qtd.."x <b>"..v[5].."</b>","info")
                            --exports.an_infobox:addNotification(tagertply,"Você recebeu "..qtd.."x <b>"..v[5].."</b>","info") 
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** enviou "..qtd.."x "..v[5].." para o **"..getElementData ( tagertply, "id" ).." - "..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."**")
                        else
                            exports.an_infobox:addNotification(ply,"A pessoa proxima não tem espaço na <b>mochila</b>","erro") 
                        end
                    else
                        exports.an_infobox:addNotification(ply,"<b>Aguarde</b>...","aviso")
                    end
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
        end
    end
end
addEvent("envitem",true)
addEventHandler ( "envitem", getRootElement(), envitem )
----------------------------------------------------------------------------------------------------------------
-- att item
----------------------------------------------------------------------------------------------------------------
function attitemdbitem(ply,item,qtd,tye)
    if tye then
        if tye == "rem" then
            if ply then
                if item then
                    triggerEvent ("remplyitem", ply,ply,item,qtd)
                end
            end
        elseif tye == "add" then
            if ply then
                if item then
                    triggerEvent ("addplyitem",ply,ply,item,qtd)
                end
            end
        elseif tye == "att" then
            if ply then
                if item then
                    triggerEvent ("attplyitem",ply,ply,item,qtd)
                end
            end
        end
    end
end
addEvent("attitemdbitem",true)
addEventHandler ( "attitemdbitem", getRootElement(), attitemdbitem )
----------------------------------------------------------------------------------------------------------------
-- variaveis
----------------------------------------------------------------------------------------------------------------
function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "id") == id then
			v = player
			break
		end
	end
	return v
end
----------------------------------------------------------------------------------------------------------------
-- porta-malas
----------------------------------------------------------------------------------------------------------------
local connec = exports["an_connect"]:getConnection()

function getFreeiditens()
	local result = dbPoll(dbQuery(connec, "SELECT id FROM an_thunk ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function getFreeiditensid()
	local result = dbPoll(dbQuery(connec, "SELECT item_id FROM an_thunk ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["item_id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end

function getFreeiditenschest()
	local result = dbPoll(dbQuery(connec, "SELECT id FROM an_chests_item ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function abriuptmalafnc(ply,veh,typ)
    if typ == 1 then
        if getVehicleDoorOpenRatio (veh, 1 ) == 0 then
            setVehicleDoorOpenRatio(veh, 1, 1, 500)
            setElementData(veh,"portamalassendousado",true)
            setElementData(ply,"usandoptmalass","sim")
            setElementData(ply,"usandoptmalasscarro",veh)
        end
    elseif typ == 2 then
        if getVehicleDoorOpenRatio (veh, 1 ) == 1 then
            setVehicleDoorOpenRatio(veh, 1, 0, 500)
            setElementData(veh,"portamalassendousado",false)
            setElementData(ply,"usandoptmalass",nil)
            setElementData(ply,"usandoptmalasscarro",nil)
        end
    end
end
addEvent("abriuptmalafnc", true)
addEventHandler("abriuptmalafnc", root, abriuptmalafnc)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function fechaptmalasonquit()
    if getElementData(source,"usandoptmalass") then
        abriuptmalafnc(source,getElementData(source,"usandoptmalasscarro"),2)
    end
    if getElementData(source,"chest") then
        setElementData(getElementData(source,"chest"),'inuso',false)
    end
end
addEventHandler ("onPlayerQuit", root, fechaptmalasonquit)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local dist = 8
local lookAtVehicle = nil
function addptmitem(ply,veh,vehid,nomeit,qtd)
    if veh ~= nil then
        if qtd ~= "" then
            if nomeit ~= nil then
                for iitens,vitens in ipairs (itemtb) do
                    if nomeit == vitens[1] then
                        if vitens[2] == "Money" then return exports.an_infobox:addNotification(ply,"Não e possivel guardar <b>dinheiro</b>","erro") end
                        local vehusedslot = getElementData(veh, "usedslots")
                        local vehmalaslot = getElementData(veh, "mala")
                        if tonumber(vehusedslot) + vitens[4]*qtd < tonumber(vehmalaslot) then
                            if getElementData(ply, vitens[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x <b>"..vitens[5].."</b>","erro") end
                            local dbid = tonumber(getElementData(veh, vitens[2]))
                            if getElementData(veh,vitens[2]) >= 1 then
                                setElementData(veh, vitens[2], getElementData(veh, vitens[2]) + qtd)
                                --exports.an_infobox:addNotification(ply,"Você colocou "..qtd.."x <b>"..vitens[5].."</b>","info")
                                setElementData(veh, "usedslots", getElementData(veh, "usedslots") + vitens[4]*qtd)
                                triggerClientEvent( ply,"attitemtrunk", ply,vitens[2],qtd,"menos")
                                local dbid2 = tonumber(getElementData(veh, vitens[2]))
                                updateammountitem(nomeit,dbid2,getElementData(veh,"id"),veh)
                                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** colocou "..qtd.."x "..vitens[5].." no carro")
                            elseif getElementData(veh,vitens[2]) == 0 then
                                setElementData(veh, vitens[2], getElementData(veh, vitens[2]) + qtd)
                                --exports.an_infobox:addNotification(ply,"Você colocou "..qtd.."x <b>"..vitens[5].."</b>","info")
                                setElementData(veh, "usedslots", getElementData(veh, "usedslots") + vitens[4]*qtd)
                                triggerClientEvent( ply,"attitemtrunk", ply,vitens[2],qtd,"menos")
                                insetitemveic(getElementData(veh,"id"),nomeit,qtd,veh)
                                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** colocou "..qtd.."x "..vitens[5].." no carro")
                            end  
                        else
                            triggerClientEvent( ply,"requestinvinfo2", ply)
                            exports.an_infobox:addNotification(ply,"O <b>porta malas</b> não tem espaço","erro")
                        end 
                    end
                end
            end
        end
    end
end
addEvent("addptmitem", true)
addEventHandler("addptmitem", root, addptmitem)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function removeptmitem(ply,veh,vehid,nomeit,qtd)
    if veh ~= nil then
        if qtd ~= "" then
            if nomeit ~= nil then
                for iitens,vitens in ipairs (itemtb) do
                    if nomeit == vitens[1] then
                        local plyusedslot = getElementData(ply, "MocSlot")
                        local plymalaslot = getElementData(ply, "MocMSlot")
                        if tonumber(plyusedslot) + vitens[4]*qtd < tonumber(plymalaslot) then
                            if getElementData(veh, vitens[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"não tem "..qtd.."x <b>"..vitens[5].."</b> no carro","erro") end
                            setElementData(veh, vitens[2], getElementData(veh, vitens[2]) - qtd)
                            --exports.an_infobox:addNotification(ply,"Você retirou "..qtd.."x <b>"..vitens[5].."</b>","info")
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** tirou "..qtd.."x "..vitens[5].." do carro")
                            local dbid = tonumber(getElementData(veh, vitens[2]))
                            setElementData(veh, "usedslots", getElementData(veh, "usedslots") - vitens[4]*qtd)
                            triggerClientEvent( ply,"attitemtrunk", ply,vitens[2],qtd,"mais")
                            updateammountitem(nomeit,dbid,vehid,veh)
                            local playeQ = dbQuery(connec,"SELECT * FROM an_thunk")
                            local playeH,playeHm = dbPoll(playeQ,-1)
                                if playeH then
                                    for k,v in ipairs(playeH) do
                                    item_id = v["item_id"]
                                    item_owner = v["item_owner"]
                                    q = v["item_count"]
                                    if q == 0 then
                                        dbExec(connec, "DELETE FROM an_thunk WHERE item_id = ? AND item_owner = ?",item_id,item_owner)
                                    end
                                end
                            end
                        else
                            triggerClientEvent( ply,"requestinvinfo2", ply)
                            exports.an_infobox:addNotification(ply,"A <b>mochila</b> não tem espaço","erro")
                        end
                    end
                end
            end
        end
    end
end
addEvent("removeptmitem", true)
addEventHandler("removeptmitem", root, removeptmitem)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function updateammountitem(nomeit,dbid,vehid,veh)
    local playeQ = dbQuery(connec,"SELECT * FROM an_thunk")
    local playeH,playeHm = dbPoll(playeQ,-1)
    if playeH then
        for k,v in ipairs(playeH) do
            item_id = v["item_id"]
            item_owner = v["item_owner"]
            if nomeit == item_id and vehid == item_owner then
                dbExec(connec, "UPDATE an_thunk SET item_count= ? WHERE item_id = ? AND item_owner = ?", dbid, item_id, vehid)
                exports.an_vehicles:saveVehicle(veh,0)
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
function insetitemveic(vehid,item,qtd,veh)
    if item and qtd and vehid then
        local freeiditem = getFreeiditens()
        local freeiditem_id = getFreeiditensid()
        dbExec(connec, "INSERT INTO an_thunk SET id = ?,item_owner = ?,item_id = ?,item_count= ?",freeiditem,vehid,item,qtd)
        exports.an_vehicles:saveVehicle(veh,0)
    end
end
----------------------------------------------------------------------------------------------------------------
function deleteitemveic()
    local playeQ = dbQuery(connec,"SELECT * FROM an_thunk")
    local playeH,playeHm = dbPoll(playeQ,-1)
        if playeH then
            for k,v in ipairs(playeH) do
            item_id = v["item_id"]
            item_owner = v["item_owner"]
            q = v["item_count"]
            if q == 0 then
                dbExec(connec, "DELETE FROM an_thunk WHERE item_id = ? AND item_owner = ?",item_id,item_owner)
            end
        end
    end
end
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),deleteitemveic)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destroyVehicleData(vehid)
    if vehid then
        local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", vehid), -1)[1]
        if not data then
            dbExec(connection, "DELETE FROM an_thunk WHERE item_owner=?", vehid)
        end
    end
end

function destroyChestidData(chestid)
    if chestid then
        local data = dbPoll(dbQuery(connection, "SELECT * FROM an_chests WHERE id = ?", chestid), -1)[1]
        if not data then
            dbExec(connection, "DELETE FROM an_chests_item WHERE item_owner=?",chestid)
        end
    end
end

function loadAllan_thunk2()
    local itemveharray = dbPoll(dbQuery(connec, "SELECT * FROM an_thunk"), -1)
    if not itemveharray then return end
    for k,v in pairs(itemveharray) do
        for key,veh in pairs(getElementsByType("vehicle")) do
            if getElementData(veh,"id") == v["item_owner"] then
                setElementData(veh,"usedslots",0)
                for i2,v2 in ipairs (itemtb) do
                    setElementData(veh,v2[2],0)
                    loadAllan_thunk(veh,v2[1])
                end
                setVehicleDoorOpenRatio(veh, 1, 0, 500)
                setElementData(veh,"portamalassendousado",false)
                setElementData(veh,"portmalasemuso",false)
            end
        end
    end
end
addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),loadAllan_thunk2)

function loadvehicletrunk(veh)
    if getElementData(veh,"id") then
        setElementData(veh,"usedslots",0)
        for i2,v2 in ipairs (itemtb) do
            setElementData(veh,v2[2],0)
            loadAllan_thunk(veh,v2[1])
        end
        setVehicleDoorOpenRatio(veh, 1, 0, 500)
        setElementData(veh,"portamalassendousado",false)
        setElementData(veh,"portmalasemuso",false)
    end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadAllan_thunk(veh,item)
    local vehid = getElementData(veh,"id")
    if vehid then
        local playeQ = dbQuery(connec,"SELECT * FROM an_thunk WHERE item_id = ? AND item_owner = ?",item,vehid)
        local playeH,playeHm = dbPoll(playeQ,-1)
        if playeH then
            for k,v in ipairs(playeH) do
                item_id = v["item_id"]
                item_owner = v["item_owner"]
                q = v["item_count"]
                if item_id then
                    if getElementData(veh,"id") == v["item_owner"] then
                        local itemdata = exports.an_account:servergetitemtable(item_id)
                        if item_id == itemdata[1] then
                            setElementData(veh,itemdata[2],q)
                            setElementData(veh,"usedslots",getElementData(veh,"usedslots") + itemdata[4]*q)
                        end
                    end
                end
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
-- POS ITEM FUNCTION
----------------------------------------------------------------------------------------------------------------
-- BANDAGEM
function bandagem1(ply)
    if getElementData(ply,"bandagem") == true then
        local pHealth = getElementHealth ( ply ) 
        setElementHealth(ply,pHealth+25)
        exports.an_infobox:addNotification(ply,"você usou 1x <b>Bandagem</b>","sucesso")
        triggerClientEvent( ply,"attitem", ply,"Bandage","1","menos")
        setElementData(ply,"bandagem",false)
    end
end
addEvent("bandagem1",true)
addEventHandler ( "bandagem1", getRootElement(), bandagem1 )
------------------------------------------------------------------------------------------------------------------
-- CHEST LOAD
------------------------------------------------------------------------------------------------------------------
function addchest(ply,veh,nomeit,qtd)
    if veh ~= nil then
        if qtd ~= "" then
            if nomeit ~= nil then
                for iitens,vitens in ipairs (itemtb) do
                    if nomeit == vitens[1] then
                        --if vitens[2] == "Money" then return exports.an_infobox:addNotification(ply,"Não e possivel guardar <b>dinheiro</b>","erro") end
                        local vehusedslot = getElementData(veh, "usedslots")
                        local vehmalaslot = getElementData(veh, "maxslots")
                        if tonumber(vehusedslot) + vitens[4]*qtd < tonumber(vehmalaslot) then
                            if getElementData(ply, vitens[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x <b>"..vitens[5].."</b>","erro") end
                            local dbid = tonumber(getElementData(veh, vitens[2]))
                            if getElementData(veh,vitens[2]) >= 1 then
                                setElementData(veh, vitens[2], getElementData(veh, vitens[2]) + qtd)
                                --exports.an_infobox:addNotification(ply,"Você colocou "..qtd.."x <b>"..vitens[5].."</b>","info")
                                setElementData(veh, "usedslots", getElementData(veh, "usedslots") + vitens[4]*qtd)
                                triggerClientEvent( ply,"attitemchest", ply,vitens[2],qtd,"menos")
                                local dbid2 = tonumber(getElementData(veh, vitens[2]))
                                updateammountitemchest(vitens[2],dbid2,getElementData(veh,"id"),veh)
                                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** colocou "..qtd.."x "..vitens[5].." no baú")
                            elseif getElementData(veh,vitens[2]) == 0 then
                                setElementData(veh, vitens[2], getElementData(veh, vitens[2]) + qtd)
                                --exports.an_infobox:addNotification(ply,"Você colocou "..qtd.."x <b>"..vitens[5].."</b>","info")
                                setElementData(veh, "usedslots", getElementData(veh, "usedslots") + vitens[4]*qtd)
                                triggerClientEvent( ply,"attitemchest", ply,vitens[2],qtd,"menos")
                                insetitemchest(getElementData(veh,"id"),vitens[2],qtd,veh)
                                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** colocou "..qtd.."x "..vitens[5].." no baú")
                            end  
                        else
                            triggerClientEvent( ply,"requestinvinfo3", ply)
                            exports.an_infobox:addNotification(ply,"O <b>baú</b> não tem espaço","erro")
                        end 
                    end
                end
            end
        end
    end
end
addEvent("addchest", true)
addEventHandler("addchest", root, addchest)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function removechest(ply,veh,nomeit,qtd)
    if veh ~= nil then
        if qtd ~= "" then
            if nomeit ~= nil then
                for iitens,vitens in ipairs (itemtb) do
                    if nomeit == vitens[1] then
                        local plyusedslot = getElementData(ply, "MocSlot")
                        local plymalaslot = getElementData(ply, "MocMSlot")
                        if tonumber(plyusedslot) + vitens[4]*qtd < tonumber(plymalaslot) then
                            if getElementData(veh, vitens[2]) < 1*qtd then return exports.an_infobox:addNotification(ply,"não tem "..qtd.."x <b>"..vitens[5].."</b> no baú","erro") end
                            setElementData(veh, vitens[2], getElementData(veh, vitens[2]) - qtd)
                            --exports.an_infobox:addNotification(ply,"Você retirou "..qtd.."x <b>"..vitens[5].."</b>","info")
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** tirou "..qtd.."x "..vitens[5].." do baú")
                            local dbid = tonumber(getElementData(veh, vitens[2]))
                            setElementData(veh, "usedslots", getElementData(veh, "usedslots") - vitens[4]*qtd)
                            triggerClientEvent( ply,"attitemchest", ply,vitens[2],qtd,"mais")
                            updateammountitemchest(vitens[2],dbid,getElementData(veh,'id'),veh)
                            local playeQ = dbQuery(connec,"SELECT * FROM an_chests_item")
                            local playeH,playeHm = dbPoll(playeQ,-1)
                                if playeH then
                                    for k,v in ipairs(playeH) do
                                    item_id = v["item"]
                                    item_owner = v["item_owner"]
                                    q = v["item_count"]
                                    if q == 0 then
                                        dbExec(connec, "DELETE FROM an_chests_item WHERE item = ? AND item_owner = ?",item_id,item_owner)
                                    end
                                end
                            end
                        else
                            triggerClientEvent( ply,"requestinvinfo3", ply)
                            exports.an_infobox:addNotification(ply,"A <b>mochila</b> não tem espaço","erro")
                        end
                    end
                end
            end
        end
    end
end
addEvent("removechest", true)
addEventHandler("removechest", root, removechest)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function updateammountitemchest(nomeit,dbid,vehid,veh)
    local playeQ = dbQuery(connec,"SELECT * FROM an_chests_item")
    local playeH,playeHm = dbPoll(playeQ,-1)
    if playeH then
        for k,v in ipairs(playeH) do
            item_id = v["item"]
            item_owner = v["item_owner"]
            if nomeit == item_id and vehid == item_owner then
                dbExec(connec, "UPDATE an_chests_item SET item_count= ? WHERE item = ? AND item_owner = ?", dbid, item_id, vehid)
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
function insetitemchest(vehid,item,qtd,veh)
    if item and qtd and vehid then
        local freeiditem = getFreeiditenschest()
        dbExec(connec, "INSERT INTO an_chests_item SET id = ?,item_owner = ?,item = ?,item_count= ?",freeiditem,vehid,item,qtd)
    end
end

function deleteitemchest()
    local playeQ = dbQuery(connec,"SELECT * FROM an_chests_item")
    local playeH,playeHm = dbPoll(playeQ,-1)
        if playeH then
            for k,v in ipairs(playeH) do
            item_id = v["item"]
            item_owner = v["item_owner"]
            q = v["item_count"]
            if q == 0 then
                dbExec(connec, "DELETE FROM an_chests_item WHERE item = ? AND item_owner = ?",item_id,item_owner)
            end
        end
    end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), deleteitemchest)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadchestitem(chest)
    local cid = tostring(getElementData(chest,'id'))
    if cid then
        local data = dbPoll(dbQuery(connection, "SELECT * FROM an_chests_item WHERE item_owner = ?", cid), -1)[1]
        if not data then
            for i,v in ipairs (itemtb) do
                local dbid2 = tonumber(getElementData(chest, v[2]))
                if dbid2 == nil then
                    setElementData(chest,v[2],0)
                end
            end
        else
            if getElementData(chest,"id") then
                setElementData(chest,"usedslots",0)
                for iitem,itemv in ipairs (itemtb) do
                    setElementData(chest,itemv[2],0)
                    loaditem_chest(chest,itemv[2])
                end
                setElementData(chest,"chestemuso",false)
            end
        end
    end
end

function loaditem_chest(chest,item)
    local cid = getElementData(chest,"id")
    if cid then
        local playeQ = dbQuery(connec,"SELECT * FROM an_chests_item WHERE item = ? AND item_owner = ?",item,cid)
        local playeH,playeHm = dbPoll(playeQ,-1)
        if playeH then
            for k,v in ipairs(playeH) do
                thitem = v["item"]
                item_owner = v["item_owner"]
                q = v["item_count"]
                if thitem then
                    if getElementData(chest,"id") == v["item_owner"] then
                        local itemdata = exports.an_account:servergetitemtable2(thitem)
                        if thitem == itemdata[2] then
                            setElementData(chest,itemdata[2],q)
                            setElementData(chest,"usedslots",getElementData(chest,"usedslots") + itemdata[4]*q)
                        end
                    end
                end
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
-- ATTACHET
----------------------------------------------------------------------------------------------------------------
function destroyAttachetobj(ply)
    if isElement(userobject[ply]) then
        exports.bone_attach:detachElementFromBone(userobject[ply])
        destroyElement(userobject[ply])
        userobject[ply] = nil
    end
end

function destroyOnQuit()
    if isElement(userobject[source]) then
        exports.bone_attach:detachElementFromBone(userobject[source])
        destroyElement(userobject[source])
        userobject[source] = nil
    end
end
addEventHandler ("onPlayerQuit", root, destroyOnQuit)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function attitemdbitemtrunk(ply,item,qtd,tye)
    if tye then
        if tye == "rem" then
            if ply then
                if item then
                    triggerEvent ("remplyitem", ply,ply,item,qtd)
                end
            end
        elseif tye == "add" then
            if ply then
                if item then
                    triggerEvent ("addplyitem",ply,ply,item,qtd)
                end
            end
        elseif tye == "att" then
            if ply then
                if item then
                    triggerEvent ("attplyitem",ply,ply,item,qtd)
                end
            end
        end
    end
end
addEvent("attitemdbitemtrunk",true)
addEventHandler ( "attitemdbitemtrunk", getRootElement(), attitemdbitemtrunk )
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function attitemdbitemchest(ply,item,qtd,tye)
    if tye then
        if tye == "rem" then
            if ply then
                if item then
                    triggerEvent ("remplyitem", ply,ply,item,qtd)
                end
            end
        elseif tye == "add" then
            if ply then
                if item then
                    triggerEvent ("addplyitem",ply,ply,item,qtd)
                end
            end
        elseif tye == "att" then
            if ply then
                if item then
                    triggerEvent ("attplyitem",ply,ply,item,qtd)
                end
            end
        end
    end
end
addEvent("attitemdbitemchest",true)
addEventHandler ( "attitemdbitemchest", getRootElement(), attitemdbitemchest )
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function sattitem(ply,n,qtd,spc)
    triggerClientEvent( ply,"attitem", ply,n,qtd,spc)
end
function sattitem2(ply,n,qtd,spc)
    triggerClientEvent( ply,"attitem2", ply,n,qtd,spc)
end

local objtable = {
    {1808},
    {2002}
}
function getproxyonply(ply,distance)
    local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
    local players = getElementsByType("object")
    for i, v in ipairs (players) do 
        local tmodel = getElementModel(v)
        for i2, v2 in ipairs (objtable) do
            local objid = unpack(v2)
            if tmodel == objid then
                local pX, pY, pZ = getElementPosition (v)
                local wpx, wpy, wpz = math.round ( pX, 3 ),math.round ( pY, 3 ),math.round ( pZ, 3 )
                if getDistanceBetweenPoints3D ( wpx, wpy, wpz, x, y, z) < dist then
                    dist = getDistanceBetweenPoints3D ( wpx, wpy, wpz, x, y, z)
                    id = v
                end
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end

function getproxyplyonjob(ply,distance)
    local px, py, pz = getElementPosition (ply) 
	local dist = distance
	local id = false
    local cow = exports.an_leiteiro:servergetjobleiteirotable()
    if cow then
        for i, v in ipairs (cow) do 
            local jid, x, y, z = unpack(v)
            if getDistanceBetweenPoints3D ( x, y, z, px, py, pz ) < dist then
                dist = getDistanceBetweenPoints3D ( x, y, z, px, py, pz )
                id = v
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end

function getproxychest(ply,distance)
    local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
    local players = getElementsByType("object")
    for i, v in ipairs (players) do 
        if getElementData(v,"maxslots") then
            local tmodel = getElementModel(v)
            for i2, v2 in ipairs (cfg.armarioobjecttable) do
                local objid = unpack(v2)
                if tmodel == objid then
                    local pX, pY, pZ = getElementPosition (v)
                    local wpx, wpy, wpz = math.round ( pX, 3 ),math.round ( pY, 3 ),math.round ( pZ, 3 )
                    if getDistanceBetweenPoints3D ( wpx, wpy, wpz, x, y, z) < dist then
                        dist = getDistanceBetweenPoints3D ( wpx, wpy, wpz, x, y, z)
                        id = v
                    end
                end
            end
        end
    end
    if id then
        return id
    else
        return false
    end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------