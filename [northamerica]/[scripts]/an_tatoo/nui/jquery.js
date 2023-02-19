$(document).ready(function(){
	let actionContainer = $("#inicio");
	/*let actionButton = $("#actionbutton");
	actionButton.fadeIn(500);*/
	actionContainer.fadeIn(500);
	requestBarbers()
});

function requestBarbers(){
    mta.triggerEvent('requestTatoo')
	$('#inicio').html(``)
}


function closeTatoo(){
    mta.triggerEvent('closeTatoo')
}

function loadTatoo(id,name,price,typ){
    $("#inicio").append(`
		<div class="model">
            <div class="name">${name}
                <div class="buy" data-typ-key="${typ}" data-name-key="${id}"><img class="buyIcon" style='filter: invert(50%);' src="images/comprar.svg"></img></div>
                <div class="view" data-typ-key="${typ}" data-name-key="${id}"><img class="viewIcon" style='filter: invert(50%);' src="images/olho.svg"></img></div>
                <br>
				<nl>Preço: $${formatarNumero(price)}</nl>
			</div>
		</div>
	`);
}

$(document).on("click",".buy",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.buy').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $buy = $('.buy.active');
	if($buy){
		mta.triggerEvent("TatooBuying",$buy.attr('data-name-key'),$buy.attr('data-typ-key'))
	}
});

$(document).on("click",".view",function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.view').removeClass('active');
	if(!isActive) $el.addClass('active');
	let $view = $('.view.active');
	if($view){
		mta.triggerEvent("TatooPreview",$view.attr('data-name-key'),$view.attr('data-typ-key'))
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