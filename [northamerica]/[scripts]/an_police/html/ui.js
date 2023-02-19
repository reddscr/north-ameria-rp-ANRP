
var vehgarageid = null;
var vehgaragename = null;

$(document).ready(function () {

    opengarage();

document.onkeyup = function (data) {
    if (data.which == 78) {
            mta.triggerEvent("closebindpl")
            closegarage();
        }
    };
    
});

function opengarage() {
    $("#garagemenu").fadeIn();
    $("#garage").empty();
    mta.triggerEvent("requestinvinfo");
    clearallgarage();
}

function closegarage() {
    $("#garagemenu").fadeOut();
}


function additem(itname,itamount,itidname,iticon) {
    $("#garage").append(`
        <div onclick="selectItem(this)" data-name="${itname}" data-amount="${itamount}" data-idname="${itidname}" style="background-position: 10px 5px; background-image: url('assets/icons/${iticon}'); background-size: 60px 60px;">
            <p class="amount">${itamount}</p>
            <p class="name">${itname}</p>
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
