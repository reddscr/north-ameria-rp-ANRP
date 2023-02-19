$(document).ready(function(){
	var sorttimer = getRandomInt(7,15)
	var sortmarginbar = getRandomInt(0,210)
	var sortmarginbarwhidit = getRandomInt(10,30)
	barsort = document.getElementById('barsort');
	barmove = document.getElementById('bar'),
	barsort.style.marginLeft = sortmarginbar + "px";
	barsort.style.width = sortmarginbarwhidit + "px";
	var left = 0,
	timerId = 0;
	timerId = setInterval( function() {
		if( left++ > 243 ) {
			clearInterval( timerId );
			mta.triggerEvent("resultbarsort", 'false')
		}
		barmove.style.marginLeft = left + "px";
	}, sorttimer );
	document.onkeyup = function (data) {
    if (data.which == 78) {
			var marg = sortmarginbar+sortmarginbarwhidit
			if (parseInt(left) < parseInt(sortmarginbar)){
				mta.triggerEvent("resultbarsort", 'false')
			} else if(parseInt(left) > parseInt(marg)){
				mta.triggerEvent("resultbarsort", 'false')
			} else {
				mta.triggerEvent("resultbarsort", 'true')
			}
        }
    };
});

function requestonKeypressed(){
	var bar = document.getElementById('bar');
	var bar2 = document.getElementById('barsort');
	var bar2left = getStyle(bar2, 'margin-left');
	var bar2w = getStyle(bar2, 'width');
	var marg = bar2left+bar2w
	var style = getStyle(bar, 'margin-left');
	if (parseInt(style) < parseInt(bar2left)){
		mta.triggerEvent("resultbarsort", 'false')
	} else if(parseInt(style) > parseInt(marg)){
		mta.triggerEvent("resultbarsort", 'false')
	} else {
		mta.triggerEvent("resultbarsort", 'true')
	}
}

function getRandomInt(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min)) + min;
}


var getStyle = function(e, styleName) {
  var styleValue = "";
  if (document.defaultView && document.defaultView.getComputedStyle) {
    styleValue = document.defaultView.getComputedStyle(e, "").getPropertyValue(styleName);
  } else if (e.currentStyle) {
    styleName = styleName.replace(/\-(\w)/g, function(strMatch, p1) {
      return p1.toUpperCase();
    });
    styleValue = e.currentStyle[styleName];
  }
  return parseInt(styleValue);
}