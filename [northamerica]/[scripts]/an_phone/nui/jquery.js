
$(document).on("click","#calllist",function(){
    $('#mainphone').hide();
    $('#mainphonecontactsmenu').show();
    $('#mainphonemsgmenu').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#main').css('background-color','gainsboro')
    $('#main').css('background-image','none')
    mta.triggerEvent("requestNAcontacts")
});

$(document).on("click","#addnewmessage",function(){
    $('#mainphone').hide();
    $('#mainphonecontactsmenu').show();
    $('#mainphonemsgmenu').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#main').css('background-color','gainsboro')
    $('#main').css('background-image','none')
    mta.triggerEvent("requestNAcontacts")
});
$(document).on("click","#returnbuttom",function(){
    $('#main').css('background-image','url("images/anbg.png")')
    $('#mainphonecontactsmenu').hide();
    $('#mainphonecontacts').hide();
    $('#mainphonemsgmenu').hide();
    $('#mainphone').show();
});

$(document).on("click","#msglist",function(){
    $('#mainphone').hide();
    $('#mainphonemsgmenu').show();
    $('#mainphonecontacts').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#main').css('background-color','gainsboro')
    $('#main').css('background-image','none')
    mta.triggerEvent("requestNAcontactsmsg")
});


function showPhoneContacts(numb,name){
    $("#mainphonecontacts").append(`
		<div class="model">
            <div class="name">${name}
                <br>
				<nl>Número: ${numb}</nl>
            </div>
            <div id="trashnumber" class="trash" data-numb-key="${numb}" data-name-key="${name}"><img class="trashIcon" src="images/excluir.svg"></img></div>
            <div id="msgtonumber" class="msg" data-numb-key="${numb}"><img class="msgIcon" src="images/msg.svg"></img></div>
		</div>
    `);
}

function showPhoneContactsmsg(numb,name){
    $("#mainphonecontacts").append(`
		<div class="model">
            <div class="name">${name}
                <br>
				<nl>Número: ${numb}</nl>
            </div>
            <div id="msgtonumber" class="msg" data-numb-key="${numb}"><img class="msgIcon" src="images/msg.svg"></img></div>
		</div>
    `);
}

$(document).on("click","#msgtonumber",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#msgtonumber').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#msgtonumber.active');
    if($buy){
        $('#mainphonemsgmenu').hide();
        $('#mainphonecontactsmenu').hide();
        $('#mainphonecontacts').empty();
        $('#returnmesagemenu').show();
        $("#mainphonecontacts").append(`
            <div id="messageplate">
            </div>
            <div id="messageplate2">
                <br><br><textarea id="sendmessagetext" name="textarea"
                rows="5" cols="30" style="height:20px; width: 120px;"
                minlength="10" placeholder="Mensagem" maxlength="200"></textarea>
                <div id="sendtommessage" datanumb="${$buy.attr('data-numb-key')}" ><img id="sendtommessageIcon" style='filter: invert(30%);' src="images/send.svg"></img></div>
            </div>
        `);
        mta.triggerEvent("requestphonemessages",$buy.attr('data-numb-key'))
    }
});    

$(document).on("click","#sendtommessage",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#sendtommessage').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#sendtommessage.active');
    if($buy){
        var msg = $("#sendmessagetext").val();
        if (!msg == "" || !msg == null) {
            $('#sendmessagetext').val('');
            mta.triggerEvent("requestsendmessage",$buy.attr('datanumb'),msg)
        }
    }
});

$(document).on("click","#returnbuttommessage",function(){
    $('#mainphone').hide();
    $('#mainphonemsgmenu').show();
    $('#mainphonecontacts').hide();
    $('#returnmesagemenu').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#main').css('background-color','gainsboro')
    $('#main').css('background-image','none')
    mta.triggerEvent("requestNAcontactsmsg")
});

function cleanmessageplate(){
    $('#messageplate').empty();
}

function loadphonemessage(id, datanumb, dataname, datamsg, datacolor){
    $("#messageplate").append(`
        <div class="modelmsg" style="background:${datacolor}; padding: 7px 10px 7px 10px;">
            <div class="name" style="width: 135px;">${dataname}:<div id="trashmessage" class="trashmsg" data-numb-id="${id}" data-numb-numb="${datanumb}"><img class="trashIcon" src="images/excluir.svg"></img></div>
            </div><br>
            <nl>${datamsg}</nl>
        </div>
    `);
    var scrollContainer = document.getElementById("messageplate");
    var observer = new MutationObserver(function(mutations) {
        var newNodesHeight = mutations.reduce(function(sum, mutation) {
            return sum + [].slice.call(mutation.addedNodes)
                .map(function (node) { return node.scrollHeight || 0; })
                .reduce(function(sum, height) {return sum + height});
          }, 0);
        if (scrollContainer.clientHeight + scrollContainer.scrollTop + newNodesHeight + 10 >= scrollContainer.scrollHeight) {
            scrollContainer.scrollTop = scrollContainer.scrollHeight;
          }
    });
    observer.observe(scrollContainer, {childList: true});
}

$(document).on("click","#trashmessage",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#trashmessage').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#trashmessage.active');
    if($buy){
        mta.triggerEvent("requestmessagedelet",$buy.attr('data-numb-id'),$buy.attr('data-numb-numb'))
    }
});

$(document).on("click","#calltonumber",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#calltonumber').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#calltonumber.active');
    if($buy){
        mta.triggerEvent("startcalling",$buy.attr('data-name-key'),$buy.attr('data-numb-key'))
        startcall($buy.attr('data-name-key'))
    }
}); 

$(document).on("click","#trashnumber",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#trashnumber').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#trashnumber.active');
    if($buy){
        $('#mainphonecontactsmenu').hide();
        $('#mainphonecontacts').empty();
        $("#mainphonecontacts").append(`
            <div class="confirm-modal">
                <form action="#do-something" method="get">
                    Você que apagar o contato: <br><br>${$buy.attr('data-name-key')} ?
                    <div id="confirmremovcontact" data-numb-key="${$buy.attr('data-numb-key')}" class="btn">Confirmar</div>
                    <div id="cancelremovecontact" class="btn2">Cancelar</div>
                </form>
            </div>
        `);
    }
});

$(document).on("click","#confirmremovcontact",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#confirmremovcontact').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#confirmremovcontact.active');
    if($buy){
        $('#mainphone').hide();
        $('#mainphonecontactsmenu').show();
        $('#mainphonecontacts').empty();
        $('#mainphonecontacts').show();
        $('#main').css('background-color','gainsboro')
        mta.triggerEvent("requestRemovenumber",$buy.attr('data-numb-key'))
    }
});     

$(document).on("click","#cancelremovecontact",function(){
    $('#mainphone').hide();
    $('#mainphonecontacts').hide();
    $('#mainphonecontactsmenu').show();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#main').css('background-color','gainsboro')
    mta.triggerEvent("requestNAcontacts")
});

$(document).on("click","#addcontactbuttom",function(){
    $('#mainphonecontactsmenu').hide();
    $('#mainphonecontacts').empty();
    $("#mainphonecontacts").append(`
        <div class="confirm-modal">
            <form action="#do-something" method="get">
                Informações do contato.
                <input id="contactname" placeholder="Nome" maxlength="20">
                <input id="contactnumber" placeholder="Número" oninput="this.value = this.value.replace(/[^0-9-]/g, '')" maxlength="9">
                <div id="confirmaddcontact" class="btn">Adicionar</div>
                <div id="canceladdcontact" class="btn2">Cancelar</div>
            </form>
        </div>
    `);
});

$(document).on("click","#canceladdcontact",function(){
    returntomainphone()
});

$(document).on("click","#confirmaddcontact",function(){
    let contactname = $("#contactname").val();
    let contactnumber = $("#contactnumber").val();
    if (contactname == "" || contactname == null){
        mta.triggerEvent("sendphonemessageerror",'Adicione um nome no contato!','erro')
    }else if (contactnumber == "" || contactnumber == null){
        mta.triggerEvent("sendphonemessageerror",'Adicione um número no contato!','erro')
    }else{
        $('#mainphone').hide();
        $('#mainphonecontactsmenu').show();
        $('#mainphonecontacts').empty();
        $('#mainphonecontacts').show();
        $('#main').css('background-color','gainsboro')
        mta.triggerEvent("requestNAcontactsandAddcontact",contactname,contactnumber)
    }
});

function startcall(data){
    $('#mainphone').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#mainphonecontactsmenu').hide();
    $('#main').css('background-color','gainsboro')
    $('#main').css('background-image','none')
    $("#mainphonecontacts").append(`
        <div class="confirm-modal" style="font-size:12px">
            <form action="#do-something" method="get">
                Chamando...<br><br>${data}
                <br>
                <div id="turnoffcall"><img id="turnoffcallIcon" style='filter: invert(30%);' src="images/fim.svg"></img></div>
            </form>
        </div>
    `);
}

function incall(data){
    $('#mainphone').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#mainphonecontactsmenu').hide();
    $('#main').css('background-color','gainsboro')
    $("#mainphonecontacts").append(`
        <div class="confirm-modal" style="font-size:12px">
            <form action="#do-something" method="get">
                Em chamada com<br><br>${data}
                <br>
                <div id="turnoffcall"><img id="turnoffcallIcon" style='filter: invert(30%);' src="images/fim.svg"></img></div>
            </form>
        </div>
    `);
}

function requestaceptcall(data,data2){
    $('#mainphone').hide();
    $('#mainphonecontacts').empty();
    $('#mainphonecontacts').show();
    $('#mainphonecontactsmenu').hide();
    $('#main').css('background-color','gainsboro')
    $("#mainphonecontacts").append(`
        <div class="confirm-modal" style="font-size:12px">
            <form action="#do-something" method="get">
                <br><br>${data}
                <br>
                <div id="turnoncall" data-name-key="${data}" data-numb-key="${data2}"><img id="turnoncallIcon" style='filter: invert(30%);' src="images/init.svg"></img></div>
                <div id="turnoffcall"><img id="turnoffcallIcon" style='filter: invert(30%);' src="images/fim.svg"></img></div>
            </form>
        </div>
    `);
}

$(document).on("click","#turnoncall",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('#turnoncall').removeClass('active');
    if(!isActive) $el.addClass('active');
    let $buy = $('#turnoncall.active');
    if($buy){
        incall($buy.attr('data-name-key'))
        mta.triggerEvent("phonecallacept", $buy.attr('data-name-key'), $buy.attr('data-numb-key'))
    }
});

$(document).on("click","#turnoffcall",function(){
    $('#main').css('background-image','url("images/anbg.png")')
    $('#mainphonecontactsmenu').hide();
    $('#mainphonecontacts').hide();
    $('#mainphone').show();
    mta.triggerEvent("finishingcalling")
});

function retorephonecall(){
    $('#main').css('background-image','url("images/anbg.png")')
    $('#mainphonecontactsmenu').hide();
    $('#mainphonecontacts').hide();
    $('#mainphone').show();
}
/* --------------------------------------------------------------------------------------------- */
function returntomainphone(){
    $('#main').css('background-image','url("images/anbg.png")')
    $('#mainphonecontactsmenu').hide();
    $('#mainphonecontacts').hide();
    $('#mainphonemsgmenu').hide();
    $('#mainphone').show();
}

/* --------------------------------------------------------------------------------------------- */