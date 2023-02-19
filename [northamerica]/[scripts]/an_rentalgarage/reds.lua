-----------------------------------------------------------------------------------------------------------
-- reantalgarage
-----------------------------------------------------------------------------------------------------------
local centralreantalgaragemk = {}
local centralreantalgaragecol = {}
function bildreantalgaragecol ()
    for i,v in ipairs (cfg.localreantalgarages) do
        local id,x,y,z,group,typ,jobdata = unpack(v)
        centralreantalgaragemk[id] = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
        centralreantalgaragecol[id] = createColSphere(x,y,z-0.5,1)
        setElementData(centralreantalgaragecol[id],"rentalgaragetype",typ)
        setElementData(centralreantalgaragecol[id],"rentalgaragegroup",group)
        setElementData(centralreantalgaragecol[id],"jobvehdatarentals",jobdata)
        setElementData(centralreantalgaragecol[id],"idcentralreantalgarage",id)
        setElementData(centralreantalgaragecol[id],"centralreantalgaragedisp",false)
        setElementData(centralreantalgaragecol[id],"colcentralreantalgarage",centralreantalgaragecol[id])
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), bildreantalgaragecol)

function fechaptreantalgaragesonquit()
    if getElementData(source,"nacentralreantalgarage") then
        setElementData(getElementData(source,"centralreantalgarage"),"centralreantalgaragedisp",false)
    end
end
addEventHandler ("onPlayerQuit", root, fechaptreantalgaragesonquit)
-----------------------------------------------------------------------------------------------------------
-- rental
-----------------------------------------------------------------------------------------------------------
vehsreantal = {}
function pegvehreantalgarage(ply,vehid,vehname,thecol,price)
    local veh = tonumber(vehid)
    local plyid = getElementData(ply,"id")
    local nome = getElementData(ply,"Nome")
    local snome = getElementData(ply,"SNome")
    local colid = getElementData(thecol,"idcentralreantalgarage")
    local garagetyp = getElementData(thecol,"rentalgaragetype")
    local vehjobdata = getElementData(thecol,"jobvehdatarentals")
    local vehjobdata2 = getElementData(thecol,"rentalgaragegroup")
    if not isElement(vehsreantal[plyid]) then
        if price then
            if getElementData(ply, "Money") >= price then
                if veh then
                    local x, y, z = getElementPosition(ply)
                    local rx,ry,rz = getElementRotation(ply)
                    if garagetyp == "pescador" then
                        vehsreantal[plyid] = createVehicle(veh,-104.744, -554.51, 8.864,0, 0, 137.011)
                    elseif garagetyp == "barcos" then
                        vehsreantal[plyid] = createVehicle(veh,302.039, -1916.793, 6.023,0, 0, 137.011)
                    elseif garagetyp == "caminhao" then
                        vehsreantal[plyid] = createVehicle(veh,x, y, z+1.5,rx,ry,rz)
                    elseif garagetyp == "medic" then
                        vehsreantal[plyid] = createVehicle(veh,x, y, z+1.5,rx,ry,rz)
                        setVehicleColor( vehsreantal[plyid], 255, 255, 255 )
                    elseif garagetyp == "police" then
                        vehsreantal[plyid] = createVehicle(veh,x, y, z+1.5,rx,ry,rz)
                        setVehicleColor( vehsreantal[plyid], 255, 255, 255 )
                    elseif garagetyp == "policeheli" then
                        vehsreantal[plyid] = createVehicle(veh,x, y, z+5,rx,ry,rz)
                        setVehicleColor( vehsreantal[plyid], 255, 255, 255 )
                    else
                        vehsreantal[plyid] = createVehicle(veh,x, y, z,rx,ry,rz)
                    end
                    warpPedIntoVehicle (ply,vehsreantal[plyid])
                    setElementData(vehsreantal[plyid],"owner",plyid)
                    setElementData(vehsreantal[plyid],"rentalvehgarage",colid)
                    setElementData(vehsreantal[plyid],"vehjobdatas",vehjobdata)
                    setElementData(vehsreantal[plyid],"vehjobdatas2",vehjobdata2)
                    setElementData(vehsreantal[plyid],"rentalveh",true)
                    setElementData(vehsreantal[plyid],"fuel",100)
                    setVehicleOverrideLights ( vehsreantal[plyid], 1 )
                    setElementData(vehsreantal[plyid],"Nome",nome)
                    setElementData(vehsreantal[plyid],"Snome",snome)   
                    if price > 0 then
                        exports.an_inventory:sattitem(ply,"Money",price,"menos")
                    end
                    triggerClientEvent(ply,"closereantalgarage",ply)
                    exports.an_infobox:addNotification(ply,"Você alugou o veiculo <b>"..vehname.."</b> pelo valor $<b>"..price.."</b>.","sucesso")
                end
            else
                exports.an_infobox:addNotification(ply,"Você não tem <b>dinheiro</b> suficiente.","erro")
            end
        end
    else
        exports.an_infobox:addNotification(ply,"Você já possui um <b>veiculo</b> alugado.","erro")
    end
end
addEvent ("pegvehreantalgarage", true)
addEventHandler ("pegvehreantalgarage", root, pegvehreantalgarage)

function guavehreantalgaragesv(ply,thecol)
    local colid = getElementData(thecol,"idcentralreantalgarage")
    local vehjobdata2 = getElementData(thecol,"rentalgaragegroup")
    local vehicl = exports.an_player:getproxveh(ply,20)
    local plyid = getElementData(ply,"id")
    if vehicl then
        if getElementData(vehicl,"rentalveh") then
            if getElementData(vehicl,"vehjobdatas2") == 'desempregado' or vehjobdata2 == getElementData(vehicl,"vehjobdatas2") then
                if getElementData(vehicl, "owner") == plyid then
                    if isElement(vehsreantal[plyid])  then
                        if getElementData(ply,"mechanicguincho") then
                            setElementData(ply,"mechanicguincho",nil)
                        end
                        local gettowerdcar = getElementData(vehsreantal[plyid],"towlevandocar")
                        if gettowerdcar then
                            attachElements(gettowerdcar, vehsreantal[plyid], 0, -10, 1.2)
                            attachElements(gettowerdcar, vehsreantal[plyid], 0, -10, 0)
                            detachElements(gettowerdcar)
                            setElementData(vehsreantal[plyid],"towlevandocar",nil)
                        end
                        destroyElement(vehsreantal[plyid])
                        vehsreantal[plyid] = nil
                        exports.an_infobox:addNotification(ply,"<b>Veiculo</b> devolvido com sucesso.","sucesso")
                    end
                else
                    exports.an_infobox:addNotification(ply,"Este <b>veiculo</b> não pertence a <b>você</b>.","erro")
                end
            else
                exports.an_infobox:addNotification(ply,"Este <b>veiculo</b> não pertence a esta <b>garagem</b>.","aviso")
            end
        else
            exports.an_infobox:addNotification(ply,"O <b>veiculo</b> próximo a você não é <b>alugado</b>.","aviso")
        end
    else
        exports.an_infobox:addNotification(ply,"Não há <b>veiculos</b> próximo.","erro") 
    end
end
addEvent ("guavehreantalgaragesv", true)
addEventHandler ("guavehreantalgaragesv", root, guavehreantalgaragesv)

local timerfordelete = {}
function destroyalugvMissionOnQuit()
    local plyid = getElementData(source,"id")
    if isElement(vehsreantal[plyid]) then
        if not isTimer(timerfordelete[plyid]) then
            timerfordelete[plyid] = setTimer(function()
                local gettowerdcar = getElementData(vehsreantal[plyid],"towlevandocar")
                if gettowerdcar then
                    attachElements(gettowerdcar, vehsreantal[plyid], 0, -10, 1.2)
                    attachElements(gettowerdcar, vehsreantal[plyid], 0, -10, 0)
                    detachElements(gettowerdcar)
                    setElementData(vehsreantal[plyid],"towlevandocar",nil)
                end
                destroyElement(vehsreantal[plyid])
                vehsreantal[plyid] = nil
            end,60000*15,1)
        end
    end
end
addEventHandler("onPlayerQuit",getRootElement(),destroyalugvMissionOnQuit)

function resettimerdeletevehrental(id)
    if isTimer(timerfordelete[id]) then
        killTimer(timerfordelete[id])
    end
end
addEvent ("resettimerdeletevehrental", true)
addEventHandler ("resettimerdeletevehrental", root, resettimerdeletevehrental)
-----------------------------------------------------------------------------------------------------------
-- variaveis
-----------------------------------------------------------------------------------------------------------