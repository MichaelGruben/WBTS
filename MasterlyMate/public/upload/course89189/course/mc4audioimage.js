// set up the option object, display the necessary text and image in the option
function initOption(optIndex, xmlOpt, htmlOpt)
{
	this.txtOption 		= $(xmlOpt).text();
	this.isCorrect 		= ($(xmlOpt).attr('correct') == '1');
	if (this.isCorrect)
	{
		totalRight++;
		rightAnswers[rightAnswers.length] = optIndex;
	}
	this.checked 		= false;
	this.divOptionText 	= $(htmlOpt).children('a');
	this.divOptionText.innerHTML = this.txtOption;
	
	//$(htmlOpt).children('a').html(this.txtOption);
	//var optIndex		= $('.option').index($(htmlOpt).parent());
	initAudio(optIndex, this.txtOption, $(htmlOpt).children('.button.play'));
	
	$(htmlOpt).children('a').addClass('active');
	$(htmlOpt).children('a').click(function(event) {
		event.preventDefault();
		
		$(this).toggleClass('active selected');
		
		var optIndex		= $('.option').index($(this).parent());
		tmpOption 			= arrOptions[optIndex];
		tmpOption.checked 	= !(tmpOption.checked);
		
		if (!attempted)
		{
			//alert('first attempt');
			
			$('#checkBtn').removeClass('disabled');
			attempted 			= true;
		}
	});
	//alert("$(htmlOpt).find('img').width()=" + $(htmlOpt).find('img').width());
};