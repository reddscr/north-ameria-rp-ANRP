	----------------------------------------------------------------------------------------------------------------------------------
	-- MySql Connect
	----------------------------------------------------------------------------------------------------------------------------------
	local connnnec = exports["an_connect"]:getConnection()
	----------------------------------------------------------------------------------------------------------------------------------
	-- VARIABLES
	----------------------------------------------------------------------------------------------------------------------------------
	local itemtb = exports.an_account:servergetitemtable3()
	----------------------------------------------------------------------------------------------------------------------------------
	-- SYSTEM
	----------------------------------------------------------------------------------------------------------------------------------
	function loaddeath(ply)
		local plyid = getElementData(ply,"id")
		local playeQ = dbQuery(connnnec,"SELECT * FROM an_death WHERE playerid = ?",plyid)
		local playeH,playeHm = dbPoll(playeQ,-1)
		if playeH then
			for k,v in ipairs(playeH) do
				plyid = v["playerid"]
				if getElementData(ply,"id") == plyid then
					killPlayeronDeath(ply)
				end
			end
		end
	end

	function checkplayhealth()
		for i, ply in pairs (getElementsByType("player")) do
			if getElementData(ply, "logado") then
				if isPedDead(ply) then
					if not getElementData(ply, 'incoma') then
						if isPedInVehicle(ply) then
							removePedFromVehicle (ply)
						end
						setElementData(ply,"muitoferido",true)
						setElementData(ply,"incoma",true)
						setElementData(ply,'removeHud',true)
						local id = getFreeid()
						local plyid = getElementData(ply,"id")
						dbExec(connnnec, "INSERT INTO an_death SET id = ?,playerid = ?", id, plyid)
						local x, y, z = getElementPosition(ply)
						local dim = getElementDimension(ply)
						local int = getElementInterior(ply)
						setElementDimension(ply, dim)
						setElementInterior(ply, int)
						spawnPlayer(ply, x, y, z, 160, getPedSkin (ply),dim,int)
						setElementHealth(ply, 100)
						setElementFrozen(ply, true)
						toggleAllControls(ply,false)
						startDeathply(ply,300)
						exports.an_infobox:addNotification(ply,"Você esta <b>inconsciente</b>.","erro")
					elseif getElementData(ply, 'incoma') then
						startDeathply(ply,0)
					end
				end
			end
		end
	setTimer(checkplayhealth,500,1)
	end
	addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), checkplayhealth)

	function requestdeath(ply)
		if getElementData(ply, "logado") then
			local plyid = getElementData(ply,"id")
			local playeQ = dbQuery(connnnec,"SELECT * FROM an_death WHERE playerid = ?",plyid)
			local playeH,playeHm = dbPoll(playeQ,-1)
			if playeH then
				for k,v in ipairs(playeH) do
					tid = v["playerid"]
					if getElementData(ply,"id") == tid then
						killPlayeronDeath(ply)
					end
				end
			end
		end
	end
	addEvent ("requestdeath", true)
	addEventHandler ("requestdeath", root, requestdeath)

	function startDeathply(ply,time)
		if time then
			triggerClientEvent( ply,"RequestDeathTimer", ply, time)
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** esta `inconsciente`")
		end
	end

	function removeplydeath(ply)
		triggerClientEvent( ply,"RemoveDeathTimer", ply)
	end

	function killPlayeronDeath(ply)
		if getElementData(ply,"logado") then
			local plyid = getElementData(ply,"id")
			dbExec(connnnec, "DELETE FROM an_death WHERE playerid = ?", plyid)
			spawnPlayer(ply, 1448.155, 2351.512, 12.4+3, 160, getPedSkin(ply), 0,0)
			setElementHealth(ply, 100)
			setElementFrozen(ply, true)
			toggleAllControls(ply, true)
			fadeCamera (ply, false)
			setTimer (setCameraTarget, 500, 1, ply, ply)
			setTimer (fadeCamera, 500, 1, ply, true)
			for i,v in ipairs (itemtb) do
				local itm = getElementData(ply,v[2])
				exports.an_inventory:sattitem2(ply,v[2],itm,"menos")
			end
			local plymonw = getElementData(ply,"Money")
			exports.an_inventory:sattitem2(ply,"Money",plymonw,"menos")
			setElementData(ply,"MocSlot",0)
			local MocStats = "5"
			local updatemoc = dbExec(connnnec, "UPDATE an_character SET MocStats=? WHERE id =?",MocStats,plyid)
			setElementData(ply,"MocMSlot",5)
			setElementData(ply,"foodstats",100)
			setElementData(ply,"watherstats",100)
			setElementData(ply,"incoma",nil)
			setElementData(ply,'removeHud',nil)
			setElementData(ply,"muitoferido",nil)
			setElementFrozen(ply, false)
			toggleAllControls(ply,true)
			setPedAnimation(ply, nil)
			triggerClientEvent( ply,"RemoveDeathTimer", ply)
			exports.an_infobox:addNotification(ply,"Você <b>morreu</b>, esqueceu de tudo e perdeu <br>tudo que estava na sua <b>mochila</b>","aviso",15000)
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** morreu e perdeu `tudo`")
		end
	end
	addEvent("killPlayeronDeath",true)
	addEventHandler ( "killPlayeronDeath", getRootElement(), killPlayeronDeath)
	----------------------------------------------------------------------------------------------------------------------------------
	-- COMMANDS
	----------------------------------------------------------------------------------------------------------------------------------
	local timerrv = {}
	addCommandHandler("rv",
	function(ply,cmd,id)
		if exports.an_account:hasPermission( ply,'medic.permission' ) then
			local tagertply = exports.an_player:getproxply(ply,3)
			if tagertply then
				local plytargetid = getElementData(tagertply,"id")
				if plytargetid then
					if getElementData(tagertply,"incoma") then
						setElementData(ply,"emacao", true)
						setPedAnimation(ply, "medic", "cpr", -1, true, false, false )
						timerrv[tagertply] = setTimer(function()
							setElementData(ply,"emacao", nil)
							setPedAnimation(ply, nil )
							dbExec(connnnec, "DELETE FROM an_death WHERE playerid = ?",plytargetid)
							setElementData(tagertply,"incoma",nil)
							setElementData(tagertply,"muitoferido",nil)
							setElementData(tagertply,'removeHud',nil)
							setElementFrozen(tagertply,false)
							toggleAllControls(tagertply,true)
							setPedAnimation(tagertply,false)
							setElementHealth(tagertply, 30)
							setPedAnimation(tagertply, nil )
							triggerClientEvent( tagertply,"RemoveDeathTimer", tagertply)
							exports.an_infobox:addNotification(tagertply,"Você foi <b>reanimado</b>, va com o medico para o <b>hospital</b>","info")
							exports.an_infobox:addNotification(ply,"Você reanimou o <b>paciente</b>. leve o mesmo para o <b>hospital</b>","sucesso")
							triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** reviveu o **"..getElementData ( tagertply, "id" ).." - "..getElementData ( tagertply, "Nome" ).." "..getElementData ( tagertply, "SNome" ).."** com `/rv`")
						end,1000*8,1)
					end
				end
			else
				exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
			end
		end
	end)

	addCommandHandler("tratament",
	function(ply,cmd,id)
		if exports.an_account:hasPermission( ply,'medic.permission' ) then
			local tagertply = exports.an_player:getproxply(ply,3)
			if tagertply then
				if getElementData(tagertply,"inmaca") then
					exports.an_infobox:addNotification(ply,"Você deu inicio ao <b>tratamento</b> do <b>paciente</b>!","sucesso")
					exports.an_infobox:addNotification(tagertply,"Você está recebendo o <b>tratamento</b>.","sucesso")
					triggerClientEvent( tagertply,"medicstarttratament", tagertply)
				end
			end
		end
	end)
	----------------------------------------------------------------------------------------------------------------------------------
	-- MACA FUNCTIONS
	----------------------------------------------------------------------------------------------------------------------------------
	function tratamentanimation(ply,typ)
		if typ then
			if typ == "stop" then
				setPedAnimation(ply,nil)
				setElementData(ply,"emacao",false)
				toggleControl(ply,"walk",true)
				toggleControl(ply,"sprint",true)
				toggleControl(ply,"jump",true)
			elseif typ == "start" then
				toggleControl(ply,"sprint",false)
				toggleControl(ply,"walk",false)
				toggleControl(ply,"jump",false)
				setPedAnimation(ply, "crack", "crckdeth2", -1, true, false, false )
				setTimer ( setPedAnimationProgress, 100, 1, ply, "crckdeth2", 1.7)
				setTimer ( setPedAnimationSpeed, 100, 1, ply, "crckdeth2", 0)
				setElementData(ply,"emacao",true)
			end
		end
	end
	addEvent("tratamentanimation",true)
	addEventHandler ( "tratamentanimation", getRootElement(), tratamentanimation)
	----------------------------------------------------------------------------------------------------------------------------------
	-- KILL FEED
	----------------------------------------------------------------------------------------------------------------------------------
	weapons = {
		{"AK-47","AK103","AK-103","AK103ammu"},
		{"M4","M4A1","M4A1","M4A1ammu"},
		{"Colt 45","pistol","M1911","pistolammu"},
		{"Deagle","glock","Glock 19","glockammu"},
		{"Rifle","winchester22","Winchester 22","winchester22ammu"},
		{"Shotgun","remington870","Remington 870","remington870ammu"},
		{"Silenced","taser","Taser","taser"},
		{"Knife","faca","Faca","faca"},
		{"Fist","mao","Mão","mao"},
	} 

	function player_Wasted ( ammo, attacker, weapon, bodypart )
		if ( attacker ) then
			local tempString
			if ( getElementType ( attacker ) == "player" ) then
				for i,v in ipairs (weapons) do
					if getWeaponNameFromID ( weapon ) == v[1] then
						triggerEvent("sendnorthamericalog", source, source,"**"..getElementData ( attacker, "id" ).." - "..getElementData ( attacker, "Nome" ).." "..getElementData ( attacker, "SNome" ).."** matou **"..getElementData ( source, "id" ).." - "..getElementData ( source, "Nome" ).." "..getElementData ( source, "SNome" ).."** com **"..v[3].."**")
					end
				end
			elseif ( getElementType ( attacker ) == "vehicle" ) then
				triggerEvent("sendnorthamericalog", source, source,"**"..getElementData ( source, "id" ).." - "..getElementData ( source, "Nome" ).." "..getElementData ( source, "SNome" ).."** morreu `atropelado`")
			end
		end
	end
	addEventHandler ( "onPlayerWasted", getRootElement(), player_Wasted )
	----------------------------------------------------------------------------------------------------------------------------------
	-- SYSTEM VARIABLES
	----------------------------------------------------------------------------------------------------------------------------------
	function getFreeid()
		local result = dbPoll(dbQuery(connnnec, "SELECT id FROM an_death ORDER BY id ASC"), -1)
		newid = false
		for i, id in pairs (result) do
			if id["id"] ~= i then
				newid = i
				break
			end
		end
		if newid then return newid else return #result + 1 end
	end