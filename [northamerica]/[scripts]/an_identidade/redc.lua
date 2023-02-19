local plyinfos = nil
function requestID()
    if getElementData(localPlayer,"id") then
        if not plyinfos then
            plyinfos = "Passaporte: <b>"..getElementData(localPlayer,"id").."</b><br>Nome: <b>"..getElementData(localPlayer,"Nome").." "..getElementData(localPlayer,"SNome").."</b><br>Idade: <b>"..getElementData(localPlayer,"Age").."  </b> <br>Phone: <b>"..getElementData(localPlayer,"phonenumber").."</b><br>Trabalho: <b>"..getElementData(localPlayer,"user_group").."</b><br>  Banco: <b>$ "..getElementData(localPlayer,"BankMoney").."</b>"
            exports.an_infobox:addNotification(plyinfos,"info",10000)
            setTimer(function()
                plyinfos = nil
            end,12000,1)
        end
    end
end
bindKey('F10','down',requestID)