

local missionitens2 = {
    ['pistolammu'] = 80,
    ['AK103ammu'] = 150,
    ['winchester22ammu'] = 120
}

function finishMafiadelJob(ply,qtd,item)
    if qtd then
        if item then
            local idata = exports.an_account:servergetitemtable2(item)
            if idata then
                if getElementData(ply,idata[2]) >= qtd then
                    exports.an_inventory:sattitem(ply,idata[2],qtd,"menos")
                    exports.an_inventory:sattitem(ply,"Money",missionitens2[idata[2]]*qtd,"mais")
                else
                    exports.an_infobox:addNotification(ply,"Você não tem "..qtd.."x <b>"..idata[5].."</b>","erro")
                end
            end
        end
    end
end
addEvent("finishMafiadelJob", true)
addEventHandler("finishMafiadelJob", root, finishMafiadelJob)