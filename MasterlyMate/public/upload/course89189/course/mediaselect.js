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
		
		var option			= $(this).parents('.option');
		
		$(option).children('a').toggleClass('active selected');
		
		var optIndex		= $('.option').index(option);
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