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


local ObjectBarbersChair = {}
----------------------------------------------------------------------------------------------------------------------------------
-- PREVIEW BARBER'S
----------------------------------------------------------------------------------------------------------------------------------
function previewBarbers(ply, data)
    if data then
        local clothertyp = 1
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
addEvent ("previewBarbers", true)
addEventHandler ("previewBarbers", root, previewBarbers)
----------------------------------------------------------------------------------------------------------------------------------
-- BUY BARBER'S
----------------------------------------------------------------------------------------------------------------------------------
function buyBarbers(ply, data)
    if data then
        local clothertyp = 1
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
addEvent ("buyBarbers", true)
addEventHandler ("buyBarbers", root, buyBarbers)
----------------------------------------------------------------------------------------------------------------------------------
-- CLOSE AND LOAD CLOTHE
----------------------------------------------------------------------------------------------------------------------------------
function closeBarbers(ply)
    exports.an_clothing:loadplyclothes(ply)
end
addEvent ("closeBarbers", true)
addEventHandler ("closeBarbers", root, closeBarbers)
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
function callBarbersonpolice(ply)
    if ply then
        local plyid = getElementData(ply,"id")
        local x,y,z = getElementPosition(ply)
        exports.an_emergencycall:createemgblipsv(plyid,x,y,z, "Denúncia de bandido <b>procurado</b>, vá até o local e verifique.")
    end
end
addEvent ("callBarbersonpolice", true)
addEventHandler ("callBarbersonpolice", root, callBarbersonpolice)
----------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL STOP ANIM BARBER'S
----------------------------------------------------------------------------------------------------------------------------------
function startChairBarbers(ply, Chair)
    if Chair then
        if not getElementData(ply,"wanted") then
            if not getElementData( ObjectBarbersChair[Chair], 'inuso') then
                if not getElementData(ply,"openui") then
                    triggerClientEvent (ply,"OpenBarbers",ply, ObjectBarbersChair[Chair], Chair)
                    attachElements (ply, ObjectBarbersChair[Chair], 0.65, 0.05, 0.5 )
                    setElementData( ObjectBarbersChair[Chair], 'inuso', true)
                    setElementData( ply, 'Chair', ObjectBarbersChair[Chair])
                    local rx, ry, rz = getElementRotation(ObjectBarbersChair[Chair])
                    setElementRotation(ply, rx, ry, rz-85)
                end 
            end
        else
            exports.an_infobox:addNotification(ply,"Você esta sendo procurado! a policia foi alertada.","aviso")
            callclothingpolice(ply)
        end
    end
end
addEvent("startChairBarbers",true)
addEventHandler ( "startChairBarbers", getRootElement(), startChairBarbers )

function stopBarbersAnim(ply)
    if ply then
        setElementData( ply, 'emacao', nil)
        setPedAnimation(ply, false )
        setElementData( getElementData(source,"Chair"), 'inuso', nil)
        setElementData( ply, 'Chair', nil)
        detachElements ( ply)
    end
end
addEvent("stopBarbersAnim",true)
addEventHandler ( "stopBarbersAnim", getRootElement(), stopBarbersAnim )

function CreateObjectonStart()
    for i,v in ipairs (cfg.Barbers) do
        ObjectBarbersChair[v.ID] = createObject(2343, v.X, v.Y, v.Z, 0, 0, v.ROT)
        setElementData(ObjectBarbersChair[v.ID], 'Chair', ObjectBarbersChair[v.ID])
    end
end
addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), CreateObjectonStart)


local rotatetime = {}
function rotateObjBarb(ply, typ, char)
    rotateBarbersObjects(ply, typ, char)
end
addEvent("rotateObjBarb",true)
addEventHandler ( "rotateObjBarb", getRootElement(), rotateObjBarb )

function rotateBarbersObjects(ply, typ, char)
    if char then
        if typ == 1 then
            local _, _, rz = getElementRotation(char)
            setElementRotation(char, 0, 0, rz+10)
            local rx, ry, rz = getElementRotation(char)
            setElementRotation(ply, rx, ry, rz-85)
        elseif typ == 2 then
            local _, _, rz = getElementRotation(char)
            setElementRotation(char, 0, 0, rz-10)
            local rx, ry, rz = getElementRotation(char)
            setElementRotation(ply, rx, ry, rz-85)
        end
    end
end
addEvent("rotateBarbersObjects",true)
addEventHandler ( "rotateBarbersObjects", getRootElement(), rotateBarbersObjects )

function restorebarbersChairs()
    if getElementData(source,"Chair") then
        setElementData(getElementData(source,"Chair"),'inuso',false)
    end
end
addEventHandler ("onPlayerQuit", root, restorebarbersChairs)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------