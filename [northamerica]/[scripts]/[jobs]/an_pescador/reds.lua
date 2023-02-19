----------------------------------------------------------------------------------------------------------------
-- comprador de peixescfg
----------------------------------------------------------------------------------------------------------------
local centralpescadorped = {}

function createmksshops()
    for i,v in ipairs (cfg.locals) do
        local jid, x, y, z, rotx, roty, rotz = unpack(v)
        centralpescadorped[jid] = createPed( 302, x, y, z )
        setElementRotation( centralpescadorped[jid], rotx, roty, rotz )
        setElementFrozen(centralpescadorped[jid],true)
		setElementData(centralpescadorped[jid],"npc",true)
    end
end
addEventHandler ("onResourceStart", getResourceRootElement(getThisResource()), createmksshops)

----------------------------------------------------------------------------------------------------------------
-- JOB ANIMATIONS SYNC
----------------------------------------------------------------------------------------------------------------
local Animobject2 = {}
function fishingjobanimation(ply,typ)
    if typ == 'start' then
        toggleControl ( ply, "walk", false )
        setPedAnimation( ply,"SWORD", "sword_IDLE", -1, true, true, true)

        local plyx, plyy, plyz = getElementPosition(ply)
        Animobject2[ply] = createObject(338, plyx, plyy, plyz)
        setObjectScale(Animobject2[ply], 1)
        setElementCollisionsEnabled(Animobject2[ply], false)
        exports.bone_attach:attachElementToBone (Animobject2[ply], ply, 12,0.2,0.02,0,0,280,0)
    elseif typ == 'stop' then
        setPedAnimation( ply, false)
        toggleControl ( ply,"walk", true )
        if isElement(Animobject2[ply]) then
            exports.bone_attach:detachElementFromBone(Animobject2[ply])
            destroyElement(Animobject2[ply])
            Animobject2[ply] = nil
        end
    end
end
addEvent("fishingjobanimation",true)
addEventHandler ( "fishingjobanimation", getRootElement(), fishingjobanimation )

function destroyOnQuit()
    if isElement(Animobject2[source]) then
        exports.bone_attach:detachElementFromBone(Animobject2[source])
        destroyElement(Animobject2[source])
        Animobject2[source] = nil
    end
end
addEventHandler ("onPlayerQuit", root, destroyOnQuit)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------