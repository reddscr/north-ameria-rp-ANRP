-------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
-------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
-------------------------------------------------------------------------------------------------------
-- Panel
-------------------------------------------------------------------------------------------------------
function createwathermk()
    webBrowser = guiCreateBrowser(0.01, 0.01, screenX, screenY, true, true, true)
    htmlinfospanel = guiGetBrowser(webBrowser)
    addEventHandler("onClientBrowserCreated", htmlinfospanel, load)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), createwathermk)

function load()
    loadBrowserURL(htmlinfospanel, "http://mta/local/html/panel.html")
end

