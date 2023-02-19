var type = "normal";
var disabled = false;
var disabledFunction = null;

function additem(itname,itamount,itidname,itpeso) {
    $("#items").append(`
        <div data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    $("#items div").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false ;
            }
            $(ui.helper).css('background-repeat', 'no-repeat');
            $(ui.helper).css('background-size', '50px 50px');
            $(ui.helper).css('width', '85px');
            $(ui.helper).css('height', '75px');
            $(ui.helper).css('background-position', 'center');
            $(ui.helper).css('font-size', '0px');
            //$(ui.helper).css('background-color', 'rgba(0,0,0,0.3)');
            $(this).css('background-image', 'none');
            itemData = $(this).data("icon");
            
        },
        stop: function () {
            itemData = $(this).data("icon");
            if (itemData !== undefined) {
                $(this).css('background-image', 'url(\'assets/icons/' + itemData + '\'');
            }
        }
    }
    );

}

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function attitens(itname,itamount,itidname,itpeso) {
    itemName = null;
    itemAmount = null;
    itemIdname = null;
    $("#items").append(`
        <div data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    $("#items div").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false ;
            }
            $(ui.helper).css('background-repeat', 'no-repeat');
            $(ui.helper).css('background-size', '50px 50px');
            $(ui.helper).css('width', '85px');
            $(ui.helper).css('height', '75px');
            $(ui.helper).css('background-position', 'center');
            $(ui.helper).css('font-size', '0px');
            $(this).css('background-image', 'none');
            itemData = $(this).data("icon");
        },
        stop: function () {
            itemData = $(this).data("icon");
            if (itemData !== undefined) {
                $(this).css('background-image', 'url(\'assets/icons/' + itemData + '\'');
            }
        }
    });
}

function clearallitens(){
    $("#items").empty();
}


function addinvinfos(slot,maxslot) {
    $(".weight").html("MOCHILA "+slot+"/"+maxslot+" kg");
}

function addinvinfos2(slot,maxslot) {
    $(".weighttrunk1").html("MOCHILA "+slot+"/"+maxslot+" kg");
}

function addinvinfosveh(slot,maxslot) {
    $(".weighttrunk2").html("PORTA-MALAS "+slot+"/"+maxslot+" kg");
}

function addinvinfoschest(slot,maxslot) {
    $(".weighttrunk2").html("BAÚ "+slot+"/"+maxslot+" kg");
}
        ////////////////////////////////// - M A L A - ///////////////////////////////////////////////

function opentrunk(itname,itamount,itidname,itpeso) {
    $("#trunk2").append(`
        <div data-inventory="trunkinv" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    $("#trunk2 div").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false ;
            }
            $(ui.helper).css('background-repeat', 'no-repeat');
            $(ui.helper).css('background-size', '50px 50px');
            $(ui.helper).css('width', '85px');
            $(ui.helper).css('height', '75px');
            $(ui.helper).css('background-position', 'center');
            $(ui.helper).css('font-size', '0px');
            $(this).css('background-image', 'none');
            itemData = $(this).data("icon");
        },
        stop: function () {
            itemData = $(this).data("icon");

            if (itemData !== undefined) {

                $(this).css('background-image', 'url(\'assets/icons/' + itemData + '\'');

            }
        }
    });
}

function additemontrunk(itname,itamount,itidname,itpeso) {
    $("#trunk1").append(`
        <div data-inventory="playerinv" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    $("#trunk1 div").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false ;
            }
            $(ui.helper).css('background-repeat', 'no-repeat');
            $(ui.helper).css('background-size', '50px 50px');
            $(ui.helper).css('width', '85px');
            $(ui.helper).css('height', '75px');
            $(ui.helper).css('background-position', 'center');
            $(ui.helper).css('font-size', '0px');
            $(this).css('background-image', 'none');
            itemData = $(this).data("icon");
        },
        stop: function () {
            itemData = $(this).data("icon");

            if (itemData !== undefined) {

                $(this).css('background-image', 'url(\'assets/icons/' + itemData + '\'');

            }
        }
    }
    );
}

function clearallitens2(){
    $("#trunk1").empty();
}

function clearallitenstrunk(){
    $("#trunk2").empty();
}


function attitens2(itname,itamount,itidname,itpeso) {
    itemName = null;
    itemAmount = null;
    itemIdname = null;
    $("#trunk1").append(`
        <div data-inventory="playerinv" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    $("#trunk1 div").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false ;
            }
            $(ui.helper).css('background-repeat', 'no-repeat');
            $(ui.helper).css('background-size', '50px 50px');
            $(ui.helper).css('width', '85px');
            $(ui.helper).css('height', '75px');
            $(ui.helper).css('background-position', 'center');
            $(ui.helper).css('font-size', '0px');
            $(this).css('background-image', 'none');
            itemData = $(this).data("icon");
        },
        stop: function () {
            itemData = $(this).data("icon");

            if (itemData !== undefined) {

                $(this).css('background-image', 'url(\'assets/icons/' + itemData + '\'');

            }
        }
    });
}

function attitenstrunk(itname,itamount,itidname,itpeso) {
    itemName = null;
    itemAmount = null;
    itemIdname = null;
    $("#trunk2").append(`
        <div data-inventory="trunkinv" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    $("#trunk2 div").draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function (event, ui) {
            if (disabled) {
                return false ;
            }
            $(ui.helper).css('background-repeat', 'no-repeat');
            $(ui.helper).css('background-size', '50px 50px');
            $(ui.helper).css('width', '85px');
            $(ui.helper).css('height', '75px');
            $(ui.helper).css('background-position', 'center');
            $(ui.helper).css('font-size', '0px');
            $(this).css('background-image', 'none');
            itemData = $(this).data("icon");
        },
        stop: function () {
            itemData = $(this).data("icon");
            if (itemData !== undefined) {
                $(this).css('background-image', 'url(\'assets/icons/' + itemData + '\'');
            }
        }
    });
    
}

//width: 50%;

var itemName = null;
var itemAmount = null;
var itemIdname = null;
$(document).ready(function () {
    open();
    mta.triggerEvent("requestinvinfo");
    document.onkeyup = function (data) {
    if (data.which == 75) {
            mta.triggerEvent("closeinv")
        }
    };
    if(  $("#drop").is(":visible") == true ){  
        $('#drop').droppable({
            drop: function (event, ui) {
                itemName = ui.draggable.data("name");
                itemAmount = ui.draggable.data("amount");
                itemIdname = ui.draggable.data("idname");
                let amount = $("#amount").val();
                if (amount == "0" || amount == "" || amount == null) {
                    mta.triggerEvent("dropitemclient",itemIdname,itemAmount)
                    disableInventory(1000);
                } else if (parseInt(amount) > parseInt(itemAmount)) {
                    var msg = "O número digitado é mais alto do que o que você tem no seu inventário!";
                    var typ = "erro";
                    mta.triggerEvent("sendmessage",msg,typ)
                } else {
                    if(itemIdname !== null) {
                        disableInventory(1000);
                        mta.triggerEvent("dropitemclient",itemIdname,amount)
                    }
                }
            }
        });
    }
    if(  $("#useitem").is(":visible") == true ){  
        $('#useitem').droppable({
            drop: function (event, ui) {
                itemName = ui.draggable.data("name");
                itemAmount = ui.draggable.data("amount");
                itemIdname = ui.draggable.data("idname");

                let amount = $("#amount").val();
                if (amount == "0" || amount == "" || amount == null) {
                    disableInventory(1000);
                    mta.triggerEvent("useritemclient",itemIdname,"1")
                } else if (parseInt(amount) > parseInt(itemAmount)) {
                    var msg = "O número digitado é mais alto do que o que você tem no seu inventário!";
                    var typ = "erro";
                    mta.triggerEvent("sendmessage",msg,typ)
                } else {
                    if(itemIdname !== null) {
                        disableInventory(1000);
                        mta.triggerEvent("useritemclient",itemIdname,"1")
                    }
                }
            }
            
        });
    }
    if(  $("#useitem").is(":visible") == true ){  
        $('#send').droppable({
            drop: function (event, ui) {
                itemName = ui.draggable.data("name");
                itemAmount = ui.draggable.data("amount");
                itemIdname = ui.draggable.data("idname");
                let amount = $("#amount").val();
                if (amount == "0" || amount == "" || amount == null) {
                    disableInventory(1000);
                    mta.triggerEvent("giveitemclient",itemIdname,itemAmount)
                } else if (parseInt(amount) > parseInt(itemAmount)) {
                    var msg = "O número digitado é mais alto do que o que você tem no seu inventário!";
                    var typ = "erro";
                    mta.triggerEvent("sendmessage",msg,typ)
                } else {
                    if(itemIdname) {
                        disableInventory(1000);
                        mta.triggerEvent("giveitemclient",itemIdname,amount)
                    }
                }
            }
        });
    }
    if(  $("#trunk1").is(":visible") == true ){  
        $('#trunk1').droppable({
            drop: function (event, ui) {
                itemInventory = ui.draggable.data("inventory");
                itemName = ui.draggable.data("name");
                itemAmount = ui.draggable.data("amount");
                itemIdname = ui.draggable.data("idname");
                let amount = $("#amount").val();
                if ( itemInventory == 'trunkinv') {
                    if (amount == "0" || amount == "" || amount == null ) {
                        disableInventory(1000);
                        mta.triggerEvent("pegItemtigger",itemIdname,itemAmount)
                    } else if (parseInt(amount) > parseInt(itemAmount)) {
                        var msg = "O número digitado é mais alto do que o que você tem no seu inventário!";
                        var typ = "erro";
                        mta.triggerEvent("sendmessage",msg,typ)
                    } else {
                        if(itemIdname !== null) {
                            disableInventory(1000);
                            mta.triggerEvent("pegItemtigger",itemIdname,amount)
                        }
                    }
                }
            }
        });
    }
    if(  $("#trunk2").is(":visible") == true ){  
        $('#trunk2').droppable({
            drop: function (event, ui) {
                itemInventory = ui.draggable.data("inventory");
                itemName = ui.draggable.data("name");
                itemAmount = ui.draggable.data("amount");
                itemIdname = ui.draggable.data("idname");
                let amount = $("#amount").val();
                if ( itemInventory == 'playerinv') {
                    if (amount == "0" || amount == "" || amount == null) {
                        disableInventory(1000);
                        mta.triggerEvent("colocItemtigger",itemIdname,itemAmount);
                    } else if (parseInt(amount) > parseInt(itemAmount)) {
                        var msg = "O número digitado é mais alto do que o que você tem no seu inventário!";
                        var typ = "erro";
                        mta.triggerEvent("sendmessage",msg,typ)
                    } else {
                        if(itemIdname !== null) {
                            disableInventory(1000);
                            mta.triggerEvent("colocItemtigger",itemIdname,amount)
                        }
                    }
                }
            }
        });
    }
});

function open() {
    $(".container").show();
}
function close() {
    $(".container").fadeOut();
    $("#home").css("display", "none");
}
function openHome() {
    $("#home").css("display", "block");
}

function Interval(time) {
    var timer = false;
    this.start = function () {
        if (this.isRunning()) {
            clearInterval(timer);
            timer = false;
        }

        timer = setInterval(function () {
            disabled = false;
        }, time);
    };
    this.stop = function () {
        clearInterval(timer);
        timer = false;
    };
    this.isRunning = function () {
        return timer !== false;
    };
}

function disableInventory(ms) {
    disabled = true;

    if (disabledFunction === null) {
        disabledFunction = new Interval(ms);
        disabledFunction.start();
    } else {
        if (disabledFunction.isRunning()) {
            disabledFunction.stop();
        }

        disabledFunction.start();
    }
}


function naitemnotify(itname, id, qtd, typ, peso){
    var html = `<div id="${id}" style="background-image: url('assets/icons/${id}.png'); background-size: 50px 50px;">
                    <p class="amount">${typ} ${qtd}<s>x</s></p>
                    <p class="name">${itname}</p>
                    <p class="peso">${formatarNumero(peso)}</p>
                </div>`
    $(html).appendTo("#nainotify").hide().fadeIn(500).delay(5000).fadeOut(500);
}


const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
/* ------------------------------------- TRUNK FUNCTIONS ------------------------------------- */

function setTheme() {
if(configs.theme.primary_color && configs.theme.secondary_color) {
        let primary_color = `--primary-color: ${configs.theme.primary_color}; `;
        let secondary_color = `--secondary-color: ${configs.theme.secondary_color}; `;
        $(":root").attr("style", primary_color + secondary_color);
    }
}
