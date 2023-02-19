-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
local lookplayer = false
-------------------------------------------------------------------------------------------------------
-- Panel   - Revistar
-------------------------------------------------------------------------------------------------------
function createpanelpolice()
    webBrowser = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    html = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", html, load)
end

function load()
    loadBrowserURL(html, "http://mta/local/html/panel.html")
end

function openpolicepanel(ply2)
  if ply2 then
    if (not isElement(webBrowser)) then
        if getElementData(localPlayer,"openui") == false then
            lookplayer = ply2
            createpanelpolice()
            focusBrowser(html)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    end
  end
end
addEvent ("openpolicepanel", true)
addEventHandler ("openpolicepanel", root, openpolicepanel)

function requestinvinfo()
  if not lookplayer == false then
    local itemtb = exports.an_account:getitemtable3()
    for i,v in ipairs (itemtb) do
        local getplydata = getElementData(lookplayer, v[2]) or 0
        if getplydata >= 1 then
            execute(string.format("additem(%s,%s,%s,%s)",toJSON(v[5]),toJSON(getplydata),toJSON(v[1]),toJSON(v[1]..".png")))
        end
    end
  end
end
addEvent ("requestinvinfo", true)
addEventHandler ("requestinvinfo", root, requestinvinfo)

function closebindpl()
  if isElement(webBrowser) then
      execute(string.format("closegarage()"))
      guiSetVisible(webBrowser, false)
      destroyElement(webBrowser)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
      lookplayer = false
  end
end
addEvent ("closebindpl", true)
addEventHandler ("closebindpl", root, closebindpl)
bindKey("n", "down", closebindpl)

-------------------------------------------------------------------------------------------------------
-- Panel   - arsenal
-------------------------------------------------------------------------------------------------------

function createpanelarsenal()
  webBrowserarsenal = guiCreateBrowser(0.4, 0.25, 0.5, screenY, true, true, true)
  htmlarsenal = guiGetBrowser(webBrowserarsenal)
  addEventHandler("onClientBrowserCreated", htmlarsenal, loadarsenal)
end

function loadarsenal()
  loadBrowserURL(htmlarsenal, "http://mta/local/html/arsenal.html")
end

function thearsenalfunctions(data)
  if data then
      if data ~= "fechar" then
          triggerServerEvent("arsenalarms", localPlayer,localPlayer,data)
      end
      if data == "fechar" then
          closearsenal()
      end
  end
end
addEvent ("thearsenalfunctions", true)
addEventHandler ("thearsenalfunctions", root, thearsenalfunctions)

function openpolicearsenal()
  if (not isElement(webBrowserarsenal)) then
      if getElementData(localPlayer,"openui") == false then
          createpanelarsenal()
          focusBrowser(htmlarsenal)
          guiSetVisible(webBrowserarsenal, true)
          showCursor(true)
          setElementData(localPlayer,"openui",true)
      end
  end
end
addEvent ("openpolicearsenal", true)
addEventHandler ("openpolicearsenal", root, openpolicearsenal)

function closearsenal()
  if isElement(webBrowserarsenal) then
      execute(string.format("closegarage()"))
      guiSetVisible(webBrowserarsenal, false)
      destroyElement(webBrowserarsenal)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
  end
end
addEvent ("closearsenal", true)
addEventHandler ("closearsenal", root, closearsenal)

local targetcolarsenal = false
local showcolarsenal = false
local colarsenalid = false


function dxpressforpanelarsenal()
  if isElement(targetcolarsenal) then
      local x, y, z = getElementPosition(targetcolarsenal)
      local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z-0.5, 0.07)
      if (WorldPositionX and WorldPositionY) then
          dxDrawRectangle(WorldPositionX - 90, WorldPositionY -10, 175, 20, tocolor(0, 0, 0, 50), false)
          dxDrawColorText("#00e98cN #d6d6d6PARA ABRIR O ARSENAL", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
      end
  end
end

function inittratamentkey()
  if getElementData(localPlayer,"openui") == false then
    if exports.an_account:hasPermission('police.permission' ) then
      if isEventHandlerAdded("onClientRender", root, dxpressforpanelarsenal) then
          if (not isPedInVehicle(localPlayer)) then
            openpolicearsenal()
          end
      end
    end
  end
end
bindKey("N", "down", inittratamentkey)

function onHitshopscol(hitElement, dim)
if hitElement ~= localPlayer then return end
  if dim then
      if getElementData(source, "idarsenal") and isElement(getElementData(source, "colarsenal")) then
        targetcolarsenal = source
        showcolarsenal = true
        colarsenalid = getElementData(source,"idarsenal")
        setElementData(localPlayer,"noarsenal",true)
        if not isEventHandlerAdded("onClientRender", root, dxpressforpanelarsenal) then
            addEventHandler ("onClientRender", root, dxpressforpanelarsenal)
        end
      end
	end
end
addEventHandler("onClientColShapeHit", root, onHitshopscol)
------------------------------------------------------------
function onLeaveshopscol(hitElement, dim)
	if hitElement ~= localPlayer then return end
    if dim then
      if getElementData(localPlayer,"openui") == false then
        targetcolarsenal = false
        showcolarsenal = false
        colarsenalid = false
        setElementData(localPlayer,"noarsenal",false)
      end
      if isEventHandlerAdded("onClientRender", root, dxpressforpanelarsenal) then
          removeEventHandler ("onClientRender", root, dxpressforpanelarsenal)
      end
  	end
end
addEventHandler("onClientColShapeLeave", root, onLeaveshopscol)
----------------------------------------------------------------------------------------------------------------
-- Algemar
----------------------------------------------------------------------------------------------------------------
function algemartheply()
  if (not isPedInVehicle(localPlayer)) then
    if not getElementData(localPlayer,"Algemado") then
      if getElementData(localPlayer,"Algema") >= 1 then
        triggerServerEvent( "algemartheply", localPlayer,localPlayer)
      end
    end 
  end
end
bindKey("h", "down", algemartheply)

local hcuffsound = {}
function starthcuffsound(ply)
  if not isElement(hcuffsound[ply]) then
    local x,y,z = getElementPosition(ply)
    hcuffsound[ply] = playSound3D("files/hcuff.wav", x, y, z, true)
    setSoundMinDistance(hcuffsound[ply], 1)
    setSoundMaxDistance(hcuffsound[ply], 20)
    setSoundVolume(hcuffsound[ply],0.1)
    attachElements(hcuffsound[ply],ply)
  end
end
addEvent ("starthcuffsound", true)
addEventHandler ("starthcuffsound", root, starthcuffsound)

function stopcuffsound(ply)
  if isElement(hcuffsound[ply]) then
    stopSound(hcuffsound[ply])
  end
end
addEvent ("stopcuffsound", true)
addEventHandler ("stopcuffsound", root, stopcuffsound)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
timer = nil
function plyalgemdetect()
  if not getElementData(localPlayer,"logado") then return end
    if not isTimer(timer) then
        if isTimer(timer) then killTimer(timer) print("..") end
        timer = setTimer(function()
          for k, v in ipairs(getElementsByType("player")) do
            if getElementData(v,"Algemado") then
              local block, animation = getPedAnimation(v)
              if animation ~= "pass_Smoke_in_car" then
                setPedAnimation(v, "ped", "pass_Smoke_in_car", 0, true, false, false)
                setTimer ( setPedAnimationProgress, 100, 1, v, "pass_Smoke_in_car", 0)
                setTimer ( setPedAnimationSpeed, 100, 1, v, "pass_Smoke_in_car", 0)
              end
            end
          end
        end,100,0)
    end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), plyalgemdetect)


addEventHandler("onClientKey", root, 
function (button, press)
  if getElementData(getLocalPlayer(),"Algemado") then
    if button == "space" then
    cancelEvent()
    end
  end
end
)
----------------------------------------------------------------------------------------------------------------
-- acept isnpect
----------------------------------------------------------------------------------------------------------------
local emgplyid = nil
local timerconfirminspect = nil
function openconfirminspect(plyid)
  if plyid then
      emgplyid = plyid
      playSoundFrontEnd ( 44 )
      exports.an_infobox:addNotification("Pedido para <b>revistar</b>.  <br><br><b>Y</b> aceitar <b>U</b> negar.","aviso")
      timerconfirminspect = setTimer(function()
        emgplyid = nil
          exports.an_infobox:addNotification("Você recusou ser <b>revistado</b> por inatividade.","aviso")
      end,9000,1)
  end
end
addEvent ("openconfirminspect", true)
addEventHandler ("openconfirminspect", root, openconfirminspect)

function aceptinspect()
    if emgplyid then
      triggerServerEvent("aceptinspect", localPlayer,localPlayer,emgplyid)
      local plyid = getElementData(emgplyid,"id")
      emgplyid = nil
      if isTimer(timerconfirminspect) then killTimer(timerconfirminspect) end
    end
end
bindKey("y", "down", aceptinspect)

function rejectinspect()
    if emgplyid then
      emgplyid = nil
      exports.an_infobox:addNotification("Você recusou ser <b>revistado</b>.","aviso")
      if isTimer(timerconfirminspect) then killTimer(timerconfirminspect) end
    end
end
bindKey("u", "down", rejectinspect)
----------------------------------------------------------------------------------------------------------------
-- BLIPS - policiais em serviço
----------------------------------------------------------------------------------------------------------------
local plyblips = {}
function policeplyblips()
  if getElementData(localPlayer, 'logado') then
    for k,v in ipairs(getElementsByType("player")) do
      if exports.an_account:hasPermission("police.permission") or getElementData(v,"necessariplyblips") then
        if getElementData(v, "policetoggle") then 
            if not isElement(plyblips[v]) then
              plyblips[v] = createBlipAttachedTo(v, 2, 2, 0, 170, 170, 255, 50, 700)
              setElementData( plyblips[v], "tooltipText",'Officer - '..getElementData(v, "Nome")..' '..getElementData(v, "SNome"))
            end
        else
          if isElement(plyblips[v]) then
            destroyElement(plyblips[v])
          end
        end
      else
        if isElement(plyblips[v]) then
          destroyElement(plyblips[v])
        end
      end
    end
    if not getElementData(localPlayer, "policetoggle") then 
      if isElement(plyblips[v]) then
        destroyElement(plyblips[v])
      end
      for k,v in ipairs(getElementsByType("player")) do
        if getElementData(v, "policetoggle") then 
          if isElement(plyblips[v]) then
            destroyElement(plyblips[v])
          end
        end
      end
    end
  end
  setTimer(policeplyblips,1000,1)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), policeplyblips)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function destroyplypolicebliponquit(ply)
  if isElement(plyblips[ply]) then
    destroyElement(plyblips[ply])
  end
end
addEvent ("destroyplypolicebliponquit", true)
addEventHandler ("destroyplypolicebliponquit", root, destroyplypolicebliponquit)
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
-- get police
function getpoliceinservice()
count = 0
  for i, v in ipairs(getElementsByType("player")) do
    if getElementData(v, "policetoggle") then 
    count = count+1
    end
  end
return count
end
-- get medic
function getmedicinservice()
count = 0
  for i, v in ipairs(getElementsByType("player")) do
    if getElementData(v, "medictoggle") then 
    count = count+1
    end
  end
return count
end
-- get mechanic
function getmechanicinservice()
count = 0
  for i, v in ipairs(getElementsByType("player")) do
    if getElementData(v, "mechanictoggle") then 
    count = count+1
    end
  end
return count
end

function loadpaytow()
  triggerServerEvent("loadpaytow", localPlayer,localPlayer)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), loadpaytow)

-- execute js
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(html, eval)
    end
end
----------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
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
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
addEventHandler ( 'onClientResourceStart', getResourceRootElement(getThisResource()), function()
txd = engineLoadTXD('files/handcuff2',321)
engineImportTXD(txd,321)
dff = engineLoadDFF('files/handcuff',321)
engineReplaceModel(dff,321)
end)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------