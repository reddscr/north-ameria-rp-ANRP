$(document).ready(function () {

   // opengarage();

document.onkeyup = function (data) {
    if (data.which == 9) {
           var msg = $("#msg").val();
            if (msg == "" || msg == null) {
                mta.triggerEvent("nomessageemgcall");
                mta.triggerEvent("closeprompt")
            } else {
                mta.triggerEvent("sendmessageemgcall",msg.toString());
                mta.triggerEvent("closeprompt")
            };
        }
    };
    
});

function openpompt(title,text){
    promptitle = title;
    promptext = text;
    $('#help1').text(promptitle);
    $('#help2').text(promptext);
}


