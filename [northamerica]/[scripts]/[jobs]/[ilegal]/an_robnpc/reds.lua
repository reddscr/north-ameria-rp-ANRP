-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	[1] = { ['index'] = "Marijuana", ['qtd'] = 1 },
	[2] = { ['index'] = "Relogioroubado", ['qtd'] = 1 },
	[3] = { ['index'] = "Pulseiraroubada", ['qtd'] = 1 },
	[4] = { ['index'] = "Anelroubado", ['qtd'] = 1 },
	[5] = { ['index'] = "Colarroubado", ['qtd'] = 1 },
	[6] = { ['index'] = "Brincoroubado", ['qtd'] = 2 },
	[7] = { ['index'] = "Carteiraroubada", ['qtd'] = 1 },
	[8] = { ['index'] = "Tabletroubado", ['qtd'] = 1 },
	[9] = { ['index'] = "Sapatosroubado", ['qtd'] = 2 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
local npcTimer = {}
function startrobnpc(ply,npc)
    if npc then
        if not isTimer(npcTimer[npc]) then
            local plyid = getElementData(ply,"id")
            local x,y,z = getElementPosition(ply)
            if math.random(0,100) > 80 then
                exports.an_infobox:addNotification(ply,"A <b>policia</b> foi acionada!","aviso")
                local policeinservice = exports.an_police:getpoliceinservicesv()
                if policeinservice >= 2 then
                    exports.an_wanted:setplywanted(ply,5)
                    exports.an_emergencycall:createemgblipsv(plyid,x,y,z,"Denúncia de <b>roubo</b> a civil, vá até o local e verifique.")
                end
            end
            setElementFrozen( npc, true)
            setPedAnimation( npc, "shop", "shp_rob_handsup" )
            npcTimer[npc] = setTimer(function()
                setPedAnimation( npc, nil)
                setElementFrozen( npc, false)
                setPedAnimation(ply, "CRIB", "CRIB_Use_Switch")
                setTimer(setPedAnimation, 1000, 1, ply, nil)
                setElementData(npc,'npcbuydrug',true)
                setElementData(npc,'npcrobbed',true)
                setPedAnimation(npc, "CRIB", "CRIB_Use_Switch")
                setTimer(setPedAnimation, 1000, 1, npc, nil)
                triggerClientEvent( ply, "finisedrobnpc", ply)
                local randitem = math.random(#itemlist)
                local idata = exports.an_account:servergetitemtable2(itemlist[randitem].index)
                if idata then
                    if getElementData(ply, "MocSlot") + idata[4]*itemlist[randitem].qtd < getElementData(ply, "MocMSlot") then
                        exports.an_inventory:sattitem( ply, idata[2], itemlist[randitem].qtd, "mais" )
                    else
                        exports.an_infobox:addNotification("A <b>mochila</b> está sem espaço!","aviso")
                    end
                end
                exports.an_inventory:sattitem( ply, 'Money', math.random(20,120), "mais" )
            end,1000*10, 1)
        end
    end
end
addEvent("startrobnpc", true)
addEventHandler("startrobnpc", root, startrobnpc)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFY
-----------------------------------------------------------------------------------------------------------------------------------------
function cancelorverifyrobnpc(ply,npc)
    if npc then
        if isTimer(npcTimer[npc]) then
            killTimer(npcTimer[npc])
            setPedAnimation( npc, nil )
            setElementFrozen( npc, false)
            triggerClientEvent( ply, "finisedrobnpc", ply)
        end
    end
end
addEvent("cancelorverifyrobnpc", true)
addEventHandler("cancelorverifyrobnpc", root, cancelorverifyrobnpc)
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------