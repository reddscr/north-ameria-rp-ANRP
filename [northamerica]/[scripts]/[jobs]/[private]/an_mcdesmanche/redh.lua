cfg = {}

cfg.dsmchelocal = {
    {1, -2287.847, -133.731, 35.4},
   
}

cfg.vehicles = {
    {"585","Crown Victoria","29500"},
    {"492","Honda Civic","40345"},
    {"546","Honda Acord","43625"},
    {"516","Dodge Charger RT","240000"},
    {"475","Dodge Challenger","180000"},
    {"494","BMW i8","225000"},
    {"445","BMW M5 E60","145000"},
    {"479","Grand Cherokee 4X4","186900"},
    {"602","Chevrolet Camaro","140000"},
    {"503","Maserati Granturismo","180000"},
    {"579","Chevrolet Silverado","247000"},
    {"400","Chevrolet Suburban","220500"},
    {"559","Nissan Skyline GTR R34","160000"},
    {"562","Nissan GTR R35","190000"},
    {"603","Jaguar F-Type","381000"},
    {"439","Plymouth Cuda","132000"},
    {"547","Mitsubishi Lancer Evo","150000"},
    {"555","Dodge Charger RT 69","180000"},
    {"468","BF-400","230000"},
    {"463","Daemon","80000"},
    {"581","Bati","150000"},
    {"521","Akuma","150000"},
    {"461","Carbon","130000"},
    {"522","Double","170000"},
    {"586","Sanchez","130000"},
}

function getDMCVehicleData(id)
	for k,v in pairs(cfg.vehicles) do
		if tonumber(v[1]) == tonumber(id) then
			return v
		end
	end
end


