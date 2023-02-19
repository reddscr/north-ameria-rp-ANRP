
-------------------------------------------------------------------------------------------------------
-- conncect
-------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()

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

function previewclothe(ply,data,data2,data3)
    local clothertyp = tonumber(data)
    local clotherdata = data3
    local clothing = data2
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
addEvent ("previewclothe", true)
addEventHandler ("previewclothe", root, previewclothe)
-------------------------------------------------------------------------------------------------------
-- BUY CLOTHES
-------------------------------------------------------------------------------------------------------
function buyclothshop(ply,data,data2,data3)
    local clothertyp = data
    local clotherdata = tostring(data3)
    local clothing = data2
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
addEvent ("buyclothshop", true)
addEventHandler ("buyclothshop", root, buyclothshop)


function getplyclothertyp(ply,typ)
    local plyid = getElementData(ply,"id")
    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_clothing WHERE plyid = ? AND typ=?",plyid,typ), -1)
    if result and type(result) == "table" then
        return #result
    end
end

function closechoshopandnobuy(ply)
    exports.an_clothing:loadplyclothes(ply)
end
addEvent ("closechoshopandnobuy", true)
addEventHandler ("closechoshopandnobuy", root, closechoshopandnobuy)


function callclothingpolice(ply)
    if ply then
        local plyid = getElementData(ply,"id")
        local x,y,z = getElementPosition(ply)
        exports.an_emergencycall:createemgblipsv(plyid,x,y,z, "Denúncia de bandido <b>procurado</b>, vá até o local e verifique.")
    end
end
addEvent ("callclothingpolice", true)
addEventHandler ("callclothingpolice", root, callclothingpolice)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------







