-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------

local sound = {}
function setlocalsound(pos,time)
    local position = fromJSON(pos)
    if position then
        if not isElement(sound[position[1]]) then
            sound[position[1]] = playSound3D("files/alarm.ogg", position[1], position[2], position[3], true)
            setElementDimension(sound[position[1]], 0)
            setElementDimension(sound[position[1]], 0)
            setSoundMinDistance(sound[position[1]], 100)
            setSoundMaxDistance(sound[position[1]], 220)
            setSoundVolume(sound[position[1]],0.1)
            setTimer(function()
                if isElement(sound[position[1]]) then
                    stopSound(sound[position[1]])
                end
            end,1000*time,1)
        end
    end
end
addEvent ("setlocalsound", true)
addEventHandler ("setlocalsound", root, setlocalsound)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------