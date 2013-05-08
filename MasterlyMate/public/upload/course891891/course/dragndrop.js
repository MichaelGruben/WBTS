var arrDraggables	= new Array();

function clearDrag(drag) 
{
	//alert('clear the dragged item');
	var dragNum			= $('#dragOptions .button').index(drag);
	
	var top				= arrDraggables[dragNum].top;
	var left			= arrDraggables[dragNum].left;		
	//alert('top=' + top);	
	$(drag).offset({ top: top, left: left });
	arrDraggables[dragNum].dropNum = null;	
	
	$(drag).removeClass('dragged');	
}

function clearDrop(drop) 
{
	//alert('clear the dropped item');
	var dropNum			= $('.option').index(drop);
	
	var tmpOption 		= arrOptions[dropNum];
	tmpOption.dragNum 	= null;
	tmpOption.checked 	= false;
	tmpOption.isCorrect = false;
		
	$(drop).removeClass('dropped');	
}

function startDrag (dragged)
{
	var dragNum			= $('#dragOptions .button').index(dragged);
	var dropNum			= arrDraggables[dragNum].dropNum;
	//alert('dragNum=' + dragNum);
	if (dropNum)
	{
		//alert('dropNum=' + dropNum);
			
		clearDrop($('.option').eq(dropNum));
	}
	
	if (arrDraggables[dragNum].top == undefined)
	{
		var offset 			= $(dragged).offset();
		//alert('offset.top=' + offset.top);
		arrDraggables[dragNum].top = offset.top;
		arrDraggables[dragNum].left = offset.left;
	}
	
	$('#dragOptions .button').removeClass('selected');
	$(dragged).removeClass('dragged');
	$(dragged).addClass('selected');
}

// check if the dragged item matches the drop target
function stopDrag (dragged, drop)
{
	var offset			= $(drop).children('.drop').offset();			
	//alert('offset.top=' + offset.top);	
	$(dragged).offset({ top: offset.top, left: offset.left });
			
	var dropNum			= $('.option').index(drop);
	var tmpOption 		= arrOptions[dropNum];
	var dropWord		= tmpOption.txtOption;	
	var dragWord		= $(dragged).find('a').text();
	var dragNum			= tmpOption.dragNum;
	//alert('dragNum=' + dragNum);
	if (dragNum)
	{
		clearDrag($('#dragOptions .button').eq(dragNum));
	}
	dragNum				= $('#dragOptions .button').index(dragged);
	tmpOption.dragNum 	= dragNum;
	arrDraggables[dragNum].dropNum = dropNum;
	//alert('dragNum=' + dragNum);	
	
	tmpOption.checked 	= true;
	tmpOption.isCorrect = dropWord == dragWord;
	
	$('#dragOptions .button').removeClass('selected');	
	$(dragged).addClass('dragged');		
	$(drop).addClass('dropped');	
	//$(dragged).draggable({ disabled: true });
	//$(drop).droppable({ disabled: true });
}

function initDraggable (drgIndex, optIndex, htmlDrg, word)
{
	this.txtOption 		= word;
	this.optIndex 		= optIndex;
	
	$(htmlDrg).children('.button a').text( word );
	$(htmlDrg).show();
	
	//this.offset			= $(htmlDrg).offset();	
	//alert('this.offset.top=' + this.offset.top);	
	
	$(htmlDrg).draggable({
		start: function()
		{ 
			startDrag(this);
		},
		containment: '#assessment',
		revert: 'invalid',
		revertDuration: 0,
		zIndex: 500
		
	});
	
	$(htmlDrg).click(function(event) {
		event.preventDefault();
		
		if ($('#dragOptions .button').hasClass('selected') && $(this).hasClass('dragged'))
		{
			//alert("stop dragging here");
			var dragNum			= $('#dragOptions .button').index(this);
			var dropNum			= arrDraggables[dragNum].dropNum;
			//alert("dropNum=" + dropNum);
			
			stopDrag($('.selected'), $('.option').eq(dropNum));
		}
		else
		{
			//alert("start dragging");
			startDrag(this);
		}
	});
}

// set up the option object, display the necessary text and image in the option
function initOption(optIndex, xmlOpt, htmlOpt)
{
	//alert("optIndex=" + optIndex);
	
	var word			= $(xmlOpt).attr('word');
	$(htmlOpt).has('p').children('p').html( $(xmlOpt).text() );
	if ( $(htmlOpt).has('img') )
	{
		initImage($(htmlOpt).children('img'), $(xmlOpt).text(), '');
	}
	
	this.txtOption 		= word;
	this.isCorrect 		= ($(xmlOpt).attr('correct') == '1');
	if (this.isCorrect)
	{
		totalRight++;
		rightAnswers[rightAnswers.length] = optIndex;
	}
	this.checked 		= false;
	
	var optRand			= optRandCount.getNum(true);
	arrDraggables[optRand] = new initDraggable(optRand, optIndex, $('#dragOptions .button').eq(optRand), word);
	/*$('#dragOptions .button').eq(optRand).children('.button a').text( word );
	$('#dragOptions .button').eq(optRand).show();*/
	
	$(htmlOpt).droppable({
		drop: function( event, ui ) {			
			stopDrag($('.ui-draggable-dragging'), this);
			
			if (!attempted)
			{
				//alert('first attempt');
				
				$('#checkBtn').removeClass('disabled');
				attempted 			= true;
			}
		}
	});	
	
	$(htmlOpt).click(function(event) {
		event.preventDefault();
		
		if ($('#dragOptions .button').hasClass('selected'))
		{
			stopDrag($('.selected'), this);
			
			if (!attempted)
			{
				//alert('first attempt');
				
				$('#checkBtn').removeClass('disabled');
				attempted 			= true;
			}
		};
	});	
	
	if (optIndex === 0)
	{
		
		$('#bg').click(function(event) {
			event.preventDefault();
			
			if ($('#dragOptions .button').hasClass('selected'))
			{
				var dragNum			= $('#dragOptions .selected').index();
				//alert('dragNum=' + dragNum);				
				clearDrag($('#dragOptions .selected'));
				
				$('#dragOptions .button').removeClass('selected');	
				
				var dropNum			= arrDraggables[dragNum].dropNum;
				//alert('dropNum=' + dropNum);
				if (dropNum)
				{
					clearDrop($('.option').eq(dropNum));	
				}
			}
		});
	}
};

function showAnswers()
{
	//alert('Show the answers in the correct order');
	
	for (var j = 0; j<$('#dragOptions .button').length; j++) 
	{
		var drag			= $('#dragOptions .button').eq(j);
		var dropNum			= arrDraggables[j].optIndex;
		if (dropNum < $('.option').length)
		{
			//alert("dropNum=" + dropNum);
			var drop 			= $('.option').eq(dropNum);
			
			var offset			= $(drop).children('.drop').offset();
			$(drag).offset({ top: offset.top, left: offset.left });
		}
		else
		{
			var top				= arrDraggables[j].top;
			var left			= arrDraggables[j].left;		
			//alert('top=' + top);	
			var tOldDragged		= $('#dragOptions .button').eq(j);
			$(tOldDragged).offset({ top: top, left: left });
		}
	}
}