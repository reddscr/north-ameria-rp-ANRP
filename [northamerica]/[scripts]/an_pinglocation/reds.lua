----------------------------------------------------------------------------------------------------------------
-- PING LOCATION
----------------------------------------------------------------------------------------------------------------
local pingCountDownTimer = {}
addCommandHandler("ping",
function(ply,cmd,id)
	if(id) then
		local playerID = tonumber(id)
		if(playerID) then
			local Player2 = getPlayerID(playerID)
            if(Player2) then
                if Player2 ~= ply then
                    if not pingCountDownTimer[ply] then
                        pingCountDownTimer[ply] = true
                        triggerClientEvent( Player2, "pingrequeststart", Player2, ply)
                        exports.an_infobox:addNotification(ply, "Solicitação de localização <b>enviada</b>!","info")
                        setTimer(function() 
                            pingCountDownTimer[ply] = nil
                        end,1000*30,1)
                    else
                        exports.an_infobox:addNotification(ply, "Você pediu localização <b>recentemente</b>.","aviso")
                    end
                end
            else
                exports.an_infobox:addNotification(ply, "Esta pessoa não se encontra na <b>cidade</b>","erro")
            end
        end
    end
end)
----------------------------------------------------------------------------------------------------------------
-- PING ACEPTED
----------------------------------------------------------------------------------------------------------------
function Pingacepted(ply2, ply)
    if ply then
        exports.an_infobox:addNotification(ply, "Solicitação de localização <b>aceita</b>!","sucesso")
        triggerClientEvent( ply, "startPingLocation", ply, ply2)
    end
end
addEvent ("Pingacepted", true)
addEventHandler ("Pingacepted", root, Pingacepted)
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
-- converter em numero menor
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
-- get id
function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "id") == id then
			v = player
			break
		end
	end
	return v
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------