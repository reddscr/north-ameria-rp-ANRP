----------------------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
----------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
----------------------------------------------------------------------------------------------------------------------------------
local Tig = false
local TigError = false
local typ = false
local qtd = false
----------------------------------------------------------------------------------------------------------------------------------
-- WEB NUI
----------------------------------------------------------------------------------------------------------------------------------
function createhtml()
  webnui = guiCreateBrowser( 0, 0, screenX, screenY, true, true, true)
  htmlnui = guiGetBrowser(webnui)
  addEventHandler("onClientBrowserCreated", htmlnui, load)
end
function load()    
  loadBrowserURL(htmlnui, "http://mta/local/nui/nui.html")  
end

function narequestsort(trigg,trigg2,qt)
  if (not isElement(webnui)) then
    if not getElementData(localPlayer, 'onSortBar') then
      if qt then
        qtd = qt
      else
        qtd = 1
      end
      typ = 'client'
      Tig = trigg
      TigError = trigg2
      createhtml()
      focusBrowser(htmlnui)
      guiSetVisible(webnui, true)
      setElementData(localPlayer,"openui",true)
      setElementData(localPlayer,"onSortBar",true)
    end
  end
end

addEvent("narequestsort", true)
addEventHandler("narequestsort", root, function(trigg,trigg2,qt)
  if (not isElement(webnui)) then
    if not getElementData(localPlayer, 'onSortBar') then
      if qt then
        qtd = qt
      else
        qtd = 1
      end
      typ = 'server'
      Tig = trigg
      TigError = trigg2
      createhtml()
      focusBrowser(htmlnui)
      guiSetVisible(webnui, true)
      setElementData(localPlayer,"openui",true)
      setElementData(localPlayer,"onSortBar",true)
    end
  end
end)

function keyPressToResult()
  if (isElement(webnui)) then
    executeBrowserJavascript(htmlnui, string.format("requestonKeypressed()"))
  end
end
bindKey('n','down',keyPressToResult)

function removeSortBar()
  if (isElement(webnui)) then
    guiSetVisible(webnui, false)
    destroyElement(webnui)
    setElementData(localPlayer,"openui",false)
    typ = false
    Tig = false 
    qtd = false
    TigError = false
    setElementData(localPlayer,"onSortBar",false)
  end
end
addEvent ("removeSortBar", true)
addEventHandler ("removeSortBar", root, removeSortBar)

function resultbarsort(data)
  if data == 'true' then
    if qtd > 1 then
        guiSetVisible(webnui, false)
        destroyElement(webnui)
        qtd = qtd -1
        createhtml()
        focusBrowser(htmlnui)
        guiSetVisible(webnui, true)
    else
      if (isElement(webnui)) then
        guiSetVisible(webnui, false)
        destroyElement(webnui)
        setElementData(localPlayer,"openui",false)
      end
      if typ == 'client' then
        triggerEvent ( Tig, localPlayer )
      elseif typ == 'server' then
        triggerServerEvent ( Tig, localPlayer, localPlayer )
      end
      typ = false
      Tig = false 
      qtd = false
      TigError = false
      setElementData(localPlayer,"onSortBar",false)
    end
  else
    if (isElement(webnui)) then
      guiSetVisible(webnui, false)
      destroyElement(webnui)
      setElementData(localPlayer,"openui",false)
    end
    if typ == 'client' then
      triggerEvent ( TigError, localPlayer )
    elseif typ == 'server' then
      triggerServerEvent ( TigError, localPlayer, localPlayer )
    end
    typ = false
    Tig = false 
    qtd = false
    TigError = false
    setElementData(localPlayer,"onSortBar",false)
  end
end
addEvent ("resultbarsort", true)
addEventHandler ("resultbarsort", root, resultbarsort)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
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