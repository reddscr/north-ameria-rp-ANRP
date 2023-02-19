----------------------------------------------------------------------------------------------------------------
--get screen
----------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )

local objectpreviw = {}
local object = {}

----------------------------------------------------------------------------------------------------------------
-- POSITION OBJECT UI
----------------------------------------------------------------------------------------------------------------


function createpanelanmoveis()
  webBrowseranmoveis = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
  htmlanmoveis = guiGetBrowser(webBrowseranmoveis)
  addEventHandler("onClientBrowserCreated", htmlanmoveis, loadanmoveis)
end

function loadanmoveis()
  loadBrowserURL(htmlanmoveis, "http://mta/local/html/panel.html")
end
 

function openpoliceanmoveis(objid)
  if (not isElement(webBrowseranmoveis)) then
    createpanelanmoveis()
    guiSetVisible(webBrowseranmoveis, true)
    setElementData(localPlayer,"openui",true)
    toggleAllControls(false)
    object = objid
    if not isElement(objectpreviw) then
      local x, y, z = getElementPosition ( localPlayer )
      local rx,ry,rz = getElementRotation ( localPlayer )
      objectpreviw = createObject ( object, x,y,z-0.5, 0, 0, 0 )
      fastmode = false
      setElementCollisionsEnabled(objectpreviw, false)
      setElementAlpha(objectpreviw, 160)
      setElementAlpha(localPlayer, 0)
    end
  end
end
addEvent ("openpoliceanmoveis", true)
addEventHandler ("openpoliceanmoveis", root, openpoliceanmoveis)


function openpoliceanmoveis2(objid,mx, my, mz,mrx, mry, mrz)
  if (not isElement(webBrowseranmoveis)) then
    createpanelanmoveis()
    guiSetVisible(webBrowseranmoveis, true)
    setElementData(localPlayer,"openui",true)
    toggleAllControls(false)
    object = objid
    fastmode = false
    if not isElement(objectpreviw) then
      objectpreviw = createObject ( object, mx, my, mz,mrx, mry, mrz )
      setElementCollisionsEnabled(objectpreviw, false)
      setElementAlpha(objectpreviw, 160)
      setElementAlpha(localPlayer, 0)
    end
  end
end
addEvent ("openpoliceanmoveis2", true)
addEventHandler ("openpoliceanmoveis2", root, openpoliceanmoveis2)

function closeanmoveisbind()
  if isElement(objectpreviw) then
      if not fastmode then
          fastmode = true
      else
          fastmode = false
      end
  end
end
bindKey("f", "down", closeanmoveisbind)

function fastmove()
  if isElement(objectpreviw) then
    local pX, pY, pZ = getElementPosition (localPlayer) 
    local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(pX, pY, pZ+0.5, 0.07)
    if (WorldPositionX and WorldPositionY) then
      local _, _, obrz = getElementRotation (objectpreviw) 
      dxDrawColorText("#d6d6d6"..math.round(obrz,1).."º", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
    end
      if fastmode then
          if getKeyState("w") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local rx, ry, rz = getElementRotation ( localPlayer )
              if rz <= 60 then
                  local origX, origY, origZ = getElementPosition ( objectpreviw )
                  moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
              elseif rz <= 160 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
              elseif rz <= 200 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
              elseif rz <= 300 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
              elseif rz <= 360 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
              end
            end
          elseif getKeyState("a") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local rx, ry, rz = getElementRotation ( localPlayer )
              if rz <= 60 then
                  local origX, origY, origZ = getElementPosition ( objectpreviw )
                  moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
              elseif rz <= 160 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
              elseif rz <= 200 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
              elseif rz <= 300 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
              elseif rz <= 360 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
              end
            end
          elseif getKeyState("d") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local rx, ry, rz = getElementRotation ( localPlayer )
              if rz <= 60 then
                  local origX, origY, origZ = getElementPosition ( objectpreviw )
                  moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
              elseif rz <= 160 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
              elseif rz <= 200 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
              elseif rz <= 300 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
              elseif rz <= 360 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
              end
            end
          elseif getKeyState("s") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local rx, ry, rz = getElementRotation ( localPlayer )
              if rz <= 60 then
                  local origX, origY, origZ = getElementPosition ( objectpreviw )
                  moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
              elseif rz <= 160 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
              elseif rz <= 200 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
              elseif rz <= 300 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
              elseif rz <= 360 then
                local origX, origY, origZ = getElementPosition ( objectpreviw )
                moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
              end
            end
          elseif getKeyState("arrow_u") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local origX, origY, origZ = getElementPosition ( objectpreviw )
              moveObject ( objectpreviw, 0,origX, origY, origZ +0.01)
            end
          elseif getKeyState("arrow_d") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local origX, origY, origZ = getElementPosition ( objectpreviw )
              moveObject ( objectpreviw, 0,origX, origY, origZ -0.01)
            end
          elseif getKeyState("arrow_l") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local x,y,z = getElementRotation ( objectpreviw )
              setElementRotation(objectpreviw,x,y,z+1)
            end
          elseif getKeyState("arrow_r") then
            local pX, pY, pZ = getElementPosition (localPlayer) 
            local x, y, z = getElementPosition (objectpreviw) 
            if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then  
              local x,y,z = getElementRotation ( objectpreviw )
              setElementRotation(objectpreviw,x,y,z-1)
            end
          end
      end
  end
end
addEventHandler ("onClientRender", root, fastmove)

function closeanmoveisbind()
  if isElement(webBrowseranmoveis) then
    guiSetVisible(webBrowseranmoveis, false)
    destroyElement(webBrowseranmoveis)
    setElementData(localPlayer,"openui",false)
    toggleAllControls(true)
    fastmode = false
    if isElement(objectpreviw) then
      destroyElement(objectpreviw)
    end
    setElementAlpha(localPlayer, 255)
 end
end
bindKey("N", "down", closeanmoveisbind)

function modebind1()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local rx, ry, rz = getElementRotation ( localPlayer )
        if rz <= 60 then
            local origX, origY, origZ = getElementPosition ( objectpreviw )
            moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
        elseif rz <= 160 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
        elseif rz <= 200 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
        elseif rz <= 300 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
        elseif rz <= 360 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
        end
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("w", "down", modebind1)

function modebind2()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local rx, ry, rz = getElementRotation ( localPlayer )
        if rz <= 60 then
            local origX, origY, origZ = getElementPosition ( objectpreviw )
            moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
        elseif rz <= 160 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
        elseif rz <= 200 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
        elseif rz <= 300 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
        elseif rz <= 360 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
        end
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("a", "down", modebind2)

function modebind3()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local rx, ry, rz = getElementRotation ( localPlayer )
        if rz <= 60 then
            local origX, origY, origZ = getElementPosition ( objectpreviw )
            moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
        elseif rz <= 160 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
        elseif rz <= 200 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
        elseif rz <= 300 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
        elseif rz <= 360 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
        end
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("d", "down", modebind3)

function modebind4()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
        if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local rx, ry, rz = getElementRotation ( localPlayer )
        if rz <= 60 then
            local origX, origY, origZ = getElementPosition ( objectpreviw )
            moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
        elseif rz <= 160 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX+0.01, origY, origZ )
        elseif rz <= 200 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY+0.01, origZ )
        elseif rz <= 300 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX-0.01, origY, origZ )
        elseif rz <= 360 then
          local origX, origY, origZ = getElementPosition ( objectpreviw )
          moveObject ( objectpreviw, 0,origX, origY-0.01, origZ )
        end
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("s", "down", modebind4)

function modebind5()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local origX, origY, origZ = getElementPosition ( objectpreviw )
        moveObject ( objectpreviw, 0,origX, origY, origZ +0.01)
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("arrow_u", "down", modebind5)

function modebind6()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local origX, origY, origZ = getElementPosition ( objectpreviw )
        moveObject ( objectpreviw, 0,origX, origY, origZ -0.01)
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end    
end
bindKey("arrow_d", "down", modebind6)

function modebind6()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local x,y,z = getElementRotation ( objectpreviw )
        setElementRotation(objectpreviw,x,y,z+0.1)
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("arrow_l", "down", modebind6)

function modebind6()
  if not fastmode then
    if isElement(objectpreviw) then
      local pX, pY, pZ = getElementPosition (localPlayer) 
      local x, y, z = getElementPosition (objectpreviw) 
      if getDistanceBetweenPoints3D (x, y, z, pX, pY, pZ)  < 2.3 then
        local x,y,z = getElementRotation ( objectpreviw )
        setElementRotation(objectpreviw,x,y,z-0.1)
      else
        exports.an_infobox:addNotification("Objeto muito <b>distante</b> cancele e posicione novamente.","aviso")
      end
    end
  end
end
bindKey("arrow_r", "down", modebind6)

function modebind6()
  if isElement(objectpreviw) then
    for i,v in ipairs (cfg.localbuymoveis) do 
      if v[4] == object then
        if getElementData(localPlayer,v[14]) < 1 then return exports.an_infobox:addNotification("você não tem <b>"..v[2].."</b>","erro") end
        local x,y,z = getElementPosition ( objectpreviw )
        local rx,ry,rz = getElementRotation ( objectpreviw )
        exports.an_inventory:attitem(v[14],"1","menos")
        triggerServerEvent( "createtheobjectinhouse", localPlayer,localPlayer,x,y,z,rx,ry,rz,object)
        guiSetVisible(webBrowseranmoveis, false)
        destroyElement(webBrowseranmoveis)
        setElementData(localPlayer,"openui",false)
        toggleAllControls(true)
        fastmode = false
        if isElement(objectpreviw) then
          destroyElement(objectpreviw)
        end
        setElementAlpha(localPlayer, 255)
      end
    end
  end
end
bindKey("enter", "down", modebind6)
----------------------------------------------------------------------------------------------------------------
-- BUY OBJECT FUNCTION AND UI
----------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
  local proxyonply = getproxyonply(3)
  if proxyonply then
      for i, v in ipairs (cfg.localbuymoveis) do
          local id,objname,objprice,objid,x,y,z,rx,ry,rz,colx,coly,colz,objdata = unpack(v)
          if  id == proxyonply then
              lookatdepartament = id
              setElementData(localPlayer,"housemid",id)
              local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(colx,coly,colz+1, 0.07)
              if (WorldPositionX and WorldPositionY) then
                dxDrawColorText("#d6d6d6 "..objname.." - Preço $ #00e98c"..objprice.."", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                dxDrawColorText("#00e98c/buy ", WorldPositionX - 1, WorldPositionY + 40, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
              end
          end
      end
  else
    if lookatdepartament then
      setElementData(localPlayer,"housemid",nil)
      lookatdepartament = false
    end
  end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function getproxyonply(distance)
  local pX, pY, pZ = getElementPosition (localPlayer) 
  local dist = distance
  local tid = false
  for i, v in ipairs (cfg.localbuymoveis) do 
      local id,objname,objprice,objid,x,y,z,rx,ry,rz,colx,coly,colz,objdata = unpack(v)
      if getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z) < dist then
          dist = getDistanceBetweenPoints3D ( pX, pY, pZ, x,y,z)
          tid = id
      end
  end
  if tid then
      return tid
  else
      return false
  end
end
----------------------------------------------------------------------------------------------------------------
-- POSITION OBJECT FUNCTIOS
----------------------------------------------------------------------------------------------------------------
function createplyobject()
  object = 1760
  if not isElement(objectpreviw) then
    local x, y, z = getElementPosition ( localPlayer )
    objectpreviw = createObject ( object, x,y,z-0.5, 0, 0, 0 )
    setElementCollisionsEnabled(objectpreviw, false)
    setElementAlpha(objectpreviw, 160)
  end
end
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
function execute(eval)
  if isElement(webBrowseranmoveis) then
      executeBrowserJavascript(htmlanmoveis, eval)
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