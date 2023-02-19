----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
------------------------------------------------------------------------------------------------------------------
-- FUEL SYSTEM
------------------------------------------------------------------------------------------------------------------
local lookatfuelpump = false
local fuelingveh = false
function dxpressforpanel()
    local proxyonply = getproxyonply(2)
    if proxyonply then
        if not isPedInVehicle(localPlayer) then
            for i,v in ipairs (cfg.fuelpumps) do
                local fid,x,y,z,rx,ry,rz,price = unpack(v)
                if fid == proxyonply then
                    lookatfuelpump = fid
                    toggleControl ( "next_weapon", false )
                    toggleControl ( "previous_weapon", false )
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.2, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        dxDrawRectangle(WorldPositionX - 80, WorldPositionY -35, 160, 20, tocolor(0, 0, 0, 115), false)
                        dxDrawColorText("#efe558$ "..price.." #d6d6d6p/LITRO", WorldPositionX - 1, WorldPositionY -50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        dxDrawRectangle(WorldPositionX - 80, WorldPositionY -10, 160, 20, tocolor(0, 0, 0, 115), false)
                        dxDrawColorText("#efe558E #d6d6d6 ABASTECER", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                        dxDrawRectangle(WorldPositionX - 80, WorldPositionY +15, 160, 20, tocolor(0, 0, 0, 115), false)
                        dxDrawColorText("#efe558N #d6d6d6 COMPRAR GALÂO #efe558$ 100", WorldPositionX - 1, WorldPositionY + 50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                    local proxyonveh = exports.an_player:getproxclientveh(2)
                    if proxyonveh then
                        local vehfuel = getElementData(proxyonveh,"fuel")
                        if vehfuel then
                            local xv, xy, xz = getElementPosition(proxyonveh)
                            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(xv, xy, xz+0.2, 0.07)
                            if (WorldPositionX and WorldPositionY) then
                                dxDrawColorText("#000000"..vehfuel.."%", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1, myFont, "center", "center", false, false, false, false, false)
                                dxDrawColorText("#efe558"..vehfuel.."%", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                            end
                        end
                    end
                end
            end
        else
            toggleControl ( "next_weapon", true )
            toggleControl ( "previous_weapon", true )
            lookatfuelpump = false
            if fuelingveh then
                setElementData(localPlayer,"fueling",nil)
                setElementData(fuelingveh,"fueling",nil)
                fuelingveh = false
                triggerServerEvent ("fuellinganim", localPlayer,localPlayer,"stop") 
            end
        end
    else
        toggleControl ( "next_weapon", true )
        toggleControl ( "previous_weapon", true )
        lookatfuelpump = false
        if fuelingveh then
            setElementData(localPlayer,"fueling",nil)
            setElementData(fuelingveh,"fueling",nil)
            fuelingveh = false
            triggerServerEvent ("fuellinganim", localPlayer,localPlayer,"stop") 
        end
    end
    if lookatfuelpump then
        if fuelingveh then
            local xp, yp, zp = getElementPosition(localPlayer)
            local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(xp, yp, zp+0.2, 0.07)
            if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#efe558E #d6d6d6PARAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            end
        end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)
------------------------------------------------------------------------------------------------------------------
-- START FUEL
------------------------------------------------------------------------------------------------------------------
function fuelingvehicle()
    local vehicl = exports.an_player:getproxclientveh(2)
    if vehicl then
        if not fuelingveh then
            if not getElementData(vehicl,"fueling") then
                for i,v in ipairs (cfg.fuelpumps) do
                    local fid,x,y,z,rx,ry,rz,price = unpack(v)
                    if fid == lookatfuelpump then
                        if getElementData(localPlayer,"Money") >= tonumber(price) then
                            fuelingveh = vehicl
                            setElementData(vehicl,"fueling",true)
                            setElementData(localPlayer,"fueling",fuelingveh)
                            triggerServerEvent ("fuellinganim", localPlayer,localPlayer,"start") 
                        else
                            exports.an_infobox:addNotification("<b>Dinheiro</b> insuficiente","erro") 
                        end
                    end
                end
            else
                exports.an_infobox:addNotification("Este <b>veiculo</b> já está sendo abastecido.","aviso") 
            end
        else
            setElementData(localPlayer,"fueling",nil)
            setElementData(fuelingveh,"fueling",nil)
            fuelingveh = false
            triggerServerEvent ("fuellinganim", localPlayer,localPlayer,"stop") 
        end
    end
end
bindKey("e","down",fuelingvehicle)
------------------------------------------------------------------------------------------------------------------
-- BUY FUEL GALLON
------------------------------------------------------------------------------------------------------------------
function buyfuelgallon()
    if lookatfuelpump then
        if getElementData(localPlayer,"Money") >= 100 then
            local itemdb = exports.an_account:getitemtable(27)
            if itemdb then
                if getElementData(localPlayer,"MocSlot") + itemdb[4]*1 < getElementData(localPlayer,"MocMSlot") then
                    exports.an_inventory:attitem("Money","100","menos")
                    exports.an_inventory:attitem(itemdb[2],"1","mais")
                    exports.an_infobox:addNotification("Comprado 1x <b>Combustível</b>.","sucesso") 
                else
                    exports.an_infobox:addNotification("A <b>mochila</b> não tem espaço.","erro")
                end
            end
        else
            exports.an_infobox:addNotification("<b>Dinheiro</b> insuficiente","erro") 
        end
    end
end
bindKey("n","down",buyfuelgallon)
------------------------------------------------------------------------------------------------------------------
-- FUELING VEH
------------------------------------------------------------------------------------------------------------------
function abastecendoveh()
    if lookatfuelpump then
        if fuelingveh then
            for i,v in ipairs (cfg.fuelpumps) do
                local fid,x,y,z,rx,ry,rz,price = unpack(v)
                if fid == lookatfuelpump then
                    if getElementData(localPlayer,"Money") >= tonumber(price) then
                        if tonumber(getElementData(fuelingveh,"fuel")) <= 99 then
                            setElementData(fuelingveh, "fuel", getElementData(fuelingveh, "fuel") + 1) 
                            exports.an_inventory:attitem("Money",price,"menos")
                        else
                            exports.an_infobox:addNotification("O tanque do <b>veiculo</b> esta cheio","aviso") 
                            setElementData(fuelingveh,"fueling",nil)
                            setElementData(localPlayer,"fueling",nil)
                            fuelingveh = false
                            triggerServerEvent ("fuellinganim", localPlayer,localPlayer,"stop") 
                        end
                    else
                        exports.an_infobox:addNotification("<b>Dinheiro</b> insuficiente","erro")
                    end
                end
            end
        end
    end
    setTimer(abastecendoveh,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), abastecendoveh)
------------------------------------------------------------------------------------------------------------------
-- GET PROX FUELPUMP
------------------------------------------------------------------------------------------------------------------
function getproxyonply(distance)
  local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i,v in ipairs (cfg.fuelpumps) do
        local fid,x,y,z,rx,ry,rz = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
            id = fid
        end
    end
    if id then
        return id
    else
        return false
    end
end
------------------------------------------------------------------------------------------------------------------
-- Pumps
------------------------------------------------------------------------------------------------------------------
fuelpump = {}
function setobjprop()
    for i,v in ipairs (cfg.fuelpumps) do
        local id,x,y,z,rx,ry,rz = unpack(v)
        fuelpump[id] = createObject ( 1676, x,y,z+0.4,rx,ry,rz )
        setObjectBreakable(fuelpump[id], false)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), setobjprop)
------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
------------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY)
  bx, by, color, scale, font = bx or ax, by or ay, color or tocolor(255,255,255,255), scale or 1, font or Font_5
  if alignX then
    if alignX == "center" then
      ax = ax + (bx - ax - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font))/2
    elseif alignX == "right" then
      ax = bx - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
    end
  end
  if alignY then
    if alignY == "center" then
      ay = ay + (by - ay - dxGetFontHeight(scale, font))/2
    elseif alignY == "bottom" then
      ay = by - dxGetFontHeight(scale, font)
    end
  end
   local clip = false
   if dxGetTextWidth(str:gsub("#%x%x%x%x%x%x","")) > bx then clip = true end
  local alpha = string.format("%08X", color):sub(1,2)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  local text = ""
  local broke = false
  while s do
    if cap == "" and col then color = tocolor(getColorFromString("#"..col..alpha)) end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
           if clip then
                local text_ = ""
                 for i = 1,string.len(cap) do
                  if dxGetTextWidth(text,scale,font) < bx then
                  text = text..""..string.sub(cap,i,i)
                  text_ = text_..""..string.sub(cap,i,i)
                  else
                  broke = true
                   break
                  end
                 end
                 cap = text_
                end
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(getColorFromString("#"..col..alpha))
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str and not broke then
    cap = str:sub(last)
                   if clip then
                local text_ = ""
                 for i = 1,string.len(cap) do
                  if dxGetTextWidth(text,scale,font) < bx then
                  text = text..""..string.sub(cap,i,i)
                  text_ = text_..""..string.sub(cap,i,i)
                  else
                  broke = true
                   break
                  end
                 end
                 cap = text_
                end
    dxDrawText(cap, ax, ay, ax + dxGetTextWidth(cap, scale, font), by, color, scale, font)
  end
end
-------------------------------------------------------------------------------------------------------------------
-- FUEL VARIAVEIS
-------------------------------------------------------------------------------------------------------------------
addEventHandler ( "onClientVehicleEnter", root,
	function ( thePlayer, seat )
		if ( thePlayer == localPlayer ) and ( seat == 0 ) then
			if ( fuelTimer ) and ( isTimer( fuelTimer ) ) then killTimer( fuelTimer ) end
			if not ( getElementData ( source, "fuel" ) ) then
				setElementData ( source, "fuel", 100 )
			elseif ( tonumber(getElementData ( source, "fuel" )) <= 0 ) then
				disableVehicleFunctions( source )
			else
				enableVehicleFunctions( source )
			end

			if ( doEventHandlers ) then
				addEventHandler ( "onClientVehicleExit", source, onVehicleExitDestroy, false )
				addEventHandler ( "onClientElementDestroy", source, onVehicleExitDestroy, false )
				doEventHandlers = false
			end

			fuelTimer = setTimer ( onDecreaseFuel, 30000, 0 )
		end
	end
)

function disableVehicleFunctions ( theVehicle )
	if ( fuelTimer ) and ( isTimer( fuelTimer ) ) then killTimer( fuelTimer ) end
	setVehicleEngineState( theVehicle, false )
	toggleControl ( "accelerate", false )
	toggleControl ( "brake_reverse", false )
	

end

function enableVehicleFunctions( theVehicle )
	setVehicleEngineState( theVehicle, true )
	toggleControl ( "accelerate", true )
	toggleControl ( "brake_reverse", true )
end

addEventHandler ( "onClientResourceStart", resourceRoot,
	function ()
		if ( getPedOccupiedVehicle ( localPlayer ) ) and ( getVehicleOccupant ( getPedOccupiedVehicle ( localPlayer ), 0 ) == localPlayer ) then
			doEventHandlers = true
			local theVehicle = getPedOccupiedVehicle ( localPlayer )
			if not ( getElementData ( theVehicle, "fuel" ) ) then
				setElementData ( theVehicle, "fuel", 100 )
			elseif ( tonumber(getElementData ( theVehicle, "fuel" )) <= 0 ) then
				disableVehicleFunctions( theVehicle )
			end

			if ( doEventHandlers ) then
				addEventHandler ( "onClientVehicleExit", root, onVehicleExitDestroy, false )
				addEventHandler ( "onClientElementDestroy", root, onVehicleExitDestroy, false )
				doEventHandlers = false
			end

			fuelTimer = setTimer ( onDecreaseFuel, 10000, 0 )
		end
	end
)

function onVehicleExitDestroy ( theVehicle )
	local theVehicle = theVehicle or source
	if ( fuelTimer ) and ( isTimer( fuelTimer ) ) then killTimer( fuelTimer ) end

	if ( getElementData ( theVehicle, "vehicleFuel" ) ) then
		setElementData ( theVehicle, "vehicleFuel", getElementData ( theVehicle, "vehicleFuel" ) )
	end

	if ( theVehicle ) then
		removeEventHandler ( "onClientVehicleExit", theVehicle, onVehicleExitDestroy, false )
		removeEventHandler ( "onClientElementDestroy", theVehicle, onVehicleExitDestroy, false )
		doEventHandlers = true
	end
end

addEventHandler ( "onClientResourceStop", resourceRoot,
	function ()
		if ( getPedOccupiedVehicle ( localPlayer ) ) and ( getVehicleOccupant ( getPedOccupiedVehicle ( localPlayer ), 0 ) == localPlayer ) then
			onVehicleExitDestroy ( getPedOccupiedVehicle ( localPlayer ) )
		end
	end
)

function onDecreaseFuel ()
	local theVehicle = getPedOccupiedVehicle ( localPlayer )
	if ( theVehicle ) then
		if ( getElementModel ( theVehicle ) == 509 ) or  ( getElementModel ( theVehicle ) == 494 ) or  ( getElementModel ( theVehicle ) == 481 )  or ( getElementModel ( theVehicle ) == 510 ) then return end
		local theFuel = getElementData ( theVehicle, "fuel" )
		if  ( getVehicleEngineState ( theVehicle ) ) and ( tonumber(theFuel) > 0 ) and ( getVehicleOccupant ( getPedOccupiedVehicle ( localPlayer ), 0 ) == localPlayer ) then
			setElementData ( theVehicle, "fuel", theFuel - 1 )
			if ( getElementData ( theVehicle, "fuel" ) <= 0 ) then
				disableVehicleFunctions( theVehicle )
			end
		end
	end
end

function getVehicleSpeed ( theVehicle, unit )
	if ( unit == nil ) then unit = 0 end
	if ( isElement( theVehicle ) ) then
		local x,y,z = getElementVelocity( theVehicle )
		if ( unit=="mph" or unit==1 or unit =='1' ) then
			return ( x^2 + y^2 + z^2 ) ^ 0.5 * 100
		else
			return ( x^2 + y^2 + z^2 ) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end
