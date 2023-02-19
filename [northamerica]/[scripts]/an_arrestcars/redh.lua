cfg = {}


cfg.locals = {
    {1, 1381.679, -1653.047, 13.6, 0, 0, 282.098}
}

cfg.localgarages = {
    {1, 1385.673, -1648.944, 13.6, 272.298},
}

function getDataGarage(id)
    for key,val in pairs(cfg.localgarages) do
        if val[1] == id then
            return val
        end
    end
end