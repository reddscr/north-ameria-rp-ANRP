-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
local housecol = {}

local housedoorcol = {}
local housedoorblock = {}
local housedoorobj = {}

homenames = {
    ---- casas condominio grande
    {1,"casa1",4,"1200000"},
    {2,"casa2",4,"1200000"},
    {3,"casa3",4,"1200000"},
    {4,"casa4",4,"1200000"},
    {5,"casa5",4,"1200000"},
    {6,"casa6",4,"1500000"},
    {7,"casa7",4,"1500000"},
    {8,"casa8",4,"1500000"},
    {9,"casa9",4,"1500000"},
    {10,"casa10",4,"1500000"},
    ---- casas vip
    {11,"casa11",6,"donate"},
    {12,"casa12",6,"donate"},
    {13,"casa13",6,"donate"},
    {14,"casa14",6,"donate"},
    {15,"casa15",6,"donate"},
    {16,"casa16",6,"donate"},
    {17,"casa17",6,"donate"},
    {18,"casa18",6,"donate"},
    {19,"casa19",6,"donate"},
    {20,"casa20",6,"donate"},
    {21,"casa21",6,"donate"},
    {22,"casa22",6,"donate"},
    {23,"casa23",6,"donate"},
    {24,"casa24",6,"donate"},
    {25,"casa25",6,"donate"},
    {26,"casa26",6,"donate"},
    {27,"casa27",6,"donate"},
    {28,"casa28",6,"donate"},
    {29,"casa29",6,"donate"},
    {30,"casa30",6,"donate"},
    {31,"casa31",6,"donate"},
    {32,"casa32",6,"donate"},
    ---- casas pequenas
    {33,"casa33",2,"130000"},
    {34,"casa34",2,"130000"},
    {35,"casa35",2,"130000"},
    {36,"casa36",2,"130000"},
    {37,"casa37",2,"130000"},
    {38,"casa38",2,"130000"},
    {39,"casa39",2,"130000"},
    {40,"casa40",2,"130000"},
    {41,"casa41",2,"130000"},
    {42,"casa42",2,"130000"},
    {43,"casa43",2,"130000"},
    {44,"casa44",2,"130000"},
    {45,"casa45",2,"130000"},
    {46,"casa46",2,"130000"},
    {47,"casa47",2,"130000"},
    {48,"casa48",2,"130000"},
    {49,"casa49",2,"130000"},
    {50,"casa50",2,"130000"},
    {51,"casa51",2,"130000"},
    {52,"casa52",2,"130000"},
    {53,"casa53",2,"130000"},
    {54,"casa54",2,"130000"},
    {55,"casa55",2,"130000"},
    {56,"casa56",2,"130000"},
    {57,"casa57",2,"130000"},
    {58,"casa58",2,"130000"},
    {59,"casa59",2,"130000"},
    {60,"casa60",2,"130000"},
    {61,"casa61",2,"130000"},
    {62,"casa62",2,"130000"},
    {63,"casa63",2,"130000"},
    {64,"casa64",2,"130000"},
    {65,"casa65",2,"130000"},
    {66,"casa66",2,"130000"},
    {67,"casa67",2,"130000"},
    {68,"casa68",2,"130000"},
    {69,"casa69",2,"130000"},
    {70,"casa70",2,"130000"},
    {71,"casa71",2,"130000"},
    {72,"casa72",2,"130000"},
    {73,"casa73",2,"130000"},
    {74,"casa74",2,"130000"},
    {75,"casa75",2,"130000"},
------------------------------------------- APT
    {76,"casa76",3,"250000"},
    {77,"casa77",3,"250000"},
    {78,"casa78",3,"250000"},
    {79,"casa79",3,"250000"},
    {80,"casa80",3,"250000"},
    {81,"casa81",3,"250000"},
    {82,"casa82",3,"250000"},
    {83,"casa83",3,"250000"},
    {84,"casa84",3,"250000"},
    {85,"casa85",3,"250000"},
    {86,"casa86",3,"250000"},
    {87,"casa87",3,"250000"},
    {88,"casa88",3,"250000"},
    {89,"casa89",3,"250000"},
    {90,"casa90",3,"250000"},
    {91,"casa91",3,"250000"},
    {92,"casa92",3,"250000"},
    {93,"casa93",3,"250000"},
    {94,"casa94",3,"250000"},
    {95,"casa95",3,"250000"},
    {96,"casa96",3,"250000"},
    {97,"casa97",3,"250000"},
    {98,"casa98",3,"250000"},
    {99,"casa99",3,"250000"},
    {100,"casa100",3,"250000"},
    {101,"casa101",3,"250000"},
    {102,"casa102",3,"250000"},
    {103,"casa103",3,"250000"},
    {104,"casa104",3,"250000"},
    {105,"casa105",3,"250000"},
    {106,"casa106",3,"250000"},
    {107,"casa107",3,"250000"},
    {108,"casa108",3,"250000"},
    {109,"casa109",3,"250000"},
    {110,"casa110",3,"250000"},
    {111,"casa111",3,"250000"},
    {112,"casa112",3,"250000"},
    {113,"casa113",3,"250000"},
    {114,"casa114",3,"250000"},
    {115,"casa115",3,"250000"},
    {116,"casa116",3,"250000"},
    {117,"casa117",3,"250000"},
    {118,"casa118",3,"250000"},
    {119,"casa119",3,"250000"},
    {120,"casa120",3,"250000"},
    {121,"casa121",3,"250000"},
    {122,"casa122",3,"250000"},
    {123,"casa123",3,"250000"},
    {124,"casa124",3,"250000"},
    {125,"casa125",3,"250000"},
    {126,"casa126",3,"250000"},
    {127,"casa127",3,"250000"},
    {128,"casa128",3,"250000"},
    {129,"casa129",3,"250000"},
    {130,"casa130",3,"250000"},
    {131,"casa131",3,"250000"},
    {132,"casa132",3,"250000"},
    {133,"casa133",3,"250000"},
    {134,"casa134",3,"250000"},
    {135,"casa135",3,"250000"},
    {136,"casa136",3,"250000"},
    {137,"casa137",3,"250000"},
    {138,"casa138",3,"250000"},
    {139,"casa139",3,"250000"},

}


homedoors = {
    ["porta"] = {{1502,"-1"}},
    ["porta2"] = {{1491,"-1"}},
    ["porta3"] = {{1499,"-1"}},
    ["portao"] = {{1939,"+1"}},
    ["portao2"] = {{1938,"+1"}},
}

function bildhomes()
    for k,v in pairs(homenames) do
        housesid = v[1]
        housesname = v[2]
        houseslot = v[3]
        houseprice = v[4]
        for k2,v2 in pairs(cfg.houses[housesname]) do
            local id,name,x,y,z,rx,ry,rz,rx2,ry2,rz2,blockx,blocky,blockz = unpack(v2[1])
            if (name == "porta") or (name == "porta2") or (name == "porta3") or (name == "portao") or (name == "portao2") then
                for k3,v3 in pairs(homedoors[name]) do
                    if name == "porta" then
                        housedoorblock[id] = createObject (2904,blockx,blocky,blockz,rx,ry,rz)
                        setElementCollisionsEnabled(housedoorblock[id] , true)
                        setElementAlpha(housedoorblock[id], 0)
                        housedoorobj[id] = createObject ( v3[1], x,y,z-1,rx,ry,rz )
                        setElementCollisionsEnabled(housedoorobj[id], false)
                        housedoorcol[id] = createColSphere(blockx,blocky,blockz-0.5,1)
                        setElementData(housedoorcol[id],"doorstats","Fechado")
                        setElementData(housedoorcol[id],"coldoors",housedoorcol[id])
                        setElementData(housedoorcol[id],"coldoorsobject",housedoorobj[id])

                        setElementData(housedoorcol[id],"coldoorsblock",housedoorblock[id])
                        setElementData(housedoorcol[id],"doorhouseid",id)
                        setElementData(housedoorcol[id],"houseiddoor",housesid)
                        setElementData(housedoorcol[id],"dorrtype",name)
                        setElementData(housedoorcol[id],"gateposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2}))
                    elseif name == "porta2" then 
                        housedoorblock[id] = createObject(2904,blockx,blocky,blockz,rx,ry,rz)
                        setElementCollisionsEnabled(housedoorblock[id] , true)
                        setElementAlpha(housedoorblock[id], 0)
                        housedoorobj[id] = createObject ( v3[1], x,y,z-1,rx,ry,rz )
                        setElementCollisionsEnabled(housedoorobj[id], false)
                        housedoorcol[id] = createColSphere(blockx,blocky,blockz-0.5,1)
                        setElementData(housedoorcol[id],"doorstats","Fechado")
                        setElementData(housedoorcol[id],"coldoors",housedoorcol[id])
                        setElementData(housedoorcol[id],"coldoorsobject",housedoorobj[id])
                        setElementData(housedoorcol[id],"coldoorsblock",housedoorblock[id])
                        setElementData(housedoorcol[id],"doorhouseid",id)
                        setElementData(housedoorcol[id],"houseiddoor",housesid)
                        setElementData(housedoorcol[id],"dorrtype",name)
                        setElementData(housedoorcol[id],"gateposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2}))
                    elseif name == "porta3" then 
                        housedoorblock[id] = createObject (2904,blockx,blocky,blockz,rx,ry,rz)
                        setElementCollisionsEnabled(housedoorblock[id] , true)
                        setElementAlpha(housedoorblock[id], 0)
                        housedoorobj[id] = createObject ( v3[1], x,y,z-1,rx,ry,rz )
                        setElementCollisionsEnabled(housedoorobj[id], false)
                        housedoorcol[id] = createColSphere(blockx,blocky,blockz-0.5,1)
                        setElementData(housedoorcol[id],"doorstats","Fechado")
                        setElementData(housedoorcol[id],"coldoors",housedoorcol[id])
                        setElementData(housedoorcol[id],"coldoorsobject",housedoorobj[id])
                        setElementData(housedoorcol[id],"coldoorsblock",housedoorblock[id])
                        setElementData(housedoorcol[id],"doorhouseid",id)
                        setElementData(housedoorcol[id],"houseiddoor",housesid)
                        setElementData(housedoorcol[id],"dorrtype",name)
                        setElementData(housedoorcol[id],"gateposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2}))
                    elseif name == "portao" then
                        housedoorobj[id] = createObject ( v3[1], x,y,z,rx,ry,rz)
                        housedoorcol[id] = createColSphere(x,y,z-0.5,3.5)
                        setElementData(housedoorcol[id],"doorstats","Fechado")
                        setElementData(housedoorcol[id],"coldoors",housedoorcol[id])
                        setElementData(housedoorcol[id],"coldoorsblock",housedoorobj[id])
                        setElementData(housedoorcol[id],"doorhouseid",id)
                        setElementData(housedoorcol[id],"houseiddoor",housesid)
                        setElementData(housedoorcol[id],"dorrtype",name)
                        setElementData(housedoorcol[id],"gateposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2}))
                    elseif name == "portao2" then
                        housedoorobj[id] = createObject ( v3[1], x,y,z,rx,ry,rz)
                        housedoorcol[id] = createColSphere(x,y,z-0.5,3.5)
                        setElementData(housedoorcol[id],"doorstats","Fechado")
                        setElementData(housedoorcol[id],"coldoors",housedoorcol[id])
                        setElementData(housedoorcol[id],"coldoorsblock",housedoorobj[id])
                        setElementData(housedoorcol[id],"doorhouseid",id)
                        setElementData(housedoorcol[id],"houseiddoor",housesid)
                        setElementData(housedoorcol[id],"dorrtype",name)
                        setElementData(housedoorcol[id],"gateposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2}))
                    end
                end
            elseif name == "col" then
                housecol[id] = createColCuboid(x,y,z-1,rx,ry,rz)
                setElementData(housecol[id],"houseid",housesid)
                setElementData(housecol[id],"housecol",housecol[id])
                setElementData(housecol[id],"houseprice",houseprice)
            end
            local data = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?", housesid), -1)[1]
            if not data then
                dbExec(connection, "INSERT INTO an_houses SET id = ?,house_vehslot = ?",housesid,houseslot)
            end
        end
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), bildhomes)



function openandclosedoor(ply,typ,col)
    local houseQ = dbQuery(connection,"SELECT * FROM an_houses")
	local houseH,vehszam = dbPoll(houseQ,-1)
	if houseH then
        for kdata,vdata in ipairs(houseH) do
            homeeid = vdata["id"]
            owid = vdata["id_owner"]
            if getElementData(col,"houseiddoor") == homeeid then
                if getElementData(ply,"id") == owid then

                    if col then
                        if (getElementData(col,"dorrtype") == "porta") or (getElementData(col,"dorrtype") == "porta2") or (getElementData(col,"dorrtype") == "porta3") then
                            if typ == "open" then
                                setElementData(col,"doorstats","Aberto")
                                setElementCollisionsEnabled(getElementData(col,"coldoorsobject"), true)
                                setElementCollisionsEnabled(getElementData(col,"coldoorsblock"), false)
                            elseif typ == "close" then
                                local poss = getElementData(col,"gateposs")
                                p = fromJSON(poss)
                                setElementData(col,"doorstats","Fechado")
                                setElementCollisionsEnabled(getElementData(col,"coldoorsobject"), false)
                                setElementRotation(getElementData(col,"coldoorsobject"),p[4],p[5],p[6])
                                setElementCollisionsEnabled(getElementData(col,"coldoorsblock"), true)
                            end
                        elseif (getElementData(col,"dorrtype") == "portao") or (getElementData(col,"dorrtype") == "portao2") then
                            if typ == "open" then
                                local poss = getElementData(col,"gateposs")
                                p = fromJSON(poss)
                                setElementData(col,"doorstats","Aberto")
                                setElementPosition(getElementData(col,"coldoorsblock"),p[1],p[2],p[3]+2.7)
                                setElementRotation(getElementData(col,"coldoorsblock"),p[7],p[8],p[9])
                                --[[moveObject (getElementData(col,"coldoorsblock"), 1100 ,p[1],p[2],p[3]+1.5 )
                                setTimer(function()
                                    setElementRotation(getElementData(col,"coldoorsblock"),p[4],280,p[6])
                                end,1200,1)]]
                            elseif typ == "close" then
                                local poss = getElementData(col,"gateposs")
                                p = fromJSON(poss)
                                setElementData(col,"doorstats","Fechado")
                                setElementPosition(getElementData(col,"coldoorsblock"),p[1],p[2],p[3])
                                setElementRotation(getElementData(col,"coldoorsblock"),p[4],p[5],p[6])
                               --[[ setElementRotation(getElementData(col,"coldoorsblock"),p[4],p[5],p[6])
                                setElementData(col,"doorstats","Fechado")
                                moveObject (getElementData(col,"coldoorsblock"), 1500 ,p[1],p[2],p[3])]]
                            end
                        end
                    end

                else
                    exports.an_infobox:addNotification(ply,"Você não tem a <b>chave</b> desta <b>casa</b>","aviso")
                end
            end
        end
    end

end
addEvent("openandclosedoor",true)
addEventHandler ( "openandclosedoor", getRootElement(), openandclosedoor )


function requesthousegarage(ply,hid,gid)
    local plyid = getElementData(ply,"id")
    local result = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?",hid), -1)
    for k,v in ipairs(result) do
        homeowner = v["id_owner"]
        if plyid == homeowner then
            exports.an_vehicles:openplyhousegarage(ply,gid)
        else
            exports.an_infobox:addNotification(ply,"Esta <b>casa</b> não pertence a você.","erro")
        end
    end
end
addEvent("requesthousegarage",true)
addEventHandler ( "requesthousegarage", getRootElement(), requesthousegarage)

local centralgaragemk = {}
function bildgaragecol ()
	for i,v in ipairs (cfg.housesgarage) do
        local id,x,y,z,garagehouse = unpack(v)
        centralgaragemk[id] = createMarker(x,y,z -1, "cylinder", 0.5, 255, 77, 77, 25)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), bildgaragecol)
-----------------------------------------------------------------------------------------------------------
-- House Commands
-----------------------------------------------------------------------------------------------------------
addCommandHandler("sell",
function(ply,cmd,price)
    if price then
        local hprice = tonumber(price)
        if hprice >= 0 then
            local plyid = getElementData(ply,"id")
            local hid = getElementData(ply,"inhousecolid")
            if hid then
                local result = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?",hid), -1)
                for k,v in ipairs(result) do
                    homeowner = v["id_owner"]
                    homeid = v["id"]
                    if plyid == homeowner then
                        local tagertply = exports.an_player:getproxply(ply,3)
                        if tagertply then
                            triggerClientEvent (tagertply,"openconfirmbuyhouse",tagertply,ply,homeid,hprice)
                            exports.an_infobox:addNotification(ply,"Aguarde a pessoa aceitar...","aviso")
                        else
                            exports.an_infobox:addNotification(ply,"Não há <b>pessoas</b> por perto.","erro")
                        end
                    else
                        exports.an_infobox:addNotification(ply,"Esta <b>casa</b> não pertence a você.","erro")
                    end
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Valor inválido.","erro")
        end
    else
        exports.an_infobox:addNotification(ply,"Você não informou o valor.","erro")
    end
end
)

function sussefulsellhouse(ply,ply2,house,price)
    if ply2 then
        if house then
            if price then
                if getElementData(ply,"Money") >= tonumber(price) then
                    local plyid = getElementData(ply,"id")
                    exports.an_inventory:sattitem(ply,"Money",price,"menos")
                    exports.an_inventory:sattitem(ply2,"Money",price,"mais")
                    dbExec(connection, "UPDATE an_houses SET id_owner = ? WHERE id = ?",plyid,house)
                    exports.an_infobox:addNotification(ply,"<b>Casa</b> comprada com sucesso!","sucesso")
                    exports.an_infobox:addNotification(ply2,"<b>Casa</b> vendida com sucesso!","sucesso")
                else
                    exports.an_infobox:addNotification(ply2,"O <b>comprador</b> não tem $ <b>"..price.."</b>.","erro")
                    exports.an_infobox:addNotification(ply,"Você não tem $ <b>"..price.."</b>.","erro")
                end
            end
        end
    end
end
addEvent("sussefulsellhouse",true)
addEventHandler ( "sussefulsellhouse", getRootElement(), sussefulsellhouse)

function gethouseowner(targethouse)
	local hid = getElementData(targethouse,"houseid")
	local result = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?",hid), -1)
	local hdis = nil
	for k,v in ipairs(result) do
        houseowid = v["id_owner"]
		if houseowid ~= 0 then
			hdis = tonumber(houseowid)
		end
	end
	if hdis then 
		return hdis
	else 
		return nil
	end
end

function gethousevehslots(targethouse)
	local hid = getElementData(targethouse,"houseid")
	local result = dbPoll(dbQuery(connection, "SELECT * FROM an_houses WHERE id = ?",hid), -1)
	hvehslot = false
	for k,v in ipairs(result) do
		homevehslot = v["house_vehslot"]
		if homevehslot ~= nil then
			hvehslot = tonumber(homevehslot)
		end
	end
	if hvehslot then 
		return hvehslot + 1  
	else 
		return 1 
	end
end

addCommandHandler("hinfo",
function(ply,cmd)
    triggerClientEvent(ply, "houseinfos", ply)
end
)

function returnhouseinfo(ply,thouse)
    if thouse then
        local houseprice = getElementData(thouse,"houseprice")
        local houseinid = getElementData(thouse,"houseid")
        local houseowner = gethouseowner(thouse)
        local hvehslot = gethousevehslots(thouse)
        if not houseowner then
            if houseprice ~= "donate" then
                exports.an_infobox:addNotification(ply,"<b>Informações da casa</b><br><br><b>Número</b>: "..houseinid.." <br><br><b>Status</b>: a venda <br><br><b>Preço</b>: "..houseprice.." <br><br><b>Vagas na garagem</b>: "..hvehslot.." ","info")
            else
                exports.an_infobox:addNotification(ply,"<b>Informações da casa</b><br><br><b>Número</b>: "..houseinid.." <br><br>Esta casa é <b>premium</b> <br><br><b>Vagas na garagem</b>: "..hvehslot.."","info")
            end
        else
            exports.an_infobox:addNotification(ply,"<b>Informações da casa</b><br><br>Esta casa possui <b>proprietário</b> <br><br><b>Número</b>: "..houseinid.." <br><br><b>Vagas na garagem</b>: "..hvehslot.." ","info")
        end
    end
end
addEvent("returnhouseinfo",true)
addEventHandler ( "returnhouseinfo", getRootElement(), returnhouseinfo )


addCommandHandler("buy",
function(ply,cmd)
    triggerClientEvent(ply, "buyhouse", ply)
end
)

function getplyvehslots(ply)
	local plyid = getElementData(ply,"id")
	local result = dbPoll(dbQuery(connection, "SELECT house_vehslot FROM an_houses WHERE id_owner = ?",plyid), -1)
	hvehslot = false
	for k,v in ipairs(result) do
		homevehslot = v["house_vehslot"]
		if homevehslot ~= nil then
			hvehslot = tonumber(homevehslot)
		end
	end
	if hvehslot then 
		return hvehslot + 1  
	else 
		return 1 
	end
end

function buythehouse(ply,thouse,price)
    local hid = getElementData(thouse,"houseid")
    local houseowner = gethouseowner(thouse)
    local plyid = getElementData(ply,"id")
    local hply = getplyvehslots(ply)
    if hid then
        if plyid then
            if hply <= 1 then
                if not houseowner then
                    exports.an_inventory:sattitem(ply,"Money",price,"menos")
                    dbExec(connection, "UPDATE an_houses SET id_owner = ? WHERE id = ?",plyid,hid)
                    exports.an_infobox:addNotification(ply,"Casa <b>comprada</b> com sucesso!","sucesso")
                else
                    exports.an_infobox:addNotification(ply,"Esta casa tem <b>proprietário</b>.","aviso")
                end
            else
                exports.an_infobox:addNotification(ply,"Você já possui uma <b>casa</b>.","aviso")
            end
        end
    end
end
addEvent("buythehouse",true)
addEventHandler ( "buythehouse", getRootElement(), buythehouse )
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
