-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
local itemtb = exports.an_account:servergetitemtable3()
--------------------------------------------------------------------------------------------------------------------
-- ARSENAL
--------------------------------------------------------------------------------------------------------------------
local arsenalcol = {}
local arsenal = {}
function createmksarsenal()
    for i,v in ipairs (cfg.arsenal) do
        local id,x,y,z,rx,ry,rz = unpack(v)
       -- pedrasobjc[id] = createObject ( obid, x,y,z-1,rx,ry,rz )
        arsenal = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
        arsenalcol[id] = createColSphere(x,y,z-0.5,1)
		setElementData(arsenalcol[id],"idarsenal",id)
        setElementData(arsenalcol[id],"colarsenal",arsenalcol[id])
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksarsenal)
--------------------------------------------------------------------------------------------------------------------
-- arsenal arms
--------------------------------------------------------------------------------------------------------------------
weapons = {
    {"Deagle","glock","Glock 19","glockammu"},
    {"M4","M4A1","M4A1","M4A1ammu"},
    {"Shotgun","remington870","Remington 870","remington870ammu"},
    {"Silenced","taser","Taser","taser"},
    {"Colete","colete","Colete","colete"},
}

function arsenalarms(ply,data)
    if data then
        if data == "colete" then
            if getElementData(ply, "MocSlot") + 3 < getElementData(ply, "MocMSlot") then
                if getElementData(ply, "colete") <= 0 then
                    exports.an_inventory:sattitem(ply,"colete",1,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 1x <b>colete</b>","sucesso")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem espaço na <b>mochila</b>","erro")
            end
        elseif data == "teser" then
            if getElementData(ply, "MocSlot") + 1 < getElementData(ply, "MocMSlot") then
                if getElementData(ply, "taser") <= 0 then
                    exports.an_inventory:sattitem(ply,"taser",1,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 1x <b>taser</b>","sucesso")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem espaço na <b>mochila</b>","erro")
            end
        elseif data == "algema" then
            if getElementData(ply, "MocSlot") + 1 < getElementData(ply, "MocMSlot") then
                if getElementData(ply, "Algema") <= 0 then
                    exports.an_inventory:sattitem(ply,"Algema",1,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 1x <b>algema</b>","sucesso")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem espaço na <b>mochila</b>","erro")
            end
        elseif data == "glock19" then
            if getElementData(ply, "MocSlot") + 1 < getElementData(ply, "MocMSlot") then
                if getElementData(ply, "glock") <= 0 then
                    exports.an_inventory:sattitem(ply,"glock",1,"mais")
                    local ammu = getElementData(ply,"glockammu")
                    exports.an_inventory:sattitem(ply,"glockammu",ammu,"menos")
                    exports.an_inventory:sattitem(ply,"glockammu",250,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 1x <b>glock 19</b>","sucesso")
                elseif getElementData(ply, "glock") >= 1 then 
                    local ammu = getElementData(ply,"glockammu")
                    exports.an_inventory:sattitem(ply,"glockammu",ammu,"menos")
                    exports.an_inventory:sattitem(ply,"glockammu",250,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 250x balas de <b>glock 19</b>","info")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem espaço na <b>mochila</b>","erro")
            end
        elseif data == "m4a1" then
            if getElementData(ply, "MocSlot") + 2 < getElementData(ply, "MocMSlot") then
                if getElementData(ply, "M4A1") <= 0 then 
                    exports.an_inventory:sattitem(ply,"M4A1",1,"mais")
                    local ammu = getElementData(ply,"M4A1ammu")
                    exports.an_inventory:sattitem(ply,"M4A1ammu",ammu,"menos")
                    exports.an_inventory:sattitem(ply,"M4A1ammu",250,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 1x <b>M4A1</b>","sucesso")
                elseif getElementData(ply, "M4A1") >= 1 then 
                    local ammu = getElementData(ply,"M4A1ammu")
                    exports.an_inventory:sattitem(ply,"M4A1ammu",ammu,"menos")
                    exports.an_inventory:sattitem(ply,"M4A1ammu",250,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 250x balas de <b>M4A1</b>","info")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem espaço na <b>mochila</b>","erro")
            end
        elseif data == "remington870" then
            if getElementData(ply, "MocSlot") + 2 < getElementData(ply, "MocMSlot") then
                if getElementData(ply, "remington870") <= 0 then 
                    exports.an_inventory:sattitem(ply,"remington870",1,"mais")
                    local ammu = getElementData(ply,"remington870ammu")
                    exports.an_inventory:sattitem(ply,"remington870ammu",ammu,"menos")
                    exports.an_inventory:sattitem(ply,"remington870ammu",250,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 1x <b>remington 870</b>","sucesso")
                elseif getElementData(ply, "remington870") >= 1 then 
                    local ammu = getElementData(ply,"remington870ammu")
                    exports.an_inventory:sattitem(ply,"remington870ammu",ammu,"menos")
                    exports.an_inventory:sattitem(ply,"remington870ammu",250,"mais")
                    exports.an_infobox:addNotification(ply,"Você pegou 250x balas de <b>remington 870</b>","info")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem espaço na <b>mochila</b>","erro")
            end
        elseif data == "rarms" then
            if getElementData(ply, "remington870") >= 1 then 
                local arm = getElementData(ply,"remington870")
                local ammu = getElementData(ply,"remington870ammu")
                exports.an_inventory:sattitem(ply,"remington870",arm,"menos")
                if ammu >= 1 then
                    exports.an_inventory:sattitem(ply,"remington870ammu",ammu,"menos")
                end
                exports.an_infobox:addNotification(ply,"Você devolveu <b>remington 870</b>","aviso")
            end
            if getElementData(ply, "M4A1") >= 1 then
                local arm = getElementData(ply,"M4A1")
                local ammu = getElementData(ply,"M4A1ammu")
                exports.an_inventory:sattitem(ply,"M4A1",arm,"menos")
                if ammu >= 1 then
                    exports.an_inventory:sattitem(ply,"M4A1ammu",ammu,"menos")
                end
                exports.an_infobox:addNotification(ply,"Você devolveu <b>M4A1</b>","aviso")
            end
            if getElementData(ply, "glock") >= 1 then
                local arm = getElementData(ply,"glock")
                local ammu = getElementData(ply,"glockammu")
                exports.an_inventory:sattitem(ply,"glock",arm,"menos")
                if ammu >= 1 then
                    exports.an_inventory:sattitem(ply,"glockammu",ammu,"menos")
                end
                exports.an_infobox:addNotification(ply,"Você devolveu <b>glock 19</b>","aviso")
            end
            if getElementData(ply, "taser") >= 1 then
                local arm = getElementData(ply,"taser")
                exports.an_inventory:sattitem(ply,"taser",arm,"menos")
                exports.an_infobox:addNotification(ply,"Você devolveu <b>taser</b>","aviso")
            end
            if getElementData(ply, "Algema") >= 1 then
                local arm = getElementData(ply,"Algema")
                exports.an_inventory:sattitem(ply,"Algema",arm,"menos")
                exports.an_infobox:addNotification(ply,"Você devolveu <b>algema</b>","aviso")
            end
            if getElementData(ply, "colete") >= 1 then
                local arm = getElementData(ply,"colete")
                exports.an_inventory:sattitem(ply,"colete",arm,"menos")
                exports.an_infobox:addNotification(ply,"Você devolveu <b>colete</b>","aviso")
            end
        end
    end
end
addEvent ("arsenalarms", true)
addEventHandler ("arsenalarms", root, arsenalarms)
--------------------------------------------------------------------------------------------------------------------
-- REVISTAR
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("inspect",
function(ply,cmd)
    local tagertply = exports.an_player:getproxply(ply,3)
    if tagertply then
        triggerClientEvent (tagertply,"openconfirminspect",tagertply,ply)
        exports.an_infobox:addNotification(ply,"Aguarde a pessoa aceitar...","aviso")
    else
        exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
    end
end
)

addCommandHandler("pinspect",
function(ply,cmd,id)
    if not (getElementData(ply, "Admin", true)) then return end
    if id then
        getplyid = tonumber(id)
        if getplyid then
        local ply2 = getPlayerID(getplyid)
            if ply2 then
                triggerClientEvent (ply,"openpolicepanel",ply,ply2)
            else
                exports.an_infobox:addNotification(ply,"id não <b>encontrado</b>.","erro")
            end
        end
    end
end
)

function aceptinspect(ply,plyinspect)
    if plyinspect then
        triggerClientEvent (plyinspect,"openpolicepanel",plyinspect,ply)
        exports.an_infobox:addNotification(ply,"Você está sendo revistado!","aviso")
    end
end
addEvent ("aceptinspect", true)
addEventHandler ("aceptinspect", root, aceptinspect)
--------------------------------------------------------------------------------------------------------------------
-- apreender itens
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("seize",
function(ply,cmd)
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        local tagertply = exports.an_player:getproxply(ply,1)
        if tagertply then
            if getElementData(tagertply,"Algemado") then
                for i,v in ipairs (cfg.ilegalitens) do
                    local getitdb = exports.an_account:servergetitemtable2(v[1])
                    if getitdb then
                        local getplydata = getElementData(tagertply, getitdb[2]) or 0
                        if getplydata >= 1 then
                            if tonumber(getElementData(ply, "MocSlot") + getitdb[4]*getplydata) <= tonumber(getElementData(ply, "MocMSlot"))then
                                exports.an_inventory:sattitem(ply,getitdb[2],getplydata,"mais")
                                exports.an_inventory:sattitem(tagertply,getitdb[2],getplydata,"menos")
                                exports.an_infobox:addNotification(ply,"Você apreendeu "..getplydata.."x <b>"..getitdb[5].."</b>","aviso")
                            else
                                triggerEvent ("drop", ply,ply,getitdb[2],getplydata)
                                exports.an_inventory:sattitem(tagertply,getitdb[2],getplydata,"menos")
                                exports.an_infobox:addNotification(ply,"A <b>mochila</b> está sem espaço o <b>"..getitdb[5].."</b> caiu no chão!","erro")
                            end
                            exports.an_infobox:addNotification(tagertply,"Todos os seus pertences foram <b>apreendidos</b>.","aviso")
                        end
                    end
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
        end
    end
end
)
--------------------------------------------------------------------------------------------------------------------
-- puxar identidade
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("identity",
function(ply,cmd)
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        local tagertply = exports.an_player:getproxply(ply,2)
        if tagertply then
			exports.an_infobox:addNotification(ply,"<b>Documento da pessoa próxima</b><br><br><b>Passaporte:</b> "..getElementData(tagertply,"id").." <br> <b>Nome: </b>"..getElementData(tagertply,"Nome").." <br> <b>Sobrenome: </b>"..getElementData(tagertply,"SNome").." <br> <b>Dinheiro: </b>"..getElementData(tagertply,"Money").." <br> <b>Banco: </b>"..getElementData(tagertply,"BankMoney").." <br>","sucesso")
        else
            exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
        end
    end
end
)
--------------------------------------------------------------------------------------------------------------------
-- puxar info do veh
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("board",
function(ply,cmd)
    if exports.an_account:hasPermission( ply, 'police.permission' ) or getElementData(ply,"Admin") == true then
        local vehicl = exports.an_player:getproxveh(ply,5)
        if vehicl then
            local vehownername = getElementData(vehicl,"Nome")
            local vehownersname = getElementData(vehicl,"Snome")
            local vehplate = ""
            if getElementData(vehicl,"number:plate") then
                 vehplate = getElementData(vehicl,"number:plate")
            elseif not getElementData(vehicl,"number:plate") then
                 vehplate = "Veiculo alugado"
            end

            exports.an_infobox:addNotification(ply,"<b>Informações do veiculo</b> <br><br><b>Dono</b>: "..vehownername.." "..vehownersname.."<br><br><b>Placa</b>: "..vehplate.."","info")
        else
            exports.an_infobox:addNotification(ply,"Não há <b>veiculo</b> por perto.","erro")
        end
    end
end
)
--------------------------------------------------------------------------------------------------------------------
-- lock and unlock veh
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("lock",
function(ply,cmd)
    if exports.an_account:hasPermission( ply, 'police.permission' ) or getElementData(ply,"Admin") == true then
        local vehicl = exports.an_player:getproxveh(ply,5)
        if vehicl then
            exports.an_infobox:addNotification(ply,"<b>Veiculo</b> trancado.","aviso")
            setVehicleLocked( vehicl, true )
            setElementData(vehicl,"vehlocked",true)
        else
            exports.an_infobox:addNotification(ply,"Não há <b>veiculo</b> por perto.","erro")
        end
    end
end
)
addCommandHandler("unlock",
function(ply,cmd)
    if exports.an_account:hasPermission( ply, 'police.permission' ) or getElementData(ply,"Admin") == true then
        local vehicl = exports.an_player:getproxveh(ply,5)
        if vehicl then
            setVehicleLocked( vehicl, false )
            setElementData(vehicl,"vehlocked",false)
            exports.an_infobox:addNotification(ply,"<b>Veiculo</b> destrancado.","aviso")
        else
            exports.an_infobox:addNotification(ply,"Não há <b>veiculo</b> por perto.","erro")
        end
    end
end
)
--------------------------------------------------------------------------------------------------------------------
-- Algemar
--------------------------------------------------------------------------------------------------------------------
local hcuff = {}
function algemartheply(ply)
    local tagertply = exports.an_player:getproxply(ply,1)
    if tagertply then
        if (not isPedInVehicle(tagertply)) then
            if not getElementData(tagertply,"Algemado") then
                setElementData(tagertply,"Algemado",true)
                setElementData(tagertply,"emacao",true)
                toggleControl(tagertply,'fire', false)
                toggleControl(tagertply,'jump', false)
                toggleControl(tagertply,'sprint',false)
                toggleControl(tagertply,'aim_weapon',false)
                toggleControl(tagertply,'enter_passenger', false)
                toggleControl(tagertply,'enter_exit', false)
                triggerClientEvent(getRootElement(), "starthcuffsound", getRootElement(), tagertply)
                setTimer(function()
                    triggerClientEvent(getRootElement(), "stopcuffsound", getRootElement(), tagertply)
                end,600,1)
                setPedAnimation(tagertply, "ped", "pass_Smoke_in_car", 0, true, false, false)
                setTimer ( setPedAnimationProgress, 100, 1, tagertply, "pass_Smoke_in_car", 0)
                setTimer ( setPedAnimationSpeed, 100, 1, tagertply, "pass_Smoke_in_car", 0)
                if not isElement(hcuff[tagertply]) then
                    local obj = createObject(321, 0, 0, 0)
                    hcuff[tagertply] = obj
                    exports["bone_attach"]:attachElementToBone(hcuff[tagertply], tagertply,12, 0,0,0,0,40,-10)
                    setObjectScale(hcuff[tagertply], 1)
                    setElementCollisionsEnabled(hcuff[tagertply], false)
                end
                
            else
                setElementData(tagertply,"Algemado",false)
                setElementData(tagertply,"emacao",false)
                toggleControl(tagertply,'fire', true)
                toggleControl(tagertply,'jump', true)
                toggleControl(tagertply,'sprint',true)
                toggleControl(tagertply,'aim_weapon',true)
                toggleControl(tagertply,'enter_passenger', true)
                toggleControl(tagertply,'enter_exit', true)
                triggerClientEvent(getRootElement(), "starthcuffsound", getRootElement(), tagertply)
                setTimer(function()
                    triggerClientEvent(getRootElement(), "stopcuffsound", getRootElement(), tagertply)
                end,600,1)
                setTimer ( setPedAnimation, 100, 1, tagertply,  "ped", "pass_Smoke_in_car", 7000, false, false, false)
                setTimer ( setPedAnimation, 250, 1, tagertply, nil)
                if isElement(hcuff[tagertply]) then
                    exports["bone_attach"]:detachElementFromBone(hcuff[tagertply])
                    destroyElement(hcuff[tagertply])
                    hcuff[tagertply] = {}
                end
            end
        end
    end
end
addEvent ("algemartheply", true)
addEventHandler ("algemartheply", root, algemartheply)
----------------------------------------------------------------------------------------------------------------
-- warning
----------------------------------------------------------------------------------------------------------------
addCommandHandler("powarning",
function(ply,cmd,typ,...)
    local message = table.concat ( { ... }, " " )
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        local name = getElementData(ply,"Nome")
        local sname = getElementData(ply,"SNome")
        triggerEvent("sendnorthamericaloganpd", ply, ply,"**Police warning**: \n`"..message.."` \n \n`Oficial`: **"..name.." "..sname.."** \n @here")
		for pk,pv in pairs(getElementsByType("player")) do
			if getElementData(pv,"logado") then
				if typ == "normal" then
					exports.an_infobox:addNotification(pv,"<b>Police Warning:</b> "..message.."","normal")
				elseif typ == "perigo" then
					exports.an_infobox:addNotification(pv,"<b>Police Warning:</b> "..message.."","erro")
				elseif typ == "aviso" then
					exports.an_infobox:addNotification(pv,"<b>Police Warning:</b> "..message.."","aviso")
				elseif typ == "info" then
					exports.an_infobox:addNotification(pv,"<b>Police Warning:</b> "..message.."","info")
				end
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
addCommandHandler("preset",
function(ply,cmd,idclot)
    if exports.an_account:hasPermission( ply, 'medic.permission' ) then
        if idclot == "1" then
            if getElementModel(ply) == 0 then
                local texture, model = getClothesByTypeIndex (17,8)
                addPedClothes (ply, texture, model , 17 )
            else
                local plyskin = getElementData(ply,"DefaultSkin")
                if plyskin then
                    setElementModel( ply, plyskin)
                    setTimer(function()
                        local texture, model = getClothesByTypeIndex (17,8)
                        addPedClothes (ply, texture, model , 17 )
                    end,100,1)
                end
            end
        elseif idclot == "2" then
            setElementModel( ply, 276)
        elseif not idclot then
            if getElementModel(ply) == 0 then
                local clotname = getPedClothes(ply,17)
                if clotname then
                    local clotid = getTypeIndexFromClothes(clotname)
                    removePedClothes(ply,clotid)
                    exports.an_clothing:loadplyclothes(ply)
                end
            else
                local plyskin = getElementData(ply,"DefaultSkin")
                if plyskin then
                    setElementModel( ply, plyskin)
                end
            end
        end
    elseif exports.an_account:hasPermission( ply, 'police.permission' ) then
        if idclot == "1" then
            if getElementModel(ply) == 0 then
                local texture, model = getClothesByTypeIndex (17,4)
                addPedClothes (ply, texture, model , 17 )
                local texture, model = getClothesByTypeIndex (13,0)
                addPedClothes (ply, texture, model , 13 )
            else
                local plyskin = getElementData(ply,"DefaultSkin")
                if plyskin then
                    setElementModel( ply, plyskin)
                    setTimer(function()
                        local texture, model = getClothesByTypeIndex (17,4)
                        addPedClothes (ply, texture, model , 17 )
                    end,100,1)
                end
            end
        elseif idclot == "2" then
            setElementModel( ply, 280)
        elseif not idclot then
            if getElementModel(ply) == 0 then
                local clotname = getPedClothes(ply,17)
                if clotname then
                    local clotid = getTypeIndexFromClothes(clotname)
                    removePedClothes(ply,clotid)
                    exports.an_clothing:loadplyclothes(ply)
                end
            else
                local plyskin = getElementData(ply,"DefaultSkin")
                if plyskin then
                    setElementModel( ply, plyskin)
                end
            end
        end
    end
end
)


function onquitsemhandcuff()
    if isElement(hcuff[source]) then
        exports["bone_attach"]:detachElementFromBone(hcuff[source])
        destroyElement(hcuff[source])
        hcuff[source] = {}
    end
end
addEventHandler ("onPlayerQuit", root, onquitsemhandcuff)
--------------------------------------------------------------------------------------------------------------------
-- prender
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("arrest",
function(ply,cmd,time)
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        if time <= '35' then
            local proxlocal = getproxyDepartament(ply,5,1)
            if proxlocal then
                local tagertply = exports.an_player:getproxply(ply,1.5)
                if tagertply then
                    if time and time ~= nil then
                        exports.an_prision:setplyjail(tagertply,time,1)
                        exports.an_infobox:addNotification(ply,"Você colocou a pena de <b>"..time.."</b> serviços comunitários para o <b>"..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."</b>","aviso")
                        triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** determinou a sentença de "..time.." serviços comunitários para o  **"..getElementData ( tagertply, "id" ).." - "..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."**")
                        triggerEvent("sendnorthamericaloganpd", ply, ply,"**"..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."** foi sentenciado em `"..time.."` serviços comunitários")
                    end
                else
                    exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
                end
            else
                exports.an_infobox:addNotification(ply,"Leve o mesmo para o <b>departamento</b>.","erro")
            end
        else
            local proxlocal = getproxyDepartament(ply,5,2)
            if proxlocal then
                local tagertply = exports.an_player:getproxply(ply,1.5)
                if tagertply then
                    if time and time ~= nil then
                        exports.an_prision:setplyjail(tagertply,time,2)
                        exports.an_infobox:addNotification(ply,"Você colocou a pena de <b>"..time.."</b> serviços comunitários para o <b>"..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."</b>","aviso")
                        triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** determinou a sentença de "..time.." serviços comunitários para o  **"..getElementData ( tagertply, "id" ).." - "..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."**")
                        triggerEvent("sendnorthamericaloganpd", ply, ply,"**"..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."** foi sentenciado em `"..time.."` serviços comunitários")
                    end
                else
                    exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
                end
            else
                exports.an_infobox:addNotification(ply,"Leve o mesmo para a <b>prisão</b>.","erro")
            end
        end
    end
end
)

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
--------------------------------------------------------------------------------------------------------------------
-- Polices
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("services",
function(ply,cmd)
    local policeinservice = exports.an_police:getpoliceinservicesv()
    if policeinservice >= 2 then
        anpd = "<b>NAPD</b> está em serviço!"
    else
        anpd = "<b>NAPD</b> não está em serviço!"
    end
    local medicinservice = exports.an_police:getmedicinservicesv()
    if medicinservice >= 1 then
        medic = "<b>AMS</b> está em serviço!"
    else
        medic = "<b>AMS</b> não está em serviço!"
    end
    local mechanic = getmechanicinservicesv()
    if mechanic >= 1 then
        mech = "<b>Gas Monkey</b> está em serviço!"
    else
        mech = "<b>Gas Monkey</b> não está em serviço!"
    end
    exports.an_infobox:addNotification(ply,"<b>Serviços</b><br><br>"..anpd.."<br><br>"..medic.."<br><br>"..mech.."","sucesso",17000)
end
)
--------------------------------------------------------------------------------------------------------------------
-- TOGGLE
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("toggle",
function(ply,cmd)
if cmd then
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        if not getElementData(ply,"policetoggle") then
            setElementData(ply,"policetoggle",true)
            exports.an_infobox:addNotification(ply,"Você entrou em <b>serviço</b>","sucesso")
            local dateandhours = an_getrealTimer()
            triggerEvent("sendnorthamericaloganpdponto", ply, ply,"`"..dateandhours.."` O oficial - **"..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** `iniciou` o seu expediente!")
        elseif getElementData(ply,"policetoggle") then
            setElementData(ply,"policetoggle",nil)
            exports.an_infobox:addNotification(ply,"Você esta fora de <b>serviço</b>","aviso")
            local dateandhours = an_getrealTimer()
            triggerEvent("sendnorthamericaloganpdponto", ply, ply,"`"..dateandhours.."` O oficial - **"..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** `finalizou` o seu expediente!")
        end
    elseif exports.an_account:hasPermission( ply, 'medic.permission' ) then
        if not getElementData(ply,"medictoggle") then
            setElementData(ply,"medictoggle",true)
            exports.an_infobox:addNotification(ply,"Você entrou em <b>serviço</b>","sucesso")
        elseif getElementData(ply,"medictoggle") then
            setElementData(ply,"medictoggle",nil)
            exports.an_infobox:addNotification(ply,"Você esta fora de <b>serviço</b>","aviso")
        end
    elseif exports.an_account:hasPermission( ply, 'mechanic.permission' ) then
        if not getElementData(ply,"mechanictoggle") then
            setElementData(ply,"mechanictoggle",true)
            exports.an_infobox:addNotification(ply,"Você entrou em <b>serviço</b>","sucesso")
        elseif getElementData(ply,"mechanictoggle") then
            setElementData(ply,"mechanictoggle",nil)
            exports.an_infobox:addNotification(ply,"Você esta fora de <b>serviço</b>","aviso")
        end
    end
end
end
)
--------------------------------------------------------------------------------------------------------------------
-- Pay Tow Truck
--------------------------------------------------------------------------------------------------------------------
addCommandHandler("paytow",
function(ply,cmd,id)
    if exports.an_account:hasPermission( ply, 'polpar.permission' ) then
        local tagertply = exports.an_player:getproxply(ply,3)
        if tagertply then
            if exports.an_account:hasPermission( tagertply, 'mechanic.permission' ) then
                if not getElementData(ply,"paytowrecent") then
                    local time = 30
                    local plyid = getElementData(ply,"id")
                    exports.an_inventory:sattitem(tagertply,"Money",700,"mais")
                    dbExec(connection, "INSERT INTO an_paytimes SET plyid = ?,time = ?",plyid,time)
                    setElementData(ply,"paytowrecent",true)
                    exports.an_infobox:addNotification(ply,"Pagamento feito com <b>sucesso</b>","sucesso")
                else
                    exports.an_infobox:addNotification(ply,"Você já fez um pagamento recente","aviso")
                end
            else
                exports.an_infobox:addNotification(ply,"Esta pessoa não é <b>Mecânico(a)</b>","aviso")
            end   
        else
            exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
        end
    end
end
)
--------------------------------------------------------------------------------------------------------------------
-- POLICE OBJECTS
--------------------------------------------------------------------------------------------------------------------
-- 1237 - 1238
cone = nil
addCommandHandler("cone",
function(ply,cmd,n)
    if exports.an_account:hasPermission( ply, 'police.permission' ) then
        if not n then
            local x, y ,z = getElementPosition(ply)
            local rx, ry, rz = getElementRotation(ply)
            setElementPosition(ply, x, y-0.5 ,z)
            cone = createObject( 1237, x, y ,z-0.95 )
            setObjectScale(cone, 1)
            setElementRotation( cone, rx, ry, rz)
            setElementData( cone, 'policeobject', true )
            setElementData( cone, 'policecone', true)
        elseif n == "d" then
            local dis = getproxyobject(ply,2)
            if dis then
                if isElement(dis) then
                    if getElementData(dis,"policecone") then
                        destroyElement(dis)
                    end
                end
            end
        end
    end
end
)

function getproxyobject(ply,distance)
    local x, y, z = getElementPosition (ply) 
	local dist = distance
	local id = false
    local players = getElementsByType("object")
    for i, v in ipairs (players) do 
        if getElementData(v,"policeobject") then
            local pX, pY, pZ = getElementPosition (v)
            if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
                dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
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
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)-1
    end
    return false
end
--------------------------------------------------------------------------------------------------------------------
function chacktimerpaytow()
local prisionArray = dbPoll(dbQuery(connection, "SELECT * FROM an_paytimes"), -1)
if not prisionArray then return end
    for k,v in pairs(prisionArray) do
    time = v["time"]
        if time >= 0 then
            for pk,pv in pairs(getElementsByType("player")) do
                    if getElementData(pv,"id") == v["plyid"] then
                        dbExec(connection, "UPDATE an_paytimes SET time = ? WHERE plyid = ?",math.percent(1,time), getElementData(pv,"id"))
                    end
                end
            end
        end
setTimer(chacktimerpaytow,60000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), chacktimerpaytow)
--------------------------------------------------------------------------------------------------------------------
function chacktimerpaytow2()
    local prisionArray = dbPoll(dbQuery(connection, "SELECT * FROM an_paytimes"), -1)
    if not prisionArray then return end
        for k,v in pairs(prisionArray) do
            time = v["time"]
            if time <= 0 then
                for pk,pv in pairs(getElementsByType("player")) do
                    if getElementData(pv,"id") == v["plyid"] then
                        dbExec(connection, "DELETE FROM an_paytimes WHERE plyid = ?", v["plyid"])
                        setElementData(pv,"paytowrecent",nil)
                    end
                end
            end
        end
setTimer(chacktimerpaytow2,2000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), chacktimerpaytow2)
--------------------------------------------------------------------------------------------------------------------
function loadpaytow(ply)
    local plyid = getElementData(ply,"id")
	local playeQ = dbQuery(connection,"SELECT * FROM an_paytimes WHERE plyid = ?",plyid)
	local playeH,playeHm = dbPoll(playeQ,-1)
	if playeH then
		for k,v in ipairs(playeH) do
            plyid = v["plyid"]
            timep = v["time"]
            if getElementData(ply,"id") == v["plyid"] then
                setElementData(ply,"paytowrecent",true)
			end
		end
    end
end
addEvent ("loadpaytow", true)
addEventHandler ("loadpaytow", root, loadpaytow)
--------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
--------------------------------------------------------------------------------------------------------------------
function getproxyDepartament(ply,distance,typ)
    if typ then
        local x, y, z = getElementPosition (ply) 
        local dist = distance
        local id = false
        local sx,sy,sz = unpack(cfg.localsprision[typ])
        if sx and sy and sz then
            if getDistanceBetweenPoints3D (x, y, z, sx,sy,sz) < dist then
                dist = getDistanceBetweenPoints3D (x, y, z, sx,sy,sz)
                id = true
            end
        end
        if id then
            return id
        else
            return false
        end
    end
end

-- get police
function getpoliceinservicesv()
count = 0
  for i, v in ipairs(getElementsByType("player")) do
    if getElementData(v, "policetoggle") then 
    count = count+1
    end
  end
return count
end
-- get medic
function getmedicinservicesv()
count = 0
  for i, v in ipairs(getElementsByType("player")) do
    if getElementData(v, "medictoggle") then 
    count = count+1
    end
  end
return count
end
-- get mechanic
function getmechanicinservicesv()
count = 0
  for i, v in ipairs(getElementsByType("player")) do
    if getElementData(v, "mechanictoggle") then 
    count = count+1
    end
  end
return count
end

function plyquitdestroypoliceblip()
    if getElementData(source, "policetoggle") then 
        local dateandhours = an_getrealTimer()
        triggerEvent("sendnorthamericaloganpdponto", source, source,"`"..dateandhours.."` O oficial - **"..getElementData ( source, "Nome" ).." "..getElementData ( source, "SNome" ).."** `finalizou` o seu expediente!")
        triggerClientEvent(getRootElement(), "destroyplypolicebliponquit", getRootElement(),source)
    end
end
addEventHandler ("onPlayerQuit", getRootElement(), plyquitdestroypoliceblip)

function an_getrealTimer()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
    local monthday = time.monthday
	local month = time.month
	local year = time.year
	local formattedTime = string.format("%02d/%02d/%04d %02d:%02d:%02d", monthday, month + 1, year + 1900, hours, minutes, seconds)
	return formattedTime
end
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------