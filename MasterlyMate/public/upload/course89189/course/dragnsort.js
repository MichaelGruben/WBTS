
function startDrag (dragged)
{
	//alert($(dragged).html());
	//alert($(dragged).hasClass('active'));
	$('#questionOptions .option').removeClass('active');
	$(dragged).addClass('active');
}

function stopDrag (dragged)
{
	//alert($(dragged).html());	
	
	$('#questionOptions .option').removeClass('active');
	
	$('.option').each(function() {
		var dragNum			= $(this).attr('id').substring(6);
		var tOption			= arrOptions[dragNum];
		//alert("tOption.optIndex=" + tOption.optIndex);
		var index			= $('.option').index(this);
		
		tOption.isCorrect 	= tOption.optIndex == index;			
		tOption.checked 	= true;	
	});
	
	if (!attempted)
	{
		//alert('first attempt');
		
		$('#checkBtn').removeClass('disabled');
		attempted 			= true;
	}
}

// set up the option object, display the necessary text and image in the option
function initOption(optIndex, trueIndex, xmlOpt)
{	
	/*$('#questionOptions').append('<div id="option' + optIndex + '" class="option"><img src="blank.gif" alt="" height="100" width="200" /><div class="button"><a href="#option' + optIndex + '">option' + optIndex + '</a></div></div>');*/
	
	htmlOpt				= $('#option' + optIndex);
	
	this.txtOption 		= $(xmlOpt).text();
	//alert("this.txtOption=" + this.txtOption);
	this.isCorrect 		= ($(xmlOpt).attr('correct') == '1');
	if (this.isCorrect)
	{
		totalRight++;
		rightAnswers[rightAnswers.length] = optIndex;
	}
	this.checked 		= false;
	this.divOptionText 	= $(htmlOpt).children('a');
	this.divOptionText.innerHTML = this.txtOption;
	this.optIndex		= trueIndex;
	
	var word			= $(xmlOpt).attr('word');
	if (word)
	{
		//alert("word=" + word);
		$(htmlOpt).find('.button a').text( word );
	}
	
	$(htmlOpt).find('img').attr('src', $(xmlOpt).text());
	$(htmlOpt).children('a').addClass('active');
	$(htmlOpt).find('a').click(function(event) {
		event.preventDefault();
		
		if ($(this).parents('.option').hasClass('active'))
		{
			$('#questionOptions .option').removeClass('active');			
		}
		else if ($('.option').hasClass('active'))
		{
			var tOption			= $('.active').detach();
			$(this).parents('.option').before(tOption);
			
			stopDrag($('.active'));
		}
		else
		{
			startDrag($(this).parents('.option'));
		}
	});
	
	//alert("optIndex=" + optIndex);
	if (optIndex == (optCount - 1))
	{
		//alert('last option');
		$('#questionOptions').sortable({
			start: function(event, ui)
			{ 
				startDrag(ui.item);
			},
			update: function(event, ui)
			{ 
				stopDrag(ui.item);
			},
			tolerance: 'pointer',
			containment: '#assessment'
		});
	}
	//alert("$(htmlOpt).find('img').width()=" + $(htmlOpt).find('img').width());
};


function showAnswers()
{
	//alert('Show the answers in the correct order');
	var arrTmpOptions	= new Array;
	
	for (var j = 0; j<optCount; j++) {
		var tOption			= arrOptions[j];
		//alert("tOption.optIndex=" + tOption.optIndex);
		
		arrTmpOptions[tOption.optIndex] = j;
	};
	
	for (var j = 0; j<optCount; j++) {
		var tOption			= arrTmpOptions[j];
		//alert("tOption=" + tOption);
		
		$('#questionOptions').append($('#option' + tOption));
	};
	
}