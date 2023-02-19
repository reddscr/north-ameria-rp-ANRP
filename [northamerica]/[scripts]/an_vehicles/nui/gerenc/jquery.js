
var vehvehgerenciid = null;
var vehvehgerenciname = null;

$(document).ready(function () {

    openvehgerenci();

document.onkeyup = function (data) {
    if (data.which == 78) {
            mta.triggerEvent("closevehgerenci")
            closevehgerenci();
        }
    };
    
});

function closevg(){
    mta.triggerEvent("closevehgerenci")
    closevehgerenci();
}

function confirmationpriceveh(){
    let priceammount = $("#plyvehprice").val();

    if (priceammount == "" || priceammount == null) {
        var msg = "Por favor, insira um <b>valor</b> válido!";
        var typ = "aviso";
        mta.triggerEvent("sendmessageconce",msg,typ)

    }else {
        mta.triggerEvent("sellmyveh",vehvehgerenciid,vehvehgerenciname,priceammount)
        mta.triggerEvent("closevehgerenci")
        closevehgerenci();
        vehvehgerenciid = null;
        vehvehgerenciname = null;
    }

}


function openvehgerenci() {
    $(".thegerencicontainer").show();
    $("#gerenci").empty();
    mta.triggerEvent("addcarsvehgerenci");
    clearallvehgerenci();
}

function closevehgerenci() {
    $(".thegerencicontainer").hide();
}

function vendveh() {
    $(".thegerencicontainer").hide();
    $("#functionsvehsell").show();
}


function pagtaxvehvehgerenci() {
    mta.triggerEvent("pagtaxvehvehgerenci",vehvehgerenciid,vehvehgerenciname)
}


function sectedvehvehgerenci(element){
    clearallvehgerenci()
    vehvehgerenciid = element.dataset.vehid;
    vehvehgerenciname = element.dataset.vehname;
    $("#gerenci div").css("background-color", "rgba(0,0,0,0.3)");
    $(element).css("background-color", "rgba(32, 119, 21, 0.74)");
}

function addvehgerencicars(id,nome,mala,vehtax,vehplate,are) {
    $("#gerenci").append(`
        <div onclick="sectedvehvehgerenci(this)" data-vehid="${id}" data-vehname="${nome}" data-vehmala="${mala}">
            <s>${nome}</s> <br>Placa: <s>${vehplate}</s> <br>Porta-Malas: <s>${mala}</s> <br>Tax status: <s>${vehtax}</s><br>${are}
        </div>
    `);
}

function clearallvehgerenci2(){
    $("#gerenci").empty();
    $("#gerenci").fadeIn();
    clearallvehgerenci();
}


function clearallvehgerenci() {
    vehvehgerenciid = null;
    vehvehgerenciname = null;
    $("#gerenci div").css("background-color", "rgba(0,0,0,0.4)");
}

function message(typ,txt){
    var html = "<div id='"+typ+"'>"+txt+"</div>"
    $(html).appendTo("#notifications").hide().fadeIn(1000).delay(8000).fadeOut(1000);
}
