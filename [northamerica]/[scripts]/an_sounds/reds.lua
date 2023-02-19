


function setalarmsound(pos,time)
    if pos then
        if time then
            triggerClientEvent(getRootElement(), "setlocalsound", getRootElement(), pos, time)
        end
    end
end

