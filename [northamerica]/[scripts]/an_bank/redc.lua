----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local localscfg = cfg.locals
local shopscfg = cfg.shop
local lookatbank = false

local machineTimer = 0
local machineStart = false
----------------------------------------------------------------------------------------------------------------
-- HTML CONFIG
----------------------------------------------------------------------------------------------------------------
local webBrowser = false
function createhtmlbank()
    webBrowser = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    htmlanui = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmlanui, loadinv1)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function loadinv1()
    loadBrowserURL(htmlanui, "http://mta/local/html/panel.html")
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function togglebank()
    if not isElement(webBrowser) then
        if getElementData(localPlayer,"openui") == false then
            createhtmlbank()
            focusBrowser(htmlanui)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
end

function closebank()
  if isElement(webBrowser) then
      guiSetVisible(webBrowser, false)
      destroyElement(webBrowser)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
  end
end
addEvent ("closebank", true)
addEventHandler ("closebank", root, closebank)


function depositbank(val)
  if isElement(webBrowser) then
    valor = tonumber(val)
    if valor then
      triggerServerEvent( "bankdeposit", localPlayer,localPlayer,valor)
    end
  end
end
addEvent ("depositbank", true)
addEventHandler ("depositbank", root, depositbank)

function withdrawbank(val)
  if isElement(webBrowser) then
    valor = tonumber(val)
    if valor then
      triggerServerEvent( "bankwithdraw", localPlayer,localPlayer,valor)
    end
  end
end
addEvent ("withdrawbank", true)
addEventHandler ("withdrawbank", root, withdrawbank)

function transferbank(val,id)
  if isElement(webBrowser) then
    valor = tonumber(val)
    tid = tonumber(id)
    if valor and tid then
      triggerServerEvent( "banktransfer", localPlayer,localPlayer,valor,tid)
    end
  end
end
addEvent ("transferbank", true)
addEventHandler ("transferbank", root, transferbank)

function paymentmultas()
  if isElement(webBrowser) then
    local plymultas = tonumber(getElementData(localPlayer,"multas"))
    if plymultas >= 1 then
      triggerServerEvent( "bankpaymultas", localPlayer,localPlayer,plymultas)
    else
      msgbank("Você não possui <b>multas pendentes</b>.", "erro")
    end
  end
end
addEvent ("paymentmultas", true)
addEventHandler ("paymentmultas", root, paymentmultas)

function requestbankinfos()
  if isElement(webBrowser) then
    local infos = 'Olá <g>'..getElementData(localPlayer,'Nome')..' '..getElementData(localPlayer,'SNome')..'</g>, a sua conta é <g>'..getElementData(localPlayer,"id")..'</g>'
    local bank = getElementData(localPlayer,"BankMoney")
    local mao = getElementData(localPlayer,"Money")
    if infos and bank and mao then
      execute(string.format("setbankinfos(%s, %s, %s)",toJSON(bank),toJSON(mao),toJSON(infos)))
    end
  end
end
addEvent ("requestbankinfos", true)
addEventHandler ("requestbankinfos", root, requestbankinfos)

function msgbank(text, type)
  if text then
    if type then
        local definition = {
            css = type,
            mensagem = text
        }
        execute(string.format("message(%s,%s)",toJSON(type),toJSON(text)))
    end
  end
end
addEvent ("msgbank", true)
addEventHandler ("msgbank", root, msgbank)
----------------------------------------------------------------------------------------------------------------
-- COL SYSTEM
----------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
    local proxyonply = getproxyonply(1.3)
    if proxyonply then
        for i, v in ipairs (localscfg) do 
          local id,x,y,z,rx,ry,rz = unpack(v)
            if id == proxyonply then
                lookatbank = id
                toggleControl ( "enter_passenger", false )
                toggleControl ( "enter_exit", false )
                toggleControl ( "next_weapon", false )
                toggleControl ( "previous_weapon", false )
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.5, 0.07)
                if (WorldPositionX and WorldPositionY) then
                  if getElementData(localPlayer,"openui") == false and (not machineStart) then
                    dxDrawColorText("#d6d6d6[E] : #3b8ff7ACESSAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    if getElementData(localPlayer, 'Dynamit') >= 1 then
                      dxDrawColorText("#d6d6d6[G] : #910808ROUBAR", WorldPositionX - 1, WorldPositionY + 50, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                    end
                  end
                end
            end
        end
    else
      if lookatbank then
        toggleControl ( "enter_passenger", true )
        toggleControl ( "enter_exit", true )
        toggleControl ( "next_weapon", true )
        toggleControl ( "previous_weapon", true )
        lookatbank = false
      end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtogglebank()
  if lookatbank then
    if not machineStart then
      if not isPedInVehicle(localPlayer) then
        togglebank()
      end
    end
  end
end
bindKey("e", "down", bindtogglebank)

function bindtogglebank()
  if lookatbank then
    if not machineStart then
      if not isPedInVehicle(localPlayer) then
        if getElementData(localPlayer, 'Dynamit') >= 1 then
          triggerServerEvent( "startbanktheft", localPlayer,localPlayer,lookatbank)
        end
      end
    end
  end
end
bindKey("g", "down", bindtogglebank)

function dxcountmachineatm()
    if machineStart then
        local x, y, z = getElementPosition(localPlayer)
        local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+0.1, 0.07)
        local WorldPositionX2, WorldPositionY2 = getScreenFromWorldPosition(x,y,z+0.15, 0.07)
        if (WorldPositionX and WorldPositionY) then
            dxDrawColorText("#d6d6d6PLANTANDO A BOMBA APERTE #910808N #d6d6d6PARA CANCELAR", WorldPositionX2 - 1, WorldPositionY2 + 1, WorldPositionX2 - 1, WorldPositionY2 + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
            dxDrawColorText("#d6d6d6RESTAM #3b8ff7"..machineTimer.." #d6d6d6SEGUNDOS PARA TERMINAR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
        end
    end
end
addEventHandler("onClientRender", getRootElement(), dxcountmachineatm)
------------------------------------------------------------------------------------------------------------------------------
function startstealmachine(time)
    if not machineStart then
        machineTimer = time
        machineStart = true
    end
end
addEvent ("startstealmachine", true)
addEventHandler ("startstealmachine", root, startstealmachine)
------------------------------------------------------------------------------------------------------------------------------
function machinetimertread()
    if machineStart and machineTimer > 0 then
        machineTimer = machineTimer - 1
        if machineTimer == 0 then
            stopMachine()
        end
    end
setTimer(machinetimertread,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), machinetimertread)
------------------------------------------------------------------------------------------------------------------------------
function bindstopMachine()
    if machineStart then
        machineStart = false
        machineTimer = 0
        triggerServerEvent("stopmachine", localPlayer,localPlayer)
    end
end
bindKey("n", "down", bindstopMachine)
------------------------------------------------------------------------------------------------------------------------------
function stopMachine()
    if machineStart then
        machineStart = false
        machineTimer = 0
    end
end
------------------------------------------------------------------------------------------------------------------------------
-- BANK OBJECT
------------------------------------------------------------------------------------------------------------------------------
local caixa = {}
function setobjprop(obj)
    for i,v in ipairs (localscfg) do
        local id,x,y,z,rx,ry,rz = unpack(v)
        caixa[id] = createObject ( 1948, x,y,z-0.4,rx,ry,rz )
        setObjectBreakable(caixa[id], false)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), setobjprop)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(htmlanui, eval)
    end
end

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (localscfg) do 
        local bid,x,y,z,rx,ry,rz = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z ) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z )
            id = bid
        end
    end
    if id then
        return id
    else
        return false
    end
end

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