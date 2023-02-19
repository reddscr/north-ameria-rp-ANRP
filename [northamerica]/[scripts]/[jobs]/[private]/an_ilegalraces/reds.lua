----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local ilegalracescol = {}
local ilegalracesmk = {}
local colracerdoor = {}
function createmksilegalraces()
    for i,v in ipairs (cfg.ilrace) do
        local id,x,y,z,pedid = unpack(v)
        ilegalracescol[v] = createColSphere(x,y,z-0.5,1)
		setElementData(ilegalracescol[v],"idilegalraces",id)
		setElementData(ilegalracescol[v],"ilegalracesmocupada",false)
        setElementData(ilegalracescol[v],"colilegalraces",ilegalracescol[v])
        ilegalracesmk = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
    end
    for i,v in ipairs (cfg.ilegalraces) do
        local id,x,y,z = unpack(v)
        colracerdoor[v] = createColSphere(x,y,z-0.5,3)
		setElementData(colracerdoor[v],"idracerdoor",id)
        setElementData(colracerdoor[v],"colracerdoor",colracerdoor[v])
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksilegalraces)


addCommandHandler("shop",
function(ply,cmd)
    if getElementData(ply,"nailegalracesm") then
        if getElementData(ply,"user_group") == "dk" then
            triggerClientEvent (ply,"openilegalrace",ply)
        end
    end
end
)


function ilracefuncs(ply,data)
    if data then
        if data == "racetkt" then
            if getElementData(ply, "Money") >= 500 then
                exports.an_inventory:sattitem(ply,"Raceticket","1","mais")
                exports.an_inventory:sattitem(ply,"Money","500","menos")
                exports.an_infobox:addNotification(ply,"Você comprou 1x <b>race ticket</b>","sucesso")
            else
                exports.an_infobox:addNotification(ply,"<b>Dinheiro</b> inssuficiente","erro")
            end
        elseif data == "nitro" then
            if getElementData(ply, "Money") >= 2500 then
                exports.an_inventory:sattitem(ply,"Nitro","1","mais")
                exports.an_inventory:sattitem(ply,"Money","2500","menos")
                exports.an_infobox:addNotification(ply,"Você comprou 1x <b>nitrous</b>","sucesso")
            else
                exports.an_infobox:addNotification(ply,"<b>Dinheiro</b> inssuficiente","erro")
            end
        end
    end
end
addEvent ("ilracefuncs", true)
addEventHandler ("ilracefuncs", root, ilracefuncs)


function openorcloseracerdoor(ply)
    if ply then
        if (not isGarageOpen(31)) then
            setGarageOpen(31, true)
        else
            setGarageOpen(31, false)
		end
    end
end
addEvent ("openorcloseracerdoor", true)
addEventHandler ("openorcloseracerdoor", root,openorcloseracerdoor)

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