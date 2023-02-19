local shaders = {}
local elementShaders = {}
local textureCache = {}
local textureCount = {}
local textureSize = 768


addEventHandler("onClientRender", getRootElement(),
    function()
        --local getComponent = getVehicleComponents(source) -- get a table with all the components of the vehicle
				--getVehicleName(vehicle theVehicle)
        for k, v in pairs (getElementsByType("vehicle")) do
								local id = getElementModel (v)
						--if k ~= "display" then
								if id == 463 then
            						setVehicleComponentVisible(v, "wheel_type", false) -- freeway
								end
								if id == 506 then
									setVehicleComponentVisible(v, "lamps", false) -- supergt 506
								end
								if id == 480 then
									setVehicleComponentVisible(v, "calipers", false) -- comet
								end
								if id == 541 then
									setVehicleComponentVisible(v, "display", false) -- bullet
								end
								setVehicleComponentVisible(v, "LFA11_engine", false)
								if id == 533 then
									setVehicleComponentVisible(v, "display", false) -- feltzer
								end
								if id == 445 then
									setVehicleComponentVisible(v, "display", false) -- admiral
								end
								if id == 503 then
									setVehicleComponentVisible(v, "display", false) -- hotring 503
								end
								if id == 585 then
									setVehicleComponentVisible(v, "motor", false)
								end
								if id == 526 then
									setVehicleComponentVisible(v, "display", false)
								end
								if id == 562 then
									setVehicleComponentVisible(v, "skyline", false)
								end
						--	outputChatBox("k")
					--	end
				end

    end
)

function applyShader(texture, img, distance, element)
	if element then
		destroyShaderCache(element)
	end
	local this = #shaders + 1
	shaders[this] = {}
	shaders[this][1] = dxCreateShader("graphics.fx",0,distance,layered)
	if not textureCount[img] then
		textureCount[img] = 0
	end
	if textureCount[img] == 0 then
		textureCache[img] = dxCreateTexture(img)
	end
	textureCount[img] = textureCount[img] + 1
	shaders[this][2] = textureCache[img]
	shaders[this][3] = texture
	if element then
		if not elementShaders[element] then
			elementShaders[element] = {shaders[this], img}
		end
	end
	if shaders[this][1] and shaders[this][2] then
		dxSetShaderValue(shaders[this][1], "TEXTURE", shaders[this][2])
		engineApplyShaderToWorldTexture(shaders[this][1], texture, element)
	end
end

function destroyShaderCache(element)
	if elementShaders[element] then
		destroyElement(elementShaders[element][1][1])
		local old_img = elementShaders[element][2]
		textureCount[old_img] = textureCount[old_img] - 1
		if textureCount[old_img] == 0 then
			destroyElement(elementShaders[element][1][2])
		end
		elementShaders[element] = nil
	end
end
addEvent("destroyShaderCache", true)
addEventHandler("destroyShaderCache", root, destroyShaderCache)

addEventHandler("onClientResourceStart", resourceRoot, function()
	for k,v in ipairs(getElementsByType("vehicle", root, true)) do
		local pj = tonumber(getElementData(v, "PaintJob")) or 0
		if pj > 0 then
			addVehiclePaintJob(v, getElementModel(v), pj)
		end
	end
end)

function getVehiclePaintJobs(model)
	if paintJobs[model] then
		return #paintJobs[model]
	else
		return 0
	end
end

function addVehiclePaintJob(veh, model, id)
	local pj = paintJobs[model]
	if pj then
		local pj = pj[id]
		if pj then
			applyShader(pj[1], pj[2], 100, veh)
		end
	end
end
addEvent("addVehiclePaintJob", true)
addEventHandler("addVehiclePaintJob", root, addVehiclePaintJob)


addEventHandler("onClientElementDestroy", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		destroyShaderCache(source)
	end
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		local pj = tonumber(getElementData(source, "PaintJob")) or 0
		if pj > 0 then
			addVehiclePaintJob(source, getElementModel(source), pj)
		end
	end
end)

addEventHandler("onClientElementStreamOut", getRootElement(), function()
	if getElementType(source) == "vehicle" then
		destroyShaderCache(source)
	end
end)
