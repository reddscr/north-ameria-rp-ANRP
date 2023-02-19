var cprice = null;



$(document).ready(function () {
    mta.triggerEvent("requestcloth1","mascara");
    document.onkeyup = function (data) {
        if (data.which == 78) {
            closeclothshop()
        }
        if(data.which == 39) { // right
            mta.triggerEvent("setplycshoprotation");
        }
        if(data.which == 37) { // left
            mta.triggerEvent("setplycshoprotation2");
        }
    };

    init();
    var actionContainer = $("#menu");
    window.addEventListener('message',function(event){
        var item = event.data;

        if (item.showmenu){
            ResetMenu()
            actionContainer.show();
        }

        if (item.hidemenu){
            actionContainer.hide();
        }
    });
});


function ResetMenu(){
    $("div").each(function(i,obj){
        var element = $(this);

        if (element.attr("data-parent")){
            element.hide();
        } else {
            element.show();
        }
    });
}

function init() {
    $(".classes").each(function(i,obj){
        var menu = $(this).data("sub");
        var element = $("#"+menu);
        $(this).click(function(){       
            if (menu != "mascara" && menu != "relogio"){
                if (typeof model !== 'undefined') {
                    var element = $("#"+menu+model);
                } else {
                    var element = $("#"+menu+"");
                }
            } else {
                var element = $("#"+menu);                    
            }
            $(".item").each(function(i, ojb){
                $(this).hide()
                $(this).empty()
            });
            mta.triggerEvent("requestcloth1",menu);
            element.fadeIn(500);
        });
    });
    
}

function closeclothshop(){
    cprice = null;
    mta.triggerEvent("closeclothshop")
}

function cleanclothdata(data){
    $("#"+data+"").empty()
}

function setcompra(pre){
    $("#functions").empty()
    $("#functions").append(`
        <button data-name="${pre}" onclick="selectItem(this)" id="buy" class="function" >$${pre} Comprar</button></br>
    `);
    $("#functions").show()
}

function selectItem(element) {
    cprice = element.dataset.name;
    if(cprice !== null) {
        mta.triggerEvent("confirmbuycshop",cprice)
        cprice = null;
    }
}

function addcloth1(tag,clothdata,clothdata2){
    if (tag  == "mascara"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="glasses"><img src="img/assets/mask/${clothdata2}"/></button>
        `);
    } else if (tag  == "calca"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="trousers"><img src="img/assets/trousers/${clothdata2}"/></button>
        `);
    } else if (tag  == "blusa"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="shirt"><img src="img/assets/blusas/${clothdata2}"/></button>
        `);
    } else if (tag  == "sapato"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="shoes"><img src="img/assets/shoe/${clothdata2}"/></button>
        `);
    } else if (tag  == "jaqueta"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="shirt"><img src="img/assets/jaqueta/${clothdata2}"/></button>
        `);
    } else if (tag  == "chapeu"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="hats"><img src="img/assets/hats/${clothdata2}"/></button>
        `);
    } else if (tag  == "oculos"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="glasses"><img src="img/assets/glasses/${clothdata2}"/></button>
        `);
    } else if (tag  == "corrente"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="chains"><img src="img/assets/corrente/${clothdata2}"/></button>
        `);
    } else if (tag  == "relogio"){
        $("#"+tag+"").append(`
            <button class="botao" onclick="testselect(this)" data-action="${clothdata}" data-typdata="watches"><img src="img/assets/relogio/${clothdata2}"/></button>
        `);
    }
}

function testselect(element) {
    if($(element).parent().attr("id") == "mascara"){
        var dados = "15";
    }
    if($(element).parent().attr("id") == "calca"){
        var dados = "2";
    }
    if($(element).parent().attr("id") == "sapato"){
        var dados = "3";
    }
    if($(element).parent().attr("id") == "blusa"){
        var dados = "0";
    }
    if($(element).parent().attr("id") == "jaqueta"){
        var dados = "0";
    }
    if($(element).parent().attr("id") == "chapeu"){
        var dados = "16";
    }
    if($(element).parent().attr("id") == "oculos"){
        var dados = "15";
    }
    if($(element).parent().attr("id") == "relogio"){
        var dados = "14";
    }
    if($(element).parent().attr("id") == "corrente"){
        var dados = "13";
    }
    var cid = $(element).data("action");
    var tipo = $(element).data("typdata");
    mta.triggerEvent("clothingshop",dados, cid,tipo);
}



