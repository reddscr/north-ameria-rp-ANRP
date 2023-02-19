-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
-------------------------------------------------------------------------------------------------------
-- Panel
-------------------------------------------------------------------------------------------------------
function chatehelppanel()
    webBrowser = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlinfospanel = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmlinfospanel, load)
end
--addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), chatehelppanel)

function load()
    loadBrowserURL(htmlinfospanel, "http://mta/local/html/panel.html")
end
----------------------------------------------------------------------------------------------------------------
-- code
----------------------------------------------------------------------------------------------------------------
function openhelp()
    if (not isElement(webBrowser)) then
        if getElementData(localPlayer,"openui") == false then
            chatehelppanel()
            focusBrowser(htmlinfospanel)
            guiSetVisible(webBrowser, true)
            showCursor(true)
            setElementData(localPlayer,"openui",true)
        end
    elseif isElement(webBrowser) then
        execute(string.format("close()"))
        guiSetVisible(webBrowser, false)
        destroyElement(webBrowser)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
bindKey("f9", "down", openhelp)
----------------------------------------------------------------------------------------------------------------
function closehelp()
    if (isElement(webBrowser)) then
        guiSetVisible(webBrowser, false)
        destroyElement(webBrowser)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
addEvent ("closehelp", true)
addEventHandler ("closehelp", root, closehelp)
----------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------
function execute(eval)
    if isElement(webBrowser) then
        executeBrowserJavascript(htmlinfospanel, eval)
    end
end
----------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
  decimals = decimals or 0
  local factor = 10 ^ decimals
  if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
  else return tonumber(("%."..decimals.."f"):format(number)) end
end
----------------------------------------------------------------------------------------------------------------