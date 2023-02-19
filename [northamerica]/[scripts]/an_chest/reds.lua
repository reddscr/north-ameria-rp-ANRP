----------------------------------------------------------------------------------------------------------
-- connect
----------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
----------------------------------------------------------------------------------------------------------
-- BILD CHEST
----------------------------------------------------------------------------------------------------------
local theObject = {}
function createchestOnStart()
    for i ,v in pairs(cfg.locals) do
        local id, obj, x, y, z, rx, ry, rz, slot = unpack(v)
        local pos = toJSON({x,y,z,rx,ry,rz})
        if id then
            local data = dbPoll(dbQuery(connection, "SELECT * FROM an_chests WHERE id = ?", id), -1)[1]
            if not data then
                theObject[id] = createObject( obj, x, y, z )
                setElementRotation(theObject[id],rx,ry,rz)
                setElementData( theObject[id], 'maxslots', slot )
                setElementData( theObject[id], 'usedslots', 0 )
                setElementData(theObject[id],"id",id)
                dbExec(connection, "INSERT INTO an_chests SET id = ?,pos = ?,usedslots = ?,maxslots = ?,owner = ?", id, pos, '0', slot, id)
            else
                loadChestOnrequest(id)
            end
        end
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createchestOnStart)
----------------------------------------------------------------------------------------------------------
-- LOAD CHEST
----------------------------------------------------------------------------------------------------------
function loadChestOnrequest(id)
    for i ,v in pairs(cfg.locals) do
        local cid, obj, x, y, z, rx, ry, rz, slot = unpack(v)
        if id == cid then
            local objectsQ = dbQuery(connection,"SELECT * FROM an_chests WHERE id=?",id)
            local objectsH,vehszam = dbPoll(objectsQ,-1)
            if objectsH then
                for k,v in ipairs(objectsH) do
                    did = v["id"]
                    usedslots = v["usedslots"]
                    maxslots = v["maxslots"]
                    if did then
                        theObject[did] = createObject( obj, x, y, z )
                        setElementRotation(theObject[did],rx,ry,rz)
                        setElementData(theObject[did],"id",did)
                        setElementData(theObject[did],'maxslots',maxslots)
                        setElementData(theObject[did],'usedslots',usedslots)
                        exports.an_inventory:loadchestitem(theObject[did])
                    end
                end
            end
        end
    end
end
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------