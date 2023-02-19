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
-------------------------------------------------------------------------------------------------------
-- loading account clothers
-------------------------------------------------------------------------------------------------------
function removeclotes(ply)
    for k,v in ipairs(cfg.defaulttt) do
        if getPedClothes(ply,v[1]) then
            local clotname = getPedClothes(ply,v[1])
            local clotid = getTypeIndexFromClothes(clotname)
            removePedClothes(ply,clotid)
        end
    end
end

function loadplyclothes(ply)
    if getElementModel(ply) == 0 then
        for k,v in ipairs(cfg.defaulttt) do
            if getPedClothes(ply,v[1]) then
                local clotname = getPedClothes(ply,v[1])
                local clotid = getTypeIndexFromClothes(clotname)
                removePedClothes(ply,clotid)
            end
        end
        for k,v in ipairs(cfg.defaultclother) do
            local texture, model = getClothesByTypeIndex ( v[1],  v[2] ) 
            addPedClothes ( ply, texture, model, v[1] )
        end
        setElementData(ply,"shirt",nil)
        setElementData(ply,"head",nil)
        setElementData(ply,"tatoo4",nil)
        setElementData(ply,"tatoo5",nil)
        setElementData(ply,"tatoo6",nil)
        setElementData(ply,"tatoo7",nil)
        setElementData(ply,"tatoo8",nil)
        setElementData(ply,"tatoo9",nil)
        setElementData(ply,"tatoo10",nil)
        setElementData(ply,"tatoo11",nil)
        setElementData(ply,"tatoo12",nil)
        setElementData(ply,"trousers",nil)
        setElementData(ply,"shoe",nil)
        setElementData(ply,"glasses",nil)
        setElementData(ply,"hats",nil)
        setElementData(ply,"chains",nil)
        setElementData(ply,"watches",nil)
        local plyid = getElementData(ply,"id")
        local result = dbPoll(dbQuery(connection,"SELECT * FROM an_clothing WHERE plyid=?",plyid), -1)
        if result then
            for i, v in pairs (result) do
                clo_plyid = v["plyid"]
                clo_typ = v["typ"]
                clo_id = v["clotherid"]
                clo_skin = v["skin"]	
                if clo_id ~= "remove" then
                    if clo_typ == 0 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"shirt",clo_id)
                    elseif clo_typ == 1 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"head",clo_id)
                    elseif clo_typ == 2 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"trousers",clo_id)
                    elseif clo_typ == 3 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"shoe",clo_id)
                    elseif clo_typ == 4 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo4",clo_id)
                    elseif clo_typ == 5 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo5",clo_id)
                    elseif clo_typ == 6 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo6",clo_id)
                    elseif clo_typ == 7 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo7",clo_id)
                    elseif clo_typ == 8 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo8",clo_id)
                    elseif clo_typ == 9 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo9",clo_id)
                    elseif clo_typ == 10 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo10",clo_id)
                    elseif clo_typ == 11 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo11",clo_id)
                    elseif clo_typ == 12 then
                        local texture, model = getClothesByTypeIndex (clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"tatoo12",clo_id)
                    elseif clo_typ == 13 then
                        local texture, model = getClothesByTypeIndex ( clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"chains",clo_id)
                    elseif clo_typ == 14 then
                        local texture, model = getClothesByTypeIndex ( clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"watches",clo_id)
                    elseif clo_typ == 15 then
                        local texture, model = getClothesByTypeIndex ( clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"glasses",clo_id)
                    elseif clo_typ == 16 then
                        local texture, model = getClothesByTypeIndex ( clo_typ,clo_id)
                        addPedClothes ( ply, texture, model, clo_typ )
                        setElementData(ply,"hats",clo_id)
                    end
                else
                    if clo_typ == 0 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"shirt",clo_id)
                    elseif clo_typ == 2 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"trousers",clo_id)
                    elseif clo_typ == 3 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"shoe",clo_id)
                    elseif clo_typ == 15 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"glasses",clo_id)
                    elseif clo_typ == 16 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"hats",clo_id)
                    elseif clo_typ == 13 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"chains",clo_id)
                    elseif clo_typ == 14 then
                        removePedClothes ( ply, clo_typ )
                        setElementData(ply,"watches",clo_id)
                    end
                end
            end
        end
    end
end
addEvent ("loadplyclothes", true)
addEventHandler ("loadplyclothes", root, loadplyclothes)
-------------------------------------------------------------------------------------------------------
-- comandos roupas
-------------------------------------------------------------------------------------------------------
addCommandHandler("mask",
function(ply,cmd,clo_id)
    if not getElementData(ply,"wanted") then
        if getElementData(ply,"Mask") >= 1 then
            local clothertyp = 15
            local clotherdata = "mask"
            local clothing = clo_id
            local config = cfg.mask
            if clothing then
                for i,v in pairs (config) do
                    if clothing == v[1] then
                        if getElementData(ply,clotherdata) then
                            local texture, model = getClothesByTypeIndex (clothertyp,v[2])
                            addPedClothes ( ply, texture, model, clothertyp )
                            setElementData(ply,clotherdata,v[2])
                            local plyid = getElementData(ply,"id")
                            local pdtwalk = dbExec(connection, "UPDATE an_clothing SET clotherid=? WHERE plyid =? AND typ=?",v[2],plyid,clothertyp)
                        elseif not getElementData(ply,clotherdata) then
                            local freeid = getFreeid()
                            local texture, model = getClothesByTypeIndex (clothertyp,v[2])
                            addPedClothes ( ply, texture, model, clothertyp )
                            setElementData(ply,clotherdata,v[2])
                            local plyid = getElementData(ply,"id")
                            local pdtwalk = dbExec(connection, "INSERT INTO an_clothing SET id=?,plyid=?,skin=?,clotherid=?,typ=?",freeid,plyid,0,v[2],clothertyp)
                        end
                    end
                end
            else
                if getPedClothes(ply,clothertyp) then
                    setElementData(ply,clotherdata,nil)
                    local plyid = getElementData(ply,"id")
                    local clotname = getPedClothes(ply,clothertyp)
                    local clotid = getTypeIndexFromClothes(clotname)
                    local pdtwalk = dbExec(connection, "DELETE FROM an_clothing WHERE plyid =? AND typ=?",plyid,clothertyp)
                    removePedClothes(ply,clotid)
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Você não tem <b>mascara</b>.","aviso")
        end
    else
        exports.an_infobox:addNotification(ply,"Você está sendo <b>procurado</b>.","erro")
    end
end
)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------