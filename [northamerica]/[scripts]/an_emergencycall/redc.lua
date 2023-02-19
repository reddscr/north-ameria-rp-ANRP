-------------------------------------------------------------------------------------------------------
-- screen
-------------------------------------------------------------------------------------------------------
local screenW,screenH = guiGetScreenSize()
local resW, resH = 1360,768
local x, y = (screenW/resW), (screenH/resH)
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function createpanelprompt()
    webBrowserprompt = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlprompt = guiGetBrowser(webBrowserprompt)
    addEventHandler("onClientBrowserCreated", htmlprompt, loadprompt)
end

function loadprompt()
  loadBrowserURL(htmlprompt, "http://mta/local/html/prompt.html")
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
calltype = false
function openplyprompt(type)
    if type then
        if (not isElement(webBrowserprompt)) then
            if getElementData(localPlayer,"openui") == false then
                createpanelprompt()
                focusBrowser(htmlprompt)
                guiSetVisible(webBrowserprompt, true)
                showCursor(true)
                setElementData(localPlayer,"openui",true)
                calltype = type
                setTimer(function()
                        local testtitle = "Por qual motivo você fez a chamada?"
                        local testtext = "aperte [ TAB ] para enviar"
                    execute(string.format("openpompt(%s,%s)",toJSON(testtitle),toJSON(testtext)))
                end,500,1)
            end
        end
    end
end
addEvent("openplyprompt", true)
addEventHandler("openplyprompt", getRootElement(), openplyprompt)

function closeprompt()
    if isElement(webBrowserprompt) then
        execute(string.format("closeprompt()"))
        guiSetVisible(webBrowserprompt, false)
        destroyElement(webBrowserprompt)
        setElementData(localPlayer,"openui",false)
        showCursor(false)
    end
end
addEvent ("closeprompt", true)
addEventHandler ("closeprompt", root, closeprompt)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function nomessageemgcall()
    exports.an_infobox:addNotification("A <b>chamada</b> foi <b>cancelada</b> por não ter motivo.","aviso")
end
addEvent ("nomessageemgcall", true)
addEventHandler ("nomessageemgcall", root, nomessageemgcall)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
function sendmessageemgcall(dt)
    local motv = tostring(dt)
    plymotvo = motv
    triggerServerEvent ("setplyemgcall", localPlayer,localPlayer,plymotvo,calltype)
end
addEvent ("sendmessageemgcall", true)
addEventHandler ("sendmessageemgcall", root, sendmessageemgcall)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
local callingply = {}
local callingplycount = 0
local callingplyPlayer = {}
local callingplyTimer = {}
local callingplyName = {}
local callingplyMotive = {}

function abrirconfirmchamado(ply2,plycnome,motive)
    if ply2 then
        callingplycount = callingplycount + 1
        callingply[callingplycount] = callingplycount
        callingplyPlayer[callingplycount] = ply2
        callingplyName[callingplycount] = plycnome
        callingplyMotive[callingplycount] = motive
        exports.an_request:naquestionrequest(callingplycount,"Chamado recebido: <br><br> Nome: "..callingplyName[callingplycount].."<br><br> Motivo: "..callingplyMotive[callingplycount].."",20)
        destroycallingPingreq(callingplycount)
    end
end
addEvent ("abrirconfirmchamado", true)
addEventHandler ("abrirconfirmchamado", root, abrirconfirmchamado)

function destroycallingPingreq(id)
    if id then
        if callingply[id] then
            callingplyTimer[id] = setTimer(function()
                callingply[id] = nil
                callingplyPlayer[id] = nil
                callingplyTimer[id] = nil
                callingplyName[id] = nil
                callingplyMotive[id] = nil
                callingplycount = callingplycount - 1
                exports.an_request:naremovequestionrequest(id)
            end,1000*20, 1)
        end
    end
end

function tablecallingrequests_()
  if callingply then
    for k, v in next, callingply do
        return v
    end
  end
end

function aceptcallingrequest()
    if callingply then
        local rid = tablecallingrequests_()
        if rid then
            local plyid = getElementData(callingplyPlayer[rid],"id")
            local x,y,z = getElementPosition(callingplyPlayer[rid])
            triggerServerEvent ("notifyemergencyplayer", localPlayer,localPlayer,callingplyPlayer[rid])
            createemgblip(plyid,x,y,z)
            callingply[rid] = nil
            callingplycount = callingplycount - 1
            exports.an_request:naremovequestionrequest(rid)
            callingplyPlayer[rid] = nil
            callingplyName[rid] = nil
            callingplyMotive[rid] = nil
            if isTimer(callingplyTimer[rid]) then killTimer(callingplyTimer[rid]) callingplyTimer[rid] = nil end
        end
    end
end
bindKey("y", "down", aceptcallingrequest)

function denycallingrequest()
    if callingply then
        local rid = tablecallingrequests_()
        if rid then
            callingply[rid] = nil
            callingplyPlayer[rid] = nil
            callingplyName[rid] = nil
            callingplyMotive[rid] = nil
            callingplycount = callingplycount - 1
            exports.an_request:naremovequestionrequest(rid)
            if isTimer(callingplyTimer[rid]) then killTimer(callingplyTimer[rid]) callingplyTimer[rid] = nil end
        end
    end
end
bindKey("u", "down", denycallingrequest)
-------------------------------------------------------------------------------------------------------
-- Create blip
-------------------------------------------------------------------------------------------------------
local mkemgconfigblip = {}
function createemgblip(id,x,y,z)
  if x and y and z then
    local mid = #mkemgconfigblip + 1
    if mid then
      mkemgconfigblip[mid] = createBlip (x,y,z, 2, 2, 200, 200, 0, 255, 50, 17500)
      setElementData(mkemgconfigblip[mid],'id',mid)
      setTimer(function()
        if isElement(mkemgconfigblip[mid]) then
          destroyElement(mkemgconfigblip[mid])
          mkemgconfigblip[mid] = nil
        end
      end,60000,1)
    end
  end
end
addEvent ("createemgblip", true)
addEventHandler ("createemgblip", root, createemgblip)

function createemgblip2(id,x,y,z,msg)
  if x and y and z and msg then
    local mid = #mkemgconfigblip + 1
    if mid then
      mkemgconfigblip[mid] = createBlip (x,y,z, 2, 2, 200, 0, 0, 255, 50, 17500)
      setElementData(mkemgconfigblip[mid],'id',mid)
      exports.an_infobox:addNotification(msg,"erro")
      setTimer(function()
        if isElement(mkemgconfigblip[mid]) then
          destroyElement(mkemgconfigblip[mid])
          mkemgconfigblip[mid] = nil
        end
      end,60000,1)
    end
  end
end
addEvent ("createemgblip2", true)
addEventHandler ("createemgblip2", root, createemgblip2)

function checkpoint_emp()
  local proxyply = getproxyonply(25)
  if proxyply then
    if isElement(proxyply) then
      destroyElement(proxyply)
      playSoundFrontEnd ( 45 )
      exports.an_infobox:addNotification("Você chegou ao local <b>solicitado</b>!","info")
    end
  end
end
addEventHandler("onClientRender", root, checkpoint_emp)

function getproxyonply(distance)
  local pX, pY, pZ = getElementPosition (localPlayer) 
  local dist = distance
  local tid = false
  for i, v in ipairs (mkemgconfigblip) do
    if isElement(v) then
      local x, y, z = getElementPosition(v)
      if getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z) < dist then
          dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x, y, z)
          tid = v
      end
    end
  end
  if tid then
      return tid
  else
      return false
  end
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
-- execute js
function execute(eval)
    if isElement(webBrowserprompt) then
        executeBrowserJavascript(htmlprompt, eval)
    end
end
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
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

addEventHandler("onClientKey", root, 
function (button, press)
  if isElement(webBrowserprompt) then
    if button == "mouse1" or button == "mouse2" or button == "mouse3" or button == "mouse4" or button == "mouse5" or button == "mouse_wheel_up" or 
    button == "mouse_wheel_down" or button == "arrow_l" or button == "arrow_u" or button == "arrow_r" or button == "0" or 
    button == "1" or button == "2" or button == "3" or button == "4" or button == "5" or button == "6" or button == "7" 
    or button == "8" or button == "9" or button == "b" or button == "c"  or button == "e" 
    or button == "f" or button == "g" or button == "h" or button == "i" or button == "j" or button == "k" or button == "l"
    or button == "m"or button == "n"or button == "o"or button == "p"or button == "q"or button == "r"or button == "s"or button == "t"
    or button == "u"or button == "v"or button == "x"or button == "y"or button == "num_0"or button == "num_1" or button == "num_2" 
    or button == "num_3" or button == "num_4" or button == "num_5" or button == "num_6" or button == "num_7" or button == "num_8" or button == "num_9" or button == "num_mul" 
    or button == "num_add" or button == "num_sep" or button == "num_sub" or button == "num_div" or button == "num_dec" or button == "num_enter" or button == "F1" or button == "F2" 
    or button == "F3" or button == "F4" or button == "F5" or button == "F6" or button == "F7" or button == "F8" or button == "F9" or button == "F10" 
    or button == "F11" or button == "F12" or button == "escape" or button == "backspace" or button == "lalt" or button == "ralt" or button == "enter" 
    or button == "space" or button == "pgup" or button == "pgdn" or button == "end" or button == "home" or button == "insert" or button == "delete" or button == "lshift" 
    or button == "rshift" or button == "lctrl" or button == "rctrl" or button == "[" or button == "]" or button == "pause" or button == "capslock" or button == "scroll" 
    or button == ";" or button == "," or button == "-" or button == "." or button == "/" or button == "#" or button == "\\" or button == "=" 
    then
    cancelEvent()
    end
  end
end
)