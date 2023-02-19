----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- INIT RACE COL
----------------------------------------------------------------------------------------------------------------
function onhitcentralraceilegal(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        if getElementData(source, "idraceboat") and isElement(getElementData(source, "colraceboat")) then
            targetcolraceboat = source
            showcolraceboat = true
            colraceboatsid = getElementData(source,"idraceboat")
        end
    end
end
addEventHandler("onClientColShapeHit", root, onhitcentralraceilegal)
------------------------------------------------------------
function onleavecolraceilegal(hitElement, dim)
if hitElement ~= localPlayer then return end
if getElementData(source, "idraceboat") ~= colraceboatsid then return end
  if dim then
      targetcolraceboat = false
      showcolraceboat = false
      colraceboatsid = false
	end
end
addEventHandler("onClientColShapeLeave", root, onleavecolraceilegal)
----------------------------------------------------------------------------------------------------------------
-- RACE POINTS
----------------------------------------------------------------------------------------------------------------
local blips = false
local inrace = false
local plyveh = false
local timerace = 0
local raceboatpoint = 1
local racepos = 0 

local races = {
	[1] = {
		['time'] = 300,
        [1] = {247.443, -1927.929, -0.55},
        [2] = {153.217, -1920.054, 5.175},
        [3] = {70.047, -1915.635, -0.485},
        [4] = {39.981, -1746.184, -0.474},
        [5] = {52.826, -1416.717, -0.267},
        [6] = {70.961, -1227.738, -0.265},
        [7] = {71.453, -1101.233, -0.247},
        [8] = {50.261, -938.919, -0.26},
        [9] = {-87.516, -893.567, -0.297},
        [10] = {-131.788, -788.568, -0.487},
        [11] = {-61.879, -642.219, -0.273},
        [12] = {27.068, -535.151, -0.276},
        [13] = {156.921, -427.947, -0.28},
        [14] = {353.487, -310.374, -0.269},
        [15] = {570.794, -238.272, -0.294},
        [16] = {783.495, -164.858, -0.278},
        [17] = {921.241, -124.246, -0.233},
        [18] = {1224.616, -152.524, -0.258},
        [19] = {1367.649, -241.545, -0.255},
        [20] = {1539.99, -188.35, -0.266},
        [21] = {1643.69, -1.75, -0.278},
        [22] = {1750.306, -27.46, -0.245},
        [23] = {1948.768, -86.222, -0.267},
        [24] = {2090.96, 6.95, -0.264},
        [25] = {2151.987, 183.058, -0.28},
        [26] = {2149.403, 345.404, -0.239},
        [27] = {2017.102, 462.235, -0.252},
        [28] = {1847.383, 494.145, -0.253},
        [29] = {1524.989, 553.479, -0.259},
        [30] = {1275.231, 600.846, -0.3},
        [31] = {962.054, 619.326, -0.273},
        [32] = {768.156, 564.014, -0.232},
        [33] = {594.122, 480.124, -0.268},
        [34] = {467.883, 378.215, -0.257},
        [35] = {319.805, 308.942, -0.257},
        [36] = {131.97, 315.44, -0.289},
        [37] = {-63.592, 310.098, -0.254},
        [38] = {-268.215, 320.034, -0.289},
        [39] = {-420.046, 322.915, -0.285},
        [40] = {-597.38, 314.706, -0.278},
        [41] = {-751.003, 257.581, -0.278},
        [42] = {-815.145, 198.471, 3.387},
        [43] = {-885.293, 136.289, -0.234},
        [44] = {-958.129, 24.549, -0.279},
        [45] = {-1036.606, 6.337, -0.277},
	},
    [2] = {
		['time'] = 320,
        [1] = {312.535, -2054.241, -0.48},
        [2] = {386.9, -2099.529, -0.479},
        [3] = {472.64, -2090.715, -0.532},
        [4] = {599.78, -2074.811, -0.475},
        [5] = {734.001, -2078.471, -0.477},
        [6] = {844.198, -2103.239, -0.483},
        [7] = {828.183, -1970.661, -0.477},
        [8] = {756.133, -1975.563, -0.438},
        [9] = {654.22, -1979.298, -0.502},
        [10] = {528.185, -1981.475, -0.408},
        [11] = {378.348, -1992.083, -0.49},
        [12] = {348.392, -2149.191, -0.481},
        [13] = {514.596, -2125.398, -0.465},
        [14] = {611.393, -2147.721, -0.399},
        [15] = {708.962, -2206.269, -0.389},
        [16] = {796.102, -2265.035, -0.518},
        [17] = {1016.312, -2415.821, -0.482},
        [18] = {1165.44, -2559.563, -0.474},
        [19] = {1285.337, -2709.614, -0.505},
        [20] = {1488.634, -2783.886, -0.407},
        [21] = {1727.817, -2789.271, -0.487},
        [22] = {1934.327, -2785.934, -0.545},
        [23] = {2143.396, -2758.432, -0.463},
        [24] = {2311.602, -2671.222, -0.494},
        [25] = {2368.629, -2437.027, -0.454},
        [26] = {2520.718, -2301.796, -0.526},
        [27] = {2746.434, -2282.755, -0.477},
        [28] = {2889.705, -2408.333, -0.416},
        [29] = {2777.294, -2593.296, -0.523},
        [30] = {2667.319, -2642.487, -0.532},
        [31] = {2433.504, -2732.274, -0.437},
        [32] = {2343.096, -2749.518, -0.505},
        [33] = {2161.613, -2775.731, -0.377},
        [34] = {1985.162, -2801.711, -0.364},
        [35] = {1708.837, -2831.262, -0.387},
        [36] = {1346.043, -2784.523, -0.476},
        [37] = {1035.718, -2537.16, -0.375},
        [38] = {894.431, -2385.251, -0.423},
        [39] = {749.573, -2247.523, -0.529},
        [40] = {598.833, -2162.834, -0.418},
        [41] = {459.235, -2118.266, -0.423},
        [42] = {380.101, -2079.069, -0.48},
        [43] = {371.479, -1984.131, -0.467},
        [44] = {448.969, -1987.74, -0.462},
        [45] = {457.82, -2079.967, -0.486},
        [46] = {362.802, -2127.142, -0.459},
        [47] = {270.86, -2069.154, -0.437},
        [48] = {211.026, -2059.213, -0.499},
	},

}
----------------------------------------------------------------------------------------------------------------
-- START RACE
----------------------------------------------------------------------------------------------------------------
targetcolraceboat = false
showcolraceboat = false
colraceboatsid = false

local raceboattacol = {}
local raceboattamk = {}
local raceboattablip = {}

function startraceboatpoints()
    if getElementData(localPlayer,"openui") == false then
        if isPedInVehicle(localPlayer) then
            if isElement(targetcolraceboat) then
                if getPedOccupiedVehicleSeat (localPlayer) == 0 then
                    if not inrace then
                        local rcp = tonumber(getElementData(targetcolraceboat,"raceboatpoint"))
                        if rcp then
                            local veh = getPedOccupiedVehicle(localPlayer)
                            plyveh = veh
                            inrace = true
                            racepos = 1
                            raceboatpoint = rcp
                            timerace = races[raceboatpoint].time
                            CriandoBlip(races,raceboatpoint,racepos)
                            exports.an_infobox:addNotification("Você iniciou uma <b>corrida de barcos</b>!","info")
                            --triggerServerEvent("plyinitrage", localPlayer,localPlayer)
                            --exports.an_inventory:attitem("Raceticket","1","menos")
                            setElementData(localPlayer,"inraceboat",true)
                        end
                    end
                end
            end
        end
    end
end
bindKey("H", "down", startraceboatpoints)

function checkpoints(hitElement, dim)
if hitElement ~= localPlayer then return end
    if dim then
        local plyid = getElementData(localPlayer,"id")
        if getElementData(source, "raceboattacolowner") == plyid and isElement(getElementData(source, "raceboattacol")) then

            if racepos == #races[raceboatpoint] then
                inrace = false
                finishanddestroy()
                triggerServerEvent("paymentply_raceboat", localPlayer,localPlayer,raceboatpoint)
                setElementData(localPlayer,"inraceboat",nil)
            else
                racepos = racepos + 1
                CriandoBlip(races,raceboatpoint,racepos)
            end

        end
    end
end
addEventHandler("onClientColShapeHit", root, checkpoints)
----------------------------------------------------------------------------------------------------------------
-- CHECKPOINTS
----------------------------------------------------------------------------------------------------------------
function CriandoBlip(races,raceboatpoint,racepos)
    local plyid = getElementData(localPlayer,"id")
    if isElement(raceboattacol) then
        destroyElement(raceboattacol)
        destroyElement(raceboattamk)
        destroyElement(raceboattablip)
        raceboattablip = createBlip (races[raceboatpoint][racepos][1],races[raceboatpoint][racepos][2],races[raceboatpoint][racepos][3], 2, 2, 200, 200, 200, 200, 50, 7500)
        raceboattacol = createColSphere(races[raceboatpoint][racepos][1],races[raceboatpoint][racepos][2],races[raceboatpoint][racepos][3],17)
        raceboattamk = createMarker(races[raceboatpoint][racepos][1],races[raceboatpoint][racepos][2],races[raceboatpoint][racepos][3]-1, "checkpoint", 20, 0, 150, 200, 0)
        setElementData(raceboattacol,"raceboattacol",raceboattacol)
        setElementData(raceboattacol,"raceboattacolowner",plyid)
    elseif not isElement(raceboattacol) then
        raceboattablip = createBlip (races[raceboatpoint][racepos][1],races[raceboatpoint][racepos][2],races[raceboatpoint][racepos][3], 2, 2, 200, 200, 200, 200, 50, 7500)
        raceboattacol = createColSphere(races[raceboatpoint][racepos][1],races[raceboatpoint][racepos][2],races[raceboatpoint][racepos][3],17)
        raceboattamk = createMarker(races[raceboatpoint][racepos][1],races[raceboatpoint][racepos][2],races[raceboatpoint][racepos][3]-1, "checkpoint", 20, 0, 150, 200, 0)
        setElementData(raceboattacol,"raceboattacol",raceboattacol)
        setElementData(raceboattacol,"raceboattacolowner",plyid)
    end
end

function finishanddestroy()
    if isElement(raceboattacol) then
        destroyElement(raceboattacol)
        destroyElement(raceboattamk)
        destroyElement(raceboattablip)
    end
end
----------------------------------------------------------------------------------------------------------------
-- RACE NUI
----------------------------------------------------------------------------------------------------------------
function dxtratamentmdcmaca ()
    if inrace and timerace > 0 then
        dxDrawColorText("#edededRESTAM #4c98ff"..timerace.." #edededSEGUNDOS PARA CHEGAR AO DESTINO FINAL DA CORRIDA", screenW * 0.3294, screenH * 0.9128, screenW * 0.6698, screenH * 0.9414, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
        dxDrawColorText("#edededVENÇA A CORRIDA E SUPERE SEUS PROPRIOS RECORDES ANTES DO TEMPO ACABAR", screenW * 0.3294, screenH * 0.9414, screenW * 0.6698, screenH * 0.9701, tocolor(255, 255, 255, 200), 1.00, myFont, "center", "center", false, false, false, false, false)
    end
end
addEventHandler ("onClientRender", root, dxtratamentmdcmaca)
----------------------------------------------------------------------------------------------------------------
-- TIMERACE
----------------------------------------------------------------------------------------------------------------
function racetimetread()
    if inrace and timerace > 0 then
        timerace = timerace - 1
        if timerace <= 0 or not isPedInVehicle(localPlayer) then
                inrace = false
                finishanddestroy()
                setElementData(localPlayer,"inraceboat",nil)
                triggerServerEvent("destroyplyblip", localPlayer, localPlayer)
                exports.an_infobox:addNotification("Você não conseguiu terminar a corrida a tempo!","info")
        end
    end
setTimer(racetimetread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), racetimetread)

----------------------------------------------------------------------------------------------------------------
-- BLIPS
----------------------------------------------------------------------------------------------------------------
local plyblips = {}
local plyblips2 = {}

function bliprace(plyracer)
    if not isElement(plyblips[plyracer]) then
        plyblips[plyracer] = createBlipAttachedTo(plyracer, 2, 2, 200, 0, 0, 255, 50, 700)
    end
end
addEvent ("bliprace", true)
addEventHandler ("bliprace", root, bliprace)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destoyilraceblip(ply)
  if isElement(plyblips[ply]) then
    destroyElement(plyblips[ply])
  end
  if isElement(plyblips2[ply]) then
    destroyElement(plyblips2[ply])
  end
end
addEvent ("destoyilraceblip", true)
addEventHandler ("destoyilraceblip", root, destoyilraceblip)

setElementData(localPlayer,"inraceboat",nil)
function racerplyblips()
    for k,v in ipairs(getElementsByType("player")) do
        --if getElementData(v,"user_group") == "police" or getElementData(v,"necessariplyblips") then
        if getElementData(v, "inraceboat") then 
            if not isElement(plyblips2[v]) then
                plyblips2[v] = createBlipAttachedTo(v, 2, 2, 200, 0, 0, 255, 50, 700)
            end
        else
            if isElement(plyblips2[v]) then
                destroyElement(plyblips2[v])
            end
        end
    -- end
        if not getElementData(localPlayer, "inraceboat") then 
            if isElement(plyblips2[v]) then
            destroyElement(plyblips2[v])
            end
            for k,v in ipairs(getElementsByType("player")) do
                if getElementData(v, "inraceboat") then 
                    if isElement(plyblips2[v]) then
                        destroyElement(plyblips2[v])
                    end
                end
            end
        end
    end
  setTimer(racerplyblips,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), racerplyblips)
----------------------------------------------------------------------------------------------------------------
-- VARIAEIS
----------------------------------------------------------------------------------------------------------------
function getFormatSpeed(ply)
  local speedes = (getVehicleVelocity((getPedOccupiedVehicle(ply)))) * 1.558
  return speedes
end
function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	return relateVelocity((speedx^2 + speedy^2 + speedz^2)^ 0.5 * 100)
end
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
local factor = 0.675
function relateVelocity(speed)
	return factor * speed
end 
--------------------------------------------------------------------
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if 
        type( sEventName ) == 'string' and 
        isElement( pElementAttachedTo ) and 
        type( func ) == 'function' 
    then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
  
    return false
end
--------------------------------------------------------------------
function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY)
    bx, by, color, scale, font = bx or ax, by or ay, color or tocolor(255,255,255,255), scale or 1, font or Font_5
    if alignX then
      if alignX == "center" then
        ax = ax + (bx - ax - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font))/2
      elseif alignX == "right" then
        ax = bx - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
      end
    end
    if alignY then
      if alignY == "center" then
        ay = ay + (by - ay - dxGetFontHeight(scale, font))/2
      elseif alignY == "bottom" then
        ay = by - dxGetFontHeight(scale, font)
      end
    end
     local clip = false
     if dxGetTextWidth(str:gsub("#%x%x%x%x%x%x","")) > bx then clip = true end
    local alpha = string.format("%08X", color):sub(1,2)
    local pat = "(.-)#(%x%x%x%x%x%x)"
    local s, e, cap, col = str:find(pat, 1)
    local last = 1
    local text = ""
    local broke = false
    while s do
      if cap == "" and col then color = tocolor(getColorFromString("#"..col..alpha)) end
      if s ~= 1 or cap ~= "" then
        local w = dxGetTextWidth(cap, scale, font)
             if clip then
                  local text_ = ""
                   for i = 1,string.len(cap) do
                    if dxGetTextWidth(text,scale,font) < bx then
                    text = text..""..string.sub(cap,i,i)
                    text_ = text_..""..string.sub(cap,i,i)
                    else
                    broke = true
                     break
                    end
                   end
                   cap = text_
                  end
        dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
        ax = ax + w
        color = tocolor(getColorFromString("#"..col..alpha))
      end
      last = e + 1
      s, e, cap, col = str:find(pat, last)
    end
    if last <= #str and not broke then
      cap = str:sub(last)
                     if clip then
                  local text_ = ""
                   for i = 1,string.len(cap) do
                    if dxGetTextWidth(text,scale,font) < bx then
                    text = text..""..string.sub(cap,i,i)
                    text_ = text_..""..string.sub(cap,i,i)
                    else
                    broke = true
                     break
                    end
                   end
                   cap = text_
                  end
      dxDrawText(cap, ax, ay, ax + dxGetTextWidth(cap, scale, font), by, color, scale, font)
    end
  end