----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
----------------------------------------------------------------------------------------------------------------------------------
-- NUI
----------------------------------------------------------------------------------------------------------------------------------
function createhtmlplyphone()
    webna = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlnui = guiGetBrowser(webna)
    addEventHandler("onClientBrowserCreated", htmlnui, load)
end

function load()
    loadBrowserURL(htmlnui, "http://mta/local/nui/nui.html")
end
----------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
----------------------------------------------------------------------------------------------------------------------------------
function openplyphone() 
    if getElementData(localPlayer,"Phone") >= 1 then
        if (not isElement(webna)) then
            if not getElementData(localPlayer, 'incoma') then
                if getElementData(localPlayer,"openui") == false then
                    createhtmlplyphone()
                    focusBrowser(htmlnui)
                    guiSetVisible(webna, true)
                    showCursor(true)
                    setElementData(localPlayer,"openui",true)
                    triggerServerEvent( "RequestContacts", localPlayer, localPlayer)
                end
            end
        elseif isElement(webna) then
            guiSetVisible(webna, false)
            destroyElement(webna)
            showCursor(false)
            setElementData(localPlayer,"openui",false)
        end
    end
end
bindKey("f1", "down", openplyphone)

function closephone()
    if isElement(webna) then
        guiSetVisible(webna, false)
        destroyElement(webna)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
    end
end
addEvent ("closephone", true)
addEventHandler ("closephone", root, closephone)
----------------------------------------------------------------------------------------------------------------------------------
-- MESSAGE MODULE
----------------------------------------------------------------------------------------------------------------------------------
function requestNAcontactsmsg()
    if isElement(webna) then
        local contactmsgloaded = {}
        --local numbs2 = getElementData(localPlayer, 'phonenumbers')
        --if numbs2 then
           -- for i,v in ipairs (numbs2) do
                local numbs = getElementData(localPlayer, 'phonemessages')
                if numbs then
                    for i,v in ipairs (numbs) do
                        if not contactmsgloaded[v['numbsended']] then
                            contactmsgloaded[v['numbsended']] = true
                            executeBrowserJavascript(htmlnui,string.format("showPhoneContactsmsg(%s,%s)",toJSON(v['numbsended']),toJSON(v['sendedname'])))
                        end
                    end
                end
          --  end
       -- end
    end
end
addEvent ("requestNAcontactsmsg", true)
addEventHandler ("requestNAcontactsmsg", root, requestNAcontactsmsg)

function requestphonemessages(data2)
    if isElement(webna) then
        if data2 then
            local message = getElementData(localPlayer, 'phonemessages')
            if message then
                for i,v in ipairs (message) do
                    if v['numbsended'] == data2 then
                        if v['sendedowner'] == getElementData(localPlayer,"id") then
                            executeBrowserJavascript(htmlnui,string.format("loadphonemessage(%s,%s,%s,%s,%s)",toJSON(v['id']),toJSON(v['numbsended']),toJSON('Você'),toJSON(v['message']),toJSON('rgba(178, 250, 202, 0.541)')))
                        else
                            executeBrowserJavascript(htmlnui,string.format("loadphonemessage(%s,%s,%s,%s,%s)",toJSON(v['id']),toJSON(v['numbsended']),toJSON(v['sendedname']),toJSON(v['message']),toJSON('rgba(255, 255, 255, 0.541)')))
                        end
                    end
                end
            end
        end
    end
end
addEvent ("requestphonemessages", true)
addEventHandler ("requestphonemessages", root, requestphonemessages)

function loadphonemessages()
    if isElement(webna) then
        local message = getElementData(localPlayer, 'phonemessages')
        if message then
            for i,v in ipairs (message) do
                executeBrowserJavascript(htmlnui,string.format("loadphonemessage(%s,%s)",toJSON(v['phonemessages']),toJSON(v['phonemessages'])))
            end
        end
    end
end
addEvent ("loadphonemessages", true)
addEventHandler ("loadphonemessages", root, loadphonemessages)

function requestmessagedelet(data,datanumb)
    if isElement(webna) then
        if data then
            if datanumb then
                executeBrowserJavascript(htmlnui,string.format("cleanmessageplate()"))
                triggerServerEvent( "removemessage", localPlayer, localPlayer, data, datanumb)
            end
        end
    end
end
addEvent ("requestmessagedelet", true)
addEventHandler ("requestmessagedelet", root, requestmessagedelet)

function requestsendmessage(datanmb,datamsg)
    if isElement(webna) then
        if datanmb then
            if datamsg then
                local numbs = getElementData(localPlayer, 'phonenumbers')
                if numbs then
                    for i,v in ipairs (numbs) do
                        if v['Phonenumber'] == datanmb then
                            executeBrowserJavascript(htmlnui,string.format("cleanmessageplate()"))
                            triggerServerEvent( "confirmsendmessage", localPlayer, localPlayer, datanmb, datamsg, v['Phonename'])
                        end
                    end
                end
            end
        end
    end
end
addEvent ("requestsendmessage", true)
addEventHandler ("requestsendmessage", root, requestsendmessage)
----------------------------------------------------------------------------------------------------------------------------------
-- CONTACT MODULE
----------------------------------------------------------------------------------------------------------------------------------
function requestNAcontactsandAddcontact(data, data2)
    if isElement(webna) then
        if data then
            if data2 then
                if data2 ~= getElementData(localPlayer,"phonenumber") then
                    triggerServerEvent( "addplycontact", localPlayer, localPlayer, data, data2)
                else
                    exports.an_infobox:addNotification('Erro! não é possível adicionar o seu número','erro')
                end
            end
        end
    end
end
addEvent ("requestNAcontactsandAddcontact", true)
addEventHandler ("requestNAcontactsandAddcontact", root, requestNAcontactsandAddcontact)

function requestNAcontacts()
    if isElement(webna) then
        if getElementData(localPlayer, 'Phone_callstarted') then
            local db = fromJSON(getElementData(localPlayer, 'Phone_callstarted'))
            executeBrowserJavascript(htmlnui,string.format("startcall(%s)",toJSON(db[1])))
        elseif getElementData(localPlayer, 'Phone_call') then
            local db = fromJSON(getElementData(localPlayer, 'Phone_call'))
            executeBrowserJavascript(htmlnui,string.format("incall(%s)",toJSON(db[1])))
        elseif getElementData(localPlayer, 'Phone_callrequest') then
            local db = fromJSON(getElementData(localPlayer, 'Phone_callrequest'))
            executeBrowserJavascript(htmlnui,string.format("requestaceptcall(%s,%s)",toJSON(db[1]),toJSON(db[2])))
        elseif (not getElementData(localPlayer, 'Phone_callstarted')) and (not getElementData(localPlayer, 'Phone_call')) then
            local numbs = getElementData(localPlayer, 'phonenumbers')
            if numbs then
                for i,v in ipairs (numbs) do
                    executeBrowserJavascript(htmlnui,string.format("showPhoneContacts(%s,%s)",toJSON(v['Phonenumber']),toJSON(v['Phonename'])))
                end
            end
        end
    end
end
addEvent ("requestNAcontacts", true)
addEventHandler ("requestNAcontacts", root, requestNAcontacts)

function requestRemovenumber(data)
    if isElement(webna) then
        triggerServerEvent( "removeplynumber", localPlayer, localPlayer, data)
        exports.an_infobox:addNotification('O Número <b>'..data..'</b> foi apagado!','aviso')
    end
end
addEvent ("requestRemovenumber", true)
addEventHandler ("requestRemovenumber", root, requestRemovenumber)
----------------------------------------------------------------------------------------------------------------------------------
-- CALL MODULE
----------------------------------------------------------------------------------------------------------------------------------
function startcalling(data, data2)
    if data then
        if data2 then
            setElementData(localPlayer, 'Phone_callstarted', toJSON({data,data2}))
            setTimer(function()
                setElementData(localPlayer, 'Phone_callstarted', nil)
                setElementData(localPlayer, 'Phone_call', toJSON({data,data2}))
                executeBrowserJavascript(htmlnui,string.format("incall(%s)",toJSON(data)))
            end,1000*1,1)
        end
    end
end
addEvent ("startcalling", true)
addEventHandler ("startcalling", root, startcalling)

function finishingcalling()
    setElementData(localPlayer, 'Phone_callstarted', nil)
    setElementData(localPlayer, 'Phone_call', nil)
    setElementData(localPlayer, 'Phone_callrequest', nil)
end
addEvent ("finishingcalling", true)
addEventHandler ("finishingcalling", root, finishingcalling)

function startedcallingply2(data, data2)
    if data then
        if data2 then
            setElementData(localPlayer, 'Phone_callrequest', toJSON({data,data2}))
        end
    end
end
addEvent ("startedcallingply2", true)
addEventHandler ("startedcallingply2", root, startedcallingply2)

function finishingcalling2(data)
    if data then
        setElementData(localPlayer, 'Phone_callstarted', nil)
        setElementData(localPlayer, 'Phone_call', nil)
        setElementData(localPlayer, 'Phone_callrequest', nil)
        executeBrowserJavascript(htmlnui,string.format("retorephonecall()"))
    end
end
addEvent ("finishingcalling2", true)
addEventHandler ("finishingcalling2", root, finishingcalling2)

function phonecallacept(data,data2)
    if data then
        if data2 then
            setElementData(localPlayer, 'Phone_callstarted', nil)
            setElementData(localPlayer, 'Phone_callrequest', nil)
            setElementData(localPlayer, 'Phone_call', toJSON({data,data2}))
        end
    end
end
addEvent ("phonecallacept", true)
addEventHandler ("phonecallacept", root, phonecallacept)
----------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
----------------------------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function sendphonemessageerror(data,typ)
    if data then
        if typ then
            exports.an_infobox:addNotification(data,typ)
        end
    end
end
addEvent ("sendphonemessageerror", true)
addEventHandler ("sendphonemessageerror", root, sendphonemessageerror)
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------