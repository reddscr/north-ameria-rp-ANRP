----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------


local ilegalrace = {}
local ilegalracecol = {}
function createmksilegalrace()
    for i,v in ipairs (cfg.localraces) do
        local id,x,y,z = unpack(v)
        ilegalrace = createMarker(x,y,z -1, "cylinder", 13.5, 255, 77, 77, 25)
        ilegalracecol[v] = createColSphere(x,y,z-0.5,7)
		setElementData(ilegalracecol[v],"idilegalrace",id)
		setElementData(ilegalracecol[v],"colilegalrace",ilegalracecol[v])
		setElementData(ilegalracecol[v],"racepoint",1)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksilegalrace)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local pay = {
	[1] = { ['min'] = 3100, ['max'] = 4700 },
	[2] = { ['min'] = 3100, ['max'] = 4700 },
	[3] = { ['min'] = 3100, ['max'] = 4700 },
	[4] = { ['min'] = 3100, ['max'] = 4700 },
	[5] = { ['min'] = 3100, ['max'] = 4700 },
	[6] = { ['min'] = 3100, ['max'] = 4700 },
}
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local racepoint = 1
function randomracepointcfg()
    racepoint = math.random(#pay)
	for k,v in pairs(ilegalracecol) do
		setElementData(ilegalracecol[k],"racepoint",racepoint)
	end
setTimer(randomracepointcfg,180000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), randomracepointcfg)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function paymentply_ilegalrace(ply,raceid)
    if raceid then
		local random = math.random(pay[raceid].min,pay[raceid].max)
		if random then
			local policia = exports.an_police:getpoliceinservicesv()
			if policia <= 0 then
				exports.an_inventory:sattitem(ply,"Money",math.round(random),"mais")
			end
			if policia >= 2 then
				exports.an_inventory:sattitem(ply,"Money",math.round((random*policia)*0.7),"mais")
			end
			exports.an_infobox:addNotification(ply,"<b>Corrida</b> finalizada com <b>sucesso</b>!","sucesso")
			for i,p in ipairs (getElementsByType("player")) do
				if exports.an_account:hasPermission(p, 'police.permission') then
					if getElementData(p,"policetoggle") then
						triggerClientEvent( p,"destoyilraceblip", p,ply)
					end
				end
			end
		end
    end
end
addEvent ("paymentply_ilegalrace", true)
addEventHandler ("paymentply_ilegalrace", root, paymentply_ilegalrace)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function plyinitrage(ply)
	local plyx,plyy,plyz = getElementPosition(ply)
	exports.an_wanted:setplywanted(ply,20)
	for i,p in ipairs (getElementsByType("player")) do
		if exports.an_account:hasPermission(p, 'police.permission') then
			if getElementData(p,"policetoggle") then
				exports.an_infobox:addNotification(p,"Encontramos um <b>corredor ilegal</b> na cidade, intercepte-o ele foi marcado em vermelho no seu <b>GPS</b>","aviso")
				triggerClientEvent( p,"bliprace", p,ply)
			end
		end
	end
end
addEvent ("plyinitrage", true)
addEventHandler ("plyinitrage", root, plyinitrage)

function destroyplyblip(ply)
	for i,p in ipairs (getElementsByType("player")) do
		if exports.an_account:hasPermission(p, 'police.permission') then
			if getElementData(p,"policetoggle") then
				triggerClientEvent( p,"destoyilraceblip", p, ply)
			end
		end
	end
end
addEvent ("destroyplyblip", true)
addEventHandler ("destroyplyblip", root, destroyplyblip)

function plyquitdestroypoliceblip()
    if getElementData(source, "inilegalrace") then 
		triggerClientEvent(getRootElement(), "destoyilraceblip", getRootElement(),source)
		if isPedInVehicle ( source ) then
			veh = getPedOccupiedVehicle ( source )
			if veh then
				local getvehf = getElementData(veh,"fuel")
                setVehicleEngineState(veh,false)
                setElementData(veh, "fuel", getElementData(veh, "fuel") - getvehf) 
			end
		end
    end
end
addEventHandler ("onPlayerQuit", getRootElement(), plyquitdestroypoliceblip)
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