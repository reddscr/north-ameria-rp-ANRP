chat_range = 25 

function isPlayerInRangeOfPoint(player,x,y,z,range) 
    local px,py,pz=getElementPosition(player) 
    return ((x-px)^2+(y-py)^2+(z-pz)^2)^0.5<=range 
end 

words = {}
lastChatMessage = {}
addEventHandler("onPlayerChat", getRootElement(),
function(text, msgtype)
local root = getRootElement()
local new = ""
local iter = 0
msg = string.gsub(text,"ـ","")
for word in msg:gmatch("%S+") do
iter = iter + 1

if iter == 1 and word:len() > 0 then
word = word:gsub("%a",string.upper,1)
end
new = new..word.." "
end
if new ~= "" then msg = new end
text = msg

lastChatMessage[source] = text
local r, g, b = getPlayerNametagColor(source)
cancelEvent()

local iddocara = getElementData ( source, "id" )
local nome = getElementData(source, "Nome")
local snome = getElementData(source, "SNome")
local px,py,pz=getElementPosition(source) 
for _,v in ipairs(getElementsByType("player")) do 
    if isPlayerInRangeOfPoint(v,px,py,pz,chat_range) then 
        cancelEvent(true)
        triggerClientEvent( v,"onmessagelocalchat", v, toJSON("#7a7a7a" ..nome.." "..snome.."#e3e3e3: "  .. text))
    end
end
end 
)
