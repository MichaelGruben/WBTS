
var optIndex		= 0;
var tarCount		= 0;
var arrTargets 		= new Array();

function initTarget(tarIndex, xmlOpt)
{
	$('#questionOptions').append('<div id="target' + tarIndex + '" class="target"></div>');
	
	var coords			= $(xmlOpt).attr('word');
	if (coords)
	{
		//alert("word=" + word);
		var x1				= coords.split('-')[0].split(',')[0];
		var y1				= coords.split('-')[0].split(',')[1];
		var x2				= coords.split('-')[1].split(',')[0];
		var y2				= coords.split('-')[1].split(',')[1];
		//alert("x1=" + x1 + " y1=" + y1 + " x2=" + x2 + " y2=" + y2);
		
		$('#questionOptions .target').eq(tarIndex).css('left', x1+'px');
		$('#questionOptions .target').eq(tarIndex).css('top', y1+'px');
		$('#questionOptions .target').eq(tarIndex).css('width', (x2 - x1)+'px');
		$('#questionOptions .target').eq(tarIndex).css('height', (y2 - y1)+'px');
	}
	
	this.optCount		= 0;
	
	totalRight++;
	tarCount++;
}

// set up the option object, display the necessary text and image in the option
function initOption(target, x, y)
{
	$('#questionOptions').append('<div id="option' + optIndex + '" class="option"><a href="#select"></a></div>');
	var $option			= $('#questionOptions #option' + optIndex);
	//alert("x=" + x + " y=" + y);
	$option.offset({ top: y, left: x });
	
	this.isCorrect 		= $(target).is(".target");
	if (this.isCorrect)
	{
		//alert('correct');
		
		tarIndex			= $(target).attr('id').substring(6);
		this.tarIndex		= tarIndex;
		//alert('tarIndex=' + tarIndex);		
		if (arrTargets[tarIndex].optCount > 0)
		{
			totalRight++;
		}
		arrTargets[tarIndex].optCount++;
		
		rightAnswers[rightAnswers.length] = optIndex;
	}
	this.checked 		= true;
		
	optIndex++;
	optCount			= optIndex;
};

function initAreaSelect()
{	
	$('div#questionOptions').click(function(event) {
		event.preventDefault();
		event.stopImmediatePropagation();
		
		if ($(event.target).parent('div').hasClass('option'))
		{
			var tIndex			= $(event.target).parent('div').attr('id').substring(6);
			//alert("arrOptions[tIndex].checked=" + arrOptions[tIndex].checked);
			
			if (arrOptions[tIndex].checked)
			{
				$(event.target).parent('div').addClass('disabled');
				arrOptions[tIndex].checked	= false;
				
				var tarIndex		= arrOptions[tIndex].tarIndex;				
				arrTargets[tarIndex].optCount--;
				if (arrOptions[tIndex].isCorrect && arrTargets[tarIndex].optCount > 0)
				{
					//alert('removing correct answer');
					/*totalRight > tarCount*/
					totalRight--;
				}
			}
		}
		else
		{
			arrOptions[optIndex] = new initOption(event.target, event.pageX - 13, event.pageY - 12);
			
			if (!attempted)
			{
				//alert('first attempt');
				
				$('#checkBtn').removeClass('disabled');
				attempted 			= true;
			}
		}
	});	
};

function showAnswers()
{
	//alert('Show the targets');
	
	//killButton($('div#questionOptions'));
		
	$('.target').addClass('show');
}