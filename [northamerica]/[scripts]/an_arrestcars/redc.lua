---------------------------------------------------------------------------------------------------------------------------------------------
--get screen
---------------------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
myFont = dxCreateFont( "files/robotb.ttf", 9 )
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
local localscfg = cfg.locals
local lookatarrestcars = false
---------------------------------------------------------------------------------------------------------------------------------------------
-- HTML CONFIG
---------------------------------------------------------------------------------------------------------------------------------------------
local webBrowser = false
function createhtmlarrestcars()
    webBrowser = guiCreateBrowser(0,0, screenX, screenY, true, true, true)
    htmlanui = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmlanui, loadinv1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
function loadinv1()
    loadBrowserURL(htmlanui, "http://mta/local/nui/nui.html")
end
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
function togglearrestcars()
    if not isElement(webBrowser) then
        if getElementData(localPlayer,"openui") == false then
            createhtmlarrestcars()
            focusBrowser(htmlanui)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
            triggerServerEvent( "requestMulta", localPlayer, localPlayer)
        end
    end
end

function closearrestcars()
  if isElement(webBrowser) then
      guiSetVisible(webBrowser, false)
      destroyElement(webBrowser)
      showCursor(false)
      setElementData(localPlayer,"openui",false)
  end
end
addEvent ("closearrestcars", true)
addEventHandler ("closearrestcars", root, closearrestcars)


function pegvehgaragearrests(vehid,vehname)
    if isElement(webBrowser) then
        local vid = tonumber(vehid)
        if vid then
            local numbs = getElementData(localPlayer, 'arrestedvehprices')
            if numbs then
                for _,mv in ipairs (numbs) do
                    if vid == tonumber(mv["Vehid"]) then
                        valor = tonumber(mv["Value"])
                        if vehname then
                            local gdata = getDataGarage(1)
                            if gdata then
                                if getElementData(localPlayer, "Money") >= tonumber(valor) then
                                    local vehpos = toJSON({gdata[2],gdata[3],gdata[4],gdata[5]})
                                    triggerServerEvent( "arrestcarspegandpay", localPlayer, localPlayer, vid, vehname, valor, vehpos)    
                                else
                                    exports.an_infobox:addNotification("Você não tem $ <b>"..valor.."</b>","aviso") 
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
addEvent ("pegvehgaragearrests", true)
addEventHandler ("pegvehgaragearrests", root, pegvehgaragearrests)


function addcarsgaragearrest()
    local vehicles = getElementData(localPlayer,"playervehicles")
    if vehicles and type(vehicles) == "table" then
        for i,v in ipairs (vehicles) do
            id = tonumber(v["id"])
            local numbs = getElementData(localPlayer, 'arrestedvehprices')
            if numbs then
                for _,mv in ipairs (numbs) do
                    if id == tonumber(mv["Vehid"]) then
                        local data = exports.an_vehicles:getVehicleData(v["Model"])
                        local vehplate = v["Number"]
                        local aprice = tonumber(mv["Value"])
                        if tonumber(v["Arrested"]) >= 1 then
                            executeBrowserJavascript(htmlanui, string.format("addarrestedcars(%s,%s,%s,%s)",toJSON(id),toJSON(data.name),toJSON(vehplate),toJSON(aprice)))
                        end
                    end 
                end 
            end
        end
    end
end
addEvent ("addcarsgaragearrest", true)
addEventHandler ("addcarsgaragearrest", root, addcarsgaragearrest)
---------------------------------------------------------------------------------------------------------------------------------------------
-- INIT SYSTEM
---------------------------------------------------------------------------------------------------------------------------------------------
function dxpressforpanel()
    local proxyonply = getproxyonply(1)
    if proxyonply then
        for i, v in ipairs (localscfg) do 
          local id,x,y,z,rx,ry,rz = unpack(v)
            if id == proxyonply then
                lookatarrestcars = id
                toggleControl ( "enter_passenger", false )
                toggleControl ( "enter_exit", false )
                toggleControl ( "next_weapon", false )
                toggleControl ( "previous_weapon", false )
                local WorldPositionX, WorldPositionY = getScreenFromWorldPosition(x,y,z+1, 0.07)
                if (WorldPositionX and WorldPositionY) then
                  if getElementData(localPlayer,"openui") == false and (not machineStart) then
                    dxDrawColorText("#d6d6d6[E] : #3b8ff7INTERAGIR", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255, 255, 255, 200), 1, myFont, "center", "center", false, false, false, false, false)
                  end
                end
            end
        end
    else
      if lookatarrestcars then
        toggleControl ( "enter_passenger", true )
        toggleControl ( "enter_exit", true )
        toggleControl ( "next_weapon", true )
        toggleControl ( "previous_weapon", true )
        lookatarrestcars = false
      end
    end
end
addEventHandler("onClientRender", root, dxpressforpanel)

function bindtogglearrestcars()
  if lookatarrestcars then
    if not machineStart then
      if not isPedInVehicle(localPlayer) then
        triggerServerEvent( "getplyvehicles", localPlayer,localPlayer)
        togglearrestcars()
      end
    end
  end
end
bindKey("e", "down", bindtogglearrestcars)
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------