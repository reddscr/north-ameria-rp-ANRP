----------------------------------------------------------------------------------------------------------------------------------
-- SCREEN & FONT
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
----------------------------------------------------------------------------------------------------------------------------------
-- WEB NUI
----------------------------------------------------------------------------------------------------------------------------------
webBrowser = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
htmlanui = guiGetBrowser(webBrowser)
addEventHandler("onClientBrowserCreated", webBrowser,
function ()
    loadBrowserURL(htmlanui, "http://mta/local/html/panel.html")  
end
)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
function addNotification(text, type, time)
  if isElement(webBrowser) then
    if text then
      if type then
          if time then
            timer = time
          else
            timer = 8000
          end
          executeBrowserJavascript(htmlanui,string.format("message(%s,%s,%s)",toJSON(type),toJSON(text),toJSON(timer)))
      end
    end
  end
end
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
function addNotification(text, type, time)
  if isElement(webBrowser) then
    if text then
      if type then
          if time then
            timer = time
          else
            timer = 8000
          end
          executeBrowserJavascript(htmlanui,string.format("message(%s,%s,%s)",toJSON(type),toJSON(text),toJSON(timer)))
      end
    end
  end
end
addEvent ("addNotification", true)
addEventHandler ("addNotification", root, addNotification)

function closefocus_infobox()
  if isElement(webBrowser) then
    showCursor(false)
    focusBrowser(nil)
  end
end
addEvent ("closefocus_infobox", true)
addEventHandler ("closefocus_infobox", root, closefocus_infobox)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------