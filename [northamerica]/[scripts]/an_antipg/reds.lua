----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local partslist = {
  {"wheel_lf_dummy",1},
  {"wheel_rf_dummy",3},
  {"wheel_lb_dummy",2},
  {"wheel_rb_dummy",4},
}
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local anapgtimer = {}
function anantipg(veh)
    if not isTimer(anapgtimer[veh]) then
        local rw = math.random(#partslist)
        local wheels = {getVehicleWheelStates(veh)}
        if wheels[partslist[rw][2]] ~= 1 then
            wheels[partslist[rw][2]] = 1
            setVehicleWheelStates(veh,wheels[1],wheels[2],wheels[3],wheels[4])
            local getvehf = getElementData(veh,"fuel")
            setVehicleEngineState(veh,false)
            setElementData(veh, "fuel", getElementData(veh, "fuel") - getvehf) 
            anapgtimer[veh] = setTimer(function()end,3000,1)
        end
    end
end
addEvent ("anantipg", true)
addEventHandler ("anantipg", root, anantipg)
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local anapgtimer2 = {}
function anantipg2(veh)
    if not isTimer(anapgtimer2[veh]) then
        local rw = math.random(#partslist)
        local wheels = {getVehicleWheelStates(veh)}
        if wheels[partslist[rw][2]] ~= 1 then
            wheels[partslist[rw][2]] = 1
            setVehicleWheelStates(veh,wheels[1],wheels[2],wheels[3],wheels[4])
            setElementHealth(veh,250)
            setVehicleEngineState(veh,false)
            for i=0,6 do
                setVehicleDoorState(veh,i,4)
            end
            anapgtimer2[veh] = setTimer(function()end,3000,1)
        end
    end
end
addEvent ("anantipg2", true)
addEventHandler ("anantipg2", root, anantipg2)
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------