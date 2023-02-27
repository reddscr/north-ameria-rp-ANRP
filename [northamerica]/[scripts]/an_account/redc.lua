----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
local screenX, screenY = guiGetScreenSize()
----------------------------------------------------------------------------------------------------------------------------------
-- NUI
----------------------------------------------------------------------------------------------------------------------------------
function createhtmlplyphone()
    webnui = guiCreateBrowser(0, 0, screenX, screenY, true, true, true)
    htmlnui = guiGetBrowser(webnui)
    addEventHandler("onClientBrowserCreated", htmlnui, load)
end

function load()
  loadBrowserURL(htmlnui, "http://mta/local/nui/nui.html")
end

function loadaccountsystem()
    toggleAllControls(false)
    fadeCamera(true, 5)
    setCameraMatrix(1090.346, 1076.669, 12, 1088.102, 1072.252, 10.836)
    triggerServerEvent("spawnplayer", localPlayer,localPlayer)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), loadaccountsystem)

function setNUiCharacterstat()
    if (not isElement(webnui)) then
        createhtmlplyphone()
        focusBrowser(htmlnui)
        guiSetVisible(webnui, true)
        showCursor(true)
        setElementData(localPlayer, "openui",true)
    end
end
addEvent ("setNUiCharacterstat", true)
addEventHandler ("setNUiCharacterstat", root, setNUiCharacterstat)

function deleteplayerAccount()
    triggerServerEvent("DeleteAccount", localPlayer, localPlayer)
end
addEvent ("deleteplayerAccount", true)
addEventHandler ("deleteplayerAccount", root, deleteplayerAccount)
--------------------------------------------------------------------------------------------------------------------------------
-- PRE LOADER
--------------------------------------------------------------------------------------------------------------------------------
function loadedAccount()
    if isElement(webnui) then
        if getElementData(localPlayer, 'Nome') and getElementData(localPlayer, 'SNome') then
            local name = getElementData(localPlayer, 'Nome') or 'Indigente'
            local sname = getElementData(localPlayer, 'SNome') or 'Indigente'
            local mon = getElementData(localPlayer, 'Money') or 0
            local Bank = getElementData(localPlayer, 'BankMoney') or 0
            local fome = getElementData(localPlayer, 'foodstats') or 0
            local sede = getElementData(localPlayer, 'watherstats') or 0
            if name then
                if sname then
                    if mon then
                        if Bank then
                            executeBrowserJavascript(htmlnui,string.format("sendcharacterNuiInfos(%s,%s,%s,%s,%s,%s)",toJSON(name),toJSON(sname),toJSON(mon),toJSON(Bank),toJSON(fome),toJSON(sede)))
                        end
                    end
                end
            end
        else
            executeBrowserJavascript(htmlnui,string.format("startcharactercreator()"))
        end
    end
end
addEvent ("loadedAccount", true)
addEventHandler ("loadedAccount", root, loadedAccount)
--------------------------------------------------------------------------------------------------------------------------------
-- LOADER
--------------------------------------------------------------------------------------------------------------------------------
function Playloadcharacter()
    if isElement(webnui) then
        --setElementData(localPlayer, "logado",true)
        guiSetVisible(webnui, false)
        destroyElement(webnui)
        showCursor(false)
        setElementData(localPlayer,"openui",false)
        triggerServerEvent("loadaccount", localPlayer, localPlayer)
    end
end
addEvent ("Playloadcharacter", true)
addEventHandler ("Playloadcharacter", root, Playloadcharacter)
--------------------------------------------------------------------------------------------------------------------------------
-- Request Account Creator
--------------------------------------------------------------------------------------------------------------------------------
local user = false
local password = false
local charname = false
local charsname = false
local charage = false
function createaccountandSelectSkin(db1, db2, db3, db4, db5)
    if db1 and db2 and db3 and db4 and db5 then
        user = db1
        password = db2
        charname = db3
        charsname = db4
        charage = db5
        for k,v in ipairs(cfg.skinpanel) do
            executeBrowserJavascript(htmlnui,string.format("loadallSkins(%s,%s)",toJSON(v[1]),toJSON(v[2])))
        end
    end
end
addEvent ("createaccountandSelectSkin", true)
addEventHandler ("createaccountandSelectSkin", root, createaccountandSelectSkin)

function sendaccountmessageerror(data,typ)
    if data then
        if typ then
            exports.an_infobox:addNotification(data,typ)
        end
    end
end
addEvent ("sendaccountmessageerror", true)
addEventHandler ("sendaccountmessageerror", root, sendaccountmessageerror)

function Account_previewskin(data)
    if data then
        for k,v in ipairs(cfg.skinpanel) do
            if v[2] == tonumber(data) then
                setElementModel(localPlayer, v[2])
            end 
        end
    end
end
addEvent ("Account_previewskin", true)
addEventHandler ("Account_previewskin", root, Account_previewskin)

function Account_confirmskinandaccount(data)
    if data then
        for k,v in ipairs(cfg.skinpanel) do
            if v[2] == tonumber(data) then
                --setElementData(localPlayer, "logado",true)
                guiSetVisible(webnui, false)
                destroyElement(webnui)
                showCursor(false)
                setElementData(localPlayer,"openui",false)
                triggerServerEvent("setstatplayer", localPlayer, localPlayer, user , password, v[2], charname, charsname ,charage )
            end
        end
    end
end
addEvent ("Account_confirmskinandaccount", true)
addEventHandler ("Account_confirmskinandaccount", root, Account_confirmskinandaccount)
--------------------------------------------------------------------------------------------------------------------------------
-- GTA V CAM
--------------------------------------------------------------------------------------------------------------------------------
function GtavCamEffect()
	toggleAllControls(false)
	local x,y,z = getElementPosition(localPlayer)
	setCameraMatrix(x,y,z+300,x,y,z)
	smoothMoveCamera(x,y,z+300,x,y,z,x,y,z,x,y,z,5000, "InQuad")
	setTimer(function()
        stopSmoothMoveCamera()
        toggleAllControls(true)
        setCameraTarget (localPlayer, localPlayer)
        fadeCamera(true, 2.0)
        setElementData(localPlayer,"logado",true)
	end, 5000, 1)
end
addEvent ("GtavCamEffect", true)
addEventHandler ("GtavCamEffect", root, GtavCamEffect)


local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil

local Plaetze = {
	{},
	{}
}

local function camRender()
	local x1, y1, z1 = getElementPosition(sm.object1)
	local x2, y2, z2 = getElementPosition(sm.object2)
	local randomPlatz = math.random(#Plaetze)
	setCameraMatrix(x1,y1,z1,x2,y2,z2)
end

local function removeCamHandler()
	if (sm.moov == 1) then
		sm.moov = 0
		removeEventHandler("onClientPreRender", root, camRender)
	end
end

function stopSmoothMoveCamera()
	if (sm.moov == 1) then
		if (isTimer(sm.timer1)) then killTimer(sm.timer1) end
		if (isTimer(sm.timer2)) then killTimer(sm.timer2) end
		if (isTimer(sm.timer3)) then killTimer(sm.timer3) end
		if (isElement(sm.object1)) then destroyElement(sm.object1) end
		if (isElement(sm.object2)) then destroyElement(sm.object2) end
		removeCamHandler()
		sm.moov = 0
	end
end

function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time, easing)
	if (sm.moov == 1) then return false end
	sm.object1 = createObject(1337, x1, y1, z1)
	sm.object2 = createObject(1337, x1t, y1t, z1t)
	setElementAlpha(sm.object1, 0)
	setElementAlpha(sm.object2, 0)
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, (easing and easing or "InOutQuad"))
	moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, (easing and easing or "InOutQuad"))

	addEventHandler("onClientPreRender", root, camRender)
	sm.moov = 1
	sm.timer1 = setTimer(removeCamHandler, time, 1)
	sm.timer2 = setTimer(destroyElement, time, 1, sm.object1)
	sm.timer3 = setTimer(destroyElement, time, 1, sm.object2)

	return true
end
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
function getitemtable(id)
	for key,val in pairs(cfg.items) do
        if val[1] == tonumber(id) then
			return val
		end
	end
end

function getitemtable2client(id)
	for key,val in pairs(cfg.items) do
        if val[2] == id then
			return val
		end
	end
end


--[[function hasPermission(group)
    if getElementData(localPlayer, 'logado') then
        local usergroup = getElementData( localPlayer, "user_group")
        if usergroup ~= "desempregado" then
            for key,val in ipairs(cfg.groups[usergroup]) do
                if val == group then
                    return true
                end
            end
        else
            return false
        end
    else
        return false
    end
end]]

function hasPermission(group)
    if getElementData(localPlayer, 'logado') then
        local usergroup = getElementData( localPlayer, "user_group")
        for i, v in next, cfg.groups do
            if i == usergroup then
                for i, v in next, cfg.groups[i] do
                    if v == group then
                        return true
                    end
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
---------------------------------------------------------------------------------------------------------------
function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
function getitemtable3()
	return cfg.items
end
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
