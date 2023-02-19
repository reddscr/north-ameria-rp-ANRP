
var vehreantalgarageid = null;
var vehreantalgaragename = null;
var vehreantalgarageprice = null;

$(document).ready(function () {

    openreantalgarage();

document.onkeyup = function (data) {
    if (data.which == 78) {
            mta.triggerEvent("closereantalgarage")
            closereantalgarage();
        }
    };
    
});

function openreantalgarage() {
    $("#reantalgaragemenu").fadeIn();
    $("#reantalgarage").empty();
    mta.triggerEvent("addcarsreantalgarage");
    clearallreantalgarage();
}

function closereantalgarage() {
    $("#reantalgaragemenu").fadeOut();
}

function pegvehreantalgarage() {
    mta.triggerEvent("pegvehreantalgarage",vehreantalgarageid,vehreantalgaragename,vehreantalgarageprice)
}
function guavehreantalgarage() {
    mta.triggerEvent("guavehreantalgarage")
}


function sectedvehreantalgarage(element){
    clearallreantalgarage()
    vehreantalgarageid = element.dataset.vehid;
    vehreantalgaragename = element.dataset.vehname;
    vehreantalgarageprice = element.dataset.price;
    $("#reantalgarage div").css("background-color", "rgba(0,0,0,0.3)");
    $(element).css("background-color", "rgb(131,174,0)");
}

function addreantalgaragecars(id,nome,price) {
    $("#reantalgarage").append(`
        <div onclick="sectedvehreantalgarage(this)" data-vehid="${id}" data-price="${price}" data-vehname="${nome}" style="background-position: 10px 1px; background-size: 90px 90px;">
            <p class="name"><s>${nome}</s> <br>Preço do aluguel: <s>${price}</s></p>
        </div>
    `);
}

function clearallreantalgarage2(){
    $("#reantalgarage").empty();
    $("#reantalgarage").fadeIn();
    clearallreantalgarage();
}


function clearallreantalgarage() {
    vehreantalgarageid = null;
    vehreantalgaragename = null;
    vehreantalgarageprice = null;
    $("#reantalgarage div").css("background-color", "rgba(0,0,0,0.4)");
}

function message(typ,txt){
    var html = "<div id='"+typ+"'>"+txt+"</div>"
    $(html).appendTo("#notifications").hide().fadeIn(1000).delay(8000).fadeOut(1000);
}
