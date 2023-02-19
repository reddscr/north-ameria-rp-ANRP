function requests(id,txt,time){
    var html = `<div id=${id}><span>${txt}</span><div class='yes'><span class='y'>Y</span> <span class='u'>U</span></div><div id='progressBar${id}'><div></div></div>`
    $(html).appendTo("#request_manager").hide().fadeIn(500).delay(time).fadeOut(500);
    $(`#progressBar${id}`).css(`background-color`,`rgba(15,15,15,255)`)
    $(`#progressBar${id}`).css(`width`,`100%`)
    $(`#progressBar${id}`).css(`height`,`10px`)
    $(`#progressBar${id}`).css(`border-top-left-radius`,`0px`)
    $(`#progressBar${id}`).css(`border-top-right-radius`,`0px`)
    $(`#progressBar${id}`).css(`border-bottom-right-radius`,`10px`)
    $(`#progressBar${id} div`).css(`height`,`100%`) 
    $(`#progressBar${id} div`).css(`text-align`,`center`) 
    $(`#progressBar${id} div`).css(`line-height`,`10px`) 
    $(`#progressBar${id} div`).css(`width`,`0px`) 
    $(`#progressBar${id} div`).css(`background-color`,`#7a63e0`)
    $(`#progressBar${id} div`).css(`color`,`#fff`)
    $(`#progressBar${id} div`).css(`font-size`,`9px`)
    $(`#progressBar${id} div`).css(`border-top-left-radius`,`0px`)
    $(`#progressBar${id} div`).css(`border-top-right-radius`,`0px`)
    progress(time/1000, time/1000, $(`#progressBar${id}`));
    function progress(timeleft, timetotal, $element) {
        var progressBarWidth = timeleft * $element.width() / timetotal;
        $element.find('div').animate({ width: progressBarWidth }, 500).html(timeleft);
        if(timeleft > 0) {
            setTimeout(function() {
                progress(timeleft - 1, timetotal, $element);
            }, 1000);
        }
    };    
}

function removerequest(id){
    $(`#${id}`).remove()
}