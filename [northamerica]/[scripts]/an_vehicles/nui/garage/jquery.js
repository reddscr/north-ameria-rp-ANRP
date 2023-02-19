
var vehgarageid = null;
var vehgaragename = null;

$(document).ready(function () {
    opengarage();
});

function closeg(){
    mta.triggerEvent("closegarage")
    closegarage();
}

function opengarage() {
    $("#garagemenu").fadeIn();
    $("#garage").empty();
    mta.triggerEvent("addcarsgarage");
    clearallgarage();
}

function closegarage() {
    $("#garagemenu").fadeOut();
}

function pegvehgarage() {
    mta.triggerEvent("pegvehgarage",vehgarageid,vehgaragename)
}
function guavehgarage() {
    mta.triggerEvent("guavehgarage")
}


function sectedvehgarage(element){
    clearallgarage()
    vehgarageid = element.dataset.vehid;
    vehgaragename = element.dataset.vehname;
    $(element).css("background-color", "rgba(32, 119, 21, 0.74)");
}

function addgarageprice(gprice){
    $(".weightgarage").empty();
    $(".weightgarage").html("<s>VALOR PARA ESTACIONAR: $"+gprice+"</s>");
}

function addgaragecars(id,nome,mala,vehtax,vehplate) {
    $("#garage").append(`
        <div onclick="sectedvehgarage(this)" data-vehid="${id}" data-vehname="${nome}" data-vehmala="${mala}">
            <s>${nome}</s> <br>Placa: <s>${vehplate}</s> <br>Porta-Malas: <s>${mala}</s> <br>Tax status: <s>${vehtax}</s>
        </div>
    `);
}

function clearallgarage2(){
    $("#garage").empty();
    $("#garage").fadeIn();
    clearallgarage();
}


function clearallgarage() {
    vehgarageid = null;
    vehgaragename = null;
    $("#garage div").css("background-color", "rgba(0,0,0,0.4)");
}

function message(typ,txt){
    var html = "<div id='"+typ+"'>"+txt+"</div>"
    $(html).appendTo("#notifications").hide().fadeIn(1000).delay(8000).fadeOut(1000);
}
