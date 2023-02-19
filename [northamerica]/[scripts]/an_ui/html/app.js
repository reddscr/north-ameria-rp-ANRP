
function widthHeightSplit(value, ele) {
    let height = 25.5;
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.css("height", eleHeight + "px");
    ele.css("top", leftOverHeight + "px");
};

function updateuistats(stats,stats2,stats3,stats4,statsfood,statswather,plystats,vehstats,stamina,voice,voiceactiv){
	if (stats4 <= 0 ) {
		if(  $("#varArmor").is(":visible") == true ){  
			$('#varArmor').fadeOut(500);
		};
	}
	else {
		if(  $("#varArmor").is(":visible") == false ){  
			$('#varArmor').fadeIn(500);
		};
	}
	if (voiceactiv == 'true') {
		if (voice <= 5 ) {
			if(  $("#voicer1").is(":visible") == false ){  
				$('#voicer1').fadeIn(100);
			};
			if(  $("#voicer2").is(":visible") == true ){  
				$('#voicer2').fadeOut(100);
			};
			if(  $("#voicer3").is(":visible") == true ){  
				$('#voicer3').fadeOut(100);
			};
			$("#voicer3").css("background-color",`rgba(206, 206, 206, 0.795)`);
			$("#voicer2").css("background-color",`rgba(206, 206, 206, 0.795)`);
			$("#voicer1").css("background-color",`rgba(253, 255, 165, 0.9)`);
		}else if(voice <= 10 ){
			if(  $("#voicer1").is(":visible") == false ){  
				$('#voicer1').fadeIn(100);
			};
			if(  $("#voicer2").is(":visible") == false ){  
				$('#voicer2').fadeIn(100);
			};
			if(  $("#voicer3").is(":visible") == true ){  
				$('#voicer3').fadeOut(100);
			};
			$("#voicer3").css("background-color",`rgba(206, 206, 206, 0.795)`);
			$("#voicer1").css("background-color",`rgba(206, 206, 206, 0.795)`);
			$("#voicer2").css("background-color",`rgba(253, 255, 165, 0.9)`);
		}else if(voice <= 20 ){
			if(  $("#voicer1").is(":visible") == false ){  
				$('#voicer1').fadeIn(100);
			};
			if(  $("#voicer2").is(":visible") == false ){  
				$('#voicer2').fadeIn(100);
			};
			if(  $("#voicer3").is(":visible") == false ){  
				$('#voicer3').fadeIn(100);
			};
			$("#voicer1").css("background-color",`rgba(206, 206, 206, 0.795)`);
			$("#voicer2").css("background-color",`rgba(206, 206, 206, 0.795)`);
			$("#voicer3").css("background-color",`rgba(253, 255, 165, 0.9)`);
		}
	}else if(voiceactiv == 'false' ){
		if (voice <= 5 ) {
			if( $("#voicer1").is(":visible") == false ){  
				$('#voicer1').fadeIn(100);
			};
			if( $("#voicer2").is(":visible") == true ){  
				$('#voicer2').fadeOut(100);
			};
			if( $("#voicer3").is(":visible") == true ){  
				$('#voicer3').fadeOut(100);
			};
			$("#voicer1").css("background-color",`rgba(206, 206, 206, 0.795)`);
		}else if(voice <= 10 ){
			if( $("#voicer1").is(":visible") == false ){  
				$('#voicer1').fadeIn(100);
			};
			if( $("#voicer2").is(":visible") == false ){  
				$('#voicer2').fadeIn(100);
			};
			if( $("#voicer3").is(":visible") == true ){  
				$('#voicer3').fadeOut(100);
			};
			$("#voicer2").css("background-color",`rgba(206, 206, 206, 0.795)`);
		}else if(voice <= 20 ){
			if( $("#voicer1").is(":visible") == false ){  
				$('#voicer1').fadeIn(100);
			};
			if(  $("#voicer2").is(":visible") == false ){  
				$('#voicer2').fadeIn(100);
			};
			if( $("#voicer3").is(":visible") == false ){  
				$('#voicer3').fadeIn(100);
			};
			$("#voicer3").css("background-color",`rgba(206, 206, 206, 0.795)`);
		}
	}
	$("#boxSetHealth").css("width",`${stats3}%`);
	$("#boxSetArmour").css("width",`${stats4}%`);
	widthHeightSplit(statsfood, $("#boxSetHunger"));
	widthHeightSplit(statswather, $("#boxSetThirst"));
	widthHeightSplit(stamina, $("#boxSetStamina"));
	$("#varCityhours").html(`${stats}`).css("font-size","10px");
	$("#stats1").html(`${vehstats}`).css("font-size","10px");
	$("#stats2").html(`${stats2}`).css("font-size","10px");
	$("#setplystats2").empty().append(`
		<div id="backuistatus">
			<div id="mainmenu">
				<button class="menuoption">${plystats}</button>
			</div>
		</div>
	`);
}

function updateplyhud2(typ) {
	if (typ == "show"){
		$("#setplystats2").show();
	}
	else if (typ == "hide"){
		$("#setplystats2").hide();
	}
}