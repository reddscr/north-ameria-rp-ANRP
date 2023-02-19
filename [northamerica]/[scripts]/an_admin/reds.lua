----------------------------------------------------------------------------------------------------------------
-- database connection
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
local itemtb = exports.an_account:servergetitemtable3()
----------------------------------------------------------------------------------------------------------------
-- kick all
----------------------------------------------------------------------------------------------------------------
addCommandHandler("kickall",
function(ply,cmd,res)
if not (getElementData(ply, "Admin", true)) then return end
	if res then
		--setWeatherBlended (id)
		local plyid1 = getElementData(ply,"id")
		for i, v in ipairs (getElementsByType("player")) do
			if v ~= ply then 
				local plyid = getElementData(v,"id")
				kickPlayer ( v, plyid1, res )
			end
		end
		
	end
end
)

addCommandHandler("loadvehs",
function(ply,cmd,id,res)
	if not (getElementData(ply, "Admin", true)) then return end
	for key,veh in pairs(getElementsByType("vehicle")) do
		for i,v in ipairs (itemtb) do
			local dbid2 = tonumber(getElementData(veh, v[2]))
			if dbid2 == nil then
				setElementData(veh,v[2],0)
			end
		end
		setTimer(function()
			exports.an_inventory:loadvehicletrunk(veh)
		end,1000,1)
	end
	exports.an_infobox:addNotification(ply,"Todos <b>porta-malas</b> carregados","info")
end)

addCommandHandler("kick",
function(ply,cmd,id,res)
if not (getElementData(ply, "Admin", true)) then return end
	local plyid = getElementData(ply,"id")
	if res then
		local ply2 = getPlayerID(tonumber(id))
		if ply2 then
			kickPlayer ( ply2, plyid, res )
		end
	end
end
)

addCommandHandler("debugtrunk",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
	if vehicl then
		setVehicleDoorOpenRatio(vehicl, 1, 0, 500)
		setElementData(vehicl,"portamalassendousado",false)
		setElementData(vehicl, "portamalassendousado", false)
		exports.an_infobox:addNotification(ply,"<b>Porta-malas</b> fechada","info")
    end
end
)

addCommandHandler("wheel",
function(ply,cmd,numb)
	if not (getElementData(ply, "Admin", true)) then return end
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
	if vehicl then
		if numb then
			addVehicleUpgrade(vehicl,numb)
		end
	end
end
)

addCommandHandler("tunning",
function(ply,cmd,numb)
	if not (getElementData(ply, "Admin", true)) then return end
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
	if vehicl then
		local variant = 0
		local vehid = getElementData(vehicl, 'id')
		setVehicleVariant( vehicl, variant, variant)
		setElementData( vehicl, "Variant", variant)
		setElementData( vehicl, "PaintJob", tonumber(numb))
		dbExec(connection, "UPDATE an_vehicle SET Paintjob = ?,Variant = ? WHERE id = ?", tonumber(numb), variant, vehid)
		local model = getElementModel(vehicl)
		triggerEvent("addVehiclePaintJob", ply, vehicl, model, tonumber(numb))
	end
end
)

addCommandHandler("tunning2",
function(ply,cmd,numb,numb2)
	if not (getElementData(ply, "Admin", true)) then return end
    local vehicl = exports.an_player:getproxveh(ply,5)
    local plyid = getElementData(ply,"id")
	if vehicl then
		local variant = tonumber(numb2)
		local vehid = getElementData(vehicl, 'id')
		setVehicleVariant( vehicl, variant, variant)
		setElementData( vehicl, "Variant", variant)
		setElementData( vehicl, "PaintJob", tonumber(numb))
		dbExec(connection, "UPDATE an_vehicle SET Paintjob = ?,Variant = ? WHERE id = ?", tonumber(numb), variant, vehid)
		local model = getElementModel(vehicl)
		triggerEvent("addVehiclePaintJob", ply, vehicl, model, tonumber(numb))
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- weather command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("weather",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if id then
		--setWeatherBlended (id)
		exports.an_infobox:addNotification(ply,"Você alterou o clima da cidade.","normal")
		setWeather(id)
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- weather command2
----------------------------------------------------------------------------------------------------------------
addCommandHandler("weather2",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if id then
		setWeatherBlended (id)
		exports.an_infobox:addNotification(ply,"Você alterou o clima da cidade.","normal")
		--setWeather(id)
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- wather command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("wather",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if id then
		setWaveHeight ( id )
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- noclip command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("nc",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
		triggerClientEvent(ply, "Admin->fly->toggle", getRootElement())
end
)
----------------------------------------------------------------------------------------------------------------
-- get position
----------------------------------------------------------------------------------------------------------------
addCommandHandler("pos",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
		local x,y,z = getElementPosition(ply)
		outputChatBox("#e23c3cPos#e3e3e3: "..table.concat ( { math.round ( x, 3 ), math.round ( y, 3 ), math.round ( z, 3 ), int }, ', ' ).."", ply, 255, 255, 255, true)
		triggerClientEvent (ply, "funtcopy", root,x,y,z)
end
)
----------------------------------------------------------------------------------------------------------------
-- get rotation
----------------------------------------------------------------------------------------------------------------
addCommandHandler("rot",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
		local x,y,z = getElementRotation(ply)
		outputChatBox("#e23c3cPos#e3e3e3: "..table.concat ( { math.round ( x, 3 ), math.round ( y, 3 ), math.round ( z, 3 ), int }, ', ' ).."", ply, 255, 255, 255, true)
		triggerClientEvent (ply, "funtcopy", root,x,y,z)
end
)
----------------------------------------------------------------------------------------------------------------
-- set skin
----------------------------------------------------------------------------------------------------------------
addCommandHandler("skin",
function(ply,cmd,id,n)
if not (getElementData(ply, "Admin", true)) then return end
if(id) then
	if n then
		local playerID = tonumber(id)
		if(playerID) then
		local Player2 = getPlayerID(playerID)
			if(Player2) then
			n = tonumber ( n )
				if ( setElementModel( Player2, n) ) then
					mdata = n
				else
					outputChatBox("#e23c3cALERTA#e3e3e3: Skin invalida", ply, 255, 255, 255, true)
				end
			end
		end
	end
end
end
)
----------------------------------------------------------------------------------------------------------------
-- check online id's
----------------------------------------------------------------------------------------------------------------
idson = {}
addCommandHandler("pon",
function(ply,cmd)
	if getElementData ( ply, "Admin" ) == true then
		idson = {}
		for pk,pv in pairs(getElementsByType("player")) do
			idson[#idson + 1] = {{tonumber(getElementData(pv, "id"))}}
		end
		exports.an_infobox:addNotification(ply,"<b>Ids online</b><br>","normal")
		for i2,v2 in ipairs (idson) do
			if v2[1][1] then
				exports.an_infobox:addNotification(ply,"<b>"..v2[1][1].."</b><br>","normal")
			end
		end

	end
end
)
----------------------------------------------------------------------------------------------------------------
-- warning
----------------------------------------------------------------------------------------------------------------
addCommandHandler("warning",
function(ply,cmd,typ,...)
	local message = table.concat ( { ... }, " " )
	if getElementData ( ply, "Admin" ) == true then
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** fez o anúncio: **"..message.."**")
		for pk,pv in pairs(getElementsByType("player")) do
			if getElementData(pv,"logado") then
				if typ == "normal" then
					exports.an_infobox:addNotification(pv,"<b>Governament Warning:</b> "..message.."","normal",60000)
				elseif typ == "perigo" then
					exports.an_infobox:addNotification(pv,"<b>Governament Warning:</b> "..message.."","erro",60000)
				elseif typ == "aviso" then
					exports.an_infobox:addNotification(pv,"<b>Governament Warning:</b> "..message.."","aviso",60000)
				elseif typ == "info" then
					exports.an_infobox:addNotification(pv,"<b>Governament Warning:</b> "..message.."","info",60000)
				end
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- take item command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("titem",
function(ply,cmd,id,n,qtd)
if not (getElementData(ply, "Admin", true)) then return end
if(id) then
	if n then
		if qtd then
				local playerID = tonumber(id)
				if(playerID) then
					local Player2 = getPlayerID(playerID)
					if(Player2) then
						local itemdata = exports.an_account:servergetitemtable2(n) 
						if itemdata then
							exports.an_inventory:sattitem(Player2,itemdata[2],qtd,"menos")
							exports.an_infobox:addNotification(ply,"Você removeu <b>"..qtd.."x</b> <b>"..itemdata[5].."</b>","info")
							triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** removeu **"..qtd.."x "..itemdata[5].."** do id **"..getElementData ( Player2, "id" ).."**")
						end
					end
				end
			end
		end	
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- debug data command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("dbg",
function(ply,cmd,id,n)
	if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
		local Player2 = getPlayerID(playerID)
		if(Player2) then
			setElementData(Player2, n, false )
	end
	end
end
end
)
----------------------------------------------------------------------------------------------------------------
-- debug moc 
----------------------------------------------------------------------------------------------------------------
addCommandHandler("debugmocslot",
function(ply,cmd)
	for i, v in ipairs (getElementsByType("player")) do
	local plyid = getElementData(v,"id")
		if plyid then
			local accountplyQ = dbQuery(connection,"SELECT * FROM an_userdata WHERE id=?",plyid)
			local accountplyH,vehszam = dbPoll(accountplyQ,-1)
			if accountplyH then
				for k,v in ipairs(accountplyH) do
					MocStats = fromJSON(v["MocStats"])
					setElementData(ply,"MocSlot",tonumber(MocStats[1]))
					setElementData(ply,"MocMSlot",tonumber(MocStats[2]))
				end
			end
		end
	end
	exports.an_infobox:addNotification(ply,"Você desbugou todas as <b>mochilas</b>","info")
end
)
----------------------------------------------------------------------------------------------------------------
-- give item command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("item",
function(ply,cmd,id,n,qtd)
if not (getElementData(ply, "Admin", true)) then return end
if(id) then
	if n then
		if qtd then
				local playerID = tonumber(id)
				if(playerID) then
					local Player2 = getPlayerID(playerID)
					if(Player2) then
					--	local itemdata = exports.an_account:servergetitemtable2(n)
						local itemdata = exports.an_account:servergetitemtable2(n) 
						if itemdata then
							exports.an_inventory:sattitem(Player2,itemdata[2],qtd,"mais")
							exports.an_infobox:addNotification(ply,"Você pegou <b>"..qtd.."x</b> <b>"..itemdata[5].."</b>","info")
							triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** adicionou **"..qtd.."x "..itemdata[5].."** no id **"..getElementData ( Player2, "id" ).."**")
						end
					end
				end
			end
		end	
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- noclip variaveis
----------------------------------------------------------------------------------------------------------------
function ncon()
setElementAlpha(source, 0)
triggerClientEvent (source, "agodModeOn",source)
end
addEvent("ncon", true)
addEventHandler("ncon", root, ncon)
function ncoff()
setElementAlpha(source, 255)
triggerClientEvent (source, "agodModeOff",source)
end
addEvent("ncoff", true)
addEventHandler("ncoff", root, ncoff)
----------------------------------------------------------------------------------------------------------------
-- delete vehicle on map
----------------------------------------------------------------------------------------------------------------
addCommandHandler("dv",
function(ply,cmd)
if not (getElementData(ply, "Admin", true)) then return end
local vehicl = exports.an_player:getproxveh(ply,15)
	if vehicl then
		exports.an_vehicles:saveVehicle(vehicl)
		destroyElement(vehicl)
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> apagado com sucesso!","sucesso")
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** deu dv em um veículo!")
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- delete vehicle in database
----------------------------------------------------------------------------------------------------------------
addCommandHandler("delveicdatabase",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
	local vehicl = exports.an_player:getproxveh(ply,9)
	if vehicl then
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** removeu o veículo do **"..getElementData ( vehicl, "owner" ).." - "..getElementData ( vehicl, "Nome" ).." "..getElementData ( vehicl, "Snome" ).."** do banco de dados!")
		dbExec(connection, "DELETE FROM an_vehicle WHERE id = ?", getElementData(vehicl,"id"))
		exports.an_inventory:destroyVehicleData(getElementData(vehicl,"id"))
		local playerID = tonumber(getElementData ( vehicl, "owner" ))
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then
				exports.an_vehicles:updatevehicle(Player2)
			end 
		end
		destroyElement(vehicl)
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> apagado do banco de dados!","sucesso")
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- car color command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("carcolor",
function(ply,cmd,r,g,b,r2,g2,b2)
if not (getElementData(ply, "Admin", true)) then return end
local vehicl = exports.an_player:getproxveh(ply,15)
	if vehicl then
		if not r2 then
			if getElementData ( vehicl, "owner" ) then
				triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** pintou o veículo do **"..getElementData ( vehicl, "owner" ).." - "..getElementData ( vehicl, "Nome" ).." "..getElementData ( vehicl, "Snome" ).."**")
			end
			setVehicleColor( vehicl, r, g, b )
		elseif r2 then
			if getElementData ( vehicl, "owner" ) then
				triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** pintou o veículo do **"..getElementData ( vehicl, "owner" ).." - "..getElementData ( vehicl, "Nome" ).." "..getElementData ( vehicl, "Snome" ).."**")
			end
			setVehicleColor( vehicl, r, g, b,r2,g2,b2)
		end
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> pintado com sucesso!","sucesso")
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
	end
end
)

----------------------------------------------------------------------------------------------------------------
-- carregar
----------------------------------------------------------------------------------------------------------------
addCommandHandler("carregar",
function(ply,cmd,r,g,b)
if not (getElementData(ply, "Admin", true)) then return end
local vehicl = exports.an_player:getproxveh(ply,15)
local pply = exports.an_player:getproxply(ply,15)
	if vehicl or pply then
		if vehicl then
			attachElements(vehicl, ply, 0, 0, 2)
			setElementData(ply,"carregando",vehicl)
			setElementAlpha(vehicl, 100)
			exports.an_infobox:addNotification(ply,"<b>Carregando</b>!","erro")
			if getElementData ( vehicl, "owner" ) then
				triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** está carregando o veículo do **"..getElementData ( vehicl, "owner" ).." - "..getElementData ( vehicl, "Nome" ).." "..getElementData ( vehicl, "Snome" ).."**")
			end
		elseif pply then
			attachElements(pply, ply, 0, 0, 2)
			setElementData(ply,"carregando",pply)
			setElementAlpha(pply, 100)
			exports.an_infobox:addNotification(ply,"<b>Carregando</b>!","erro")
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** está carregando o **"..getElementData ( pply, "id" ).." - "..getElementData ( pply, "Nome" ).." "..getElementData ( pply, "SNome" ).."**")
		end
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> ou <b>pessoa</b> não detectado!","erro")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- soltar
----------------------------------------------------------------------------------------------------------------
addCommandHandler("soltar",
function(ply,cmd)
if not (getElementData(ply, "Admin", true)) then return end
oncarg = getElementData(ply, "carregando")
	if getElementData(ply, "carregando") then
		if oncarg then
			detachElements(oncarg)
			setElementAlpha(oncarg,255)
			setElementData(ply,"carregando",nil)
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- create car command
----------------------------------------------------------------------------------------------------------------
caradm = {}
addCommandHandler("car",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
local x,y,z = getElementPosition(ply)
local rx,ry,rz = getElementRotation(ply)
	if id then
		caradm[ply] = createVehicle(id,x, y, z+1,rx,ry,rz)
		local vehicleName = getVehicleName ( caradm[ply] )
		warpPedIntoVehicle (ply,caradm[ply])
		setElementData(caradm[ply],"number:plate","  NA RP")
		setVehiclePlateText( caradm[ply], "  NA RP" )
		exports.an_infobox:addNotification(ply,"Você criou o veículo <b>"..vehicleName.."</b>","info")
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** criou o veículo **"..vehicleName.."**")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- tp to me
----------------------------------------------------------------------------------------------------------------
addCommandHandler("tptome",
function(ply,cmd,id,set)
if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then	
				local px, py, pz = getElementPosition(ply)
				local p2x, p2y, p2z = getElementPosition(Player2)
				if not getElementData(Player2,'nc') then
					setElementPosition ( Player2, px+1, py, pz)
					exports.an_infobox:addNotification(ply,"<b>"..id.."</b> foi puxado ate você!","sucesso")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** puxou o **"..getElementData ( Player2, "id" ).." - "..getElementData ( Player2, "Nome" ).." "..getElementData ( Player2, "SNome" ).."** até ele!")
				else
					triggerClientEvent( Player2,"tpcdsply", ply, px+1, py, pz)
					exports.an_infobox:addNotification(ply,"<b>"..id.."</b> foi puxado ate você!","sucesso")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** puxou o **"..getElementData ( Player2, "id" ).." - "..getElementData ( Player2, "Nome" ).." "..getElementData ( Player2, "SNome" ).."** até ele!")
				end
			else
				exports.an_infobox:addNotification(ply,"<b>"..id.."</b> não foi encontrado!","erro")
			end 
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- tp to cords
----------------------------------------------------------------------------------------------------------------
addCommandHandler("tpcds",
function(ply,cmd,x,y,z)
if not (getElementData(ply, "Admin", true)) then return end
	if not getElementData(ply,"nc") then
		setElementPosition ( ply, x, y, z+1)
		exports.an_infobox:addNotification(ply,"Você se teleportou para a cordenada <b>"..x.." "..y.." "..z.."</b>","info")
	else
		triggerClientEvent( ply,"tpcdsply", ply, x, y, z+1)
		exports.an_infobox:addNotification(ply,"Você se teleportou para a cordenada <b>"..x.." "..y.." "..z.."</b>","info")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- TOGGLE SCRENN PLAYERS INFO
----------------------------------------------------------------------------------------------------------------
addCommandHandler("toggleinfo",
function(ply,cmd,x,y,z)
if not (getElementData(ply, "Admin", true)) then return end
	triggerClientEvent( ply,"togglescreenadmininfo", ply)
	triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** está usando o `toggleinfo`!")
end
)
----------------------------------------------------------------------------------------------------------------
-- tp to id
----------------------------------------------------------------------------------------------------------------
addCommandHandler("tpto",
function(ply,cmd,id,set)
if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then	
				local px, py, pz = getElementPosition(ply)
				local p2x, p2y, p2z = getElementPosition(Player2)
				if not getElementData(ply,'nc') then
					setElementPosition ( ply, p2x+1, p2y, p2z)
					exports.an_infobox:addNotification(ply,"Você se teleportou para o <b>"..id.."</b>!","sucesso")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** se teleportou para o **"..getElementData ( Player2, "id" ).." - "..getElementData ( Player2, "Nome" ).." "..getElementData ( Player2, "SNome" ).."**")
				else
					triggerClientEvent( ply,"tpcdsply", ply, p2x+1, p2y, p2z)
					exports.an_infobox:addNotification(ply,"Você se teleportou para o <b>"..id.."</b>!","sucesso")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** se teleportou para o **"..getElementData ( Player2, "id" ).." - "..getElementData ( Player2, "Nome" ).." "..getElementData ( Player2, "SNome" ).."**")
				end
			else
				exports.an_infobox:addNotification(ply,"<b>"..id.."</b> não foi encontrado!","erro")
			end 
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
--- clean chat
----------------------------------------------------------------------------------------------------------------
addCommandHandler("chat",
function(ply,cmd)
if not (getElementData(ply, "Admin", true)) then return end
--for i = 1,40 do
  --  i = outputChatBox("                  ")
  --triggerEvent ("onChat2Clear",ply)
  	for i, player in ipairs (getElementsByType("player")) do
  		triggerClientEvent(player, "onChat2Clear", player)
	end

end
)
----------------------------------------------------------------------------------------------------------------
-- nui debug command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("nuidebug",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then
				setElementData(Player2,"openui",false)
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- nui debug command
----------------------------------------------------------------------------------------------------------------
addCommandHandler("invdebug",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then
				setElementData(Player2,"MocSlot",0)
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- god command 
----------------------------------------------------------------------------------------------------------------
addCommandHandler("god",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if id == nil then
		if getElementData(ply, "incoma") then
			dbExec(connection, "DELETE FROM an_death WHERE playerid = ?", getElementData(ply,"id"))
			exports.an_medic:removeplydeath(ply)
			setElementData(ply,"incoma",nil)
			setElementData(ply,"muitoferido",nil)
			setElementData(ply,'removeHud',nil)
			setTimer (setElementData, 50, 1, ply,"died",nil)
			setElementFrozen(ply,false)
			toggleAllControls(ply,true)
			setPedAnimation(ply,false)
			setElementHealth(ply, 30)
			setPedAnimation(ply, nil )
			setElementHealth (ply, 100 )	
			--setPedArmor(ply, 100 )
			setElementData(ply,"foodstats",100)
			setElementData(ply,"watherstats",100)
			--print(getElementData(ply, "Nome").." "..getElementData(ply, "SNome").." usou o poder '/god'")
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** usou o `/god` `morto`")
			exports.an_infobox:addNotification(ply,"Você se curou","aviso")
		else
			setElementHealth ( ply, 100 )	
			--setPedArmor(  ply, 100 )
			setElementData(ply,"foodstats",100)
			setElementData(ply,"watherstats",100)
			--print(getElementData(ply, "Nome").." "..getElementData(ply, "SNome").." usou o poder '/god'")
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** usou o `/god` vivo")
			exports.an_infobox:addNotification(ply,"Você se curou","aviso")
		end
	else
		if id then
			local ply2 = getPlayerID(tonumber(id))
			if ply2 then
				if ply2 ~= ply then
					if getElementData(ply2, "incoma") then
						dbExec(connection, "DELETE FROM an_death WHERE playerid = ?", getElementData(ply2,"id"))
						exports.an_medic:removeplydeath(ply2)
						setElementData(ply2,"incoma",nil)
						setElementData(ply2,"muitoferido",nil)
						setElementData(ply2,'removeHud',nil)
						setTimer (setElementData, 50, 1, ply2,"died",nil)
						setElementFrozen(ply2,false)
						toggleAllControls(ply2,true)
						setPedAnimation(ply2,false)
						setElementHealth(ply2, 30)
						setPedAnimation(ply2, nil )
						setElementHealth ( ply2, 100 )
						setElementData(ply2,"foodstats",100)
						setElementData(ply2,"watherstats",100)
					else
						setElementHealth ( ply2, 100 )	
						setElementData(ply,"foodstats",100)
						setElementData(ply,"watherstats",100)
					end
					exports.an_infobox:addNotification(ply,"Você curou o jogador "..getElementData(ply2, "Nome").." "..getElementData(ply2, "SNome").."","aviso")
					--print(getElementData(ply, "Nome").." "..getElementData(ply, "SNome").." usou o poder '/god' para curar o "..getElementData(ply2, "Nome").." "..getElementData(ply2, "SNome").." ")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** usou o `/god` no **"..getElementData ( ply2, "id" ).." - "..getElementData ( ply2, "Nome" ).." "..getElementData ( ply2, "SNome" ).."**")
				end
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- kil player
----------------------------------------------------------------------------------------------------------------
addCommandHandler("kill",
function(ply,cmd,id)
	if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then
				setElementHealth ( Player2, 0 )	
				setPedArmor(  Player2, 0 )
				triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** matou o **"..getElementData ( Player2, "id" ).." - "..getElementData ( Player2, "Nome" ).." "..getElementData ( Player2, "SNome" ).."** com o /kill")
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- remove wanted
----------------------------------------------------------------------------------------------------------------
addCommandHandler("rwanted",
function(ply,cmd,id)
	if not (getElementData(ply, "Admin", true)) then return end
	if id then
		getplyid = tonumber(id)
		if getplyid then
			local ply2 = getPlayerID(getplyid)
			if ply2 then
				if getElementData(ply2,"wanted") then
					exports.an_wanted:removeplywanted(ply2)
					exports.an_infobox:addNotification(ply,"Procurado removido do <b>"..getElementData(ply2, "Nome").." "..getElementData(ply2, "SNome").."</b>","aviso")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** removeu o procurado do **"..getElementData ( ply2, "id" ).." - "..getElementData ( ply2, "Nome" ).." "..getElementData ( ply2, "SNome" ).."**")
				else
					exports.an_infobox:addNotification(ply,"Esta pessoa não está sendo <b>procurada</b>.","erro")
				end
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- remove jail
----------------------------------------------------------------------------------------------------------------
addCommandHandler("rjail",
function(ply,cmd,id)
	if not (getElementData(ply, "Admin", true)) then return end
	if id then
		getplyid = tonumber(id)
		if getplyid then
			local ply2 = getPlayerID(getplyid)
			if ply2 then
				if getElementData(ply2,"injail") then
					exports.an_prision:removeplyjail(ply2)
					exports.an_infobox:addNotification(ply,"Você removeu <b>"..getElementData(ply2, "Nome").." "..getElementData(ply2, "SNome").."</b> da prisão","aviso")
					triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** removeu o **"..getElementData ( ply2, "id" ).." - "..getElementData ( ply2, "Nome" ).." "..getElementData ( ply2, "SNome" ).."** da `prisão`")
				else
					exports.an_infobox:addNotification(ply,"Esta pessoa não está <b>presa</b>.","erro")
				end
			end
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- set house
----------------------------------------------------------------------------------------------------------------
addCommandHandler("sethouse",
function(ply,cmd,id,n)
if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
		if n then
			local playerID = tonumber(id)
			if(playerID) then
				local Player2 = getPlayerID(playerID)
				if(Player2) then
					local db2 = dbQuery(connection,"SELECT * FROM an_houses WHERE id_owner = ?", getElementData(Player2,'id'))
					local dbh2,_ = dbPoll(db2,-1)
					if dbh2 then
						for k,v in ipairs(dbh2) do
							id = v['id']
							if id then
								dbExec(connection, "UPDATE an_houses SET id_owner = ? WHERE id = ?", 0, id)
							end
						end
						exports.an_infobox:addNotification(ply,"Casa <b>"..n.."</b> setada no id <b>"..getElementData(Player2,'id').."</b>!","aviso")
						dbExec(connection, "UPDATE an_houses SET id_owner = ? WHERE id = ?",getElementData(Player2,'id'), n)
					end
				end
			end
		end
	end
end
)

addCommandHandler("resethouse",
function(ply,cmd,id)
if not (getElementData(ply, "Admin", true)) then return end
	if(id) then
			local playerID = tonumber(id)
			if(playerID) then
				local Player2 = getPlayerID(playerID)
				if(Player2) then
					local db2 = dbQuery(connection,"SELECT * FROM an_houses WHERE id_owner = ?", getElementData(Player2,'id'))
					local dbh2,_ = dbPoll(db2,-1)
					if dbh2 then
						for k,v in ipairs(dbh2) do
							id = v['id']
							if id then
								dbExec(connection, "UPDATE an_houses SET id_owner = ? WHERE id = ?", 0, id)
							end
						end
					end
				end
			end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- set time in server
----------------------------------------------------------------------------------------------------------------
addCommandHandler("settime",
function(ply,cmd,time,minutes)
if not (getElementData(ply, "Admin", true)) then return end
	if time then
		if minutes then
			exports.an_sync:setServerTime(tonumber(time), tonumber(minutes))
		end
		local getime, min = exports.an_sync:getantime()
		exports.an_infobox:addNotification(ply,"Você trocou o horário do servidor para <b>"..getime.." h</b>","aviso")
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** tocou o horário da cidade para **"..getime.."h**")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- set fps limit
----------------------------------------------------------------------------------------------------------------
addCommandHandler("setfpslimit",
function(ply,cmd,fps)
if not (getElementData(ply, "Admin", true)) then return end
	if fps then
		if tonumber(fps) <= 100 then
			setFPSLimit ( fps ) 
			exports.an_infobox:addNotification(ply,"Limite de fps setado em "..fps.." ","aviso")
		else
			exports.an_infobox:addNotification(ply,"Não é possível setar limite de fps em "..fps.." ","erro")
		end
	end
end
)


----------------------------------------------------------------------------------------------------------------
-- save all vehs
----------------------------------------------------------------------------------------------------------------
addCommandHandler("saveallvehs",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
	for i, v in ipairs (getElementsByType("vehicle")) do
		exports.an_vehicles:saveVehicle(v)
	end
	triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** salvou todos os veículos")
	exports.an_infobox:addNotification(ply,"Você salvou os veiculos","aviso")
end
)

----------------------------------------------------------------------------------------------------------------
-- save all vehs
----------------------------------------------------------------------------------------------------------------
addCommandHandler("debugallinv",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
	for i, v in ipairs (getElementsByType("player")) do
		setElementData(v,"openui",false)
	end
	exports.an_infobox:addNotification(ply,"Você desbugou todos os inv's","aviso")
end
)
----------------------------------------------------------------------------------------------------------------
-- set server pass
----------------------------------------------------------------------------------------------------------------
addCommandHandler("setspass",
function(ply,cmd,pass)
if not (getElementData(ply, "Admin", true)) then return end
	if (pass == "") or (pass == nil) then
		setServerPassword( nil )
		exports.an_infobox:addNotification(ply,"Você removeu a senha do servidor!","aviso")
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** removeu a senha do servidor")
	elseif pass then
		setServerPassword( pass )
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** adicionou a senha **"..pass.."** no servidor")
		exports.an_infobox:addNotification(ply,"Você adicionou a senha "..pass.." no servidor!","aviso")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- fix next car
----------------------------------------------------------------------------------------------------------------
addCommandHandler("fix",
function(ply,cmd,r,g,b)
if not (getElementData(ply, "Admin", true)) then return end
	local vehicl = exports.an_player:getproxveh(ply,9)
	if vehicl then
		fixVehicle(vehicl)
		setVehicleDamageProof( vehicl, false )
		exports.an_vehicles:saveVehicle(vehicl)
		local rotX, rotY, rotZ = getElementRotation(vehicl)
		setVehicleRotation(vehicl, 0, 0, (rotX > 90 and rotX < 270) and (rotZ + 180) or rotZ)
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> reparado com sucesso!","sucesso")
		triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** reparou um veículo com `/fix`")
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
	end
end
)

addCommandHandler("rveh",
function(ply,cmd)
	if not (getElementData(ply, "Admin", true)) then return end
	local vehicl = exports.an_player:getproxveh(ply,9)
	if vehicl then
		for pk,pv in pairs(getElementsByType("player")) do
			for seat, player6 in pairs(getVehicleOccupants(vehicl,pv)) do
				removePedFromVehicle (player6)
			end
		end
	end
end)

addCommandHandler("dvbyid",
function(ply,cmd,id)
	if not (getElementData(ply, "Admin", true)) then return end
	if id then
		local data = dbPoll(dbQuery(connection, "SELECT * FROM an_vehicle WHERE id = ?", id), -1)[1]
		if data then
			vehid = data["id"]
			local veh = findVeh(vehid)
			if isElement(veh) then
				exports.an_vehicles:saveVehicle(veh)
				destroyElement(veh)
				exports.an_infobox:addNotification(ply,"<b>Veículo</b> apagado com sucesso!","sucesso")
			end
		end
	end
end)
----------------------------------------------------------------------------------------------------------------
-- set fuel veh
----------------------------------------------------------------------------------------------------------------
addCommandHandler("setfuel",
function(ply,cmd,qtd)
if not (getElementData(ply, "Admin", true)) then return end
	local vehicl = exports.an_player:getproxveh(ply,9)
	if vehicl then
		if qtd then
			setElementData(vehicl, "fuel", qtd) 
			exports.an_infobox:addNotification(ply,"Combustível do <b>veículo</b> alterado!","sucesso")
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** alterou o combustível de um veículo com `/setfuel`")
		end	
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- set fuel veh
----------------------------------------------------------------------------------------------------------------
addCommandHandler("debugmala",
function(ply,cmd)
if not (getElementData(ply, "Admin", true)) then return end
	local vehicl = exports.an_player:getproxveh(ply,9)
	if vehicl then
		setElementData(vehicl, "usedslots", 0) 
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> debugado!","aviso")
	else
		exports.an_infobox:addNotification(ply,"<b>Veículo</b> não detectado!","erro")
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- check next id
----------------------------------------------------------------------------------------------------------------
addCommandHandler("id",
function(ply,cmd,id)
	if not (getElementData(ply, "Admin", true)) then return end
	if id then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
			if(Player2) then
				exports.an_infobox:addNotification(ply,"<b>Informações do ID: "..id.."</b> <br> <b>ID:</b> "..getElementData(Player2,"id").." <br> <b>Nome: </b>"..getElementData(Player2,"Nome").." <br> <b>Sobrenome: </b>"..getElementData(Player2,"SNome").." <br> <b>Dinheiro: </b>"..getElementData(Player2,"Money").." <br> <b>Banco: </b>"..getElementData(Player2,"BankMoney").."","sucesso")
			else
				exports.an_infobox:addNotification(ply,"<b>"..id.."</b> não foi encontrado!","erro")
			end
		end
	else
		local tagertply = exports.an_player:getproxply(ply,25)
		if tagertply then
			exports.an_infobox:addNotification(ply,"<b>Pessoa mais próxima</b> <br> <b>ID:</b> "..getElementData(tagertply,"id").." <br> <b>Nome: </b>"..getElementData(tagertply,"Nome").." <br> <b>Sobrenome: </b>"..getElementData(tagertply,"SNome").." <br> <b>Dinheiro: </b>"..getElementData(tagertply,"Money").." <br> <b>Banco: </b>"..getElementData(tagertply,"BankMoney").."","sucesso")
		else
			exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
		end
	end
end
)
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
-- converter em numero menor
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
-- get id
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
function findVeh(id)
	local vehicles = getElementsByType("vehicle")
	for k,v in pairs(vehicles) do
		if getElementData(v,"id") == id then
			return v
		end
	end
	return false
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------


