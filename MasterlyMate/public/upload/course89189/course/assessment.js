// TO DO: kill everything function unique to types
// TO DO: Check send answers
// TO DO: load responses for drag and drop activities
// TO DO: redo option backgrounds, include correct/incorrect for drag and drop
// TO DO: randomize option order for multiple choice
// TO DO: select audio w/ image - check audio playback is correct
// TO DO: single background image for play buttons for older IE
// TO DO: media select to use initImage

var totalRight 		= 0;
var audioCount 		= 0;
var optCount 		= 0;
var aType			= new String();
var optRandCount	= new Object();
var arrOptions 		= new Array();
var selAnswers		= new Array();
var rightAnswers	= new Array();
var feedBack 		= new Array();
var feedBackAudio	= new Array();
var marked			= new Boolean();
var attempted		= false;

function randNum(iMax, iMin)
{
	if(!iMin) { iMin = 0 };
	
	this.randArray = new Array();
	
	for (i = 0; i<=(iMax - iMin); i++)
	{
		this.randArray[i] = i + iMin;
	}
	
	this.getNum = function (rand)
	{
		//alert('rand=' + rand);
		var j	= Math.floor(Math.random() * (this.randArray.length - 1));	
		
		if (rand)	{ var num = this.randArray.splice(j, 1); }
		else		{ var num = this.randArray[j] };
		//alert('this.randArrary=' + this.randArray);
		//alert('num=' + num);
		
		return num;
	};
	
	//alert('this.randArrary=' + this.randArray);
};

	
// set the src and alt of an image
function initImage(imgLoc, imgSrc, imgAlt)
{
	//alert("imgLoc=" + imgLoc);
	var imgWidth	= $(imgLoc).attr("width");
	var imgHeight	= $(imgLoc).attr("height");	
	
	$(imgLoc).removeAttr("width");
	$(imgLoc).removeAttr("height");
	
	$(imgLoc).attr("src", imgSrc);
	$(imgLoc).attr("alt", imgAlt);	
	
	$(imgLoc).attr("width", imgWidth);
	if ( $(imgLoc).height() > imgHeight ) 
	{ 
		$(imgLoc).removeAttr("width");
		$(imgLoc).attr("height", imgHeight); 
	};
	//alert("$(imgLoc).height()=" + $(imgLoc).height());	
};

// append a jPlayer div into the destination and set its source
function initAudio(audioName, audioSrc, playLoc, audioAlt)
{
	$("#audio").append('<div id="audio_' + audioName + '" class="jplayer"></div>');	
	//alert("audioSrc=" + audioSrc);	
	
	$("#audio_" + audioName).jPlayer({
		/*errorAlerts: true,*/
		ready: function () {
			//alert("audioSrc=" + audioSrc);
			$(this).jPlayer("setMedia", {
				mp3: audioSrc
			});
		},
		swfPath: "jplayer",
		supplied: "mp3",
		cssSelectorAncestor: "#audio"
	});
	
	// if a location was specified add a play/pause button
	if (playLoc)
	{
			var audioID = "#audio_" + audioName;
			$(playLoc).find('a').attr('href', audioID);
			
			$(playLoc).click(function(event) {
				event.preventDefault();
				
				if ($(this).hasClass('play'))
				{
					var audioID = $(this).find('a').attr('href');
					//alert("$(audioID).html()=" + $(audioID).html());	
					$(audioID).jPlayer("play");
				}
				else
				{
					$('#audio .jplayer').jPlayer("stop");
				}
				
				$(this).toggleClass('play pause');
			});
			
			if (audioAlt)
			{
				$(playLoc).parent().append('<span class="text audio"> ' + audioAlt + '</span>');
			};
	}
};
	
//-- show answers function --\\
function showAnswers()
{
	//alert('Show the correct answers disable the other answers');
	
	for (var j = 0; j<optCount; j++) 
	{
		tOption = arrOptions[j];

		if (tOption.isCorrect == true)
		{
			$('.option').eq(j).children('a').removeClass().addClass('correct');
		}
		else
		{
			$('.option').eq(j).children('a').removeClass().addClass('disabled');
		}
	}	
};

// get the info out of the xml file
function initAssessment(xmlFile, themeDir)
{	
	//alert("xmlFile=" + xmlFile);
	aType	= $('#assessment').attr("class").split(' ')[0];
	//alert("aType=" + aType);
	
	// set up the instructions/feedback panel
	$('#panel').css('display', 'none');
	$('#panel .feedback').css('display', 'none');
	$('#panel').click(function(event) {
		event.preventDefault();
		$('#audio .jplayer').jPlayer("stop");
		$(this).css('display', 'none');
		if (intIncorrectGoToScreenID>0 && rightWrongStatus=="incorrect")
			UDUTU_API.goScreen(intIncorrectGoToScreenID);
		if (intCorrectGoToScreenID>0 && rightWrongStatus=="correct")
			UDUTU_API.goScreen(intCorrectGoToScreenID);
		if (intPartialGoToScreenID>0 && rightWrongStatus=="partial")
			UDUTU_API.goScreen(intPartialGoToScreenID);

	});
	function initPanel(sName, hmtlTxt, audioSrc)
	{
		//alert("hmtlTxt=" + hmtlTxt);		
		$('#' + sName).html(hmtlTxt);	
		//alert("audioSrc=" + audioSrc);
		if ( audioSrc )
		{
			//alert("audioSrc=" + audioSrc);
			initAudio(sName, audioSrc)
						
			//$('#' + sName).append('<div id="jquery_jplayer_1" class="jp-jplayer"></div>');
		};
	};
	function showPanel(sName)
	{
		//alert("hmtlTxt=" + hmtlTxt);		
		$('#panel .feedback').css('display', 'none');
		$('#panel #instructions').css('display', 'none');
		$('#panel #' + sName).css('display', 'block');
		$('#panel').css('display', 'block');
		$('#audio .jplayer').jPlayer("stop");
		$('#audio_' + sName).jPlayer("play");		
		//$('#panel #' + sName + ' .jplayer').css('background-color', 'red');
	};
	
	// kill button function, remove current click function and replace with empty click
	function killButton(button)
	{
		//alert("$(button).text()=" + $(button).text());
		$(button).unbind('click');
		$(button).click(function(event) {
			event.preventDefault();
		});
	};
	
	// get that sweet, sweet xml
	$.ajax({
        type: "GET",
		url: xmlFile,
		dataType: "xml",
		success: function(xml) {
			// load attributes from root node
			marked						= $(xml).find('content').attr('marked');	// is the assessment marked		
			if (marked == 'true' ) { 	$('#showBtn').css('display', 'none') };	// if marked no show me button
			if ( $(xml).find('content').attr('checkText') ) { 			$('#checkBtn a').text( $(xml).find('content').attr('checkText') ) };		// load button text
			if ( $(xml).find('content').attr('instructionsText') ) { 	$('#instructBtn a').text( $(xml).find('content').attr('instructionsText') ) };
			if ( $(xml).find('content').attr('closeText') ) { 			$('.panel .button a').text( $(xml).find('content').attr('closeText') ) };
			if ( $(xml).find('content').attr('showText') && $(xml).find('content').attr('showText') != 'none') { 			$('#showBtn a').text( $(xml).find('content').attr('showText') ) };
			if ($(xml).find('content').attr('showText') == 'none') { 		$('#showBtn').css('display', 'none') };
			
			// set up instructions, if none hide the button else show the instructions
			var instructTxt				= $(xml).find('instructions').text() + '';
			var regExp = /\s+/g;
			
			if(!instructTxt || instructTxt.replace(regExp,'') == '' )
			{
				$('#instructions').css('display', 'none'); 
			}
			else
			{
				initPanel('instructions', instructTxt); 
				
				$('#panel').css('display', 'block');
				$('#instructBtn').click(function() {
					showPanel('instructions');
				});
			};
			
			// collect all the feedback content 
			feedBack['correct'] 		= jQuery.trim($(xml).find('correct').text());
			feedBackAudio['correct'] 	= $(xml).find('correct').attr('audio');
			feedBack['incorrect'] 		= jQuery.trim($(xml).find('incorrect').text());
			feedBackAudio['incorrect']	= $(xml).find('incorrect').attr('audio');
			feedBack['partial'] 		= jQuery.trim($(xml).find('partial').text());
			feedBackAudio['partial'] 	= $(xml).find('partial').attr('audio');
			feedBack['show_me'] 		= jQuery.trim($(xml).find('show_me').text());
			feedBackAudio['show_me'] 	= $(xml).find('show_me').attr('audio');
			// load the feedback into the panel			
			for (x in feedBack)
			{
				initPanel(x, feedBack[x], feedBackAudio[x]);
			};
			
			// set question if it exists
			var questTxt				= $(xml).find('question').text();
			if (questTxt)
			{
				$('#divQuestionText').html(questTxt);
			};
			
			// grab the necessary image
			var imgSrc					= $(xml).find('media visual[type="image"]').attr('file');
			if (imgSrc)
			{
				initImage('#media1 img', imgSrc, $(xml).find('media visual').attr('alt'));
			};
			// grab the necessary audio
			var audioSrc				= $(xml).find('media visual[type="audio"]').attr('file');
			if (audioSrc)
			{
				initAudio(audioCount, audioSrc, $('.audioControl .play'), $(xml).find('media visual[type="audio"]').attr('alt'));
				
				audioCount++;
			};
			
			// load up all the options, hide the unnecessary ones
 			optCount 			= $(xml).find('option').length;	
			optRandCount		= new randNum(optCount);
			//alert("optCount=" + optCount);		
			$(xml).find('option').each(function(index) {
				//alert("this=" + $(this).text());
				
				if(aType === 'areaselect')
				{
					arrTargets[index] = new initTarget(index, this);
				}
				else if (aType === 'dragnsort')
				{
					var optRand			= optRandCount.getNum(true);
					arrOptions[optRand] = new initOption(optRand, index, this);
				}
				else
				{
					arrOptions[index] = new initOption(index, this, $('.option').eq(index));
				}
			});
			//alert('arrOptions[0].txtOption=' + arrOptions[0].txtOption);
			$('.option').slice(optCount).remove(); // hide unnecessary options
			if(aType === 'areaselect')
			{
				initAreaSelect();
			}			
		}
	});
	
	// check answers	
	$('#checkBtn').click(function(event)
	{
		event.preventDefault();		
		
		if (attempted)
		{			
			checkAnswers();
		}
	});
	function checkAnswers(sendResponses)
	{
		rightWrongStatus = "";
		selAnswers = new Array();
		var tOption;
		var tRight = 0;
		var tWrong = 0;
	
		//-- tally up all of the right and wrong answers --\\
		for (j in arrOptions) {
			tOption = arrOptions[j];
			//alert("tOption.isCorrect=" + tOption.isCorrect);
			if (tOption.checked) {
				if (!tOption.isCorrect)			{ tWrong++; } 
				else if (tOption.isCorrect) 	{ tRight++; }
				
				selAnswers[selAnswers.length] = j;				
			}
		}
		//alert("tRight=" + tRight + "\r totalRight=" + totalRight + "\r tWrong=" + tWrong);
	
		//-- figure out right, wrong or partial --\\
		if (tRight == totalRight && tWrong == 0) // right: all correct selected and no incorrect
		{
			rightWrongStatus = "correct";
			
			for (var j = 0; j<optCount; j++) {
				tOption = arrOptions[j];
				
				//alert("tOption.checked=" + tOption.checked);
				if (tOption.isCorrect)
				{ 
					$('.option').eq(j).children('a').toggleClass('selected correct');
				}
				else
				{
					$('.option').eq(j).children('a').toggleClass('active disabled');
				}
			}
				
			$('.option a').each(function() {
				killButton(this);
			});
			$('.button').not('#panel .button').each(function() {
				$(this).addClass('disabled');
				killButton(this);
			});
			killButton($('div#questionOptions')); //just for area select
		} 
		else if (tRight == 0) // wrong: no correct
		{
			rightWrongStatus = "incorrect";
			
			for (var j = 0; j<optCount; j++) {
				tOption = arrOptions[j];
				
				if (marked == "true") 
				{
					//-- one chance to get it right --\\					
					if (!tOption.checked)
					{ 
						$('.option').eq(j).children('a').toggleClass('active disabled');
					}
					else
					{
						$('.option').eq(j).children('a').toggleClass('selected incorrect');
					}
					
					killButton($('.option').eq(j).children('a'));
					$('.button').not('#panel .button').each(function() {
						$(this).addClass('disabled');
						killButton(this);
					});
					killButton($('div#questionOptions')); //just for area select
				} 
				else if (marked == "false" && tOption.checked) 
				{
					$('.option').eq(j).children('a').toggleClass('selected incorrect');
					tOption.checked = false;
					
					killButton($('.option').eq(j).children('a'));
				}
			}
		}
		else 
		{
			rightWrongStatus = "partial";
			if (marked == "true")
			{
				//-- one chance to get it right --\\
				$('.option a.active').toggleClass('active disabled');
				$('.option a').css('cursor', 'default');
				
				$('.option a').each(function() {
					killButton(this);
				});
				$('.button').not('#panel .button').each(function() {
					$(this).addClass('disabled');
					killButton(this);
				});
				
				killButton($('div#questionOptions')); //just for area select
			}
		}
		
		//-- play sound and show feedback if it exists --\\ 
		//alert('feedBack[rightWrongStatus]=' + feedBack[rightWrongStatus]);
		if (feedBack[rightWrongStatus]) 
		{
			showPanel(rightWrongStatus);
		}
		
		//-- how to deal with the buttons --\\
		if (marked == "false" && (tRight<totalRight || tWrong>0)) 
		{
			showMe = true;
			
			$('#showBtn').toggleClass('disabled');
		}
		if (marked == "true" || rightWrongStatus == "correct") 
		{
			
			$('.option a').each(function() {
				killButton(this);
			});
			$('.button').not('#panel .button').each(function() {
				$(this).addClass('disabled');
				killButton(this);
			});
			
			killButton($('div#questionOptions')); //just for area select				
	
		}
		//-- send the course back whether the user was correct, incorrect, or partial, the right answers, and what the user selected --\\           
		if (sendResponses == true) {
			sendAnswers();
		}
		if (rightWrongStatus != null && feedBack[rightWrongStatus] == null) {
			proceed();
		}
	};
	
	
	$('#showBtn').click(function(event)
	{
		event.preventDefault();
		
		//alert('show answers');
		if (!$(this).hasClass('disabled'))
		{
			showAnswers();	
	
			if (feedBack['show_me']) 
			{
				showPanel('show_me');
			}
			
			killButton($('div#questionOptions'));			
			$('.option a').each(function() {
				killButton(this);
			});
			$('.button').not('#panel .button').each(function() {
				$(this).addClass('disabled');
				killButton(this);
			});
		}
	});
};

