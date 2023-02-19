local plyinfos = {}
addCommandHandler("rg",
function(ply,cmd)
    if ply then
        if getElementData(ply,"id") then
            if not plyinfos[ply] then
                plyinfos[ply] = "Passaporte: <b>"..getElementData(ply,"id").."</b><br>Nome: <b>"..getElementData(ply,"Nome").." "..getElementData(ply,"SNome").."</b><br>Idade: <b>"..getElementData(ply,"Age").."  </b> <br>Phone: <b>"..getElementData(ply,"phonenumber").."</b><br>Trabalho: <b>"..getElementData(ply,"user_group").."</b><br>  Banco: <b>$ "..getElementData(ply,"BankMoney").."</b>"
                exports.an_infobox:addNotification(ply,plyinfos[ply],"info",10000)
                setTimer(function()
                    plyinfos[ply] = nil
                end,12000,1)
            end
        end
    end
end)

function policeid(ply,ply2)
    if ply then
        if ply2 then
            if getElementData(ply2,"id") then
                local tplyinfos = "Passaporte: <b>"..getElementData(ply2,"id").."</b><br>Nome: <b>"..getElementData(ply2,"Nome").." "..getElementData(ply2,"SNome").."</b><br>Idade: <b>"..getElementData(ply2,"Age").."  </b> <br>Phone: <b>"..getElementData(ply2,"phonenumber").."</b><br>Trabalho: <b>"..getElementData(ply2,"user_group").."</b><br>  Banco: <b>$ "..getElementData(ply2,"BankMoney").."</b>"
                exports.an_infobox:addNotification(ply,tplyinfos,"info",4000)
            end
        end
    end
end