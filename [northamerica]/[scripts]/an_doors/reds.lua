local doorblock = {}
local doorobj = {}
local doorcol = {}

function startandcreatedoors()
    for k,v in pairs(cfg.doorcfg) do
        local id,doortype,x,y,z,rx,ry,rz,rx2,ry2,rz2,blockx,blocky,blockz,doorgroup,doormodeltype,emersion = unpack(v)
        if doormodeltype == "porta" then
            if doortype then
                doorblock[id] = createObject (2904,blockx,blocky,blockz,rx,ry,rz)
                setElementAlpha(doorblock[id], 0)
                doorobj[id] = createObject ( doortype, x,y,z-1,rx,ry,rz )
                setElementCollisionsEnabled(doorobj[id], false)
                doorcol[id] = createColSphere(blockx,blocky,blockz-0.5,1)
                setElementData(doorcol[id],"groupdoorstats","Fechado")
                setElementData(doorcol[id],"colgroupgroupdoor",doorcol[id])
                setElementData(doorcol[id],"colgroupdoorsobject",doorobj[id])
                setElementData(doorcol[id],"colgroupdoorsblock",doorblock[id])
                setElementData(doorcol[id],"groupdoorid",id)
                setElementData(doorcol[id],"groupdoor",doorgroup)
                setElementData(doorcol[id],"groupdoortype",doormodeltype)
                setElementData(doorcol[id],"groupdoorposs",toJSON({x,y,z,rx,ry,rz}))
            end
        elseif doormodeltype == "portao" then
            if doortype then
                doorobj[id] = createObject ( doortype, x,y,z,rx,ry,rz )
                doorcol[id] = createColSphere(x,y,z-0.5,4)
                setElementData(doorcol[id],"groupdoorstats","Fechado")
                setElementData(doorcol[id],"colgroupgroupdoor",doorcol[id])
                setElementData(doorcol[id],"colgroupdoorsobject",doorobj[id])
                setElementData(doorcol[id],"groupdoorid",id)
                setElementData(doorcol[id],"groupdoor",doorgroup)
                setElementData(doorcol[id],"groupdoortype",doormodeltype)
                setElementData(doorcol[id],"groupdoorposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2,emersion}))
            end
        elseif doormodeltype == 'portaolado' then
            if doortype then
                doorobj[id] = createObject ( doortype, x,y,z,rx,ry,rz )
                doorcol[id] = createColSphere(x,y,z-0.5,emersion)
                setElementData(doorcol[id],"groupdoorstats","Fechado")
                setElementData(doorcol[id],"colgroupgroupdoor",doorcol[id])
                setElementData(doorcol[id],"colgroupdoorsobject",doorobj[id])
                setElementData(doorcol[id],"groupdoorid",id)
                setElementData(doorcol[id],"groupdoor",doorgroup)
                setElementData(doorcol[id],"groupdoortype",doormodeltype)
                setElementData(doorcol[id],"groupdoorposs",toJSON({x,y,z,rx,ry,rz,rx2,ry2,rz2,emersion}))
            end
        end
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), startandcreatedoors)

function openandclosedoorgroup(ply,typ,col)
    if col then
        if (getElementData(col,"groupdoortype") == "porta") then
            if typ == "open" then
                setElementData(col,"groupdoorstats","Aberto")
                setElementCollisionsEnabled(getElementData(col,"colgroupdoorsobject"), true)
                setElementCollisionsEnabled(getElementData(col,"colgroupdoorsblock"), false)
            elseif typ == "close" then
                local poss = getElementData(col,"groupdoorposs")
                p = fromJSON(poss)
                setElementData(col,"groupdoorstats","Fechado")
                setElementCollisionsEnabled(getElementData(col,"colgroupdoorsobject"), false)
                setElementRotation(getElementData(col,"colgroupdoorsobject"),p[4],p[5],p[6])
                setElementCollisionsEnabled(getElementData(col,"colgroupdoorsblock"), true)
            end
        elseif (getElementData(col,"groupdoortype") == "portao") then
            if typ == "open" then
                local poss = getElementData(col,"groupdoorposs")
                p = fromJSON(poss)
                setElementData(col,"groupdoorstats","Aberto")
                setElementPosition(getElementData(col,"colgroupdoorsobject"),p[1],p[2],p[3]+p[10])
                setElementRotation(getElementData(col,"colgroupdoorsobject"),p[7],p[8],p[9])
            elseif typ == "close" then
                local poss = getElementData(col,"groupdoorposs")
                p = fromJSON(poss)
                setElementData(col,"groupdoorstats","Fechado")
                setElementPosition(getElementData(col,"colgroupdoorsobject"),p[1],p[2],p[3])
                setElementRotation(getElementData(col,"colgroupdoorsobject"),p[4],p[5],p[6])
            end
        elseif (getElementData(col,"groupdoortype") == "portaolado") then
            if typ == "open" then
                local poss = getElementData(col,"groupdoorposs")
                p = fromJSON(poss)
                setElementData(col,"groupdoorstats","Aberto")
                moveObject(getElementData(col,"colgroupdoorsobject"),2000,p[7],p[8],p[9])
                --setElementPosition(getElementData(col,"colgroupdoorsobject"),p[1],p[2],p[3]+p[10])
                --setElementRotation(getElementData(col,"colgroupdoorsobject"),p[7],p[8],p[9])
            elseif typ == "close" then
                local poss = getElementData(col,"groupdoorposs")
                p = fromJSON(poss)
                setElementData(col,"groupdoorstats","Fechado")
                moveObject(getElementData(col,"colgroupdoorsobject"),2000,p[1],p[2],p[3])
                --setElementPosition(getElementData(col,"colgroupdoorsobject"),p[1],p[2],p[3])
                --setElementRotation(getElementData(col,"colgroupdoorsobject"),p[4],p[5],p[6])
            end
        end
    end
end
addEvent("openandclosedoorgroup",true)
addEventHandler ( "openandclosedoorgroup", getRootElement(), openandclosedoorgroup )
