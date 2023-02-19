-------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
-- N C 
----------------------------------------------------------------------------------------------------------------
function ativencmode(timeslice)
    if isChatBoxInputActive() or isConsoleActive() then
        return
    end
    local cx,cy,cz,ctx,cty,ctz = getCameraMatrix()
    ctx,cty = ctx-cx,cty-cy
    timeslice = timeslice*0.05
    if not isConsoleActive() then
        if getKeyState("rshift") then timeslice = timeslice*10 end
		if getKeyState("ralt") then timeslice = timeslice*0.05 end
        if getKeyState("num_7") then timeslice = timeslice*4 end
        if getKeyState("num_9") then timeslice = timeslice*0.25 end
        if getKeyState("lshift") then timeslice = timeslice*1 end
        local mult = timeslice/math.sqrt(ctx*ctx+cty*cty)
        ctx,cty = ctx*mult,cty*mult
        if getKeyState("w") then
            abx,aby = abx+ctx,aby+cty
            
            local a = thencmode(0)
            setElementRotation(localPlayer,0,0,a)
        end
        if getKeyState("s") then
            abx,aby = abx-ctx,aby-cty
            
            local a = thencmode(180)
            setElementRotation(localPlayer,0,0,a)
        end
        if getKeyState("d") then
            abx,aby = abx+cty,aby-ctx
            
            local a = thencmode(90)
            setElementRotation(localPlayer,0,0,a)
        end
        if getKeyState("a") then
            abx,aby = abx-cty,aby+ctx
            
            local a = thencmode(-90)
            setElementRotation(localPlayer,0,0,a)
        end
        if getKeyState("space") then
            abz = abz+timeslice
        end
        if getKeyState("lctrl") then
            abz = abz-timeslice
        end
    end
        
    tempPos = abx, aby, abz
    setElementPosition(localPlayer,abx,aby,abz)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function togglencmode()
    air_brake = not air_brake or nil
    if air_brake then
        abx,aby,abz = getElementPosition(localPlayer)
		setElementData(localPlayer, "nc", true)
		triggerServerEvent( "ncon", localPlayer )
		setElementCollisionsEnabled(localPlayer, false)
        addEventHandler("onClientPreRender",root,ativencmode)
    else
        abx,aby,abz = nil
		setElementData(localPlayer, "nc", false)
		triggerServerEvent( "ncoff", localPlayer )
		setElementCollisionsEnabled(localPlayer, true)
        removeEventHandler("onClientPreRender",root,ativencmode)
    end
end
----------------------------------------------------------------------------------------------------------------
-- god mode
----------------------------------------------------------------------------------------------------------------
addEvent("agodModeOn", true)
addEvent("agodModeOff", true)
addEventHandler ("agodModeOn", getRootElement(), 
function()
  addEventHandler ("onClientPlayerDamage", getRootElement(), cancelEventEvent)
end)

addEventHandler ("agodModeOff", getRootElement(), 
function()
  removeEventHandler ("onClientPlayerDamage", getRootElement(), cancelEventEvent)
end)

function cancelEventEvent () cancelEvent() end 
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function thencmode(rzOffset)
    local cx,cy,_,fx,fy = getCameraMatrix(getLocalPlayer())
    local deltaY,deltaX = fy-cy,fx-cx
    local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
    if deltaY >= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    elseif deltaY <= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    end
    return -rotZ+90 + rzOffset
end
addEvent("Admin->fly->toggle", true)
addEventHandler("Admin->fly->toggle", getRootElement(), togglencmode)
----------------------------------------------------------------------------------------------------------------
-- copy cords
----------------------------------------------------------------------------------------------------------------
function funtcopy(x,y,z)
    local text = table.concat ( { math.round ( x, 3 ), math.round ( y, 3 ), math.round ( z, 3 ), int }, ', ' )
    local success = setClipboard( text )
end
addEvent ("funtcopy", true)
addEventHandler ("funtcopy", root, funtcopy)
----------------------------------------------------------------------------------------------------------------
--dev mode
----------------------------------------------------------------------------------------------------------------
addCommandHandler("devmodeoff",
function(cmd)
if not (getElementData(localPlayer, "Admin", true)) then return end
    setDevelopmentMode(false)
end
)

addCommandHandler("devmodeon",
function(cmd)
if not (getElementData(localPlayer, "Admin", true)) then return end
    setDevelopmentMode(true, true)
end
)
----------------------------------------------------------------------------------------------------------------
-- TP COM NC
----------------------------------------------------------------------------------------------------------------
function tpcdsply(x,y,z)
    abx,aby,abz = x,y,z
end
addEvent ("tpcdsply", true)
addEventHandler ("tpcdsply", root, tpcdsply)
----------------------------------------------------------------------------------------------------------------
-- TOGGLE SCRENN PLAYERS INFO
----------------------------------------------------------------------------------------------------------------
local togglescreeninfos = false
function screenplysinfos()
    if togglescreeninfos then
        local plyx, plyy, plyz = getElementPosition (localPlayer) 
        local dist = 20
        local players = getElementsByType("player")
        for i, v in ipairs (players) do 
            if localPlayer ~= v then
                local pX, pY, pZ = getElementPosition (v) 
                if getDistanceBetweenPoints3D (plyx, plyy, plyz, pX, pY, pZ) < dist then
                    dist = getDistanceBetweenPoints3D (plyx, plyy, plyz, pX, pY, pZ)
                    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(pX, pY, pZ+0.95, 0.07)
                    if (WorldPositionX and WorldPositionY) then
                        local plyid = getElementData(v,'id')
                        local plyname = getElementData(v,'Nome')
                        local plysname = getElementData(v,'SNome')
                        if plyid then
                            if getElementData(v, 'falando') then
                                dxDrawColorText("#ffffcc"..plyid.." - "..plyname.." "..plysname, WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 255), 1, myFont, "center", "center", false, false, false, false, false)
                            else
                                dxDrawColorText("#cccccc"..plyid.." - "..plyname.." "..plysname, WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 255), 1, myFont, "center", "center", false, false, false, false, false)
                            end
                        end
                    end
                end
            end
        end
    end
end
addEventHandler('onClientRender',getRootElement(),screenplysinfos)

function togglescreenadmininfo()
    if not togglescreeninfos then
        togglescreeninfos = true
    else
        togglescreeninfos = false
    end
end
addEvent ("togglescreenadmininfo", true)
addEventHandler ("togglescreenadmininfo", root, togglescreenadmininfo)
-------------------------------------------------------------------------------------------------------------------
-- GERAL VARIABLES
-------------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end

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
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
