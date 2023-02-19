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

addCommandHandler("wanted",
function(ply,cmd)
    if getElementData(ply,"wanted") then
        local plyid = getElementData(ply,"id")
        local accountplyQ = dbQuery(connection,"SELECT * FROM an_wanted WHERE plyid=?",plyid)
        local accountplyH,vehszam = dbPoll(accountplyQ,-1)
        if accountplyH then
            for k,v in ipairs(accountplyH) do
                time = v["time"]
                if time then
                    exports.an_infobox:addNotification(ply,"Você está sendo <b>procurado</b> restam <b>"..time.."</b> minutos.","info")
                end
            end
        end
    else
        exports.an_infobox:addNotification(ply,"Você não está sendo <b>procurado</b>.","sucesso")
    end
end
)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function setplywanted(ply,timew)
    if getElementData(ply,"wanted") then
        local timeamais = timew
        local plyid = getElementData(ply,"id")
        local accountplyQ = dbQuery(connection,"SELECT * FROM an_wanted WHERE plyid=?",plyid)
        local accountplyH,vehszam = dbPoll(accountplyQ,-1)
        if accountplyH then
            for k,v in ipairs(accountplyH) do
                time = v["time"]
                if time >= 0 then
                    setElementData(ply,"wanted",true)
                    dbExec(connection, "UPDATE an_wanted SET time=? WHERE plyid=?",timeamais+time,plyid)
                end
            end
        end
    elseif not getElementData(ply,"wanted") then
        local timerr = 30
        local plyid = getElementData(ply,"id")
        setElementData(ply,"wanted",true)
        dbExec(connection, "INSERT INTO an_wanted SET plyid = ?,time = ?",plyid,timerr)
    end
end

function removeplywanted(ply)
    if getElementData(ply,"wanted") then
        local plyid = getElementData(ply,"id")
        setElementData(ply,"wanted",nil)
        dbExec(connection, "DELETE FROM an_wanted WHERE plyid = ?",plyid)
    end
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function chacktimerwanted()
local prisionArray = dbPoll(dbQuery(connection, "SELECT * FROM an_wanted"), -1)
if not prisionArray then return end
    for k,v in pairs(prisionArray) do
    time = v["time"]
        if time >= 0 then
            for pk,pv in pairs(getElementsByType("player")) do
                    if getElementData(pv,"id") == v["plyid"] then
                        dbExec(connection, "UPDATE an_wanted SET time = ? WHERE plyid = ?",math.percent(1,time), getElementData(pv,"id"))
                    end
                end
            end
        end
setTimer(chacktimerwanted,60000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), chacktimerwanted)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function chacktimerwanted2()
    local prisionArray = dbPoll(dbQuery(connection, "SELECT * FROM an_wanted"), -1)
    if not prisionArray then return end
        for k,v in pairs(prisionArray) do
            time = v["time"]
            if time <= 0 then
                for pk,pv in pairs(getElementsByType("player")) do
                    if getElementData(pv,"id") == v["plyid"] then
                        dbExec(connection, "DELETE FROM an_wanted WHERE plyid = ?",v["plyid"])
                        setElementData(pv,"wanted",nil)
                        exports.an_infobox:addNotification(ply,"O seu tempo de <b>procurado</b> acabou!","info")
                    end
                end
            end
        end
setTimer(chacktimerwanted2,2000,1)
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), chacktimerwanted2)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function loadwanted(ply)
    local plyid = getElementData(ply,"id")
	local playeQ = dbQuery(connection,"SELECT * FROM an_wanted WHERE plyid = ?",plyid)
	local playeH,playeHm = dbPoll(playeQ,-1)
	if playeH then
		for k,v in ipairs(playeH) do
            plyid = v["plyid"]
            timep = v["time"]
            if getElementData(ply,"id") == plyid then
                setElementData(ply,"wanted",true)
                exports.an_infobox:addNotification(ply,"Você está sendo <b>procurado</b>!","info")
			end
		end
    end
end
addEvent ("loadwanted", true)
addEventHandler ("loadwanted", root, loadwanted)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------