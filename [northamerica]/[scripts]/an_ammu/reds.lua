




local usertimer = {}
function buyammushop(ply,data,data2,data3)
    if not isTimer(usertimer[ply]) then
        if data then
            local idata = exports.an_account:servergetitemtable2(data)
            if getElementData(ply,"Money") >= tonumber(data2) then
                if getElementData(ply, "MocSlot") +  idata[4]*data3 < getElementData(ply, "MocMSlot") then
                    exports.an_inventory:sattitem(ply,"Money",data2,"menos")
                    exports.an_inventory:sattitem(ply,idata[2],data3,"mais")
                    exports.an_infobox:addNotification(ply,"Comprado "..data3.."x <b>"..idata[5].."</b>!","sucesso")
                    usertimer[ply] = setTimer(function()
                    end,1200,1)
                else
                    exports.an_infobox:addNotification(ply,"A <b>mochila</b> não tem espaço.","erro")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem $ <b>"..data2.."</b>.","erro")
            end
        end
    end
end
addEvent ("buyammushop", true)
addEventHandler ("buyammushop", root, buyammushop)









