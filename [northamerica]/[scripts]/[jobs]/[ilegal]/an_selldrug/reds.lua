-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
local pay = 0

function finishiselldrug(ply,npc, item, qtd, policests)
	if npc then
		local idata = exports.an_account:servergetitemtable2(item)
		if idata then
			local getplydata = getElementData(ply, idata[2]) or 0
			if getplydata >= qtd then
				if policests >= 2 then
					pay = math.random(350,950)
					exports.an_inventory:sattitem(ply,idata[2],qtd,"menos")
					exports.an_inventory:sattitem(ply,"Money",pay*qtd,"mais")
					setPedAnimation(ply, "CRIB", "CRIB_Use_Switch")
					setTimer(setPedAnimation, 1000, 1, ply, nil)
					setElementData(npc,'npcbuydrug',true)
					setElementData(npc,'npcrobbed',true)
					setPedAnimation(npc, "CRIB", "CRIB_Use_Switch")
					setTimer(setPedAnimation, 1000, 1, npc, nil)
					--exports.an_infobox:addNotification(ply,"Você vendeu "..qtd.."x <b>"..idata[5].."</b> e recebeu $ <b>"..pay*qtd.."</b> dinheiro sujo","sucesso")
				else
					pay = math.random(100,700)
					exports.an_inventory:sattitem(ply,idata[2],qtd,"menos")
					exports.an_inventory:sattitem(ply,"Money",pay*qtd,"mais")
					setPedAnimation(ply, "CRIB", "CRIB_Use_Switch")
					setTimer(setPedAnimation, 1000, 1, ply, nil)
					setElementData(npc,'npcbuydrug',true)
					setElementData(npc,'npcrobbed',true)
					setPedAnimation(npc, "CRIB", "CRIB_Use_Switch")
					setTimer(setPedAnimation, 1000, 1, npc, nil)
					--exports.an_infobox:addNotification(ply,"Você vendeu "..qtd.."x <b>"..idata[5].."</b> e recebeu $ <b>"..pay*qtd.."</b> dinheiro sujo","sucesso")
				end
			else
				exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x <b>"..idata[5].."</b>","aviso")
			end
		end
	end
end
addEvent("finishiselldrug", true)
addEventHandler("finishiselldrug", root, finishiselldrug)

function policechance(ply,npc)
	local plyid = getElementData(ply,"id")
	local x,y,z = getElementPosition(ply)
	if math.random(0,100) > 65 then
		setElementData(npc,'npcbuydrug',true)
		triggerClientEvent( ply,"calcelselldrug", ply)
		exports.an_infobox:addNotification(ply,"A <b>policia</b> foi acionada!","aviso")
		local policeinservice = exports.an_police:getpoliceinservicesv()
		if policeinservice >= 2 then
			exports.an_wanted:setplywanted(ply,5)
			exports.an_emergencycall:createemgblipsv(plyid,x,y,z,"Denúncia de venda de <b>drogas</b>, vá até o local e verifique.")
		end
	end
end
addEvent("policechance", true)
addEventHandler("policechance", root, policechance)
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------