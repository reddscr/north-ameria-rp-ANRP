----------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
----------------------------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
function getFreeid()
	local result = dbPoll(dbQuery(connection, "SELECT id FROM an_clothing ORDER BY id ASC"), -1)
	newid = false
	for i, id in pairs (result) do
		if id["id"] ~= i then
			newid = i
			break
		end
	end
	if newid then return newid else return #result + 1 end
end
----------------------------------------------------------------------------------------------------------------------------------
-- PREVIEW Tatoos'S
----------------------------------------------------------------------------------------------------------------------------------
function previewTatoos(ply, data, typ)
    if data then
        local clothertyp = typ
        local clothing = data
        if clothing ~= "remove" then
            local texture, model = getClothesByTypeIndex (clothertyp,clothing)
            addPedClothes ( ply, texture, model, clothertyp )
        else
            local clotname = getPedClothes(ply,clothertyp)
            if clotname then
                local clotid = getTypeIndexFromClothes(clotname)
                removePedClothes(ply,clotid)
            end
        end  
    end
end
addEvent ("previewTatoos", true)
addEventHandler ("previewTatoos", root, previewTatoos)
----------------------------------------------------------------------------------------------------------------------------------
-- BUY Tatoos'S
----------------------------------------------------------------------------------------------------------------------------------
function buyTatoos(ply, data, typ)
    if data then
        local clothertyp = typ
        local clotherdata = tostring(1)
        local clothing = data
        local plyid = getElementData(ply,"id")
        local freeid = getFreeid()
        if clothing ~= "remove" then
            local plyclot = getplyclothertyp(ply,clothertyp)
            if plyclot >= 1 then
                local texture, model = getClothesByTypeIndex (clothertyp,clothing)
                addPedClothes ( ply, texture, model, clothertyp )
                setElementData(ply,clotherdata,clothing)
                local pdtwalk = dbExec(connection, "UPDATE an_clothing SET clotherid=? WHERE plyid =? AND typ=?",clothing,plyid,clothertyp)
            else
                local texture, model = getClothesByTypeIndex (clothertyp,clothing)
                addPedClothes ( ply, texture, model, clothertyp )
                setElementData(ply,clotherdata,clothing)
                local pdtwalk = dbExec(connection, "INSERT INTO an_clothing SET id=?,plyid=?,skin=?,clotherid=?,typ=?",freeid,plyid,0,clothing,clothertyp)
            end
        else
            local plyclot = getplyclothertyp(ply,clothertyp)
            if plyclot >= 1 then
                setElementData(ply,clotherdata,clothing)
                local pdtwalk = dbExec(connection, "UPDATE an_clothing SET clotherid=? WHERE plyid =? AND typ=?",clothing,plyid,clothertyp)
                removePedClothes ( ply, clothertyp )
            else
                setElementData(ply,clotherdata,clothing)
                local pdtwalk = dbExec(connection, "INSERT INTO an_clothing SET id=?,plyid=?,skin=?,clotherid=?,typ=?",freeid,plyid,0,clothing,clothertyp)
                removePedClothes ( ply, clothertyp )
            end
        end
    end
end
addEvent ("buyTatoos", true)
addEventHandler ("buyTatoos", root, buyTatoos)
----------------------------------------------------------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------------------------------------
function closeTatoos(ply)
    exports.an_clothing:loadplyclothes(ply)
end
addEvent ("closeTatoos", true)
addEventHandler ("closeTatoos", root, closeTatoos)
----------------------------------------------------------------------------------------------------------------------------------
-- GET CLOTHES
----------------------------------------------------------------------------------------------------------------------------------
function getplyclothertyp(ply,typ)
	local plyid = getElementData(ply,"id")
	local result = dbPoll(dbQuery(connection, "SELECT * FROM an_clothing WHERE plyid = ? AND typ=?",plyid,typ), -1)
	if result and type(result) == "table" then
		return #result
	end
end
----------------------------------------------------------------------------------------------------------------------------------
-- CALL TO POLICE
----------------------------------------------------------------------------------------------------------------------------------
function callTatoossonpolice(ply)
    if ply then
        local plyid = getElementData(ply,"id")
        local x,y,z = getElementPosition(ply)
        exports.an_emergencycall:createemgblipsv(plyid,x,y,z, "Denúncia de bandido <b>procurado</b>, vá até o local e verifique.")
    end
end
addEvent ("callTatoossonpolice", true)
addEventHandler ("callTatoossonpolice", root, callTatoossonpolice)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------