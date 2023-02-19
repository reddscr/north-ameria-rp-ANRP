function message(typ,txt,time){
    var html = "<div id='"+typ+"'>"+txt+"</div>"
    $(html).appendTo("#notifications").hide().fadeIn(1000).delay(time).fadeOut(1000);
}

$('*').click(function(e) {  
    mta.triggerEvent('closefocus_infobox')
});

