$(document).ready(function () {
	mta.triggerEvent("loadedAccount");
});

function sendcharacterNuiInfos(datan,datasn,datam,databm,databf,databs){
	$("#actionmenu").html(`
		<div class="model" style="background-image: linear-gradient(-90deg, rgba(49, 49, 49, 0.28), rgb(49, 49, 49));">
			<div class="name" style="text-align: center; color: rgb(105, 105, 105);">North America RP™</div>
		</div>
        <div class="maincharacterinfo">
            <div class="model">
                <div class="name">Nome: <nl>${datan} ${datasn}</nl></div>
            </div>
            <div class="model">
                <div class="name">Dinheiro: <nl>$ ${formatarNumero(datam)}</nl></div>
            </div>
            <div class="model">
                <div class="name">Banco: <nl>$ ${formatarNumero(databm)}</nl></div>
            </div>
            <div class="model">
                <div class="name">Fome: <nl>${databf}%</nl></div>
            </div>
            <div class="model">
                <div class="name">Sede: <nl>${databs}%</nl></div>
            </div>
            <div class="namefunc" style="width: 75px;">PLAY
                <div class="playIcon" id="Playload"><img class="img" style='filter: invert(30%);' src="images/play.svg"></img></div>
            </div>
            <div class="namefunc">EXCLUIR
                <div class="exclIcon" id="Deletecharacter"><img class="img" style='filter: invert(30%);' src="images/excluir.svg"></img></div>
            </div>
        </div>
	`);
}

$(document).on("click","#Playload",function(){
	mta.triggerEvent("Playloadcharacter")
});

$(document).on("click","#Deletecharacter",function(){
	$("#actionmenu").html(`
		<div class="model" style="background-image: linear-gradient(-90deg, rgba(49, 49, 49, 0.28), rgb(49, 49, 49));">
			<div class="name" style="text-align: center; color: rgb(105, 105, 105);">North America RP™</div>
		</div>
		<div class="confirm-modal">
			<form action="#do-something" method="get">
				Você quer apagar este personagem?
				<div id="confirmdeletecharacter" class="btn">Confirmar</div>
				<div id="canceldeletecharacter" class="btn2">Cancelar</div>
			</form>
		</div>
	`);
});


$(document).on("click","#confirmdeletecharacter",function(){
	mta.triggerEvent("deleteplayerAccount")
});

$(document).on("click","#canceldeletecharacter",function(){
	mta.triggerEvent("loadedAccount")
});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var user = null;
var password = null;
var charname = null;
var charsname = null;
var charage = null;

function startcharactercreator(){
	$("#actionmenu").html(`
		<div class="model" style="background-image: linear-gradient(-90deg, rgba(49, 49, 49, 0.28), rgb(49, 49, 49));">
			<div class="name" style="text-align: center; color: rgb(105, 105, 105);">Criando a conta</div>
		</div>
		<div class="confirm-modal">
			<form action="#do-something" method="get">
				Crie a sua conta<br>
				<input id="Accountname" placeholder="Usuário" maxlength="20">
				<input id="Accountpass" type="password" placeholder="Senha" maxlength="20">
				<div id="confirmaccount" class="btn">Confirmar</div>
			</form>
		</div>
	`);
}


$(document).on("click","#confirmaccount",function(){
    let username = $("#Accountname").val();
    let userpass = $("#Accountpass").val();
    if (username == "" || username == null){
        mta.triggerEvent("sendaccountmessageerror",'Adicione um usuário!','erro')
    }else if (userpass == "" || userpass == null){
        mta.triggerEvent("sendaccountmessageerror",'Adicione uma senha!','erro')
    }else{
		user = username;
		password = userpass;
		$("#actionmenu").html(`
			<div class="model" style="background-image: linear-gradient(-90deg, rgba(49, 49, 49, 0.28), rgb(49, 49, 49));">
				<div class="name" style="text-align: center; color: rgb(105, 105, 105);">Criando o personagem</div>
			</div>
			<div class="confirm-modal">
				<form action="#do-something" method="get">
					Crie a sua conta<br>
					<input id="charAge" placeholder="Idade" oninput="this.value = this.value.replace(/[^0-9]/g, '')" maxlength="2">
					<input id="charName" placeholder="Nome" maxlength="20">
					<input id="charSName" placeholder="Sobrenome" maxlength="20">
					<div id="confirmCharinf" class="btn">Confirmar</div>
					<div id="returntoaccount" class="btn2">Voltar</div>
				</form>
			</div>
		`);
		
    }
});

$(document).on("click","#returntoaccount",function(){
	$("#actionmenu").html(`
		<div class="model" style="background-image: linear-gradient(-90deg, rgba(49, 49, 49, 0.28), rgb(49, 49, 49));">
			<div class="name" style="text-align: center; color: rgb(105, 105, 105);">Criando a conta</div>
		</div>
		<div class="confirm-modal">
			<form action="#do-something" method="get">
				Crie a sua conta<br>
				<input id="Accountname" placeholder="Usuário" maxlength="20">
				<input id="Accountpass" type="password" placeholder="Senha" maxlength="20">
				<div id="confirmaccount" class="btn">Confirmar</div>
			</form>
		</div>
	`);
});

$(document).on("click","#confirmCharinf",function(){
    let charname = $("#charName").val();
    let charsname = $("#charSName").val();
    let charage = $("#charAge").val();
    if (charname == "" || charname == null){
        mta.triggerEvent("sendaccountmessageerror",'Adicione um nome!','erro')
    }else if (charsname == "" || charsname == null){
        mta.triggerEvent("sendaccountmessageerror",'Adicione um sobrenome!','erro')
    }else if (charage == "0" || charage == "" || charage == null || parseInt(charage) < parseInt(20)) {
        mta.triggerEvent("sendaccountmessageerror",'Adicione uma idade válida!','erro')
    }else{
		charname = charname;
		charsname = charsname;
		charage = charage;
		$("#actionmenu").html(`
			<div class="model" style="background-image: linear-gradient(-90deg, rgba(49, 49, 49, 0.28), rgb(49, 49, 49));">
				<div class="name" style="text-align: center; color: rgb(105, 105, 105);">Selecione uma skin</div>
			</div>
			<div class="skinselection"></div>
		`)
		mta.triggerEvent("createaccountandSelectSkin", user, password, charname, charsname, charage)
    }
});


function loadallSkins(datanum, dataid){
	$(".skinselection").append(`
		<div class="skinmodel">
			<div class="skinname">${datanum}
				<div class="select" data-id-key="${dataid}""><img class="selectIcon" style='filter: invert(50%);' src="images/comprar.svg"></img></div>
				<div class="view" data-id-key="${dataid}""><img class="viewIcon" style='filter: invert(50%);' src="images/olho.svg"></img></div>
			</div>
		</div>
	`);
}

$(document).on("click",".select",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.select').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $buy = $('.select.active');
	if($buy){
		mta.triggerEvent("Account_confirmskinandaccount",$buy.attr('data-id-key'))
	}
});

$(document).on("click",".view",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.view').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $buy = $('.view.active');
	if($buy){
		mta.triggerEvent("Account_previewskin",$buy.attr('data-id-key'))
	}
});



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