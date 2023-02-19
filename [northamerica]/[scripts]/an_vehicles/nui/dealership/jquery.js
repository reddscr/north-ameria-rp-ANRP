
var selected = null;

$(document).ready(function(){
	let actionContainer = $("#actionmenu");
	let actionButton = $("#actionbutton");
	actionButton.fadeIn(500);
	actionContainer.fadeIn(500);
	requestcars()
});

const loadMenu = (name) => {
	return new Promise((resolve) => {
		$("#inicio").load(name+".html",function(){
			resolve();
		});
	});
}

function loadcars( db1, db2, db3, db4, db5, db6 ){
	$("#inicio").append(`
		<div class="model">
			<div class="name">${db2}
				<div class="buttom2" id="buy" data-name-key="${db1}"><img class="buttom2Icon" style='filter: invert(50%);' src="images/comprar.svg"></img></div>
				<div class="buttom2" id="view" data-name-key="${db1}"><img class="buttom2Icon" style='filter: invert(50%);' src="images/olho.svg"></img></div>
				<br>
				<nl>Preço: $${formatarNumero(db3)} - Estoque: ${db5} - Porta-malas: ${db4} - Taxa: ${db6}</nl>
			</div>
		</div>
	`);
}

function requestcars(){
	mta.triggerEvent('requestcars')
	$('#inicio').html(``)
}

function requestbikes(){
	mta.triggerEvent('requestbikes')
	$('#inicio').html(``)
}

function requesttruck(){
	mta.triggerEvent('requesttruck')
	$('#inicio').html(``)
}

function requestuserveh(){
	mta.triggerEvent('requestuserveh')
	$('#inicio').html(``)
}

function loaduserveh( db1, db2, db3){
	$("#inicio").append(`
		<div class="model" data-value-key="${formatarNumero(db3)}">
			<div class="name">${db2}
				<div class="buttom2" id="sell" data-name-key="${db1}"><img class="buttom2Icon" style='filter: invert(50%);' src="images/vender.svg"></img></div>
				<br>
				<nl>Valor: $${formatarNumero(db3)}</nl>
			</div>
		</div>
	`);
}

$(document).on("click","#buy",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('#buy').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $buy = $('#buy.active');
	if($buy){
		selected = $buy.attr('data-name-key')
		$('#inicio').html(`
		<div class="confirm-modal">
			<form action="#do-something" method="get">
				Você quer comprar este veículo?
				<div id="confirmdealershipbuy" class="btn">Confirmar</div>
				<div id="canceldealershipbuy" class="btn2">Cancelar</div>
			</form>
		</div>`)
	}
});

$(document).on("click","#confirmdealershipbuy",function(){
	if (selected){
		mta.triggerEvent("buynewvehicleintheshop",selected)
        mta.triggerEvent('requestcars')
        selected = null;
        $('#inicio').html(``)
	}
});

$(document).on("click","#canceldealershipbuy",function(){
	mta.triggerEvent('requestcars')
	selected = null;
	$('#inicio').html(``)
});


$(document).on("click","#view",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('#view').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $view = $('#view.active');
	if($view){
		mta.triggerEvent("showDealershipvehprev",$view.attr('data-name-key'))
	}
});

$(document).on("click","#sell",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('#sell').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $buy = $('#sell.active');
	if($buy){
		selected = $buy.attr('data-name-key')
		$('#inicio').html(`
		<div class="confirm-modal">
			<form action="#do-something" method="get">
				Você quer vender este veículo?
				<div id="confirmdealershipsell" class="btn">Confirmar</div>
				<div id="canceldealershipsell" class="btn2">Cancelar</div>
			</form>
		</div>`)
	}
});

$(document).on("click","#confirmdealershipsell",function(){
	if (selected){
		mta.triggerEvent("sellmyvehfortheshop",selected)
        mta.triggerEvent('requestcars')
        selected = null;
        $('#inicio').html(``)
	}
});

$(document).on("click","#canceldealershipsell",function(){
	mta.triggerEvent('requestcars')
	selected = null;
	$('#inicio').html(``)
});


$(document).on("click","#actionbutton",function(){
	mta.triggerEvent("closenewdealership")
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