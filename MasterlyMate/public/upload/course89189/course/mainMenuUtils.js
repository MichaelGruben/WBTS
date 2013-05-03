// JScript File
function InitializeMainMenu()
{
  var btnBack = getObjByName('UDUTU_MainMenu_btnBack');
  if (UDUTU_API.getCurrScreen().id == UDUTU_API.gblScreens[0].id)
    btnBack.style.visibility = "hidden"; 
  else
    btnBack.style.visibility = "visible";
}
function UDUTU_MainMenuGoBack()
{
    UDUTU_API.goScreenFromMainMenu(UDUTU_API.getCurrScreen().id);
}
function UDUTU_MainMenuGoModule(moduleID)
{
    UDUTU_API.goModuleFromMainMenu(moduleID);
}
function UDUTU_MainMenuGoScreen(screenID)
{
    UDUTU_API.goScreenFromMainMenu(screenID);
}

function GetViewedTag(oItem)
{

	var bCompleted = true;

	switch (oItem.type) {
		case 'module' : bCompleted = UDUTU_API.evaluateModuleCompletion(oItem);
						break;
		case 'screen' : bCompleted = oItem.isCompleted();
						break;
	}

	var sHTML = '<img id="imgVisited_' + oItem.id + '" src="' + UDUTU_API.gblRelativePathToFiles + UDUTU_API.gblThemeDir + '{0}.gif" border="0" />';
	return ( bCompleted ) ? formatString(sHTML,['viewed']) : formatString(sHTML,['spacer']); 
}