cfg = {}

cfg.drugtable = {
    {"Marijuana"}
}

function checkpolice()
    local policeinservice = exports.an_police:getpoliceinservice()
    police = 0
    if policeinservice >= 2 then
        police = policeinservice
    end
    return police
end


