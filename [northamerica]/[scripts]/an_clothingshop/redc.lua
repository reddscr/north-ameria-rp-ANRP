----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
local localscfg = cfg.locals
local shopscfg = cfg.shop
local lookatdepartament = false


local clothesidbuy = {}
local clothesprice = 0

local clothetyp = {}
local cpricelist = {}
local clotheconfgbuy = {}
----------------------------------------------------------------------------------------------------------------
-- HTML SHOP CONFIG
----------------------------------------------------------------------------------------------------------------
function createhtmldepst()
    webBrowser = guiCreateBrowser(0*screenX, 0*screenX, screenX, screenY, true, true, true)
    htmldepartments = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmldepartments, loadinv1)
end
function loadinv1()
    loadBrowserURL(htmldepartments, "http://mta/local/html/panel.html")
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function toggleclothshop()
    if not isElement(webBrowser) then
      if not getElementData(localPlayer,"wanted") then
        if getElementData(localPlayer,"openui") == false then
            createhtmldepst()
            focusBrowser(htmldepartments)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
            toggleAllControls(false)
           -- showChat(true)
            clothesidbuy = {}
            clothesprice = {}
            cpricelist = {}
            clothesprice = 0
            clotheconfgbuy = {}
        end
      else
        exports.an_infobox:addNotification("Você esta sendo procurado! a policia foi alertada.","aviso")
        triggerServerEvent("callclothingpolice", localPlayer, localPlayer)
      end
    end
end

function closeclothshop()
  if isElement(webBrowser) then
      guiSetVisible(webBrowser, false)
      destroyElement(webBrowser)
      showCursor(false)
    --  showChat(false)
      setElementData(localPlayer,"openui",false)
      toggleAllControls(true)
      triggerServerEvent("closechoshopandnobuy", localPlayer, localPlayer)
  end
end
addEvent ("closeclothshop", true)
addEventHandler ("closeclothshop", root, closeclothshop)

local clotheprice = {
  ["0"] = {"0","100"},
  ["2"] = {"2","100"},
  ["3"] = {"3","100"},
  ["13"] = {"13","100"},
  ["14"] = {"14","100"},
  ["15"] = {"15","100"},
  ["16"] = {"16","100"},
}

function clothingshop(data,data2,data3)
  if data then
    if data2 then
      if data3 then
        if cpricelist[clotheprice[data][1]] == nil then
          cpricelist[clotheprice[data][1]] = true
          clothesprice = clothesprice+clotheprice[data][2]
        end
        clotheconfgbuy[#clotheconfgbuy + 1] = {['clottyp']=tostring(data),['cloth']=data2,['clothdata']=data3}
        execute(string.format("setcompra(%s)",toJSON(clothesprice)))
        triggerServerEvent("previewclothe", localPlayer,localPlayer,data,data2,data3)
      end
    end
  end
end
addEvent ("clothingshop", true)
addEventHandler ("clothingshop", root, clothingshop)


function confirmbuycshop(price)
  if price then
    pri = tonumber(price)
    if getElementData(localPlayer,"Money") >= pri then
      if isElement(webBrowser) then
          guiSetVisible(webBrowser, false)
          destroyElement(webBrowser)
          showCursor(false)
          setElementData(localPlayer,"openui",false)
          toggleAllControls(true)
          for i, v in pairs (clotheconfgbuy) do
            triggerServerEvent("buyclothshop", localPlayer, localPlayer,v.clottyp,v.cloth,v.clothdata)
          end
          exports.an_inventory:attitem("Money",pri,"menos")
          exports.an_infobox:addNotification("Roupa(as) compradas com <b>sucesso</b>!","sucesso")
      end
    else
      exports.an_infobox:addNotification("Você não tem $ <b>"..pri.."</b>.","erro")
    end
  end
end
addEvent ("confirmbuycshop", true)
addEventHandler ("confirmbuycshop", root, confirmbuycshop)

function setplycshoprotation()
  if isElement(webBrowser) then
    local rotX, rotY, rotZ = getElementRotation(localPlayer)
    setElementRotation(localPlayer,0,0,rotZ+10,"default",true)
  end
end
addEvent ("setplycshoprotation", true)
addEventHandler ("setplycshoprotation", root, setplycshoprotation)

function setplycshoprotation2()
  if isElement(webBrowser) then
    local rotX, rotY, rotZ = getElementRotation(localPlayer)
    setElementRotation(localPlayer,0,0,rotZ-10,"default",true)
  end
end
addEvent ("setplycshoprotation2", true)
addEventHandler ("setplycshoprotation2", root, setplycshoprotation2)


local clothtimer = {}
function requestcloth1(data)
  for i, v in ipairs (cfg.mascara) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.calca) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.blusa) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.sapato) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.jaqueta) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.chapeu) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.oculos) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.corrente) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  for i, v in ipairs (cfg.relogio) do 
    if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
  end
  if tostring(data) == "mascara" then
    for i, v in ipairs (cfg.mascara) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "calca" then
    for i, v in ipairs (cfg.calca) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "blusa" then
    for i, v in ipairs (cfg.blusa) do 
     if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "sapato" then
    for i, v in ipairs (cfg.sapato) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "jaqueta" then
    for i, v in ipairs (cfg.jaqueta) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "chapeu" then
    for i, v in ipairs (cfg.chapeu) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "oculos" then
    for i, v in ipairs (cfg.oculos) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "corrente" then
    for i, v in ipairs (cfg.corrente) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  elseif tostring(data) == "relogio" then
    for i, v in ipairs (cfg.relogio) do 
      if isTimer(clothtimer[i]) then killTimer(clothtimer[i]) end
      clothtimer[i] = setTimer(function()
        execute(string.format("addcloth1(%s,%s,%s)",toJSON(data),toJSON(v[1]),toJSON(v[1]..".png")))
      end,50*i,1)
    end
  end
end
addEvent ("requestcloth1", true)
addEventHandler ("requestcloth1", root, requestcloth1)
----------------------------------------------------------------------------------------------------------------
-- COL SYSTEM
----------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
    local proxyonply = getproxyonply(1)
    if proxyonply then
        for i, v in ipairs (localscfg) do 
            if v.id == proxyonply then
                lookatdepartament = v.id
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(v.x, v.y, v.z-0.2, 0.07)
                if (WorldPositionX and WorldPositionY) then
                  if getElementData(localPlayer,"openui") == false then
                    dxDrawColorText("#00e98cN #d6d6d6ACESSAR A LOJA", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                  end
                end
            end
        end
    else
        lookatdepartament = false
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtoggleclothshop()
    if lookatdepartament then
        toggleclothshop()
    end
end
bindKey("n", "down", bindtoggleclothshop)
----------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(htmldepartments, eval)
    end
end

function getproxyonply(distance)
    local pX, pY, pZ = getElementPosition (localPlayer) 
	local dist = distance
	local id = false
    for i, v in ipairs (localscfg) do 
        --local id,x,y,z = unpack(v)
        if getDistanceBetweenPoints3D ( pX, pY, pZ, v.x, v.y, v.z) < dist then
            dist = getDistanceBetweenPoints3D ( pX, pY, pZ, v.x, v.y, v.z)
            id = v.id
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