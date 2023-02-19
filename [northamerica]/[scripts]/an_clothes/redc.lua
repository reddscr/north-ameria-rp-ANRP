


function onStartResourceDeleteFiles()
    for i,v in ipairs (cfg.clot) do
        if not fileExists(v[2]) and not fileExists(v[3]) then
            downloadFile(v[2])
        elseif not fileExists(v[3]) then
            downloadFile(v[2])
        end
        if fileExists(v[3]) then
            setTimer(function()
                loadtxd(v[1],v[3])
            end,1000,1)
        end
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)

addEventHandler("onClientFileDownloadComplete", getResourceRootElement(getThisResource()),function(file)
    for i,v in ipairs (cfg.clot) do
        if file == v[2] and (not fileExists(v[3])) then
            fileRename(v[2],v[3])  
            print(v[2],v[3])
            setTimer(function()
                loadtxd(v[1],v[3])
            end,1000,1)
        end   
   end   
end)

function loadtxd(clt,txd)
    local txd = engineLoadTXD(txd,true)
    engineImportTXD(txd, clt)
end













