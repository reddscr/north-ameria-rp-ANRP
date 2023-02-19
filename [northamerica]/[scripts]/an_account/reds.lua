----------------------------------------------------------------------------------------------------------------
-- CONNECTION
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
----------------------------------------------------------------------------------------------------------------
-- ID GERATOR
----------------------------------------------------------------------------------------------------------------
function countIDs()
    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_contas"), -1)
    newid = false
    for i, id in pairs (result) do
        if id["id"] ~= i then
            newid = i
            break
        end
    end
    if newid then return newid else return #result + 1 end
end

function countIDs2()
    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_character"), -1)
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
-- ID COUNT
----------------------------------------------------------------------------------------------------------------
function countitemIDs()
    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_useritem"), -1)
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
-- ACCOUNT GERATOR
----------------------------------------------------------------------------------------------------------------
addEventHandler("onPlayerConnect",getRootElement(),
function(playerNick,playerIP,playerUsername,playerSerial)
    local charQuery = dbPoll(dbQuery(connection, "SELECT * FROM an_contas"), -1)
    for _, row in ipairs(charQuery) do
        if string.lower(playerSerial) == string.lower(row["serial"]) then
            return
        end
    end
    local charInsert = dbExec(connection, "INSERT INTO an_contas SET id = ?,serial = ?,ip = ?,ban = ?,whitelisted = ?", countIDs(),playerSerial,playerIP,0,0)
end)
----------------------------------------------------------------------------------------------------------------
-- WHITELIST AND BAN SYST 
----------------------------------------------------------------------------------------------------------------
addEventHandler("onPlayerConnect",getRootElement(),
function(playerNick,playerIP,playerUsername,playerSerial)
    local sql2 = dbQuery(connection, "SELECT * FROM an_contas WHERE serial='" .. playerSerial .. "' LIMIT 1")
    local result = dbPoll(sql2, -1)
    if result then
        for _, row in ipairs(result) do 
            charwl = row["whitelisted"]
            charban = row["ban"]
            if charban == 0 then            
                if charwl <= 0 then
                    local sql = dbQuery(connection, "SELECT * FROM an_contas WHERE serial='" .. playerSerial .. "' LIMIT 1")
                    local result = dbPoll(sql, -1)
                    if result then
                        for _, row in ipairs(result) do
                            charid = row["id"]
                            cancelEvent(true,"O seu passaporte é ( "..charid.." )")
                        end
                    end
                end
            else
                local sql = dbQuery(connection, "SELECT * FROM an_contas WHERE serial='" .. playerSerial .. "' LIMIT 1")
                local result = dbPoll(sql, -1)
                if result then
                    for _, row in ipairs(result) do
                        charid = row["id"]
                        cancelEvent(true,"O seu passaporte ( "..charid.." ) está banido")
                    end
                end
            end     
        end
    end
end)
----------------------------------------------------------------------------------------------------------------
-- CHECK BANNED'S
----------------------------------------------------------------------------------------------------------------
function checkbanned()
for pk,pv in pairs(getElementsByType("player")) do
    local theSerial = getPlayerSerial( pv )
    local sql = dbQuery(connection, "SELECT * FROM an_contas WHERE serial='"..theSerial.."' LIMIT 1")
    local result = dbPoll(sql, -1)
    if result then
        for _, row in ipairs(result) do
            charid = row["id"]
            charban = row["ban"]
            if charban >= 1 then
                kickPlayer ( pv, "servidor", "O seu passaporte ( "..charid.." ) foi banido" )
            end
        end
    end
end
setTimer(checkbanned,1000,1)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), checkbanned)
----------------------------------------------------------------------------------------------------------------
-- SPAWN MODULE
----------------------------------------------------------------------------------------------------------------
function spawnplayer(ply)
    local theSerial = getPlayerSerial( ply )
    local accountplyQ = dbQuery(connection,"SELECT * FROM an_contas WHERE serial=?",theSerial)
    local accountplyH,vehszam = dbPoll(accountplyQ,-1)
    if accountplyH then
        for k,v in ipairs(accountplyH) do
            id = v["id"]
            tAdming = v["Admin"]
            user = v["username"]
            pass = v["password"]
            if user ~= '' or nil and pass ~= '' or nil then
                setElementData(ply, 'id', id)
                local accountplyQ = dbQuery(connection,"SELECT * FROM an_character WHERE Playerid=?",id)
                local accountplyH,vehszam = dbPoll(accountplyQ,-1)
                if accountplyH then
                    for k,v in ipairs(accountplyH) do
                        pid = v["Playerid"]
                        name = v["Name"]
                        sname = v["SName"]
                        Age = v["Age"]
                        Group = v["User_group"]
                        DefaultSkin = v["Skin"]
                        Skin = v["TSkin"]
                        Walkstyle = v["Walkstyle"]
                        Phone = v["Phone"]
                        Bank = v["Bank"]
                        MocStats = v["MocStats"]
                        Food = v["Food"]
                        Weather = v["Weather"]
                        Health = v["Health"]
                        Armor = v["Armor"]
                        pos = fromJSON(v["Position"])
                        if Skin then
                            spawnPlayer(ply, 1088.102, 1072.252, 10.836, 326.648, Skin, 0, 100+id)
                            setElementInterior(ply, 0)
                            setElementData(ply, 'Nome', name)
                            setElementData(ply, 'SNome', sname)
                            setElementData(ply, 'Age', Age)
                            setElementData(ply, 'user_group', Group)
                            setElementData(ply, 'DefaultSkin', DefaultSkin)
                            setElementData(ply, "Skin", skin)
                            setElementData(ply, 'walkstyle', Walkstyle)
                            setElementData(ply, 'phonenumber', Phone)
                            setElementData(ply, 'BankMoney', Bank)
                            setElementData(ply, 'MocMSlot', MocStats)
                            setElementData(ply, 'foodstats', Food)
                            setElementData(ply, 'watherstats', Weather)
                            setElementData(ply, 'Health', Health)
                            setElementData(ply, 'Armor', Armor)
                            setElementData(ply, 'Position', pos)
                            setElementData(ply, "range", 10) 
                            setElementHealth(ply, Health)
                            setPedArmor(ply, Armor)
                            if id == 1 then
                                setElementData(ply,"Admin",true)
                            end
                            if tAdming then
                                if tAdming >= 1 then
                                    setElementData(ply,"Admin",true)
                                end
                            end
                            for i,v in ipairs (cfg.items) do
                                setElementData(ply,v[2],0)
                                setElementData(ply,"MocSlot",0)
                            end
                            loadplyaccountonstart(ply)
                            exports.an_clothing:loadplyclothes(ply)
                            triggerClientEvent( ply,"setNUiCharacterstat", ply)
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** entrou da cidade!")
                            exports.an_rentalgarage:resettimerdeletevehrental(getElementData ( ply, "id" ))
                            exports.an_vehicles:resettimerdeleteveh(getElementData ( ply, "id" ))
                        end
                    end 
                end
            else
                spawnPlayer(ply, 1088.102, 1072.252, 10.836, 326.648, Skin, 0, 100+id)
                setElementInterior(ply, 0)
                exports.an_clothing:loadplyclothes(ply)
                setElementData(ply, 'Nome', nil)
                setElementData(ply, 'SNome', nil)
                setElementData(ply, "user_group", 'desempregado')
                triggerClientEvent( ply,"setNUiCharacterstat", ply)
            end
        end
    end
end
addEvent("spawnplayer",true)
addEventHandler("spawnplayer", root, spawnplayer)
----------------------------------------------------------------------------------------------------------------
-- LOAD ACCOUNT ON JOIN
----------------------------------------------------------------------------------------------------------------
function loadaccount(ply)
    local pid = getElementData(ply, 'id')
    if pid then
        local pos = getElementData(ply,'Position')
        setElementPosition(ply, pos[1], pos[2], pos[3])
        setElementRotation(ply, pos[4], pos[5], pos[6])
        setElementInterior(ply, pos[7])
        setElementDimension(ply, pos[8])
        exports.an_vehicles:updatevehicle(ply)
        exports.an_wanted:loadwanted(ply)
        exports.an_prision:loadjailed(ply)
        exports.an_vips:loadvip(ply)
        exports.an_player:SetBlurEffect(ply)
        triggerClientEvent( ply, "GtavCamEffect", ply)
    end
end
addEvent("loadaccount",true)
addEventHandler("loadaccount", root, loadaccount)
----------------------------------------------------------------------------------------------------------------
-- LOAD ITEM ACCOUNT
----------------------------------------------------------------------------------------------------------------
function loadplyaccountonstart(ply)
    if ply then
        plyid = getElementData(ply,"id")
        if plyid then
            local row = dbQuery(connection,"SELECT * FROM an_useritem WHERE item_owner=?",plyid)
            local irow,vrow = dbPoll(row,-1)
            if irow then
                for k,v in ipairs(irow) do
                itemid = v["item_id"]
                itemcount = v["item_count"]
                    for i2,v2 in ipairs (cfg.items) do
                        if itemid == v2[1] then
                            setElementData(ply,v2[2],itemcount)
                            setElementData(ply,"MocSlot",getElementData(ply,"MocSlot") + v2[4]*itemcount )
                        end
                    end
                end
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------------
-- ADD ITEM
----------------------------------------------------------------------------------------------------------------
function addplyitem(ply,item,qtd)
    local plyid = getElementData(ply,"id")
    local geraitemid = countitemIDs()
    if item and qtd and plyid then
        dbExec(connection, "INSERT INTO an_useritem SET id = ?,item_owner=?,item_id = ?,item_count = ?",geraitemid,plyid,item,qtd)
    end
end
addEvent("addplyitem",true)
addEventHandler("addplyitem", root, addplyitem)
----------------------------------------------------------------------------------------------------------------
-- ATT ITEM
----------------------------------------------------------------------------------------------------------------
function attplyitem(ply,item,qtd)
    local plyid = getElementData(ply,"id")
    if plyid then
        local row = dbQuery(connection,"SELECT * FROM an_useritem WHERE item_owner=?",plyid)
        local irow,vrow = dbPoll(row,-1)
        if irow then
            for k,v in ipairs(irow) do
                itemid = v["item_id"]
                itemcount = v["item_count"]
                if item == itemid then
                    dbExec(connection, "UPDATE an_useritem SET item_count = ? WHERE item_id = ? AND item_owner = ?", qtd, item, plyid)
                end
            end
        end
    end
end
addEvent("attplyitem",true)
addEventHandler("attplyitem", root, attplyitem)
----------------------------------------------------------------------------------------------------------------
-- REMOVE ITEM
----------------------------------------------------------------------------------------------------------------
function remplyitem(ply,item,qtd)
    local plyid = getElementData(ply,"id")
    if plyid then
        local row = dbQuery(connection,"SELECT * FROM an_useritem WHERE item_owner=?",plyid)
        local irow,vrow = dbPoll(row,-1)
        if irow then
            for k,v in ipairs(irow) do
                itemid = v["item_id"]
                itemcount = v["item_count"]
                if item == itemid then
                    dbExec(connection, "DELETE FROM an_useritem WHERE item_id = ? AND item_owner=?",itemid,plyid)
                end
            end
        end
    end
end
addEvent("remplyitem",true)
addEventHandler("remplyitem", root, remplyitem)
----------------------------------------------------------------------------------------------------------------
-- SET PLAYER STATS ON NEW ACCOUNT
----------------------------------------------------------------------------------------------------------------
function DeleteAccount(ply)
    local plyid = getElementData(ply, 'id')
    if plyid then
        triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** `apagou` a conta!")
        setElementData(ply, "Nome", nil)
        setElementData(ply, "SNome", nil)
        local db = dbQuery(connection,"SELECT * FROM an_vehicle WHERE Account = ?", plyid)
        local dbh,_ = dbPoll(db,-1)
        if dbh then
            for k,v in ipairs(dbh) do
                id = v["id"]
                owne = v["Account"]
                if id then
                    dbExec(connection, "DELETE FROM an_vehicle WHERE id = ?", id)
                    exports.an_inventory:destroyVehicleData(id)
                    local vehicl = findVeh(id)
                    if vehicl then
                        destroyElement(vehicl)
                    end
                    local playerID = tonumber(owne)
                    if(playerID) then
                        local Player2 = getPlayerID(playerID)
                        if(Player2) then
                            exports.an_vehicles:updatevehicle(Player2)
                        end 
                    end
                end
            end
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_houseobjects WHERE Owner = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['id']
                objid = v['ObjID']
                if id then
                    dbExec(connection, "DELETE FROM an_houseobjects WHERE id = ?", id)
                    if objid == 1741 then
                        dbExec(connection, "DELETE FROM an_chests WHERE id = ? AND owner = ?",id, plyid)
                        exports.an_inventory:destroyChestidData(id)
                    end
                end
            end
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_clothing WHERE plyid = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['plyid']
                if id then
                    dbExec(connection, "DELETE FROM an_clothing WHERE plyid = ?", id)
                end
            end
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_houses WHERE id_owner = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['id']
                if id then
                    dbExec(connection, "UPDATE an_houses SET id_owner = ? WHERE id = ?", 0, id)
                end
            end
        end
        for i,v in ipairs (cfg.items) do
            local itm = getElementData(ply,v[2])
            exports.an_inventory:sattitem2(ply, v[2], itm, "menos")
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_vips WHERE plyid = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['plyid']
                if id then
                    dbExec(connection, "DELETE FROM an_vips WHERE plyid = ?", id)
                end
            end
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_phonecontacts WHERE Owner = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['Owner']
                if id then
                    dbExec(connection, "DELETE FROM an_phonecontacts WHERE Owner = ?", id)
                end
            end
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_character WHERE Playerid = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['Playerid']
                if id then
                    dbExec(connection, "DELETE FROM an_character WHERE Playerid = ?", id)
                end
            end
        end
        local db2 = dbQuery(connection,"SELECT * FROM an_clothing WHERE plyid = ?", plyid)
        local dbh2,_ = dbPoll(db2,-1)
        if dbh2 then
            for k,v in ipairs(dbh2) do
                id = v['plyid']
                if id then
                    dbExec(connection, "DELETE FROM an_character WHERE plyid = ?", id)
                end
            end
        end
        dbExec(connection, "UPDATE an_contas SET username = ?,password = ? WHERE id =?",nil,nil, plyid)
        triggerClientEvent( ply,"loadedAccount", ply)
    end
end
addEvent("DeleteAccount",true)
addEventHandler("DeleteAccount", root, DeleteAccount)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function setstatplayer(ply,daccount,pass,skin,name,sname,age)
    if ply then
        if daccount then
            if skin then
                for i2,v2 in ipairs (cfg.items) do
                    setElementData(ply,v2[2],0)
                    setElementData(ply,"MocSlot",0)
                end
                local theSerial = getPlayerSerial( ply )
                local accountplyQ = dbQuery(connection,"SELECT * FROM an_contas WHERE serial=?",theSerial)
                local accountplyH,vehszam = dbPoll(accountplyQ,-1)
                if accountplyH then
                    for k,v in ipairs(accountplyH) do
                        id = v["id"]
                        tAdming = v["Admin"]
                        if id then
                            local fid = countIDs2()
                            local generatephonenumber = generatePhoneNumber()
                            spawnPlayer(ply, 1688.373, 1454.408, 10.768+1.5, 160, skin, 0, 0)
                            dbExec(connection, "UPDATE an_contas SET username = ?,password = ? WHERE id =?",daccount,pass,id)
                            local geraitemid = countitemIDs()
                            local x, y, z = getElementPosition(ply)
                            local rx,ry,rz = getElementRotation(ply)
                            local dim = getElementDimension(ply)
                            local int = getElementInterior(ply)
                            local Pos = toJSON({x, y, z,rx,ry,rz,dim,int})
                            local MocStats = "5"
                            dbExec(connection, "INSERT INTO an_character SET id=?, Playerid=?,Name=?,SName=?,Age=?,User_group=?,Skin=?,TSkin=?,Walkstyle=?,Phone=?,Bank=?,MocStats=?,Food=?,Weather=?,Health=?,Armor=?,Position=?", fid, id, name, sname, age, "desempregado", skin, 0, 0, generatephonenumber, 3000, MocStats, 100, 100, 100, 0, Pos)
                            dbExec(connection, "INSERT INTO an_useritem SET id=?,item_owner=?,item_id=?,item_count=?",geraitemid,id,1,2000)
                            if id == 1 then
                                setElementData(ply,"Admin",true)
                            end
                            if tAdming then
                                if tAdming >= 1 then
                                    setElementData(ply,"Admin",true)
                                end
                            end
                            setElementData(ply, "user_group", 'desempregado')
                            setElementData(ply, "phonenumber", generatephonenumber)
                            setElementData(ply, "id", id)
                            setElementData(ply, "Nome", name)
                            setElementData(ply, "SNome", sname)
                            setElementData(ply, "Age", age)
                            setPedWalkingStyle(ply, 0) 
                            setElementData(ply, "walkstyle", 0)
                            setElementData(ply, 'DefaultSkin', skin)
                            setElementData(ply, "Skin", skin)
                            setElementData(ply, "MocSlot", 0)
                            setElementData(ply, "MocMSlot", MocStats)
                            setElementData(ply, "foodstats", 100)
                            setElementData(ply, "watherstats", 100)
                            setElementHealth(ply, 100)
                            setPedArmor(ply,0)
                            setElementData(ply, "Money", 2000)
                            setElementData(ply, "BankMoney", 3000)
                            setElementData(ply, "range", 10) 
                            setTimer (setElementHealth, 500, 1, ply, 100)
                            setTimer (setPedArmor, 500, 1, ply, 0)
                            exports.an_vehicles:updatevehicle(ply)
                            triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** criou uma conta e entrou na cidade!")
                            triggerClientEvent( ply, "GtavCamEffect", ply)
                            exports.an_infobox:addNotification(ply,"Seja bem-vindo ao <b>North America RP</b><br><br>User a tecla <b>F9</b> para abrir o painel de comandos.<br><br>Caso ainda reste alguma dúvida, chame um <br><b>admin</b> no <b>discord</b> do servidor<br><br><b>Divirta-se<b>","info")
                        end
                    end
                end
            end
        end
    end
end
addEvent("setstatplayer",true)
addEventHandler("setstatplayer", root, setstatplayer)
----------------------------------------------------------------------------------------------------------------
-- SAVE ON QUIT
----------------------------------------------------------------------------------------------------------------
function setstatplayerOnQuit(quitType)
    if getElementData(source, 'logado') then
        local theid = getElementData(source,"id")
        local accountplyQ = dbQuery(connection,"SELECT * FROM an_contas WHERE id=?",theid)
        local accountplyH,vehszam = dbPoll(accountplyQ,-1)
        if accountplyH then
            for k,v in ipairs(accountplyH) do
                id = v["id"]
                if id then
                    local plyskinid = getElementModel ( source )
                    local foodstats = getElementData(source,"foodstats")
                    local watherstats = getElementData(source,"watherstats")
                    local plyhealt = getElementHealth(source)
                    local plyarmor = getPedArmor(source)
                    local mocmslot = getElementData(source,"MocMSlot") or 5
                    local BankMoney = getElementData(source,"BankMoney")
                    local wstyle = getPedWalkingStyle(source)
                    local x, y, z = getElementPosition(source)
                    local rx,ry,rz = getElementRotation(source)
                    local dim = getElementDimension(source)
                    local int = getElementInterior(source)
                    local Pos = toJSON({x, y, z,rx,ry,rz,dim,int})
                    if getElementData(source,"Admin") == true then
                        local updatetheaccountonquit2 = dbExec(connection, "UPDATE an_contas SET Admin=? WHERE id =?",1,id)
                    end
                    local emp = getElementData(source,"user_group") or "desempregado"
                    local updatetheaccountonquit4 = dbExec(connection, "UPDATE an_character SET Position=?,User_group=?,Bank=?,MocStats=?,Health=?,Armor=?,Food=?,Weather=?,TSkin=?,Walkstyle=? WHERE Playerid =?",Pos,emp,BankMoney,mocmslot,plyhealt,plyarmor,foodstats,watherstats,plyskinid,wstyle,id)
                    triggerEvent("sendnorthamericalog", source, source,"**"..getElementData ( source, "id" ).." - "..getElementData ( source, "Nome" ).." "..getElementData ( source, "SNome" ).."** saiu da cidade! `"..quitType.."`")
                end
            end
            for iitemp,vitemp in ipairs (cfg.items) do
                local getplydata = getElementData(source, vitemp[2]) or 0
                if getplydata >= 1 then
                    local updatetheaccountonquit5 = dbExec(connection, "UPDATE an_useritem SET item_count=? WHERE item_id=? and item_owner=?",getplydata,vitemp[1],theid)
                end
            end
        end
    end
end
addEventHandler ("onPlayerQuit", getRootElement(), setstatplayerOnQuit)
----------------------------------------------------------------------------------------------------------------
-- GROUP ATT
----------------------------------------------------------------------------------------------------------------
function attnnewgroupplayer()
for pk,pv in pairs(getElementsByType("player")) do
    if getElementData(pv, 'logado') then
        local theid = getElementData(pv, "id")
        if theid then
            local db = dbQuery(connection,"SELECT * FROM an_character WHERE Playerid=?",theid)
            local dbh,_ = dbPoll(db,-1)
            if dbh then
                for _, row in ipairs(dbh) do
                    group = row["User_group"]
                    if group then
                        setElementData(pv,"user_group",group)
                    end
                end
            end
        end
    end
end
setTimer(attnnewgroupplayer,1000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), attnnewgroupplayer)
----------------------------------------------------------------------------------------------------------------
-- NORTH AMERICA VARIABLES AND MODULES
----------------------------------------------------------------------------------------------------------------
--[[function hasPermission(ply, group)
    local usergroup = getElementData( ply, "user_group")
    if usergroup ~= "desempregado" then
        for key,val in pairs(cfg.groups[usergroup]) do
            if val == group then
                return true
            end
        end
    else
        return false
    end
end]]

function hasPermission(ply, group)
    if getElementData(ply, 'logado') then
        local usergroup = getElementData( ply, "user_group")
        for i, v in next, cfg.groups do
            if i == usergroup then
                for i, v in next, cfg.groups[i] do
                    if v == group then
                        return true
                    end
                end
            end
        end
    end
end

function getUserByPhone(phone)
    local rows = dbPoll(dbQuery(connection, "SELECT id FROM an_character WHERE Phone = ?", phone or ""), -1)
    if #rows > 0 then
        return rows[1].user_id
    end
end

function generatePhoneNumber()
    local user_id = nil
    local phone = ""

    repeat
        phone = generateStringNumber("DDD-DDD")
        user_id = getUserByPhone(phone)
    until not user_id

    return phone
end

function generateStringNumber(format)
    local abyte = string.byte("A")
    local zbyte = string.byte("0")
    local number = ""
    for i=1,#format do
        local char = string.sub(format,i,i)
        if char == "D" then number = number..string.char(zbyte+math.random(0,9))
        elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
        else number = number..char end
    end
    return number
end

function servergetitemtable(id)
    for key,val in pairs(cfg.items) do
        if val[1] == tonumber(id) then
            return val
        end
    end
end

function servergetitemtable2(id)
    for key,val in pairs(cfg.items) do
        if val[2] == id then
            return val
        end
    end
end

function servergetitemtable3()
    return cfg.items
end

function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

function an_getrealTimer()
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    local formattedTime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds)
    return formattedTime
end

function an_getrealTimeraddedday(added)
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    local formattedTime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday+added, hours, minutes, seconds)
    return formattedTime
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function findVeh(id)
    local vehicles = getElementsByType("vehicle")
    for k,v in pairs(vehicles) do
        if getElementData(v,"id") == id then
            return v
        end
    end
    return false
end

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
----------------------------------------------------------------------------------------------------------------