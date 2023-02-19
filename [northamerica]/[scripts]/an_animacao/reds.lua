----------------------------------------------------------------------------------------------------------------
-- connect
----------------------------------------------------------------------------------------------------------------
local connection = exports["an_connect"]:getConnection()
---------------------------------------------------------------------------------------------------------------
-- STOP ANIM
---------------------------------------------------------------------------------------------------------------
local Animobject = {}
local Animobject2 = {}

function stopplyanimsv(ply)
    if ply then
        if getElementData(ply,"animdeitado") == true then
            setElementData(ply,"animdeitado",false)
        end
        setPedAnimation( ply, nil )
        setElementData(ply,"fazendoplyanims",false)
        setElementData(ply,"fazendoplyanimsobj", nil)
        destoryplyobject(ply,"all")
    end
end
addEvent("stopplyanimsv",true)
addEventHandler ( "stopplyanimsv", getRootElement(), stopplyanimsv )
---------------------------------------------------------------------------------------------------------------
-- ANIMATIONS OBJECTS
---------------------------------------------------------------------------------------------------------------
addCommandHandler("e",
function(ply,cmd,anim)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            if anim then
                destoryplyobject(ply,"all")
                if anim == "box" then
                    local plyx, plyy, plyz = getElementPosition(ply)
                    Animobject[ply] = createObject(1220, plyx, plyy, plyz)
                    setObjectScale(Animobject[ply], 0.6)
                    setElementCollisionsEnabled(Animobject[ply], false)
                    exports.bone_attach:attachElementToBone (Animobject[ply], ply, 12,0.24,0.17,0.07,80,90,70)
                    toggleControl ( ply, 'fire', false )
                    toggleControl ( ply, 'aim_weapon', false )
                    toggleControl ( ply, 'jump', false )
                    toggleControl ( ply, 'sprint', false )
                    toggleControl ( ply, 'crouch', false )
                    toggleControl ( ply, 'action', false )
                    setElementData( ply,"fazendoplyanims",true)
                    setElementData( ply,"fazendoplyanimsobj",true)
                    setPedAnimation( ply, "CARRY", "crry_prtial", 1, true, true, true )
                elseif anim == "soundbox" then
                    local plyx, plyy, plyz = getElementPosition(ply)
                    Animobject2[ply] = createObject(2226, plyx, plyy, plyz)
                    setObjectScale(Animobject2[ply], 0.6)
                    setElementCollisionsEnabled(Animobject2[ply], false)
                    exports.bone_attach:attachElementToBone (Animobject2[ply], ply, 12,0,0.03,0.27,0,180,10)
                    setElementData( ply,"fazendoplyanims",true) 
                elseif anim == "suitcase" then
                    local plyx, plyy, plyz = getElementPosition(ply)
                    Animobject2[ply] = createObject(1210, plyx, plyy, plyz)
                    setObjectScale(Animobject2[ply], 1)
                    setElementCollisionsEnabled(Animobject2[ply], false)
                    exports.bone_attach:attachElementToBone (Animobject2[ply], ply, 12,0,0.09,0.29,0,180,10)
                    setElementData( ply,"fazendoplyanims",true) 
                end 
            end
        end
    end
end)
---------------------------------------------------------------------------------------------------------------
-- ANIMATIONS
---------------------------------------------------------------------------------------------------------------
addCommandHandler("e",
function(ply,cmd,anim)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            if not ( anim == nil) and not (anim == "") then
                for i,v in ipairs (cfg.animations) do
                    if anim == v[1] then
                        destoryplyobject(ply,1)
                        setTimer(function()
                            setElementData(ply,"fazendoplyanims",true)
                            setPedAnimation(ply, v[2], v[3], -1, true, false, false )
                        end,50,1)
                    elseif anim == "morrer" then
                        destoryplyobject(ply,1)
                        setTimer(function()
                            setElementData(ply,"fazendoplyanims",true)
                            setElementData(ply,"animdeitado",true)   
                        end,50,1)
                    elseif anim == "stop" then
                        if getElementData(ply,"fazendoplyanims") == true then
                            destoryplyobject(ply,1)
                            setPedAnimation( ply, nil )
                            setElementData(ply,"fazendoplyanims",false)
                        end
                    end
                end
            end
        else
            exports.an_infobox:addNotification(ply,"Você está em <b>ação</b>!","aviso")
        end
    end
end
)
---------------------------------------------------------------------------------------------------------------
-- E2
---------------------------------------------------------------------------------------------------------------
addCommandHandler("e2",
function(ply,cmd,anim)
    if not (getElementData(ply, "Admin", true)) then return end
    local tagertply = exports.an_player:getproxply(ply,8)
    if tagertply then
        targetSpeed = getElementSpeed(tagertply)
        if targetSpeed <= 0 then
            if not ( anim == nil) and not (anim == "") then
                for i,v in ipairs (cfg.animations) do
                    if anim == v[1] then
                        destoryplyobject(tagertply,1)
                        setTimer(function()
                            setElementData(tagertply,"fazendoplyanims",true)
                            setPedAnimation(tagertply, v[2], v[3], -1, true, false, false )
                        end,50,1)
                    elseif anim == "morrer" then
                        destoryplyobject(tagertply,1)
                        setElementData(tagertply,"fazendoplyanims",true)
                        setElementData(tagertply,"animdeitado",true)   
                    elseif anim == "stop" then
                        if getElementData(tagertply,"fazendoplyanims") == true then
                            setPedAnimation( tagertply, nil )
                            setElementData(tagertply,"fazendoplyanims",false)
                            destoryplyobject(tagertply,1)
                        end
                    end
                end
            end
        end
    end
end
)
---------------------------------------------------------------------------------------------------------------
-- DESTROY OBJECTS
---------------------------------------------------------------------------------------------------------------
function destoryplyobject(ply,typ)
    if typ == 1 then
        if isElement(Animobject[ply]) then
            exports.bone_attach:detachElementFromBone(Animobject[ply])
            destroyElement(Animobject[ply])
            Animobject[ply] = nil
            toggleControl ( ply, 'fire', true )
            toggleControl ( ply, 'aim_weapon', true )
            toggleControl ( ply, 'jump', true )
            toggleControl ( ply, 'sprint', true )
            toggleControl ( ply, 'crouch', true )
            toggleControl ( ply, 'action', true )
            setPedAnimation( ply, "rapping", "laugh_01", -1, true, false, false )
            setTimer(setPedAnimation, 50, 1, ply, nil)
        end
    elseif typ == "all" then
        if isElement(Animobject[ply]) then
            exports.bone_attach:detachElementFromBone(Animobject[ply])
            destroyElement(Animobject[ply])
            Animobject[ply] = nil
            toggleControl ( ply, 'fire', true )
            toggleControl ( ply, 'aim_weapon', true )
            toggleControl ( ply, 'jump', true )
            toggleControl ( ply, 'sprint', true )
            toggleControl ( ply, 'crouch', true )
            toggleControl ( ply, 'action', true )
            setPedAnimation( ply, "rapping", "laugh_01", -1, true, false, false )
            setTimer(setPedAnimation, 50, 1, ply, nil)
        elseif isElement(Animobject2[ply]) then
            exports.bone_attach:detachElementFromBone(Animobject2[ply])
            destroyElement(Animobject2[ply])
            Animobject2[ply] = nil
        end
    end
end

function destroyOnQuit()
    if isElement(Animobject[source]) then
        exports.bone_attach:detachElementFromBone(Animobject[source])
        destroyElement(Animobject[source])
        Animobject[source] = nil
    elseif isElement(Animobject2[source]) then
        exports.bone_attach:detachElementFromBone(Animobject2[source])
        destroyElement(Animobject2[source])
        Animobject2[source] = nil
    end
end
addEventHandler ("onPlayerQuit", root, destroyOnQuit)
---------------------------------------------------------------------------------------------------------------
-- style walk
---------------------------------------------------------------------------------------------------------------
addCommandHandler("default",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,0) 
            setElementData(ply,"walkstyle",0)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",0,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("old",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,118) 
            setElementData(ply,"walkstyle",118)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",118,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("old2",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,119) 
            setElementData(ply,"walkstyle",119)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",119,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("old3",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,120) 
            setElementData(ply,"walkstyle",120)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",120,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("cool2",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,121) 
            setElementData(ply,"walkstyle",121)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",121,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("cool3",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,122) 
            setElementData(ply,"walkstyle",122)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",122,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("oldfat",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,123) 
            setElementData(ply,"walkstyle",123)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",123,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("fat",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,124) 
            setElementData(ply,"walkstyle",124)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",124,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("jogger",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,125) 
            setElementData(ply,"walkstyle",125)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",125,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("drunk",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,126) 
            setElementData(ply,"walkstyle",126)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",126,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("blind",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,127) 
            setElementData(ply,"walkstyle",127)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",127,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("cool",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,128) 
            setElementData(ply,"walkstyle",128)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",128,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("woman",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,129) 
            setElementData(ply,"walkstyle",129)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",129,plyid)
        end 
    end
end
)
------------------------------------------
addCommandHandler("woman2",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,131) 
            setElementData(ply,"walkstyle",131)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",131,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("woman3",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,132) 
            setElementData(ply,"walkstyle",132)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",132,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("woman4",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,133) 
            setElementData(ply,"walkstyle",133)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",133,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("oldwoman",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,134) 
            setElementData(ply,"walkstyle",134)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",134,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("fatwoman",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,135) 
            setElementData(ply,"walkstyle",135)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",135,plyid)
        end
    end
end
)
------------------------------------------
addCommandHandler("jogwoman",
function(ply,cmd)
    targetSpeed = getElementSpeed(ply)
    if targetSpeed <= 0 then
        if not getElementData(ply,"emacao") then
            setPedWalkingStyle(ply,136) 
            setElementData(ply,"walkstyle",136)
            local plyid = getElementData(ply,"id")
            local pdtwalk = dbExec(connection, "UPDATE an_character SET Walkstyle=? WHERE id =?",136,plyid)
        end
    end
end
)
---------------------------------------------------------------------------------------------------------
------- HAND UP
---------------------------------------------------------------------------------------------------------
function starthandup(ply)
    setPedAnimation(ply, "GHANDS", "gsign1", 0, true, false, false)
    setTimer ( setPedAnimationProgress, 100, 1, ply, "gsign1", 1.7)
    setTimer ( setPedAnimationSpeed, 100, 1, ply, "gsign1", 0)
end
addEvent("starthandup", true)
addEventHandler("starthandup", getRootElement(), starthandup)

function stophandup(ply)
    setTimer ( setPedAnimation, 50, 1, ply,  "GHANDS", "gsign1", 7000, false, false, false)
    setTimer ( setPedAnimation, 100, 1, ply, nil)
end
addEvent("stophandup", true)
addEventHandler("stophandup", getRootElement(), stophandup)
---------------------------------------------------------------------------------------------------------
------- apont
---------------------------------------------------------------------------------------------------------
wpnid = {
    [28] = true,
}

addEventHandler ( 'onPlayerWeaponSwitch', getRootElement ( ),
    function ( previousWeaponID, currentWeaponID )
        if ( wpnid[currentWeaponID] ) then
            --toggleControl ( source, 'fire', false )
            setControlState ( source, "aim_weapon", true )
            setPlayerHudComponentVisible(source, "crosshair", false)
        else
            --toggleControl ( source, 'fire', true )
            setControlState ( source, "aim_weapon", false )
            setPlayerHudComponentVisible(source, "crosshair", true)
        end
    end
)
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
local timeapont = {}
local timerloock = {}
function addApontar(p)
    if not timeapont[p] then 
        timeapont[p] = true
        toggleControl(p,'fire',false)
        toggleControl(p,'action',false)
        toggleControl(p,'aim_weapon',false)
        if not isTimer(timerloock[p]) then
            timerloock[p] = setTimer(function()
                giveWeapon(p, 28, 10000, true)
            end, 100, 1)
        end
    end
end
addEvent("addApontar", true)
addEventHandler("addApontar", getRootElement(), addApontar)

function removerApontar(p)
    if timeapont[p] then 
        timeapont[p] = nil
        takeWeapon(p, 28)
        toggleControl(p,'fire',true)
        toggleControl(p,'aim_weapon',true)
        toggleControl(p,'action',true)
        if isTimer(timerloock[p]) then
            killTimer(timerloock[p])
        end
    end
end
addEvent("removerApontar", true)
addEventHandler("removerApontar", getRootElement(), removerApontar)
---------------------------------------------------------------------------------------------------------
-- VARIAEIS
---------------------------------------------------------------------------------------------------------
function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return (x^2 + y^2 + z^2) ^ 0.5 * 100
        else
            return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
        end
    else
        return false
    end
end
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------