------------------------------------------------------------------------------------------------------- 
-- connect
-------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function math.percent(percent,maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue*percent)-1
    end
    return false
end

function getfreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_vips ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end

function seplyvip(ply,vip)
    if not getElementData(ply,"anvip") then
        local freid = getfreeid()
        local rtimeradded = an_getrealTimeraddedday(1)
        local plyid = getElementData(ply,"id")
        setElementData(ply,"anvip",vip)
        dbExec(connection, "INSERT INTO an_vips SET id = ?,plyid = ?,viptype = ?,time = ?",freid,plyid,vip,rtimeradded)
    end
end
-------------------------------------------------------------------------------------------------------
--  COWDOWN VIP
-------------------------------------------------------------------------------------------------------
function checkatmtimer()
local marketArray = dbPoll(dbQuery(connection, "SELECT * FROM an_vips"), -1)
if not marketArray then return end
local rtimer = exports.an_account:an_getrealTimer()
    for k,v in pairs(marketArray) do
        id = v["id"]
        plyid = v["plyid"]
        viptype = v["viptype"]
        time = v["time"]
        if tostring(time) <= rtimer then
            dbExec(connection, "DELETE FROM an_vips WHERE id = ?", id)
            print("O vip do id: "..plyid.." acaba de expirar.")
            if plyid then
                local ply = getPlayerID(tonumber(plyid))
                if ply then
                    setElementData(ply,"anvip",nil)
                    exports.an_infobox:addNotification(ply,"O seu vip <b>"..viptype.."</b> expirou.","aviso")
                end
            end
        end
    end
setTimer(checkatmtimer,1000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), checkatmtimer)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function loadvip(ply)
    local plyid = getElementData(ply,"id")
	local playeQ = dbQuery(connection,"SELECT * FROM an_vips WHERE plyid = ?",plyid)
	local playeH,playeHm = dbPoll(playeQ,-1)
	if playeH then
		for k,v in ipairs(playeH) do
            plyid = v["plyid"]
            vitype = v["viptype"]
            time = v["time"]
            if getElementData(ply,"id") == plyid then
                if vitype then
                    setElementData(ply,"anvip",vitype)
                    setTimer(function()
                        exports.an_infobox:addNotification(ply,"<b>Status</b> do seu vip: <b>Ativo</b> até a data: <b>"..time.."</b>","info")
                    end,5000,1)
                end
			end
		end
    end
end
addEvent ("loadvip", true)
addEventHandler ("loadvip", root, loadvip)

local salarios = {
    {"Space",7000},
    {"Star",5500},
    {"Planet",4000},
    {"Meteorite",3000},
}

function paymoneyplyvip(ply)
    if getElementData(ply,"anvip") then
        for k,v in ipairs(salarios) do
            if getElementData(ply,"anvip") == v[1] then
                setElementData(ply, "BankMoney", getElementData(ply, "BankMoney") + v[2])
                exports.an_infobox:addNotification(ply,"Obrigado por colaborar com a cidade <br>o valor de <b>"..v[2].."</b> foi depositado","info")
            end
        end
    end
end
addEvent ("paymoneyplyvip", true)
addEventHandler ("paymoneyplyvip", root, paymoneyplyvip)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
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

function an_getrealTimeraddedday(added)
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
    local monthday = time.monthday
	local month = time.month
	local year = time.year
	local formattedTime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1 + added, monthday, hours, minutes, seconds)
	return formattedTime
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------