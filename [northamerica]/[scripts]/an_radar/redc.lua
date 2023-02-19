min, max, cos, sin, rad, deg, atan2 = math.min, math.max, math.cos, math.sin, math.rad, math.deg, math.atan2
sqrt, abs, floor, ceil, random = math.sqrt, math.abs, math.floor, math.ceil, math.random
gsub = string.gsub

screenW, screenH = guiGetScreenSize()

reMap = function(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

responsiveMultiplier = math.min(1, reMap(screenW, 1024, 1920, 0.75, 1))

resp = function(value)
	return value * responsiveMultiplier
end

respc = function(value)
	return ceil(value * responsiveMultiplier)
end

deepcopy = function(original)
	local copy

	if type(original) == "table" then
		copy = {}

		for k, v in next, original, nil do
			copy[deepcopy(k)] = deepcopy(v)
		end

		setmetatable(copy, deepcopy(getmetatable(original)))
	else
		copy = original
	end

	return copy
end

local function rotateAround(angle, x, y)
	angle = math.rad(angle)
	local cosinus, sinus = math.cos(angle), math.sin(angle)
	return x * cosinus - y * sinus, x * sinus + y * cosinus
end



local mapTextureSize = 3072
local mapRatio = 6000 / mapTextureSize
local minimapPosX = 0
local minimapPosY = 0
local minimapWidth = respc(320)
local minimapHeight = respc(225)
local minimapCenterX = minimapPosX + minimapWidth / 2
local minimapCenterY = minimapPosY + minimapHeight / 2
local minimapRenderSize = 400
local minimapRenderHalfSize = minimapRenderSize * 0.5
local minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
local playerMinimapZoom = 0.7
local minimapZoom = playerMinimapZoom
local minimapIsVisible = true

local bigmapPosX = screenW/2 - 570
local bigmapPosY = screenH/2 - 250

local bigmapWidth = screenW - 200
local bigmapHeight = screenH - 250
local bigmapCenterX = bigmapPosX + bigmapWidth / 2
local bigmapCenterY = bigmapPosY + bigmapHeight / 2
local bigmapZoom = 0.5
local bigmapIsVisible = false

local lastCursorPos = false
local mapDifferencePos = false
local mapMovedPos = false
local lastDifferencePos = false
local mapIsMoving = false
local lastMapPosX, lastMapPosY = 0, 0
local mapPlayerPosX, mapPlayerPosY = 0, 0

local zoneLineHeight = respc(0)
local screenSource = dxCreateScreenSource(screenW, screenH)

local gpsLineWidth = respc(60)
local gpsLineIconSize = respc(40)
local gpsLineIconHalfSize = gpsLineIconSize / 2
local createdTextures = {}

settingsStorage = {
	show3DBlips = true,
}

createdFonts = {}

occupiedVehicle = false

createdBlips = {}
local mainBlips = {
  --[[	{1758.576171875, -1790.1455078125, 14.446235656738, "blips/tuning.png"},
]]
}

local blipTooltips = cfg.blipconfignames

local visibleBlipTooltip = false
local hoveredWaypointBlip = false

local farshowBlips = {}
local farshowBlipsData = {}

carCanGPSVal = false
local gpsHello = false
local gpsLines = {}
local gpsRouteImage = false
local gpsRouteImageData = {}

local state3DBlip = true
local hover3DBlipCb = false

local playerCanSeePlayers = false

local getZoneNameEx = getZoneName
function getZoneName(x, y, z, citiesonly)
	local zoneName = getZoneNameEx(x, y, z, citiesonly)
	if zoneName == "Greenglass College" then
		return " "
	else
		return zoneName
	end
end

function getTexture(name)
	if createdTextures[name] then
		return createdTextures[name]
	end

	return false
end


local hudTable = {
	"ammo",
	"area_name",
	"armour",
	"breath",
	"clock",
	"health",
	"money",
	"radar",
	"vehicle_name",
	"weapon",
	"radio",
	"wanted",
}

addEventHandler( "onClientResourceStart", resourceRoot,
    function ()
		for id, hudComponents in ipairs(hudTable) do
			setPlayerHudComponentVisible(hudComponents, false)
			setPlayerHudComponentVisible("crosshair", true)
			toggleControl( "radar", false )
		end
		setPedTargetingMarkerEnabled(false)
    end
);

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		--local textura = dxCreateTexture("files/radar.jpg")
    	createdTextures = {
			--[[minimapMap = textura,
			bigmapMap = textura,]]
			minimapMap = dxCreateTexture("files/radar.jpg"),
			bigmapMap = dxCreateTexture("files/radar.jpg"),
		}
		initFont("Roboto", "Roboto.ttf", 12)
		initFont("RobotoB", "RobotoB.ttf", 24)
		occupiedVehicle = getPedOccupiedVehicle(localPlayer)
		if getTexture("minimapMap") then
			dxSetTextureEdge(getTexture("minimapMap"), "border", tocolor(128, 167, 208))
		end
		if getTexture("bigmapMap") then
			dxSetTextureEdge(getTexture("bigmapMap"), "border", tocolor(128, 167, 208))
		end
		for k,v in ipairs(getElementsByType("blip")) do
			blipTooltips[v] = getElementData(v, "tooltipText")
		end
		for k,v in ipairs(mainBlips) do
			createCustomBlip(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8])
		end
		if occupiedVehicle then
			carCanGPS()
		end
		state3DBlip = settingsStorage.show3DBlips
		if settingsStorage.show3DBlips then
			--addEventHandler("onClientHUDRender", getRootElement(), render3DBlips, true, "low-99999999")
		end
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == occupiedVehicle then
			if dataName == "vehicle.tuning.seeGO" then
				local dataValue = getElementData(source, dataName) or false

				if dataValue then
					carCanGPSVal = dataValue
				else
					if oldValue then
						carCanGPSVal = false
					end
				end

				if not carCanGPSVal then
					if getElementData(source, "gpsDestination") then
						endRoute()
					end
				end
			elseif dataName == "gpsDestination" then
				local dataValue = getElementData(source, dataName) or false

				if dataValue then
					gpsThread = coroutine.create(makeRoute)
					coroutine.resume(gpsThread, unpack(dataValue))
					waypointInterpolation = false
				else
					endRoute()
				end
			end
		end

		if getElementType(source) == "blip" and dataName == "tooltipText" then
			blipTooltips[source] = getElementData(source, dataName)
		end
	end
)

addEventHandler("onClientPlayerDamage", getLocalPlayer(),
	function ()
		damageEffectStart = getTickCount()
	end
)

addEventHandler("onClientRender", getRootElement(),
	function ()
		renderTheBigmap()
		if  getElementData(localPlayer, "logado") then
			renderMinimap(12, screenH - 170, 220, 150)
		end
	end
)

function renderMinimap(x, y, w, h)
	if bigmapIsVisible or not minimapIsVisible or not getElementData( localPlayer, 'necessarigps') then
		if bigmapIsVisible or not occupiedVehicle then
			return
		end
	end
	if getElementData( localPlayer, 'offhud') then
		return
	end

	minimapWidth = w
	minimapHeight = h

	if (minimapWidth > respc(445) or minimapHeight > respc(400)) and minimapRenderSize < 800 then
		minimapRenderSize = 800
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end
	if minimapWidth <= respc(445) and minimapHeight <= respc(400) and minimapRenderSize > 600 then
		minimapRenderSize = 600
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end
	if (minimapWidth > respc(325) or minimapHeight > respc(235)) and minimapRenderSize < 600 then
		minimapRenderSize = 600
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end
	if minimapWidth <= respc(325) and minimapHeight <= respc(235) and minimapRenderSize > 400 then
		minimapRenderSize = 400
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize)
	end

	if minimapPosX ~= x or minimapPosY ~= y then
		minimapPosX = x
		minimapPosY = y
	end

	minimapCenterX = minimapPosX + minimapWidth / 2
	minimapCenterY = minimapPosY + minimapHeight / 2

	dxUpdateScreenSource(screenSource, true)

	if getKeyState("num_add") and playerMinimapZoom < 1.2 then
		playerMinimapZoom = playerMinimapZoom + 0.01
	elseif getKeyState("num_sub") and playerMinimapZoom > 0.31 then
		playerMinimapZoom = playerMinimapZoom - 0.01
	end

	minimapZoom = playerMinimapZoom

	if occupiedVehicle then
		local vehicleZoom = getVehicleSpeed(occupiedVehicle) / 1300
		if vehicleZoom >= 0.1 then
			vehicleZoom = 0.1
		end
		minimapZoom = minimapZoom - vehicleZoom
	end

	local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
	local playerDimension = getElementDimension(localPlayer)
	local cameraX, cameraY, _, faceTowardX, faceTowardY = getCameraMatrix()
	local cameraRotation = deg(atan2(faceTowardY - cameraY, faceTowardX - cameraX)) + 360 + 90

	local minimapRenderSizeOffset = respc(minimapRenderSize * 0.75)

	farshowBlips = {}
	farshowBlipsData = {}

	if playerDimension == 0 or playerDimension == 65000 or playerDimension == 33333 then
		local remapPlayerPosX, remapPlayerPosY = remapTheFirstWay(playerPosX), remapTheFirstWay(playerPosY)
		local farBlips = {}
		local farBlipsCount = 10000
		local manualBlipsCount = 1
		local defaultBlipsCount = 1

		dxSetRenderTarget(minimapRender)
		dxDrawImageSection(0, 0, minimapRenderSize, minimapRenderSize, remapTheSecondWay(playerPosX) - minimapRenderSize / minimapZoom / 2, remapTheFirstWay(playerPosY) - minimapRenderSize / minimapZoom / 2, minimapRenderSize / minimapZoom, minimapRenderSize / minimapZoom, getTexture("minimapMap"))

		if gpsRouteImage then
			--dxSetBlendMode("add")
			dxDrawImage(minimapRenderSize / 2 + (remapTheFirstWay(playerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * minimapZoom - gpsRouteImageData[3] * minimapZoom / 2, minimapRenderSize / 2 - (remapTheFirstWay(playerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * minimapZoom + gpsRouteImageData[4] * minimapZoom / 2, gpsRouteImageData[3] * minimapZoom, -(gpsRouteImageData[4] * minimapZoom), gpsRouteImage, 180, 0, 0, tocolor(101, 56, 255))
			--dxSetBlendMode("blend")
		end

		for i = 1, #createdBlips do
			if createdBlips[i] then
				if createdBlips[i].farShow then
					farBlips[farBlipsCount + manualBlipsCount] = createdBlips[i].icon
				end

				renderBlip(createdBlips[i].icon, createdBlips[i].posX, createdBlips[i].posY, remapPlayerPosX, remapPlayerPosY, createdBlips[i].iconSize, createdBlips[i].iconSize, createdBlips[i].color, cameraRotation, createdBlips[i].farShow, i)

				manualBlipsCount = manualBlipsCount + 1
			end
		end

		local defaultBlips = getElementsByType("blip")
		for i = 1, #defaultBlips do
			if defaultBlips[i] then
				local tableId = farBlipsCount + manualBlipsCount + defaultBlipsCount
				--farBlips[tableId] = "blips/target.png"
				
				local blipPosX, blipPosY = getElementPosition(defaultBlips[i])
				for _,v in ipairs (cfg.blipsnameandfouder) do
					if getBlipIcon(defaultBlips[i]) == v[2] then
						local r, g, b = getBlipColor(defaultBlips[i])
						farshowb = true
						if getElementData(defaultBlips[i], 'farshow') then
							farshowb = false
						end
						if r and g and b then
							colorb = tocolor(r, g, b,255)
						else
							colorb = tocolor(255,255,255,255)
						end
						renderBlip(v[1], blipPosX, blipPosY, remapPlayerPosX, remapPlayerPosY, 10, 10, colorb, cameraRotation, farshowb, tableId)
					end
				end

				defaultBlipsCount = defaultBlipsCount + 1
			end
		end

		dxSetRenderTarget()
		dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, minimapRender, cameraRotation - 180)

		for k in pairs(farshowBlips) do
			if createdBlips[k] then
				dxDrawImage(farshowBlipsData[k].posX, farshowBlipsData[k].posY, createdBlips[k].iconSize, createdBlips[k].iconSize, "files/" .. createdBlips[k].icon, 0, 0, 0, farshowBlipsData[k].color)
			else
				table.insert(farBlips, k)
			end
		end

		for i = 1, #farBlips do
			if farshowBlipsData[farBlips[i]] then
				dxDrawImage(farshowBlipsData[farBlips[i]].posX, farshowBlipsData[farBlips[i]].posY, farshowBlipsData[farBlips[i]].iconWidth, farshowBlipsData[farBlips[i]].iconHeight, "files/" .. farshowBlipsData[farBlips[i]].icon, 0, 0, 0, farshowBlipsData[farBlips[i]].color)
			end
		end
	end

	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
	dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
	dxDrawImageSection(minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)

	if playerDimension == 0 then
		local playerArrowSize = 40 / (4 - minimapZoom) + 3
		local playerArrowHalfSize = playerArrowSize / 2
		local _, _, playerRotation = getElementRotation(localPlayer)

		dxDrawImage(minimapCenterX - playerArrowHalfSize, minimapCenterY - playerArrowHalfSize, playerArrowSize, playerArrowSize, "files/arrow.png", abs(360 - playerRotation) + (cameraRotation - 180))
	
		if gpsRoute or (not gpsRoute and waypointEndInterpolation) then
			local naviX = minimapPosX + minimapWidth - gpsLineWidth
			local naviCenterY = minimapPosY + (minimapHeight - zoneLineHeight) / 2

			if waypointEndInterpolation then
				local interpolationProgress = (getTickCount() - waypointEndInterpolation) / 500
				local interpolateAlpha = interpolateBetween(1, 0, 0, 0, 0, 0, interpolationProgress, "Linear")

				if interpolationProgress > 1 then
					waypointEndInterpolation = false
				end
			end
		end
	else
		dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth, minimapHeight, tocolor(0, 0, 0))
		if not lostSignalStartTick then
			lostSignalStartTick = getTickCount()
		end

		local fadeAlpha = 255
		if not lostSignalFadeIn then
			fadeAlpha = 255
		else
			fadeAlpha = 0
		end

		local lostSignalTick = (getTickCount() - lostSignalStartTick) / 1500
		if lostSignalTick > 1 then
			lostSignalStartTick = getTickCount()
			lostSignalFadeIn = not lostSignalFadeIn
		end
	end


end

function renderTheBigmap()
	if not bigmapIsVisible then
		return
	end

	if hoveredWaypointBlip then
		hoveredWaypointBlip = false
	end

	if hover3DBlipCb then
		hover3DBlipCb = false
	end

	dxDrawOuterBorder(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, 5, tocolor(0, 0, 0, 125))

	if getElementDimension(localPlayer) == 0 then
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		cursorX, cursorY = getHudCursorPos()
		if cursorX and cursorY then
			cursorX, cursorY = cursorX * screenW, cursorY * screenH

			if getKeyState("mouse1") then
				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY}
				end

				if not mapDifferencePos then
					mapDifferencePos = {0, 0}
				end

				if not lastDifferencePos then
					if not mapMovedPos then
						lastDifferencePos = {0, 0}
					else
						lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
					end
				end

				mapDifferencePos = {mapDifferencePos[1] + cursorX - lastCursorPos[1], mapDifferencePos[2] + cursorY - lastCursorPos[2]}

				if not mapMovedPos then
					if abs(mapDifferencePos[1]) >= 3 or abs(mapDifferencePos[2]) >= 3 then
						mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
						mapIsMoving = true
					end
				elseif mapDifferencePos[1] ~= 0 or mapDifferencePos[2] ~= 0 then
					mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
					mapIsMoving = true
				end

				lastCursorPos = {cursorX, cursorY}
			else
				if mapMovedPos then
					lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
				end

				lastCursorPos = false
				mapDifferencePos = false
			end
		end

		mapPlayerPosX, mapPlayerPosY = lastMapPosX, lastMapPosY

		if mapMovedPos then
			mapPlayerPosX = mapPlayerPosX + mapMovedPos[1]
			mapPlayerPosY = mapPlayerPosY + mapMovedPos[2]
		else
			mapPlayerPosX, mapPlayerPosY = playerPosX, playerPosY
			lastMapPosX, lastMapPosY = mapPlayerPosX, mapPlayerPosY
		end

		dxDrawImageSection(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2, remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2, bigmapWidth / bigmapZoom, bigmapHeight / bigmapZoom, getTexture("bigmapMap"))

		if gpsRouteImage then
			dxUpdateScreenSource(screenSource, true)
			dxDrawImage(bigmapCenterX + (remapTheFirstWay(mapPlayerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * bigmapZoom - gpsRouteImageData[3] * bigmapZoom / 2, bigmapCenterY - (remapTheFirstWay(mapPlayerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * bigmapZoom + gpsRouteImageData[4] * bigmapZoom / 2, gpsRouteImageData[3] * bigmapZoom, -(gpsRouteImageData[4] * bigmapZoom), gpsRouteImage, 180, 0, 0, tocolor(101, 56, 255))
			dxDrawImageSection(0, 0, bigmapPosX, screenH, 0, 0, bigmapPosX, screenH, screenSource)
			dxDrawImageSection(screenW - bigmapPosX, 0, bigmapPosX, screenH, screenW - bigmapPosX, 0, bigmapPosX, screenH, screenSource)
			dxDrawImageSection(bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
			dxDrawImageSection(bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
		end

		for i = 1, #createdBlips do
			if createdBlips[i] then
				renderBigBlip(createdBlips[i].icon, createdBlips[i].posX, createdBlips[i].posY, mapPlayerPosX, mapPlayerPosY, createdBlips[i].renderDistance, createdBlips[i].iconSize, createdBlips[i].iconSize, createdBlips[i].color, false, i, playerRotation)
			end
		end
		for k,v in ipairs(getElementsByType("blip")) do
			if getElementAttachedTo(v) ~= localPlayer then
				local blipPosX, blipPosY = getElementPosition(v)
				for blipi,blipv in ipairs (cfg.blipsnameandfouder) do
					if getBlipIcon(v) == blipv[2] then
						local r, g, b = getBlipColor(v)
						if r and g and b then
							colorb = tocolor(r, g, b,255)
						else
							colorb = tocolor(255,255,255,255)
						end
						renderBigBlip(blipv[1], blipPosX, blipPosY, mapPlayerPosX, mapPlayerPosY, 9999, 7, 7, colorb, v, k)
					end
				end
			end
		end
		renderBigBlip("arrow.png", playerPosX, playerPosY, mapPlayerPosX, mapPlayerPosY, false, 20, 20)
		dxDrawRectangle(bigmapPosX, bigmapPosY + bigmapHeight - zoneLineHeight, bigmapWidth, zoneLineHeight, tocolor(0, 0, 0, 200))
		if cursorX and cursorY then
			local zoneX = reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
			local zoneY = reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
			if visibleBlipTooltip then
				dxDrawRectangle(cursorX - respc(30), cursorY+ respc(20), dxGetTextWidth(visibleBlipTooltip, 0.75, getFont("Roboto")) + respc(10), respc(25), tocolor(0, 0, 0, 150))
				dxDrawText(visibleBlipTooltip, cursorX - respc(30), cursorY+ respc(40), cursorX + (dxGetTextWidth(visibleBlipTooltip, 0.75, getFont("Roboto")) + respc(10)) - respc(30), cursorY + respc(25), 0xFFFFFFFF, 0.75, getFont("Roboto"), "center", "center")
			end
		else
			dxDrawText(getZoneName(playerPosX, playerPosY, playerPosZ), bigmapPosX + 10, bigmapPosY + bigmapHeight - zoneLineHeight, bigmapPosX + bigmapWidth, bigmapPosY + bigmapHeight, 0xFFFFFFFF, 0.5, getFont("Roboto"), "left", "center")
		end
		if visibleBlipTooltip then
			visibleBlipTooltip = false
		end
		if mapMovedPos then
			if getKeyState("space") then
				mapMovedPos = false
				lastDifferencePos = false
			end
		end
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, pressDown)
		if key == "F11" and pressDown then
			if pressDown and getElementData(localPlayer, "logado") then
				bigmapIsVisible = not bigmapIsVisible
				setElementData(localPlayer, "bigmapIsVisible", bigmapIsVisible, false)
				if bigmapIsVisible then
					showCursor(true)
					setElementData(localPlayer, "enableall", false)
					setElementData(localPlayer,"openui",true)
				else
					showCursor(false)
					setElementData(localPlayer, "enableall", false)
					setElementData(localPlayer, "openui", false)
				end
			end

			cancelEvent()
		elseif (key == "mouse_wheel_up") or (getKeyState("num_add")) then
			if pressDown then
				if bigmapIsVisible and bigmapZoom + 0.1 <= 2.1 then
					bigmapZoom = bigmapZoom + 0.1
				end
			end
		elseif (key == "mouse_wheel_down") or (getKeyState("num_sub")) then
			if pressDown then
				if bigmapIsVisible and bigmapZoom - 0.1 >= 0.1 then
					bigmapZoom = bigmapZoom - 0.1
				end
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, cursorX, cursorY)
		if not bigmapIsVisible then
			return
		end
		local gpsRouteProcess = false
		if button == "right" and state == "up" then
			if occupiedVehicle and carCanGPS() then
				if getElementData(occupiedVehicle, "gpsDestination") then
					setElementData(occupiedVehicle, "gpsDestination", false)
				else
					setElementData(occupiedVehicle, "gpsDestination", {
						reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000),
						reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
					})
				end
				gpsRouteProcess = true
			end
		end
	end
)

addEventHandler("onClientRestore", getRootElement(),
	function ()
		if gpsRoute then
			processGPSLines()
		end
	end
)

function renderBlip(icon, blipX, blipY, playerPosX, playerPosY, blipWidth, blipHeight, blipColor, cameraRotation, farShow, blipTableId)
	local blipPosX = minimapRenderHalfSize + (playerPosX - remapTheFirstWay(blipX)) * minimapZoom
	local blipPosY = minimapRenderHalfSize - (playerPosY - remapTheFirstWay(blipY)) * minimapZoom

	if not farShow and (blipPosX > minimapRenderSize or 0 > blipPosX or blipPosY > minimapRenderSize or 0 > blipPosY) then
		return
	end

	local blipIsVisible = true
	if farShow then
		if blipPosX > minimapRenderSize then
			blipPosX = minimapRenderSize
		end
		if blipPosX < 0 then
			blipPosX = 0
		end
		if blipPosY > minimapRenderSize then
			blipPosY = minimapRenderSize
		end
		if blipPosY < 0 then
			blipPosY = 0
		end

		local angle = rad((cameraRotation - 270) + 90)
		local cosinus, sinus = cos(angle), sin(angle)

		local blipScreenPosX = minimapPosX - minimapRenderHalfSize + minimapWidth / 2 + (minimapRenderHalfSize + cosinus * (blipPosX - minimapRenderHalfSize) - sinus * (blipPosY - minimapRenderHalfSize) - blipWidth / 2)
		local blipScreenPosY = minimapPosY - minimapRenderHalfSize + minimapHeight / 2 + (minimapRenderHalfSize + sinus * (blipPosX - minimapRenderHalfSize) + cosinus * (blipPosY - minimapRenderHalfSize) - blipHeight / 2)

		farshowBlips[blipTableId] = nil

		if blipScreenPosX < minimapPosX or blipScreenPosX > minimapPosX + minimapWidth - blipWidth then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if blipScreenPosY < minimapPosY or blipScreenPosY > minimapPosY + minimapHeight - zoneLineHeight - blipHeight then
			farshowBlips[blipTableId] = true
			blipIsVisible = false
		end

		if farshowBlips[blipTableId] then
			farshowBlipsData[blipTableId] = {
				posX = max(minimapPosX, min(minimapPosX + minimapWidth - blipWidth, blipScreenPosX)),
				posY = max(minimapPosY, min(minimapPosY + minimapHeight - zoneLineHeight - blipHeight, blipScreenPosY)),
				icon = icon,
				iconWidth = blipWidth,
				iconHeight = blipHeight,
				color = blipColor
			}
		end
	end

	if blipIsVisible then
		dxDrawImage(blipPosX - blipWidth / 2, blipPosY - blipHeight / 2, blipWidth, blipHeight, "files/" .. icon, 180 - cameraRotation, 0, 0, blipColor)
	end
end

function renderBigBlip(icon, blipX, blipY, playerPosX, playerPosY, renderDistance, blipWidth, blipHeight, blipColor, blipElement, blipId)
	if renderDistance and getDistanceBetweenPoints2D(playerPosX, playerPosY, blipX, blipY) > renderDistance then
		return
	end

	blipWidth = (blipWidth / (4 - bigmapZoom) + 3) * 2.25
	blipHeight = (blipHeight / (4 - bigmapZoom) + 3) * 2.25

	local blipHalfWidth = blipWidth / 2
	local blipHalfHeight = blipHeight / 2

	blipX = max(bigmapPosX + blipHalfWidth, min(bigmapPosX + bigmapWidth - blipHalfWidth, bigmapCenterX + (remapTheFirstWay(playerPosX) - remapTheFirstWay(blipX)) * bigmapZoom))
	blipY = max(bigmapPosY + blipHalfHeight, min(bigmapPosY + bigmapHeight - blipHalfHeight - zoneLineHeight, bigmapCenterY - (remapTheFirstWay(playerPosY) - remapTheFirstWay(blipY)) * bigmapZoom))

	if icon == "arrow.png" then
		local _, _, playerRotation = getElementRotation(localPlayer)
		dxDrawImage(blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight, "files/" .. icon, abs(360 - playerRotation))
	else
		dxDrawImage(blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight, "files/" .. icon, 0, 0, 0, blipColor)
	end

	if cursorX and cursorY then
		if isElement(blipElement) then
			if isCursorWithinArea(cursorX, cursorY, blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight) then
				if blipTooltips[blipElement] then
					visibleBlipTooltip = blipTooltips[blipElement]
				--[[elseif getElementType(blipElement) == "player" and playerCanSeePlayers then
					visibleBlipTooltip = string.gsub(string.gsub(getElementData(blipElement, "visibleName") or getPlayerName(blipElement), "#%x%x%x%x%x%x", ""), "_", " ") .. " (" .. getElementData(blipElement, "playerID") .. ")"]]
				end
			end
		else
			if blipTooltips[icon] and isCursorWithinArea(cursorX, cursorY, blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight) then
				if blipTooltips[text] then
					visibleBlipTooltip = blipTooltips[text]
				else
					visibleBlipTooltip = blipTooltips[icon]
				end
				
				if icon == "blips/markblip.png" then
					hoveredWaypointBlip = blipId
				end
			elseif createdBlips[blipId] and isCursorWithinArea(cursorX, cursorY, blipX - blipHalfWidth, blipY - blipHalfHeight, blipWidth, blipHeight) then
				if createdBlips[blipId].text then
					visibleBlipTooltip = createdBlips[blipId].text
				end
				if icon == "blips/markblip.png" then
					hoveredWaypointBlip = blipId
				end
			end
		end
	end
end

function render3DBlips()
	if getElementDimension(localPlayer) == 0 then
		local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		for i = 1, #createdBlips do
			if createdBlips[i] then
				local screenX, screenY = getScreenFromWorldPosition(createdBlips[i].posX, createdBlips[i].posY, createdBlips[i].posZ)

				if createdBlips[i].icon == "blips/markblip.png" and screenX and screenY then
					local distanceBetweenBlip = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, createdBlips[i].posX, createdBlips[i].posY, createdBlips[i].posZ)
					local blipHalfSize = createdBlips[i].iconSize / 2

					dxDrawText(floor(distanceBetweenBlip) .. " m\nKijelölt pont", screenX + 1, screenY + 1 + blipHalfSize + respc(4), screenX, 0, tocolor(0, 0, 0, 255), 0.75, getFont("Roboto"), "center", "top")
					dxDrawText(floor(distanceBetweenBlip) .. " m#e0e0e0\nKijelölt pont", screenX, screenY + blipHalfSize + respc(4), screenX, 0, 0xFFFFFFFF, 0.75, getFont("Roboto"), "center", "top", false, false, false, true)
					dxDrawImage(screenX - blipHalfSize, screenY - blipHalfSize, createdBlips[i].iconSize, createdBlips[i].iconSize, "files/blips/markblip2.png", 0, 0, 0, tocolor(255, 255, 255, 200))
				end

				if string.find(createdBlips[i].icon, "jobblips") and screenX and screenY then
					local distanceBetweenBlip = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, createdBlips[i].posX, createdBlips[i].posY, createdBlips[i].posZ)
					local blipHalfSize = createdBlips[i].iconSize / 2

					dxDrawText(floor(distanceBetweenBlip) .. " m", screenX + 1, screenY + 1 + blipHalfSize + respc(4), screenX, 0, tocolor(0, 0, 0, 255), 0.75, getFont("Roboto"), "center", "top")
					dxDrawText(floor(distanceBetweenBlip) .. " m", screenX, screenY + blipHalfSize + respc(4), screenX, 0, 0xFFFFFFFF, 0.75, getFont("Roboto"), "center", "top")
					dxDrawImage(screenX - blipHalfSize, screenY - blipHalfSize, createdBlips[i].iconSize, createdBlips[i].iconSize, "files/" .. createdBlips[i].icon, 0, 0, 0, tocolor(255, 255, 255, 200))
				end
			end
		end

		local blipTable = getElementsByType("blip")
		for i = 1, #blipTable do
			if blipTable[i] then
				if getElementAttachedTo(blipTable[i]) ~= localPlayer then
					local blipPosX, blipPosY, blipPosZ = getElementPosition(blipTable[i])
					local screenX, screenY = getScreenFromWorldPosition(blipPosX, blipPosY, blipPosZ)

					if screenX and screenY then
						local distanceBetweenBlip = getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, blipPosX, blipPosY, blipPosZ)
						local blipIcon = (getBlipIcon(blipTable[i]) == 1 and "munkajarmu") or "target"

						dxDrawText(floor(distanceBetweenBlip) .. " m\n" .. (blipTooltips[blipTable[i]] or ""), screenX + 1, screenY + 1 + 7.5 + respc(4), screenX, 0, tocolor(0, 0, 0, 255), 0.75, getFont("Roboto"), "center", "top")
						dxDrawText(floor(distanceBetweenBlip) .. " m#e0e0e0\n" .. (blipTooltips[blipTable[i]] or ""), screenX, screenY + 7.5 + respc(4), screenX, 0, 0xFFFFFFFF, 0.75, getFont("Roboto"), "center", "top", false, false, false, true)
						dxDrawImage(screenX - 9, screenY - 7.5, 18, 15, "files/blips/" .. blipIcon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 200))
					end
				end
			end
		end
	end
end

function createCustomBlip(x, y, z, icon, farShow, visibleDistance, size, color, txt)
	table.insert(createdBlips, {
		posX = x,
		posY = y,
		posZ = z,
		icon = icon,
		farShow = farShow,
		renderDistance = visibleDistance or 9999,
		iconSize = size or 22,
		text = txt,
		color = color or tocolor(255, 255, 255)
	})
end

function deleteCustomBlip(count)
	print(count)
	table.remove(createdBlips, count)
end

function remapTheFirstWay(coord)
	return (-coord + 3000) / mapRatio
end

function remapTheSecondWay(coord)
	return (coord + 3000) / mapRatio
end

function carCanGPS()
	if getElementData(occupiedVehicle, "dbid") then
		carCanGPSVal = getElementData(occupiedVehicle, "vehicle.tuning.seeGO") or false
	else
		carCanGPSVal = 1
	end

	return carCanGPSVal
end

function addGPSLine(x, y)
	table.insert(gpsLines, {remapTheFirstWay(x), remapTheFirstWay(y)})
end

function processGPSLines()
	local routeStartPosX, routeStartPosY = 99999, 99999
	local routeEndPosX, routeEndPosY = -99999, -99999

	for i = 1, #gpsLines do
		if gpsLines[i][1] < routeStartPosX then
			routeStartPosX = gpsLines[i][1]
		end

		if gpsLines[i][2] < routeStartPosY then
			routeStartPosY = gpsLines[i][2]
		end

		if gpsLines[i][1] > routeEndPosX then
			routeEndPosX = gpsLines[i][1]
		end

		if gpsLines[i][2] > routeEndPosY then
			routeEndPosY = gpsLines[i][2]
		end
	end

	local routeWidth = (routeEndPosX - routeStartPosX) + 16
	local routeHeight = (routeEndPosY - routeStartPosY) + 16

	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end

	gpsRouteImage = dxCreateRenderTarget(routeWidth, routeHeight, true)
	gpsRouteImageData = {routeStartPosX - 8, routeStartPosY - 8, routeWidth, routeHeight}

	dxSetRenderTarget(gpsRouteImage)
	dxSetBlendMode("modulate_add")

	for i = 2, #gpsLines do
		if gpsLines[i - 1] then
			local startX = gpsLines[i][1] - routeStartPosX + 8
			local startY = gpsLines[i][2] - routeStartPosY + 8
			local endX = gpsLines[i - 1][1] - routeStartPosX + 8
			local endY = gpsLines[i - 1][2] - routeStartPosY + 8
			dxDrawLine(startX, startY, endX, endY, tocolor(255, 255, 255), 9)
		end
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

function clearGPSRoute()
	gpsLines = {}

	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end
	gpsRouteImage = false
end


function dxDrawInnerBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)

	dxDrawRectangle(x, y, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h - borderSize, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + borderSize, borderSize, h - (borderSize * 2), borderColor, postGUI)
	dxDrawRectangle(x + w - borderSize, y + borderSize, borderSize, h - (borderSize * 2), borderColor, postGUI)
end

function dxDrawOuterBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)

	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

function dxDrawBorderedImageSection(x, y, w, h, ux, uy, uw, uh, path, rx, ry, rz, color, postGUI)
	dxDrawImageSection(x - 1, y - 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x - 1, y + 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x + 1, y - 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x + 1, y + 1, w, h, ux, uy, uw, uh, path, rx, ry, rz, tocolor(0, 0, 0, 200), postGUI)
	dxDrawImageSection(x, y, w, h, ux, uy, uw, uh, path, rx, ry, rz, color, postGUI)
end

function dxDrawBorderedText(text, x, y, w, h, color, ...)
	local textWithoutHEX = gsub(text, "#%x%x%x%x%x%x", "")
	dxDrawText(textWithoutHEX, x - 1, y - 1, w - 1, h - 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(textWithoutHEX, x - 1, y + 1, w - 1, h + 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(textWithoutHEX, x + 1, y - 1, w + 1, h - 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(textWithoutHEX, x + 1, y + 1, w + 1, h + 1, tocolor(0, 0, 0, 255), ...)
	dxDrawText(text, x, y, w, h, color, ...)
end

function dxDrawRoundedRectangle(x, y, w, h, color, postGUI, subPixelPositioning, radius)
	radius = radius or 5

	dxDrawImage(x, y, radius, radius, getTexture("round"), 0, 0, 0, color, postGUI)
	dxDrawRectangle(x, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x, y + h - radius, radius, radius, getTexture("round"), 270, 0, 0, color, postGUI)
	dxDrawRectangle(x + radius, y, w - radius * 2, h, color, postGUI, subPixelPositioning)
	dxDrawImage(x + w - radius, y, radius, radius, getTexture("round"), 90, 0, 0, color, postGUI)
	dxDrawRectangle(x + w - radius, y + radius, radius, h - radius * 2, color, postGUI, subPixelPositioning)
	dxDrawImage(x + w - radius, y + h - radius, radius, radius, getTexture("round"), 180, 0, 0, color, postGUI)
end

function getHudCursorPos()
	if isCursorShowing() then
		return getCursorPosition()
	end
	return false
end

function getFont(name)
	if createdFonts[name] then
		return createdFonts[name]
	end

	return "default"
end

function initFont(name, path, size)
	if not createdFonts[name] then
		createdFonts[name] = dxCreateFont("files/" .. path, resp(size), false, "antialiased")
	else
		return createdFonts[name]
	end
end

function isCursorWithinArea(cx, cy, x, y, w, h)
	if isCursorShowing() then
		if cx >= x and cx <= x + w and cy >= y and cy <= y + h then
			return true
		end
	end

	return false
end

addEventHandler("onClientVehicleEnter", getRootElement(),
	function (player)
		if player == localPlayer then
			if occupiedVehicle ~= source then
				occupiedVehicle = source
			end
		end
	end
)

addEventHandler("onClientVehicleExit", getRootElement(),
	function (player)
		if player == localPlayer then
			if occupiedVehicle == source then
				occupiedVehicle = false
			end
		end
	end
)

addEventHandler("onClientElementDestroy", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

addEventHandler("onClientVehicleExplode", getRootElement(),
	function ()
		if occupiedVehicle == source then
			occupiedVehicle = false
		end
	end
)

function getVehicleSpeed(vehicle)
	local velocityX, velocityY, velocityZ = getElementVelocity(vehicle)
	return ((velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ) ^ 0.5) * 187.5
end


theblips = {}
function createblip()
  for i,v in ipairs (cfg.statcsblips) do
	if not theblips[i] then
		local id, x, y, z, size, viz, color, text = unpack(v)
		if text then
			theblips[i] = exports.an_radar:createCustomBlip( x, y, z, id, viz, 9999, size, color, text)
		else
			theblips[i] = exports.an_radar:createCustomBlip( x, y, z, id, viz, 9999, size, color)
		end
    end
  end
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), createblip)
