var type = "normal";
var disabled = false;
var disabledFunction = null;

function addplyitemtrade(itname,itamount,itidname,itpeso,type){
    $("#tradde1").append(`
        <div data-inventory="tradde1" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
            <p class="amount">${itamount}<s>x</s></p>
            <p class="name">${itname}</p>
            <p class="peso">${itpeso}</p>
        </div>
    `);
    if ( type == 'saller') {
        $("#tradde1 div").draggable({
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
}

function additemtrade(itname,itamount,itidname,itpeso,type){
    if ( type == 'buy') {
        $("#tradde2").append(`
            <div data-inventory="tradde2" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
                <!--<p class="amount">${itamount}</p>-->
                <p class="name">${itname}</p>
                <p class="peso">${itpeso}<s>kg</s></p>
            </div>
        `);
        $("#tradde2 div").draggable({
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
        $("#tradde2 div").mouseover(function() {
            $(".weighttradde2").html($(this).data("amount"));
            $(".weighttradde2").show()
        });
        $("#tradde2 div").mouseleave(function() {
            $(".weighttradde2").html('');
            $(".weighttradde2").hide()
        });
    }else if ( type == 'saller') {
        $("#tradde2").append(`
            <div data-inventory="tradde2" data-name="${itname}" data-icon="${itidname}.png" data-amount="${itamount}" data-idname="${itidname}" style="background-image: url('assets/icons/${itidname}.png'); background-size: 50px 50px;">
                <p class="amount">${itamount}</p>
                <p class="name">${itname}</p>
                <!--<p class="peso">${itpeso}<s>kg</s></p>-->
            </div>
        `);
        $(".weighttradde2").html('Arraste e solte neste lado para vender');
        $(".weighttradde2").show()
    }
    
}

$(document).ready(function () {
    mta.triggerEvent("requestinvtotrade");
    document.onkeyup = function (data) {
    if (data.which == 78) {
            mta.triggerEvent("closetrader")
        }
    };
    $('#tradde1').droppable({
        drop: function (event, ui) {
            itemInventory = ui.draggable.data("inventory");
            itemName = ui.draggable.data("name");
            itemIdname = ui.draggable.data("idname");
            let amount = $("#tradeamount").val();
            if ( itemInventory !== 'tradde1') {
                if (amount == "0" || amount == "" || amount == null ) {
                    disableInventory(1000);
                    mta.triggerEvent("buyItemtrader",itemIdname,'1')
                } else {
                    if(itemIdname !== null) {
                        disableInventory(1000);
                        mta.triggerEvent("buyItemtrader",itemIdname,amount)
                    }
                }
            }
        }
    });
    $('#tradde2').droppable({
        drop: function (event, ui) {
            itemInventory = ui.draggable.data("inventory");
            itemName = ui.draggable.data("name");
            itemIdname = ui.draggable.data("idname");
            let amount = $("#tradeamount").val();
            if ( itemInventory !== 'tradde2') {
                if (amount == "0" || amount == "" || amount == null ) {
                    disableInventory(1000);
                    mta.triggerEvent("sellItemtrader",itemIdname,'1')
                } else {
                    if(itemIdname !== null) {
                        disableInventory(1000);
                        mta.triggerEvent("sellItemtrader",itemIdname,amount)
                    }
                }
            }
        }
    });
});

function clearallitenstrade() {
    $("#tradde1").empty();
}

function clearallitenstrade2() {
    $("#tradde2").empty();
}

function addtradeplyinfo(slot,maxslot) {
    $(".weighttradde1").html("MOCHILA "+slot+"/"+maxslot+" kg");
}

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
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

function setTheme() {
if(configs.theme.primary_color && configs.theme.secondary_color) {
        let primary_color = `--primary-color: ${configs.theme.primary_color}; `;
        let secondary_color = `--secondary-color: ${configs.theme.secondary_color}; `;
        $(":root").attr("style", primary_color + secondary_color);
    }
}

$.widget('ui.dialog', $.ui.dialog, {
    options: {
        clickOutside: false,
        clickOutsideTrigger: ''
    },
    open: function () {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function (event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        this._super();
    },
    close: function () {
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        this._super();
    },
});