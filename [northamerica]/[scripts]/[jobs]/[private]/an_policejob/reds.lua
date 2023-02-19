-------------------------------------------------------------------------------------------------------
-- JOB PAY
-------------------------------------------------------------------------------------------------------
function paymentply_motoristapolice(ply,payment)
    if payment then
        exports.an_inventory:sattitem(ply,"Money",payment,"mais")
    end
end
addEvent ("paymentply_motoristapolice", true)
addEventHandler ("paymentply_motoristapolice", root, paymentply_motoristapolice)
-------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------