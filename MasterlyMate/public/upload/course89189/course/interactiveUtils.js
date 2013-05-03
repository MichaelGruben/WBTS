// JScript File
// Correct Handler
var intCorrectGoToScreenID;
var intPartialGoToScreenID;
var intIncorrectGoToScreenID;
function UDUTU_Correct(strFeedback){
	UDUTU_API.setCurrScreenPassed();
	
	if (intCorrectGoToScreenID > 0)
	{
	  alert(strFeedback);
	  UDUTU_API.goScreen(intCorrectGoToScreenID);
	}
}
// Partially Correct Handler
function UDUTU_PartiallyCorrect(strFeedback){
	UDUTU_API.setCurrScreenFailed();
	if (intPartialGoToScreenID > 0)
	{
		alert(strFeedback);
		UDUTU_API.goScreen(intPartialGoToScreenID);
	}
}
// Incorrect Handler
function UDUTU_Incorrect(strFeedback){ 
	UDUTU_API.setCurrScreenFailed();
	if (intIncorrectGoToScreenID > 0)
	{
		alert(strFeedback);
		UDUTU_API.goScreen(intIncorrectGoToScreenID);
	}
}

var gblResult;
function UDUTU_MultipleChoice_Answer(result, correct_response, learner_response)
{
  gblResult = result;
  if (intCorrectGoToScreenID > 0 && intPartialGoToScreenID > 0 && intIncorrectGoToScreenID > 0)
  {
    UDUTU_API.disableNav();
    UDUTU_API.gblNextButton.image.alt = "You must finish the interaction to continue";
    UDUTU_API.gblPreviousButton.image.alt = "You must finish the interaction to continue";
  }
  UDUTU_API.setCurrScreenInteractionStatus(result,correct_response,learner_response,'choice');
}

function UDUTU_Matching_Answer(result, correct_response, learner_response)
{
  gblResult = result;
  if (intCorrectGoToScreenID > 0 && intPartialGoToScreenID > 0 && intIncorrectGoToScreenID > 0)
  {
    UDUTU_API.disableNav();
    UDUTU_API.gblNextButton.image.alt = "You must finish the interaction to continue";
    UDUTU_API.gblPreviousButton.image.alt = "You must finish the interaction to continue";
  }
  UDUTU_API.setCurrScreenInteractionStatus(result,correct_response,learner_response,'matching');
}

function UDUTU_Custom_Answer(result, correct_response, learner_response, scaled_score)
{
  gblResult = result;
  if (intCorrectGoToScreenID > 0 && intPartialGoToScreenID > 0 && intIncorrectGoToScreenID > 0)
  {
    UDUTU_API.disableNav();
    UDUTU_API.gblNextButton.image.alt = "You must finish the interaction to continue";
    UDUTU_API.gblPreviousButton.image.alt = "You must finish the interaction to continue";
  }
  UDUTU_API.setCurrScreenInteractionStatus(result,correct_response,learner_response,'other', scaled_score);
}

function UDUTU_MultipleChoice_ShowContinue()
{
  return (intCorrectGoToScreenID > 0 || intPartialGoToScreenID > 0 || intIncorrectGoToScreenID > 0);
}

function UDUTU_MultipleChoice_ActivateContinue()
{
  if (gblResult == 'correct' && intCorrectGoToScreenID > 0)
  {
    return true;
  }
  else if (gblResult == 'incorrect' && intIncorrectGoToScreenID > 0)
  {
    return true;
  }
  else if (gblResult == 'partial' && intPartialGoToScreenID > 0)
  {
    return true;
  }
  else
    return false;
}

function UDUTU_MultipleChoice_Proceed()
{
  //UDUTU_API.enableNav();
  if (gblResult == 'correct' && intCorrectGoToScreenID > 0)
  {
    UDUTU_API.goScreen(intCorrectGoToScreenID);
  }
  else if (gblResult == 'incorrect' && intIncorrectGoToScreenID > 0)
  {
    UDUTU_API.goScreen(intIncorrectGoToScreenID);
  }
  else if (gblResult == 'partial' && intPartialGoToScreenID > 0)
  {
    UDUTU_API.goScreen(intPartialGoToScreenID);
  }
  
  UDUTU_API.gblNextButton.image.alt = UDUTU_API.gblNextButton.image.strAlt;
  UDUTU_API.gblPreviousButton.image.alt = UDUTU_API.gblNextButton.image.strAlt;
}
function UDUTU_Matching_Proceed()
{
  UDUTU_MultipleChoice_Proceed();
}
function UDUTU_Custom_Proceed()
{
  UDUTU_MultipleChoice_Proceed();
}
function UDUTU_MultipleChoice_LoadResponse()
{
  var response = UDUTU_API.searchLastInteractionResult(UDUTU_API.getCurrScreen().id);
  if (response != null)
  {UDUTU_API.enableNav();
   return response.learner_response;
  }
  else return null;
}
function UDUTU_Matching_LoadResponse()
{
  return UDUTU_MultipleChoice_LoadResponse();
}
function UDUTU_Custom_LoadResponse()
{
  return UDUTU_MultipleChoice_LoadResponse();
}
function UDUTU_Interaction_DoFSCommand(command, args)
{
  if (command == 'UDUTU_Correct')
  {
    UDUTU_Correct(args);
  }
  else if (command == 'UDUTU_Incorrect')
  {
    UDUTU_Incorrect(args);
  }
  else if (command == 'UDUTU_PartiallyCorrect')
  {
    UDUTU_PartiallyCorrect(args);
  }
}

var API = window;
var API_1484_11 = window;

//function overloaded (screen also has an Initialize function called with no params), so do the same as that function if param is null
function Initialize(param)
{
  //the parameter is unused - reserved by SCORM for future use
  if (param == null)
  	InitSound();
  if (param != null)
  	//alert("scorm 2004 LMS Initialize");
return "true";
}

function Terminate(tmp)
{
  //the parameter is unused - reserved by SCORM for future use
  //alert("scorm 2004 LMS Finish");
return "true";
}

function GetValue(parameter)
{
  //alert("scorm 2004 LMS GetValue: " + parameter);
}

function SetValue(parameter, value)
{
    //alert("scorm 2004 SetValue: parameter=" + parameter + " value=" + value);
    switch(parameter)
    {
	case "cmi.core.score.raw":
	  break;
	case "cmi.core.score.max":
	  break;
	case "cmi.core.lesson_status":
	  if (value == 'passed')
	        UDUTU_API.setCurrScreenInteractionStatus('correct','','','choice');
	  else
		UDUTU_API.setCurrScreenInteractionStatus('incorrect','','','choice');
	  break;
	case "cmi.success_status":
	  if (value == 'passed')
	        UDUTU_API.setCurrScreenInteractionStatus('correct','','','choice');
	  else
		UDUTU_API.setCurrScreenInteractionStatus('incorrect','','','choice');
	  break;
	default:
	  break;
    }
return "true";
}

function Commit()
{
  //the parameter is unused - reserved by SCORM for future use
  //alert("scorm 2004 Commit");
return "true";
}
function GetLastError()
{
  return 0;
}

//scorm 1.2

function LMSInitialize()
{
  //the parameter is unused - reserved by SCORM for future use
  //alert("SCORM 1.2 LMS Initialize");
return "true";
}

function LMSFinish(tmp)
{
  //the parameter is unused - reserved by SCORM for future use
  //alert("SCORM 1.2 LMS Finish");
return "true";
}

function LMSGetValue(parameter)
{
  //alert("scorm 1.2 LMS GetValue: " + parameter);
  switch(parameter)
  {
	case "cmi.core.lesson_status":
	  return "incomplete";
	  break;
	case "cmi.suspend_data":
	  return "";
	  break;
	default:
	  return "";
	  break;
  }
  
}

function LMSGetLastError()
{
  return 0;
}

function LMSSetValue(parameter, value)
{
    //alert("scorm 1.2 SetValue: parameter=" + parameter + " value=" + value);
    switch(parameter)
    {
	case "cmi.core.score.raw":
	  break;
	case "cmi.core.score.max":
	  break;
	case "cmi.core.lesson_status":
	  if (value == 'passed')
	        UDUTU_API.setCurrScreenInteractionStatus('correct','','','choice');
	  else
		UDUTU_API.setCurrScreenInteractionStatus('incorrect','','','choice');
	  break;
	default:
	  break;
    }
return "true";
}

function LMSCommit()
{
  //the parameter is unused - reserved by SCORM for future use
  //alert("scorm 1.2 Commit");
return "true";
}


var isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && navigator.userAgent.indexOf("Windows") != -1 && navigator.userAgent.indexOf("Windows 3.1") == -1) {
	document.write('<script language=\"VBScript\"\>\n');
	document.write('On Error Resume Next\n');
	document.write('Sub UDUTU_Interaction_FSCommand(ByVal command, ByVal args)\n');
	document.write('	Call UDUTU_Interaction_DoFSCommand(command, args)\n');
	document.write('End Sub\n');
	document.write('</script\>\n');
}