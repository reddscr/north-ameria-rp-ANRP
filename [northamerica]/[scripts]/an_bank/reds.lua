-------------------------------------------------------------------------------------------------------
-- CONNECT
-------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
-------------------------------------------------------------------------------------------------------
-- DEPOSIT
-------------------------------------------------------------------------------------------------------
function bankdeposit(ply,val)
    if val then
        if tonumber(getElementData(ply,"Money")) >= val then
            local plyid = getElementData(ply,"id")
            if plyid then
                exports.an_inventory:sattitem(ply,"Money",val,"menos")
                local plybankmoney = getElementData(ply,"BankMoney") + val
                setElementData(ply,"BankMoney", plybankmoney)
                local updatetheaccountonquit4 = dbExec(connection, "UPDATE an_character SET Bank=? WHERE Playerid =?",plybankmoney,plyid)
                triggerClientEvent( ply,"msgbank", ply,"<b>Depósito</b> de $ <b>"..val.."</b> efetuado com sucesso!","sucesso")
                triggerClientEvent( ply,"requestbankinfos", ply)
                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData(ply,"id").." - "..getElementData(ply,"Nome").." "..getElementData(ply,"SNome").."** depositou $**"..val.."**")
            end
        else
            triggerClientEvent( ply,"msgbank", ply,"Erro ao fazer <b>depósito</b>, você não possui $ <b>"..val.."</b> em mãos.","erro")
            triggerClientEvent( ply,"requestbankinfos", ply)
        end
    end
end
addEvent ("bankdeposit", true)
addEventHandler ("bankdeposit", root, bankdeposit)
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function bankwithdraw(ply,val)
    if val then
        if tonumber(getElementData(ply,"BankMoney")) >= val then
            local plyid = getElementData(ply,"id")
            if plyid then
                local plybankmoney = getElementData(ply,"BankMoney") - val
                setElementData(ply,"BankMoney", plybankmoney)
                exports.an_inventory:sattitem(ply,"Money",val,"mais")
                local updatetheaccountonquit4 = dbExec(connection, "UPDATE an_character SET Bank=? WHERE Playerid =?",plybankmoney,plyid)
                triggerClientEvent( ply,"msgbank", ply,"<b>Saque</b> de $ <b>"..val.."</b> efetuado com sucesso!","sucesso")
                triggerClientEvent( ply,"requestbankinfos", ply)
                triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData(ply,"id").." - "..getElementData(ply,"Nome").." "..getElementData(ply,"SNome").."** sacou $**"..val.."**")
            end
        else
            triggerClientEvent( ply,"msgbank", ply,"Erro ao fazer <b>saque</b>, você não possui $ <b>"..val.."</b> no banco.","erro")
            triggerClientEvent( ply,"requestbankinfos", ply)
        end
    end
end
addEvent ("bankwithdraw", true)
addEventHandler ("bankwithdraw", root, bankwithdraw)
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function banktransfer(ply,val,tid)
    if val then
        if tid then
            local ply2 = getPlayerID(tid)
            if ply2 then
                if ply2 ~= ply then
                    if tonumber(getElementData(ply,"BankMoney")) >= val then
                        local plyid = getElementData(ply,"id")
                        local plyid2 = getElementData(ply2,"id")
                        if plyid and plyid2 then
                            local plybankmoney = getElementData(ply,"BankMoney") - val
                            setElementData(ply,"BankMoney", plybankmoney)
                            local updatebankaccount = dbExec(connection, "UPDATE an_character SET Bank=? WHERE Playerid =?",plybankmoney,plyid)
                            local plybankmoney2 = getElementData(ply2,"BankMoney") + val
                            setElementData(ply2,"BankMoney", plybankmoney2)
                            exports.an_infobox:addNotification(ply2,"Você recebeu $ <b>"..val.."</b> de <b>"..getElementData(ply,"Nome").." "..getElementData(ply,"SNome").."</b> na sua conta bancaria","sucesso",12000)
                            local updatebankaccount2 = dbExec(connection, "UPDATE an_character SET Bank=? WHERE Playerid =?",plybankmoney2,plyid2)
                            triggerClientEvent( ply,"msgbank", ply,"<b>Transferência</b> de $ <b>"..val.."</b> efetuada com sucesso!","sucesso")
                            triggerClientEvent( ply,"requestbankinfos", ply)
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData(ply,"id").." - "..getElementData(ply,"Nome").." "..getElementData(ply,"SNome").."** enviou $**"..val.."** para a conta do **"..getElementData(ply2,"id").." - "..getElementData(ply2,"Nome").." "..getElementData(ply2,"SNome").."**")
                        end
                    else
                        triggerClientEvent( ply,"msgbank", ply,"Erro ao fazer <b>transferência</b>, você não possui $ <b>"..val.."</b> no banco.","erro")
                        triggerClientEvent( ply,"requestbankinfos", ply)
                    end
                else
                    triggerClientEvent( ply,"msgbank", ply,"Erro ao fazer <b>transferência</b>","erro")
                    triggerClientEvent( ply,"requestbankinfos", ply)
                end
            else
                triggerClientEvent( ply,"msgbank", ply,"Erro ao fazer <b>transferência</b>","erro")
                triggerClientEvent( ply,"requestbankinfos", ply)
            end
        end
    end
end
addEvent ("banktransfer", true)
addEventHandler ("banktransfer", root, banktransfer)
------------------------------------------------------------------------------------------------------------------------------
-- New robb machine
------------------------------------------------------------------------------------------------------------------------------
local machineTimer = 10
local machineGlobal = 0
local machineStart = false
local machineBlips = {}
local themachineTimer = nil

function startbanktheft(ply,bankid)
    if bankid then
        local getcaixadata = bankid
        local atmsq = dbQuery(connection,"SELECT * FROM an_atmrobb")
        local atmsh,atmz = dbPoll(atmsq,-1)
        if atmsh then
            for k,v in ipairs(atmsh) do
                id = v["id"]
                if id == getcaixadata then return exports.an_infobox:addNotification(ply,"Este <b>caixa</b> não se recuperou do ultimo <b>roubo</b>","aviso")  end
            end
            local policeinservice = exports.an_police:getpoliceinservicesv()
            if policeinservice >= 2 then
                    if machineGlobal <= 0 then
                        local plyx,plyy,plyz = getElementPosition(ply)
                        exports.an_inventory:sattitem(ply,"Dynamit","1","menos")
                        local plyid = getElementData(ply,"id")
                        machineStart = true
                        machineGlobal = 600
                        triggerClientEvent(ply, "startstealmachine", ply,machineTimer)
                        local getfreeidcx = getFreeid()
                        local currentTime = getRealTime().timestamp
                        local timeToPlace = currentTime + 60*60
                        setPedAnimation(ply, "rob_bank", "cat_safe_rob", true, false, false)
                        setElementData(ply,"emacao",true)
                        dbExec(connection, "INSERT INTO an_atmrobb SET id = ?,plyid = ?,atmdate = ?",getcaixadata,plyid,timeToPlace)
                        toggleAllControls ( ply, false )
                        themachineTimer = setTimer(function()
                            local pos = toJSON({plyx,plyy,plyz})
                            exports.an_wanted:setplywanted(ply,20)
                            exports.an_emergencycall:createemgblipsv(plyid,plyx,plyy,plyz,"O sistema do <b>caixa eletronico</b> foi invadido, vá até o local e verifique.")
                            local object = createObject(1654, plyx,plyy,plyz-0.9, 0, 90, 180)
                            setElementCollisionsEnabled(object, false)
                            machineStart = false
                            toggleAllControls ( ply, true )
                            setPedAnimation( ply, nil )
                            setElementData(ply,"emacao",false)
                            startBombTimer(ply,pos,object)
                            exports.an_infobox:addNotification(ply,"Bomba <b>plantada</b>, saia de perto!!!","info")
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** `Está roubando o caixa eletronico`!")
                        end,machineTimer*1000,1)
                else
                    exports.an_infobox:addNotification(ply,"Aguarde <b>"..machineGlobal.."</b> segundos para roubar o caixa.","aviso")
                end
            else
                exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>policiais</b> no momento","aviso")
            end
        end
    end
end
addEvent ("startbanktheft", true)
addEventHandler ("startbanktheft", root, startbanktheft)
------------------------------------------------------------------------------------------------------------------------------
-- Start bomb timer
------------------------------------------------------------------------------------------------------------------------------
local sortitem = {
    'Copper',
    'Steel',
    'Plastic',
    'Iron',
    'Circuit',
}
function startBombTimer(ply,pos,obj)
    if ply then
        setTimer(function()
            local dt = fromJSON(pos)
            exports.an_sounds:setalarmsound(pos,machineTimer+80)
            createExplosion ( dt[1], dt[2], dt[3], 0 )
            destroyElement(obj)
            triggerEvent("drop2", ply, ply, pos, 'Money', math.random(4000,9000))
            triggerEvent("drop2", ply, ply, pos, sortitem[math.random(#sortitem)], math.random(3,10))
        end,1000*40,1)
    end
end
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
function stopmachine(ply)
    if isTimer(themachineTimer) then killTimer(themachineTimer) end
    machineStart = false
    toggleAllControls ( ply, true )
    setPedAnimation( ply, nil )
    setElementData(ply,"emacao",false)
    exports.an_infobox:addNotification(ply,"O <b>roubo</b> foi cancelado!","aviso")
end
addEvent ("stopmachine", true)
addEventHandler ("stopmachine", root, stopmachine)
------------------------------------------------------------------------------------------------------------------------------
function machineglobaltimer()
    if machineGlobal > 0 then
        machineGlobal = machineGlobal - 1
        if machineGlobal <= 0 and machineStart then
            machineStart = false
        end
    end
setTimer(machineglobaltimer,1000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), machineglobaltimer)
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end
-------------------------------------------------------------------------------------------------------
--  COWDOWN ATM
-------------------------------------------------------------------------------------------------------
function checkatmtimer()
local marketArray = dbPoll(dbQuery(connection, "SELECT * FROM an_atmrobb"), -1)
if not marketArray then return end
local currentTime = getRealTime().timestamp
    for k,v in pairs(marketArray) do
        id = v["id"]
        if v["atmdate"] <= currentTime then
            dbExec(connection, "DELETE FROM an_atmrobb WHERE id = ?", v["id"])
        end
    end
setTimer(checkatmtimer,1000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), checkatmtimer)
-------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-------------------------------------------------------------------------------------------------------
function getFreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_atmrobb ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
-------------------------------------------------------------------------------------------------------
-- VARIABLES
-------------------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------