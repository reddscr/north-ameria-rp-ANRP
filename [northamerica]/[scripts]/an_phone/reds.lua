----------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
----------------------------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
----------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
----------------------------------------------------------------------------------------------------------------------------------
function RequestContacts(ply)
    local plyid = getElementData(ply,'id')
    if plyid then
        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonecontacts WHERE Owner = ?", plyid), -1)
        if type(result) == "table" then
            setElementData(ply, "phonenumbers", result)
        end
        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonemessages WHERE owner = ?", plyid), -1)
        if type(result) == "table" then
            setElementData(ply, "phonemessages", result)
        end
    end
end
addEvent ("RequestContacts", true)
addEventHandler ("RequestContacts", root, RequestContacts)
----------------------------------------------------------------------------------------------------------------------------------
-- ADD CONTACT
----------------------------------------------------------------------------------------------------------------------------------
function addplycontact(ply,data,data2)
    if data then
        if data2 then
            local plyid = getElementData(ply,'id')
            if plyid then
                local re = dbPoll(dbQuery(connection, "SELECT * FROM an_phonecontacts WHERE id = ? AND Phonenumber = ?", plyid, data2), -1)[1]
                if not re then
                    local idnumb = getFreeid()
                    dbExec(connection, "INSERT INTO an_phonecontacts SET id = ?, Owner = ?, Phonename = ?, Phonenumber = ?", idnumb, plyid, data, data2)
                    exports.an_infobox:addNotification(ply, 'O contato:<br><br><b>'..data..'</b> - <b>'..data2..'</b><br><br>foi adicionado com sucesso!','sucesso')
                    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonecontacts WHERE Owner = ?", plyid), -1)
                    if type(result) == "table" then
                        setElementData(ply, "phonenumbers", result)
                    end
                    triggerClientEvent(ply, "requestNAcontacts", ply)

                    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonemessages WHERE owner = ? AND numbsended = ?", plyid, data2), -1)
                    resultn = false
                    for k,v in ipairs(result) do
                        homevehslot = v["sendedname"]
                        if homevehslot ~= data then
                            dbExec(connection, "UPDATE an_phonemessages SET sendedname=? WHERE owner = ? AND numbsended = ?",data,plyid,data2)
                        end
                    end
                else
                    exports.an_infobox:addNotification(ply,'Você já tem este contato salvo!','erro')
                end
            end
        end
    end
end
addEvent ("addplycontact", true)
addEventHandler ("addplycontact", root, addplycontact)

function removemessage(ply, data, datanumb)
    if data then
        local plyid = getElementData(ply,'id')
        if plyid then
            dbExec(connection, "DELETE FROM an_phonemessages WHERE owner = ? AND id = ?", plyid, data)
            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonemessages WHERE owner = ?", plyid), -1)
            if type(result) == "table" then
                setElementData(ply, "phonemessages", result)
            end
            exports.an_infobox:addNotification(ply,'<b>Mensagem</b> apagada.','info')
            triggerClientEvent(ply, "requestphonemessages", ply, datanumb)
        end
    end
end
addEvent ("removemessage", true)
addEventHandler ("removemessage", root, removemessage)


function requestnamecontact(id,numb)
    local result = dbPoll(dbQuery(connection, "SELECT Phonename FROM an_phonecontacts WHERE Owner = ? AND Phonenumber = ?", id, numb), -1)
    resultn = false
    for k,v in ipairs(result) do
        homevehslot = v["Phonename"]
        if homevehslot then
            resultn = homevehslot
        end
    end
    if resultn then 
        return resultn 
    else 
        return false
    end
end

function confirmsendmessage(ply, datanumb, datamsg, datanname)
    if datanumb then
        local plyid = getElementData(ply,'id')
        local plynumb = getElementData(ply,'phonenumber')
        if plyid then
            local playeQ = dbQuery(connection,"SELECT * FROM an_character WHERE Phone = ?", datanumb)
            local playeH,playeHm = dbPoll(playeQ,-1)
            if playeH then
                for k,v in ipairs(playeH) do
                    player2id = v["Playerid"]
                    if player2id then
                        local player2ctcname = requestnamecontact(player2id,plynumb)
                        if player2ctcname then
                            name = player2ctcname
                        else
                            name = plynumb
                        end
                        exports.an_infobox:addNotification(ply,'<b>Mensagem</b> enviada!','info')
                        local idmsg = getFreeidmsg()
                        dbExec(connection, "INSERT INTO an_phonemessages SET id = ?, owner = ?, message = ?, numbowner = ?, numbsended = ?, sendedname = ?, sendedowner = ?", idmsg, plyid, datamsg, plynumb, datanumb, datanname, plyid)
                        local idmsg2 = getFreeidmsg()
                        dbExec(connection, "INSERT INTO an_phonemessages SET id = ?, owner = ?, message = ?, numbowner = ?, numbsended = ?, sendedname = ?, sendedowner = ?", idmsg2, player2id, datamsg, datanumb, plynumb, name, plyid)
                        local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonemessages WHERE owner = ?", plyid), -1)
                        if type(result) == "table" then
                            setElementData(ply, "phonemessages", result)
                        end
                        triggerClientEvent(ply, "requestphonemessages", ply, datanumb)
                        local ply2 = getPlayerID(tonumber(player2id))
                        if ply2 then
                            exports.an_infobox:addNotification(ply2,'Você recebeu uma <b>mensagem</b>!','info')
                            local plyid2 = getElementData(ply2,'id')
                            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonemessages WHERE owner = ?", plyid2), -1)
                            if type(result) == "table" then
                                setElementData(ply2, "phonemessages", result)
                            end
                            triggerClientEvent(ply2, "requestphonemessages", ply2, datanumb)
                        end
                    end
                end
            end
        end
    end
end
addEvent ("confirmsendmessage", true)
addEventHandler ("confirmsendmessage", root, confirmsendmessage)
----------------------------------------------------------------------------------------------------------------------------------
-- REMOVE CONTACT
----------------------------------------------------------------------------------------------------------------------------------
function removeplynumber(ply,data)
    if data then
        local plyid = getElementData(ply,'id')
        if plyid then
            dbExec(connection, "DELETE FROM an_phonecontacts WHERE Owner = ? AND Phonenumber = ?", plyid, data)
            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_phonecontacts WHERE Owner = ?", plyid), -1)
            if type(result) == "table" then
                setElementData(ply, "phonenumbers", result)
            end
            triggerClientEvent(ply, "requestNAcontacts", ply)
        end
    end
end
addEvent ("removeplynumber", true)
addEventHandler ("removeplynumber", root, removeplynumber)
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
function getFreeid()
    local result = dbPoll(dbQuery(connection, "SELECT id FROM an_phonecontacts ORDER BY id ASC"), -1)
    newid = false
    for i, id in pairs (result) do
        if id["id"] ~= i then
            newid = i
            break
        end
    end
    if newid then return newid else return #result + 1 end
end

function getFreeidmsg()
    local result = dbPoll(dbQuery(connection, "SELECT id FROM an_phonemessages ORDER BY id ASC"), -1)
    newid = false
    for i, id in pairs (result) do
        if id["id"] ~= i then
            newid = i
            break
        end
    end
    if newid then return newid else return #result + 1 end
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
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------