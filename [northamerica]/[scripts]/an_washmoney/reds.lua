----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local whashmoneycol = {}
local whashmoneyped = {}
function createmkswhashmoney()
    for i,v in ipairs (cfg.washmoney) do
        local id,x,y,z,rx,ry,rz,pedid = unpack(v)
        whashmoneycol[v] = createColSphere(x,y,z-0.5,1)
        setElementData(whashmoneycol[v],"idwhashmoney",id)
        setElementData(whashmoneycol[v],"whashmoneymocupada",false)
        setElementData(whashmoneycol[v],"colwhashmoney",whashmoneycol[v])

        whashmoneyped[id] = createPed(pedid,x,y,z)
        setElementRotation(whashmoneyped[id],rx,ry,rz)
        setElementFrozen(whashmoneyped[id],true)
        setElementData(whashmoneyped[id],"npc",true)

    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmkswhashmoney)

local usertimer = {}
addCommandHandler("wash",
function(ply,cmd,qtd)
    if getElementData(ply,"openui") == false then
        if getElementData(ply,"nawhashmoneym") then
            if not isTimer(usertimer[ply]) then
                exports.an_infobox:addNotification(ply,"Fazendo a <b>lavagem</b>...","sucesso")
                usertimer[ply] = setTimer(function()
                    if qtd then
                        local plydirtymoney = getElementData(ply,"DirtyMoney") or 0
                        if tonumber(plydirtymoney) >= tonumber(qtd) then
                            if tonumber(qtd) >= 1000 then
                                if getElementData(ply,"openui") == false then
                                    exports.an_inventory:sattitem(ply,"DirtyMoney",qtd,"menos")
                                    local sortpersent = math.random(50,70)
                                    local requestplypersentmoney = math.percent(sortpersent,tonumber(qtd))
                                    exports.an_inventory:sattitem(ply,"Money",math.round(requestplypersentmoney),"mais")
                                    exports.an_infobox:addNotification(ply,"Você lavou o dinheiro e recebeu <b>"..sortpersent.."%</b> renda: $<b>"..math.round(requestplypersentmoney).."</b>","sucesso")
                                else
                                    exports.an_infobox:addNotification(ply,"Lavagem <b>cancelada</b>","erro")
                                end
                            else
                                exports.an_infobox:addNotification(ply,"Só posso lavar acima de $<b>1000</b>","erro")
                            end
                        else
                            exports.an_infobox:addNotification(ply,"Dinheiro <b>insuficiente</b>","erro")
                        end
                    end
                end,1000,1)
            end
        end
    end
end
)

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)/100
    end
    return false
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------