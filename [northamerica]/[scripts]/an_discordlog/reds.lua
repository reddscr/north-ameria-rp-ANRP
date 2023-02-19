 --- link do webhook - log do servidor

local discordWebhookURL = "https://discordapp.com/api/webhooks/741763136889028627/ZsTyBZKjoLK2j7oNWLk5ZG2PuegIQ2YGVYeKUp52ws-4Sy2XP_Tkwu7VxTLtKkJKyI1E"

function sendnorthamericalog(ply, post)
    local sendOptions = {
    queueName = "northamerica",
    connectionAttempts = 3,
    connectTimeout = 5000,
    formFields = {
        content = post
    },
}
fetchRemote ( discordWebhookURL, sendOptions, function()end )
end
addEvent("sendnorthamericalog", true)
addEventHandler("sendnorthamericalog", root, sendnorthamericalog)

 --- link do webhook - apreenções/multas/anuncios da policia
local discordWebhookURLNAPD = "https://discordapp.com/api/webhooks/735061295098888252/1KB0xtye_ZS5-ahFIuce47gdB38Lcgql27z__MUv6cfMYWZTzOX68aPiFet5G77V1flH"

function sendnorthamericaloganpd(ply, post)
    local sendOptions = {
    queueName = "northamerica",
    connectionAttempts = 3,
    connectTimeout = 5000,
    formFields = {
        content = post
    },
}
fetchRemote ( discordWebhookURLNAPD, sendOptions, function()end )
end
addEvent("sendnorthamericaloganpd", true)
addEventHandler("sendnorthamericaloganpd", root, sendnorthamericaloganpd)

 --- link do webhook - policiais em serviço
local discordWebhookURLNAPDponto = "https://discordapp.com/api/webhooks/757629117129687070/EnZepLiPsh2WR3R84H0uCAO8w1r3n7Cz0h56U4csfqhMqsrRidj0SZVXkueakqpu4dW5"
function sendnorthamericaloganpdponto(ply, post)
    local sendOptions = {
    queueName = "northamerica",
    connectionAttempts = 3,
    connectTimeout = 5000,
    formFields = {
        content = post
    },
}
fetchRemote ( discordWebhookURLNAPDponto, sendOptions, function()end )
end
addEvent("sendnorthamericaloganpdponto", true)
addEventHandler("sendnorthamericaloganpdponto", root, sendnorthamericaloganpdponto)



