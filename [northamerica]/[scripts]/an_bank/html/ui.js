$(function() {
    mta.triggerEvent("requestbankinfos");
});

function setbankinfos(caixa,mao,infos) {
    $("#main").html(`
        <div class="containerplyinfo">
            <div id="infosply">${infos}</div>
        </div><br><br><br>
        <div class="model" >
            <div class="name">DEPOSITAR
                <div class="viewIcon" id="maindeposit"><img class="img" style='filter: invert(30%);' src="images/deposito.svg"></img></div>
                <br><nl>Mão: ${formatarNumero(mao)}</nl>
            </div>
            <div class="name">SACAR
                <div class="viewIcon" id="mainwith"><img class="img" style='filter: invert(30%);' src="images/retirar.svg"></img></div>
                <br><nl>Banco: ${formatarNumero(caixa)}</nl>
            </div>
            <div class="name">TRANSFERIR
                <div class="viewIcon" id="maintransf"><img class="img" style='filter: invert(30%);' src="images/transferir.svg"></img></div>
            </div>
            <!--<div class="name">PAGAR MULTAS
                <div class="viewIcon" id="paymultas"><img class="img" style='filter: invert(30%);' src="images/bem.svg"></img></div>
                <br><nl>Multas: </nl>
            </div>-->
        </div>
    `)
    /* ------------------------------------------------------- */
    document.getElementById("closeb").onclick = function() {
        mta.triggerEvent("closebank");
    };
    /* ------------------------------------------------------- */
    document.getElementById("maindeposit").onclick = function() {
        $("#main").hide();
        $(".containerplyinfo").hide();
        $("#loading").fadeIn(500);
        $("#closeb").hide();
        setTimeout( function() {
            $("#loading").hide();
            $("#depositmenu").fadeIn(500);
        }, 500 );
    };
    document.getElementById("mainwith").onclick = function() {
        $("#main").hide();
        $(".containerplyinfo").hide();
        $("#loading").fadeIn(500);
        $("#closeb").hide();
        setTimeout( function() {
            $("#loading").hide();
            $("#withmenu").fadeIn(500);
        }, 500 );
    };
    document.getElementById("maintransf").onclick = function() {
        $("#main").hide();
        $(".containerplyinfo").hide();
        $("#loading").fadeIn(500);
        $("#closeb").hide();
        setTimeout( function() {
            $("#loading").hide();
            $("#transfermenu").fadeIn(500);
        }, 500 );
    };
    /* ------------------------------------------------------- */
    document.getElementById("returntomain").onclick = function() {
        $("#depositmenu").hide();
        $("#withmenu").hide();
        $("#transfermenu").hide();
        $("#loading").fadeIn(500);
        setTimeout( function() {
            $(".containerplyinfo").fadeIn(1500);
            $("#closeb").show();
            $("#loading").hide();
            $("#main").fadeIn(500);
        }, 500 );
    };
    document.getElementById("returntomain2").onclick = function() {
        $("#depositmenu").hide();
        $("#withmenu").hide();
        $("#transfermenu").hide();
        $("#loading").fadeIn(500);
        setTimeout( function() {
            $(".containerplyinfo").fadeIn(1500);
            $("#closeb").show();
            $("#loading").hide();
            $("#main").fadeIn(500);
        }, 500 );
    };
       document.getElementById("returntomain3").onclick = function() {
        $("#depositmenu").hide();
        $("#withmenu").hide();
        $("#transfermenu").hide();
        $("#loading").fadeIn(500);
        setTimeout( function() {
            $(".containerplyinfo").fadeIn(1500);
            $("#closeb").show();
            $("#loading").hide();
            $("#main").fadeIn(500);
        }, 500 );
    };
    /* ------------------------------------------------------- */
    document.getElementById("deposit").onclick = function() {
        let valor = $("#amountcash").val();
        if (valor == "0" || valor == "" || valor == null) {
            var msg = "Por favor, insira um <b>valor</b> válido!";
            var typ = "erro";
            mta.triggerEvent("msgbank",msg,typ);
        } else {
            $("#depositmenu").hide();
            $("#loading").fadeIn(500);
            mta.triggerEvent("depositbank",valor);
            setTimeout( function() {
                $("#amountcash").val(null);
                $("#loading").hide();
                $(".containerplyinfo").fadeIn(1500);
                $("#main").fadeIn(500);
                $("#closeb").show();
            }, 500 );
        }
    };
    document.getElementById("withdraw").onclick = function() {
        let valor = $("#amountcash2").val();
        if (valor == "0" || valor == "" || valor == null) {
            var msg = "Por favor, insira um <b>valor</b> válido!";
            var typ = "erro";
            mta.triggerEvent("msgbank",msg,typ);
        } else {
            $("#withmenu").hide();
            $("#loading").fadeIn(500);
            mta.triggerEvent("withdrawbank",valor);
            setTimeout( function() {
                $("#amountcash2").val(null);
                $("#loading").hide();
                $(".containerplyinfo").fadeIn(1500);
                $("#main").fadeIn(500);
                $("#closeb").show();
            }, 500 );
        }
    };
    document.getElementById("transfer").onclick = function() {
        let valor = $("#amountcash3").val();
        let plyid = $("#amountcash4").val();
        if (valor == "0" || valor == "" || valor == null) {
            var msg = "Por favor, insira um <b>valor</b> válido!";
            var typ = "erro";
            mta.triggerEvent("msgbank",msg,typ);
        } else if (plyid == "0" || plyid == "" || plyid == null) {
            var msg = "Por favor, insira uma <b>conta</b> válida!";
            var typ = "erro";
            mta.triggerEvent("msgbank",msg,typ);
        } else {
            $("#transfermenu").hide();
            $("#loading").fadeIn(500);
            mta.triggerEvent("transferbank",valor,plyid);
            setTimeout( function() {
                $("#amountcash3").val(null);
                $("#amountcash4").val(null);
                $("#loading").hide();
                $(".containerplyinfo").fadeIn(1500);
                $("#main").fadeIn(500);
                $("#closeb").show();
            }, 500 );
        }
    };
    /* ------------------------------------------------------- */
}

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function message(typ,txt){
    $("#notifications").empty()
    var html = "<div id='"+typ+"'>"+txt+"</div>"
    $("#notifications").html(html).show().delay(5000).fadeOut();
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