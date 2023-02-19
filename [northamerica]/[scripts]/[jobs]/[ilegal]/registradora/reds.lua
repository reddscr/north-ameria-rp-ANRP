----------------------------------------------------------------------------------------------------------------
-- ANIMATIONS
----------------------------------------------------------------------------------------------------------------
local machineTimer = {}
local machineregister = {}
function requestmachineregister(ply,machine)
	local policeinservice = exports.an_police:getpoliceinservicesv()
	if policeinservice >= 2 then
		local rmachine = machine
		if not machineregister[machine] then
			machineregister[machine] = machine
			setPedAnimation(ply, "int_shop", "shop_loop", true, false, false)
			setElementData(ply,"emacao",true)
			triggerClientEvent(ply,"confirmstartmachineregister",ply)
			exports.an_wanted:setplywanted(ply,15)
			local plyid = getElementData(ply,"id")
			local x,y,z = getElementPosition(ply)
			local pos = toJSON({x,y,z})
			exports.an_sounds:setalarmsound(pos,120)
			triggerEvent("sendnorthamericalog", ply, ply,"**"..getElementData ( ply, "id" ).." - "..getElementData ( ply, "Nome" ).." "..getElementData ( ply, "SNome" ).."** `Está roubando um caixa registradora`!")
			if math.random(0,100) > 50 then
				exports.an_infobox:addNotification(ply,"A <b>policia</b> foi acionada!","aviso")
				exports.an_emergencycall:createemgblipsv(plyid,x,y,z,"Esta acontecendo um roubo na <b>loja</b> marcada, vá até o local e verifique.")
			end
		else
			exports.an_infobox:addNotification(ply,"Esta <b>registradora</b> não tem dinheiro","aviso")
		end
	else
		exports.an_infobox:addNotification(ply,"Não há a quantidade necessária de <b>policiais</b> no momento","aviso")
	end
end
addEvent ("requestmachineregister", true)
addEventHandler ("requestmachineregister", root, requestmachineregister)
----------------------------------------------------------------------------------------------------------------
-- FINISH MACHINE
----------------------------------------------------------------------------------------------------------------
function stopmachineregister(ply,machine)
	setPedAnimation(ply, nil)
	setElementData(ply,"emacao",false)
	local rmoney = math.random(1000,4500)
	exports.an_inventory:sattitem(ply,"Money",rmoney,"mais")
	timermechineregister(machine)
	exports.an_infobox:addNotification(ply,"Roubo <b>finalizado</b>!","sucesso")
end
addEvent ("stopmachineregister", true)
addEventHandler ("stopmachineregister", root, stopmachineregister)

function stopmachineregister2(ply,machine)
	setPedAnimation(ply, nil)
	setElementData(ply,"emacao",false)
	timermechineregister(machine)
	exports.an_infobox:addNotification(ply,"Roubo <b>cancelado</b>","aviso")
end
addEvent ("stopmachineregister2", true)
addEventHandler ("stopmachineregister2", root, stopmachineregister2)
----------------------------------------------------------------------------------------------------------------
-- MACHINE TIMER
----------------------------------------------------------------------------------------------------------------
function timermechineregister(machine)
	if not isTimer(machineTimer[machine]) then
		machineTimer[machine] = setTimer(function()
			machineregister[machine] = nil
		end,20*60000,1)
	end
end
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
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