----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------


local raceboat = {}
local raceboatcol = {}
function createmksraceboat()
    for i,v in ipairs (cfg.localraces) do
        local id,x,y,z = unpack(v)
        raceboat = createMarker(x,y,z -35, "cylinder", 35, 200, 200, 200, 100)
        raceboatcol[v] = createColSphere(x,y,z-0.5,25)
		setElementData(raceboatcol[v],"idraceboat",id)
		setElementData(raceboatcol[v],"colraceboat",raceboatcol[v])
		setElementData(raceboatcol[v],"raceboatpoint",1)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksraceboat)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local pay = {
	[1] = { ['min'] = 100, ['max'] = 200 },
	[2] = { ['min'] = 100, ['max'] = 200 },
}
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local raceboatpoint = 1
function randomraceboatpointcfg()
    raceboatpoint = math.random(#pay)
	for k,v in pairs(raceboatcol) do
		setElementData(raceboatcol[k],"raceboatpoint",raceboatpoint)
	end
setTimer(randomraceboatpointcfg,180000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), randomraceboatpointcfg)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function paymentply_raceboat(ply,raceid)
    if raceid then
		local random = math.random(pay[raceid].min,pay[raceid].max)
		if random then
			exports.an_inventory:sattitem(ply,"Money",math.round(random),"mais")
			exports.an_infobox:addNotification(ply,"<b>Corrida</b> finalizada com <b>sucesso</b>!","sucesso")
		end
    end
end
addEvent ("paymentply_raceboat", true)
addEventHandler ("paymentply_raceboat", root, paymentply_raceboat)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------z
function plyquitdestroypoliceblip()
    if getElementData(source, "inraceboat") then 
        triggerClientEvent(getRootElement(), "destoyilraceblip", getRootElement(),source)
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