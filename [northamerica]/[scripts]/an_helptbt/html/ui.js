


$(document).ready(function() {
    open();

  document.onkeyup = function(data) {
    if (data.which == 120) {
        mta.triggerEvent("closehelp")
        close();
    }
  };
});


function open() {
    $("#actionmenu").fadeIn();
}

function close() {
    $("#actionmenu").fadeOut();
}

