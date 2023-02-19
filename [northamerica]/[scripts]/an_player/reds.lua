----------------------------------------------------------------------------------------------------------------
-- VOICE VARIABLES
----------------------------------------------------------------------------------------------------------------
local voiceCols = {}
local broadcoastTo = {}
----------------------------------------------------------------------------------------------------------------
-- VOICE SYSTEM
----------------------------------------------------------------------------------------------------------------
addEventHandler("onPlayerVoiceStart", root,
    function()
        if not getElementData(source,"logado") then return end
        if not getElementData(source,"incall") then
        local voiceSource = source
        setElementData(voiceSource,'falando',true)
        local sx, sy, sz = getElementPosition(voiceSource)
        local r = getElementData(voiceSource, "range") or 10
        voiceCols[voiceSource] = createColSphere(sx, sy, sz, r)
        attachElements(voiceCols[voiceSource], voiceSource)
        broadcoastTo[voiceSource] = getElementsWithinColShape(voiceCols[voiceSource], "player")
        setPlayerVoiceBroadcastTo(voiceSource, broadcoastTo[voiceSource])
        addEventHandler("onColshapeHit", voiceCols[voiceSource],
            function(element)
                if (getElementType(element) == "player") then
                    table.insert(broadcoastTo[voiceSource], element)
                    setPlayerVoiceBroadcastTo(voiceSource, broadcoastTo[voiceSource])
                end
            end
        )
        addEventHandler("onColshapeLeave", voiceCols[voiceSource],
            function(element)
                if (getElementType(element) == "player") then
                    for key, player in pairs(broadcoastTo[voiceSource]) do
                        if (element == player) then
                            table.remove(broadcoastTo[voiceSource], key)
                            break
                        end
                    end
                    setPlayerVoiceBroadcastTo(voiceSource, broadcoastTo[voiceSource])
                end
            end
        )
    end
end
)      

addEventHandler("onPlayerVoiceStop", root,
    function()
        if isElement(voiceCols[source]) then
            destroyElement(voiceCols[source])
        end
        setElementData(source,'falando',nil)
    end
)
----------------------------------------------------------------------------------------------------------------
-- VEHICLE HOOD
----------------------------------------------------------------------------------------------------------------
addCommandHandler("hood",
function(ply,cmd)
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
    if vehicl then
        if getElementData(vehicl, "owner") == plyid or exports.an_account:hasPermission( ply,'mechanic.permission' ) or getElementData(ply,"Admin") then
            if getVehicleDoorOpenRatio (vehicl, 0 ) == 0 then
                setVehicleDoorOpenRatio(vehicl, 0, 1, 1500)
                exports.an_infobox:addNotification(ply,"<b>Capô</b> aberto","info")
            else
                setVehicleDoorOpenRatio(vehicl, 0, 0, 1500)
                exports.an_infobox:addNotification(ply,"<b>Capô</b> fechada","info")
            end
        else 
            exports.an_infobox:addNotification(ply,"O <b>veiculo</b> não pertence a você.","erro")
        end
    end
end
)
----------------------------------------------------------------------------------------------------------------
-- VEHICLE TRUNH
----------------------------------------------------------------------------------------------------------------
addCommandHandler("trunk",
function(ply,cmd)
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
    if vehicl then
        if getElementData(vehicl, "owner") == plyid or getElementData(ply,"Admin") then
            if getElementData(vehicl, "portamalassendousado") == false then
                if getVehicleDoorOpenRatio (vehicl, 1 ) == 1 then
                    setVehicleDoorOpenRatio(vehicl, 1, 0, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta-malas</b> fechada","info")
                end
            else
                exports.an_infobox:addNotification(ply,"<b>Porta-malas</b> em uso","erro")
            end
        else 
            exports.an_infobox:addNotification(ply,"O <b>veiculo</b> não pertence a você.","erro")
        end
    end
end
)
----------------------------------------------------------------------------------------------------------------
-- CHEST TRUNH
----------------------------------------------------------------------------------------------------------------
addCommandHandler("chest",
function(ply,cmd)
    local chest = exports.an_inventory:getproxychest( ply, 4 )
    local pply = exports.an_player:getproxply( ply , 5)
    local plyid = getElementData(ply,"id")
    if chest then
        if not pply then
            if getElementData(chest, "Owner") == plyid then
                if not getElementData( ply, "chest") then
                    setElementData(chest,'inuso',false)
                else
                    exports.an_infobox:addNotification(ply,"Você esta usando o <b>baú</b>.","erro")
                end
            else
                exports.an_infobox:addNotification(ply,"Este <b>baú</b> não pertence a você.","erro")
            end
        else
            exports.an_infobox:addNotification(ply,"Não pode aver <b>pessoas</b> próximas do baú","erro")
        end
    else
        exports.an_infobox:addNotification(ply,"Não tem <b>baú</b> por perto","erro")
    end
end
)
----------------------------------------------------------------------------------------------------------------
-- VEHICLE DOOR
----------------------------------------------------------------------------------------------------------------
addCommandHandler("door",
function(ply,cmd,num)
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
    if vehicl then
        if getElementData(vehicl, "owner") == plyid or getElementData(ply,"Admin") then
            if num == "1" then
                if getVehicleDoorOpenRatio (vehicl, 2 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 2, 1, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> aberta","info")
                else
                    setVehicleDoorOpenRatio(vehicl, 2, 0, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> fechada","info")
                end
            elseif num == "2" then
                if getVehicleDoorOpenRatio (vehicl, 3 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 3, 1, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> aberta","info")
                else
                    setVehicleDoorOpenRatio(vehicl, 3, 0, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> fechada","info")
                end
            elseif num == "3" then
                if getVehicleDoorOpenRatio (vehicl, 4 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 4, 1, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> aberta","info")
                else
                    setVehicleDoorOpenRatio(vehicl, 4, 0, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> fechada","info")
                end
            elseif num == "4" then
                if getVehicleDoorOpenRatio (vehicl, 5 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 5, 1, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> aberta","info")
                else
                    setVehicleDoorOpenRatio(vehicl, 5, 0, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Porta</b> fechada","info")
                end
            end
        else 
            exports.an_infobox:addNotification(ply,"O <b>veiculo</b> não pertence a você.","erro")
        end
    end
end
)

addCommandHandler("doors",
function(ply,cmd)
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
    if vehicl then
        if getElementData(vehicl, "owner") == plyid or getElementData(ply,"Admin") then
                if getVehicleDoorOpenRatio (vehicl, 2 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 2, 1, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Portas</b> abertas","info")
                else
                    setVehicleDoorOpenRatio(vehicl, 2, 0, 1500)
                    exports.an_infobox:addNotification(ply,"<b>Portas</b> fechadas","info")
                end
                if getVehicleDoorOpenRatio (vehicl, 3 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 3, 1, 1500)
                else
                    setVehicleDoorOpenRatio(vehicl, 3, 0, 1500)
                end
                if getVehicleDoorOpenRatio (vehicl, 4 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 4, 1, 1500)
                else
                    setVehicleDoorOpenRatio(vehicl, 4, 0, 1500)
                end
                if getVehicleDoorOpenRatio (vehicl, 5 ) == 0 then
                    setVehicleDoorOpenRatio(vehicl, 5, 1, 1500)
                else
                    setVehicleDoorOpenRatio(vehicl, 5, 0, 1500)
                end
        else 
            exports.an_infobox:addNotification(ply,"O <b>veiculo</b> não pertence a você.","erro")
        end
    end
end
)
----------------------------------------------------------------------------------------------------------------
-- INI- LOCKPICK
----------------------------------------------------------------------------------------------------------------
local dist = 9
local lookAtVehicle = nil
function lockpick1(ply)
if (not isPedInVehicle(ply)) then
    lookAtVehicle = getPedTarget(ply)
    local plyid = getElementData(ply,"id")
    if (lookAtVehicle) and (getElementType(lookAtVehicle) == "vehicle" ) then
        local vx, vy, vz = getElementPosition(lookAtVehicle)
        local px, py, pz = getElementPosition(ply)
        local distplayers = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz);
        if not (distplayers < dist) then return end
        if getElementData(ply,"Lockpick") < 1 then return exports.an_infobox:addNotification(ply,"você não tem <b>lockpick</b>","erro") end
            if math.random(100) >= 50 then
                exports.an_inventory:sattitem(ply,"Lockpick","1","menos")
                exports.an_infobox:addNotification(ply,"A porta do veículo foi arrombada","sucesso")
                setVehicleLocked( lookAtVehicle,false)
                --setElementData(ply,"lockpick",false)
                setElementData(lookAtVehicle,"vehlocked",false)
            else
                exports.an_infobox:addNotification(ply,"Você não conseguiu arrombar a porta","aviso")
               -- setElementData(ply,"lockpick",false)
                if math.random(100) >= 70 then
                    exports.an_infobox:addNotification(ply,"Você <b>quebrou</b> o <b>lockpick</b>","aviso")
                    exports.an_inventory:sattitem(ply,"Lockpick","1","menos")
                end
                if math.random(100) >= 70 then
                    exports.an_infobox:addNotification(ply,"A <b>policia</b> foi acionada","aviso")

                    local plyx,plyy,plyz = getElementPosition(ply)
                    exports.an_emergencycall:createemgblipsv(plyx,plyy,plyz,"<b>Assalto</b> a <b>veiculo</b> iniciado não deixe o bandido fugir!")
                    
                end
            end
        end
    end
end
addEvent("lockpick1",true)
addEventHandler("lockpick1", root, lockpick1)
----------------------------------------------------------------------------------------------------------------
-- SET PLY FERIMENTS
----------------------------------------------------------------------------------------------------------------
function setplyferidoanim(ply,typ)
    if typ == 1 then
        setPedWalkingStyle(ply,123) 
    elseif typ == 2 then
        local plyw = getElementData(ply,"walkstyle")
        if plyw then
            setPedWalkingStyle(ply,plyw) 
        end
    end
end
addEvent("setplyferidoanim",true)
addEventHandler("setplyferidoanim", root, setplyferidoanim)
----------------------------------------------------------------------------------------------------------------
-- KICK PACKET LOSS AND PING
----------------------------------------------------------------------------------------------------------------
function kickplyloss(ply)
    if ply then
        kickPlayer(ply, "Packet loss detected !") 
    end
end
addEvent("kickplyloss",true)
addEventHandler("kickplyloss", root, kickplyloss)

function kickPing()
    for i, player in ipairs(getElementsByType("player")) do
        if (getPlayerPing(player) >= 3000) then
            kickPlayer(player, "Ping over 3000!") 
        end
    end
  setTimer(kickPing,50,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), kickPing)
----------------------------------------------------------------------------------------------------------------
-- SAVE ALL WEAPOM
----------------------------------------------------------------------------------------------------------------
addCommandHandler("sweapons",
function(ply,cmd)
    takeAllWeapons ( ply ) 
    exports.an_infobox:addNotification(ply,"você guardou todas as armas equipadas","info")
end
)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES SCRIPT
----------------------------------------------------------------------------------------------------------------
function funcaosoandar ()
    if not ( getControlState ( source, "walk" ) ) then 
        setControlState ( source, "walk", true )
    end
end
addEvent("funcaosoandar",true)
addEventHandler ( "funcaosoandar", getRootElement(), funcaosoandar ) 

function removeplyitemonwaterhit(ply,itemid,qtd)
    if itemid then
        if qtd then
            local itemdata = exports.an_account:servergetitemtable2(itemid)
            if itemdata then
                if getElementData(ply,itemdata[2]) >= 1 then
                    exports.an_infobox:addNotification(ply,"Você perdeu "..qtd.."x <b>"..itemdata[5].."</b> na água.","aviso")
                    exports.an_inventory:sattitem(ply,itemdata[2],qtd,"menos")
                end
            end
        end
    end
end
addEvent("removeplyitemonwaterhit",true)
addEventHandler ( "removeplyitemonwaterhit", getRootElement(), removeplyitemonwaterhit ) 
----------------------------------------------------------------------------------------------------------------
-- PAY
----------------------------------------------------------------------------------------------------------------
local salarios = {
    {"police.permission",4500,"policetoggle"},
    {"medicdirector.permission",4500,"medictoggle"},
    {"mediccir.permission",4500,"medictoggle"},
    {"mediccli.permission",3200,"medictoggle"},
    {"medicenf.permission",2600,"medictoggle"},
    {"medicpar.permission",2000,"medictoggle"},
    {"medicest.permission",1500,"medictoggle"},
    {"mechanic.permission",3500,"mechanictoggle"},
}

function paymoneyply(ply)
    if getElementData(ply,"user_group") then
        for k,v in ipairs(salarios) do
            if exports.an_account:hasPermission( ply, v[1]) then
                if getElementData(ply, v[3]) then
                    setElementData(ply, "BankMoney", getElementData(ply, "BankMoney") + v[2])
                    exports.an_infobox:addNotification(ply,"Obrigado por colaborar com a cidade <br>o valor de <b>"..v[2].."</b> foi depositado","info")
                end
            end
        end
    end
end
addEvent ("paymoneyply", true)
addEventHandler ("paymoneyply", root, paymoneyply)
----------------------------------------------------------------------------------------------------------------
-- LOG SYSTEM
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
local logcollisions = {}
function debugconsl2 ( ply )
    if not isElement(logcollisions[ply]) then 
        local sx, sy, sz = getElementPosition(ply)
        logcollisions[ply] = createColSphere(sx, sy, sz, 15)
        attachElements(logcollisions[ply], ply)
        setElementData(logcollisions[ply],"colpyid",getElementData(ply,"id"))
    end
end
addEvent("debugconsl2", true)
addEventHandler("debugconsl2", root, debugconsl2)

function debugconsl(id,id2,typ)
    if typ == 1 then
        local rtimer = exports.an_account:an_getrealTimer()
        dbExec(connection, "INSERT INTO playerlog SET playid = ?,playid2 = ?,date = ?",id,id2,rtimer)
    end
end
addEvent("debugconsl", true)
addEventHandler("debugconsl", root, debugconsl)

function quitPlayer()
    if isElement(logcollisions[source]) then 
        destroyElement(logcollisions[source])
    end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )
----------------------------------------------------------------------------------------------------------------
-- COMANDS BLOCKED
----------------------------------------------------------------------------------------------------------------
local blockcomandlist = {
    {"logout"},
    {"register"},
    {"me"},
    {"msg"},
    {"chgmypass"},

}
function cancelAccount(cmd)
    for i, v in ipairs (blockcomandlist) do 
        if cmd == v[1] then
            cancelEvent()
        end
    end
end
addEventHandler("onPlayerCommand", getRootElement(), cancelAccount)
----------------------------------------------------------------------------------------------------------------
-- Group set and dset
----------------------------------------------------------------------------------------------------------------
local thagroups = {
    ["gsfamilyleader"] = {['farmer'] = "gsfamilyfarmer",['membro'] = "gsfamily"},
    ["vagosleader"] = {['farmer'] = "vagosfarmer",['membro'] = "vagos"},
    ["ballasleader"] = {['farmer'] = "ballasfarmer",['membro'] = "ballas"},
    ["aztecasleader"] = {['farmer'] = "aztecasfarmer",['membro'] = "aztecas"},
    ["westcoastchief"] = {['farmer'] = "westcoastschief",['membro'] = "westcoast"},
    ["mafianachief"] = {['farmer'] = "mafianaarms",['membro'] = "mafiana"},
    ["thelostchief"] = {['farmer'] = "thelostdmc",['membro'] = "thelost"},
    ["mechanicchief"] = {['mec'] = "mechanic"},
}

function getgroup(ply)
    local usergroup = getElementData( ply, "user_group")
    for i, v in next, thagroups do
        if i == usergroup then
            return true
        end
    end
end

addCommandHandler("set",
function(ply,cmd,id,grp)
    if id then
        if grp then
            if getgroup(ply) then
                local ply2 = getPlayerID(tonumber(id))
                if ply2 then
                    if ply2 ~= ply then
                        local p2group = getElementData( ply2, "user_group")
                        if p2group == "desempregado" then
                            for i, v in next, thagroups[getElementData( ply, "user_group")] do
                                if grp == i then
                                    print(v)
                                    if p2group ~= v then
                                        exports.an_infobox:addNotification(ply,"O id <b>"..id.."</b> foi setado como <b>"..grp.."</b>","sucesso")
                                        setElementData(ply2,"user_group",v)
                                        dbExec(connection, "UPDATE an_character SET User_group=? WHERE Playerid=?",v,id)
                                    else
                                        exports.an_infobox:addNotification(ply,"O mesmo ja esta neste <b>grupo</b>.","aviso")
                                    end
                                end
                            end
                        else
                            exports.an_infobox:addNotification(ply,"O mesmo ja esta em um <b>grupo</b>.","aviso")
                        end
                    end
                else
                    exports.an_infobox:addNotification(ply,"ID não <b>encontrado</b>.","erro")
                end
            end
        end
    end
end)

addCommandHandler("dset",
function(ply,cmd,id)
    if id then
        local usergroup = getElementData( ply, "user_group")
        for i,v in next,thagroups do
            if i == usergroup then
                local ply2 = getPlayerID(tonumber(id))
                if ply2 then
                    if ply2 ~= ply then
                        local p2group = getElementData( ply2, "user_group")
                        if p2group == v.membro or p2group == v.farmer then
                            local gp = 'desempregado'
                            exports.an_infobox:addNotification(ply,"O id <b>"..id.."</b> foi removido do <b>grupo</b>","sucesso")
                            setElementData(ply2,"user_group",gp)
                            dbExec(connection, "UPDATE an_character SET User_group=? WHERE Playerid=?",gp,id)
                        else
                            exports.an_infobox:addNotification(ply,"O mesmo não esta no seu <b>grupo</b>.","aviso")
                        end
                    end
                else
                    exports.an_infobox:addNotification(ply,"ID não <b>encontrado</b>.","erro")
                end
            end
        end
    end
end)
----------------------------------------------------------------------------------------------------------------
-- ANTI BLUR EFFECT
----------------------------------------------------------------------------------------------------------------
function SetBlurEffect(ply)
    plyblur = getPlayerBlurLevel( ply )
    if plyblur > 0 then
        setPlayerBlurLevel ( ply, 0 )
    end
end

function sincnitroussound(ply, typ)
    local veh = getPedOccupiedVehicle( ply )
    if veh then
        triggerClientEvent(getRootElement(), "startnitroussound", getRootElement(), veh,typ)
    end
end
addEvent("sincnitroussound", true)
addEventHandler("sincnitroussound", root, sincnitroussound)

function sincnitroussound2(veh, typ)
    if veh then
        triggerClientEvent(getRootElement(), "startnitroussound", getRootElement(), veh,typ)
    end
end
addEvent("sincnitroussound2", true)
addEventHandler("sincnitroussound2", root, sincnitroussound2)

addEventHandler("onElementDestroy", getRootElement(), function ()
    if getElementType(source) == "vehicle" then
        triggerClientEvent(getRootElement(), "startnitroussound", getRootElement(), source,'stop') 
    end
end)
----------------------------------------------------------------------------------------------------------------
-- NORTH AMERICA MODULES
----------------------------------------------------------------------------------------------------------------
--- get next player
function getproxply(ply,distance)
    local x, y, z = getElementPosition (ply) 
    local dist = distance
    local id = false
    local players = getElementsByType("player")
    for i, v in ipairs (players) do 
        if ply ~= v then
            local pX, pY, pZ = getElementPosition (v) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
                dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
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
--- get next vehicle
function getproxveh(ply,distance)
    local x, y, z = getElementPosition (ply) 
    local dist = distance
    local id = false
    local players = getElementsByType("vehicle")
    for i, v in ipairs (players) do 
        if ply ~= v then
            local pX, pY, pZ = getElementPosition (v) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ) < dist then
                dist = getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)
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

function changeBlurLevel()
    setPlayerBlurLevel ( source, 0 )
end
addEventHandler ( "onPlayerJoin", getRootElement(), changeBlurLevel )
 
function removebluronstrt()
    setPlayerBlurLevel ( getRootElement(), 0)
end
addEventHandler ("onResourceStart",getResourceRootElement(getThisResource()),removebluronstrt)

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
-----------------------------------------------------------------------------------------------------------------------------------
-- REMOVE NAME TAG
-----------------------------------------------------------------------------------------------------------------------------------
function onResourceStart ( ) 
    local players = getElementsByType ( "player" ) 
    for key, player in ipairs ( players ) do  
        setPlayerNametagShowing ( player, false ) 
    end 
end 
addEventHandler ( "onResourceStart", resourceRoot, onResourceStart ) 
function onPlayerJoin ( ) 
    setPlayerNametagShowing ( source, false ) 
end 
addEventHandler ( "onPlayerJoin", root, onPlayerJoin ) 
-----------------------------------------------------------------------------------------------------------------------------------
-- ENTER AND EXIT - VEHICLE LOG
-----------------------------------------------------------------------------------------------------------------------------------
function logOnVehicleEnter ( ply, seat, jacked )
    if getElementData ( source, "owner" ) ~= getElementData ( ply, "id" ) then
        if getElementData ( source, "Nome" ) and getElementData ( source, "Snome" ) then
            local model = getElementData ( source, "Model" )
            local data = exports.an_vehicles:getVehicleData(model)
            if data then
                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** entrou no veículo `"..data.name.."` do **"..getElementData ( source, "owner" ).." - "..getElementData ( source, "Nome" ).." "..getElementData ( source, "Snome" ).."**")
            end
        end
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), logOnVehicleEnter )
function logOnVehicleExit ( ply, seat, jacked )
    if getElementData ( source, "owner" ) ~= getElementData ( ply, "id" ) then
        if getElementData ( source, "Nome" ) and getElementData ( source, "Snome" ) then
            local model = getElementData ( source, "Model" )
            local data = exports.an_vehicles:getVehicleData(model)
            if data then
                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** saiu do veículo `"..data.name.."` do **"..getElementData ( source, "owner" ).." - "..getElementData ( source, "Nome" ).." "..getElementData ( source, "Snome" ).."**")
            end
        end
    end
end
addEventHandler ( "onVehicleExit", getRootElement(), logOnVehicleExit )


-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------