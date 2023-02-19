
var vehgarageid = null;
var vehgaragename = null;

$(document).ready(function () {
    opengarage();
});

function closegarrests(){
	clearallarrestedcars()
    mta.triggerEvent("closearrestcars")
    closegarage();
}

function opengarage() {
    $("#garagemenu").fadeIn();
    $("#garage").empty();
    mta.triggerEvent("addcarsgaragearrest");
    clearallgarage();
}

function closegarage() {
    $("#garagemenu").fadeOut();
}

function pegvehgaragearrests() {
    mta.triggerEvent("pegvehgaragearrests", vehgarageid,vehgaragename)
}

function sectedvehgarage(element){
    clearallgarage()
    vehgarageid = element.dataset.vehid;
    vehgaragename = element.dataset.vehname;
    $(element).css("background-color", "rgba(32, 119, 21, 0.74)");
}

function addarrestedcars(id,nome,vehplate,aprice) {
    $("#garage").append(`
        <div onclick="sectedvehgarage(this)" data-vehid="${id}" data-vehname="${nome}">
            <s>${nome}</s> <br><br>Placa: <s>${vehplate}</s> <br><br>Valor da multa: <s>$ ${aprice}</s>
        </div>
    `);
}

function clearallarrestedcars(){
    $("#garage").empty();
    $("#garage").fadeIn();
    clearallgarage();
}

function clearallgarage() {
    vehgarageid = null;
    vehgaragename = null;
    $("#garage div").css("background-color", "rgba(0,0,0,0.4)");
}