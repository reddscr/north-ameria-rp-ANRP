-------------------------------------------------------------------------------------------------------
-- connection
-------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
local coldowncall = {}
local plyrecentcall = {}
addCommandHandler("call",
function(ply,cmd,typ)
if not getElementData(ply, 'incoma') then
        if typ == "police" then
            local policeinservice = exports.an_police:getpoliceinservicesv()
            if policeinservice >= 0 then
                triggerClientEvent(ply, "openplyprompt", ply,'police.permission')
                plyrecentcall[ply] = true
            else
                exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>policiais</b> no momento","aviso")
            end
        elseif typ == "medic" then
            local policeinservice = exports.an_police:getpoliceinservicesv()
            if policeinservice >= 2 then
                triggerClientEvent(ply, "openplyprompt", ply,'medic.permission')
                plyrecentcall[ply] = true
            else
                exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>medicos</b> no momento","aviso")
            end
        elseif typ == "mechanic" then
            local policeinservice = exports.an_police:getmechanicinservicesv()
            if policeinservice >= 1 then
                triggerClientEvent(ply, "openplyprompt", ply,'mechanic.permission')
                plyrecentcall[ply] = true
            else
                exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>mecanicos</b> no momento","aviso")
            end
        end
    end
end
)

function getplycalls(ply)
	local plyid = getElementData(ply,"id")
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_emergencycall WHERE id = ?",plyid), -1)
	plycallsss = false
	for k,v in ipairs(result) do
		plycalls = v["id"]
		if plycalls ~= nil then
			plycallsss = tonumber(plycalls)
		end
	end
	if plycallsss then 
		return plycallsss
	else 
		return false
	end
end

function setplyemgcall(ply,motive,calltipe)
    local plyid = getElementData(ply,"id")
    if plyid then
        if calltipe then
            local plyname = getElementData(ply,"Nome")
            local plysname = getElementData(ply,"SNome")
            local plycnome = ""..plyname.." "..plysname..""
            for i,p in ipairs (getElementsByType("player")) do
                if exports.an_account:hasPermission( p, calltipe) then
                    --exports.an_infobox:addNotification(p,"Chamado recebido, <b>você quer aceitar?</b> <br><br><b>Motivo</b>: "..motive.." <br><br><b>Nome</b>: "..plycnome.." <br><br><b>Y</b> sim <b>U</b> não","info")
                    triggerClientEvent (p,"abrirconfirmchamado",p,ply,plycnome,motive)
                end
            end
        end
    end
end
addEvent ("setplyemgcall", true)
addEventHandler ("setplyemgcall", root, setplyemgcall)

function acceptplycall(ply)
    if getElementData(ply,"oncall") then
        local plyid = getElementData(ply,"oncall")
        if plyid then
            local result = dbPoll(dbQuery(connection, "SELECT * FROM an_emergencycall WHERE id = ?",plyid), -1)
            for k,v in ipairs(result) do
                plymsgcall = v["callmotive"]
                plymsgcallid = v["id"]
                if plymsgcall ~= nil then
                    local ply2id = tonumber(plyid)
                    if ply2id then
                        local ply2 = getPlayerID(tonumber(ply2id))
                        if ply2 then
                            local x,y,z = getElementPosition(ply2)
                            exports.an_infobox:addNotification(ply,"<b>Chamado de</b>: "..getElementData(ply2,"Nome").." "..getElementData(ply2,"SNome").." <br><b>Motivo</b>: "..plymsgcall.." ","info")
                            triggerClientEvent (ply,"createemgblip",ply,plymsgcallid,x,y,z,"A <b>localização</b> do chamado foi marcada no seu <b>GPS</b>")
                        end
                    end
                end
            end
            dbExec(connection, "DELETE FROM an_emergencycall WHERE id = ?", plyid)
            setElementData(ply,"oncall",nil)
        end
    end
end
addEvent ("acceptplycall", true)
addEventHandler ("acceptplycall", root, acceptplycall)

function notifyemergencyplayer(ply,plyid)
    if plyid then
        exports.an_infobox:addNotification(plyid, "O seu <b>chamado</b> foi atendido! aguarde no local.", "aviso")
    end
end
addEvent ("notifyemergencyplayer", true)
addEventHandler ("notifyemergencyplayer", root, notifyemergencyplayer)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function createemgblipsv(id,x,y,z,msg)
    if id then
        if x then
            if msg then
                for i,p in ipairs (getElementsByType("player")) do
                    if exports.an_account:hasPermission(p, 'police.permission') then
                        if getElementData(p,"policetoggle") then
                            triggerClientEvent (p,"createemgblip2",p,id,x,y,z,msg)
                        end
                    end
                end
            end
        end
    end
end
addEvent ("createemgblipsv", true)
addEventHandler ("createemgblipsv", root, createemgblipsv)
-------------------------------------------------------------------------------------------------------
-- VARIAVEIS
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