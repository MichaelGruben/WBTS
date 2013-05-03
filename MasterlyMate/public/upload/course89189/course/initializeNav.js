//udutu api (initialize_top) interface layer
var findAPITries = 0;
var UDUTU_API;
function findUDUTU_API(win)
{
   // Check to see if the window (win) contains the API
   // if the window (win) does not contain the API and
   // the window (win) has a parent window and the parent window
   // is not the same as the window (win)
   while ( (win.UDUTU_API == null) &&
           (win.parent != null) &&
           (win.parent != win) )
   {
      // increment the number of findAPITries
      findAPITries++;
      // Note: 7 is an arbitrary number, but should be more than sufficient
      if (findAPITries > 7)
      {
         alert("Error finding UDUTU_API -- too deeply nested.");
         return null;
      }

      // set the variable that represents the window being
      // being searched to be the parent of the current window
      // then search for the API again
      win = win.parent;
   }
   return win.UDUTU_API;
}
function getUDUTU_API()
{
   // start by looking for the API in the current window
   var theAPI = findUDUTU_API(window);
   // if the API is null (could not be found in the current window)
   // and the current window has an opener window
   if ( (theAPI == null) &&
        (window.opener != null) &&
        (typeof(window.opener) != "undefined") )
   {

      // try to find the API in the current window's opener
      theAPI = findUDUTU_API(window.opener);
   }
   // if the API has not been found
   if (theAPI == null)
   {
      // Alert the user that the API Adapter could not be found
      alert("Unable to find UDUTU_API");
   }

   return theAPI;
}



   function initializeNav() //generic initialization used by most nav templates 
{ 
//var gblThemeDir;  //(not needed here - bring in from top frame, send to studentview iframe) 
UDUTU_API = getUDUTU_API();


UDUTU_API.gblNavFrame = getObjByName('NavFrame',UDUTU_API.document); 

UDUTU_API.gblNavDocument = document; 

UDUTU_API.gblNextButton = new UDUTU_API.initButton(next_up, next_over, next_disabled, 'btnNext', parent.goNextPage,'Next page','This is the last page of the course'); 

UDUTU_API.gblPreviousButton = new UDUTU_API.initButton(previous_up, previous_over, previous_disabled, 'btnPrevious', parent.goPreviousPage,'Previous page','This is the first page of the course'); 

UDUTU_API.gblExitButton = new UDUTU_API.initButton(exit_up, exit_over, exit_up, 'btnExit', parent.doExit,'Close and Exit','You may not Exit at this time.'); 

UDUTU_API.gblCourseMapButton = new UDUTU_API.initButton(coursemap_up, coursemap_over, coursemap_disabled, 'btnCourseMap', parent.openCourseMap,'Course Map','The Course Map is disabled until the Interaction has been completed.'); 

UDUTU_API.gblGlossaryButton = new UDUTU_API.initButton(glossary_up, glossary_over, glossary_up, 'btnGlossary', parent.openGlossary,'Glossary','The Glossary is currently disabled.'); 

UDUTU_API.gblSearchButton = new UDUTU_API.initButton(search_up, search_over, search_up, 'btnSearch', parent.openSearch,'Search the Course for keywords','Search is disabled until the Interaction has been completed.'); 


UDUTU_API.gblReplayButton = new UDUTU_API.initButton(replay_up, replay_over, replay_disabled, 'btnReplay', parent.doReplay,'Refresh this screen','This is the last page of the course'); 


UDUTU_API.gblMainMenuButton = new UDUTU_API.initButton(home_up, home_over, home_disabled, 'btnHome', parent.goMainMenu,'Main Menu','The Main Menu is disabled until the Interaction has been completed.'); 

if (typeof( window[ 'resources_up' ] ) != "undefined"){
UDUTU_API.gblResourcesButton = new UDUTU_API.initButton(resources_up, resources_over, resources_disabled, 'btnResources', parent.goResources,'Resources','Resources are disabled until the Interaction has been completed.'); 
}
UDUTU_API.gblFAQButton = new UDUTU_API.initButton(faq_up, faq_over, faq_up, 'btnFAQ', parent.openFAQ,'FAQ','The FAQ is currently disabled.'); 
UDUTU_API.gblHelpButton = new UDUTU_API.initButton(help_up, help_over, help_up, 'btnHelp', parent.openFAQ,'Help','The Help is currently disabled.');
UDUTU_API.gblGuideButton = new UDUTU_API.initButton(guide_up, guide_over, guide_up, 'btnGuide', parent.openGuide,'Open the Guide','The Guide is currently unavailable.');

UDUTU_API.gblPrintButton = new UDUTU_API.initButton(print_up, print_over, print_up, 'btnPrint', parent.printScreen,'Print this screen','Print is not supported for this screen.');
UDUTU_API.gblMuteButton = new UDUTU_API.initButton(mute_up, mute_over, mute_up, 'btnMute', parent.toggleSound, 'Toggle Sound','Toggle Sound');

UDUTU_API.gblBreadCrumbLabel = new UDUTU_API.initLabel('lblBreadCrumb'); 
UDUTU_API.gblCourseLabel = new UDUTU_API.initLabel('lblCourseName'); 
UDUTU_API.gblModuleLabel = new UDUTU_API.initLabel('lblModuleName'); 
UDUTU_API.gblTopicLabel = new UDUTU_API.initLabel('lblTopicName'); 
UDUTU_API.gblScreenLabel = new UDUTU_API.initLabel('lblScreenName'); 
UDUTU_API.gblCurrentPageLabel = new UDUTU_API.initLabel('lblCurrentPage'); 
UDUTU_API.gblNumPagesLabel = new UDUTU_API.initLabel('lblLastPage'); 

UDUTU_API.gblScreenFrame = getObjByName('frameScreen',document); 
UDUTU_API.gblScreenFrameWidth = UDUTU_API.gblScreenFrame.width;
UDUTU_API.gblScreenFrameHeight = UDUTU_API.gblScreenFrame.height;

if ((UDUTU_API.gblMainMenuURL == '' || UDUTU_API.gblMainMenuURL == null) && UDUTU_API.gblHomeScreenID < 1)
{
    if (UDUTU_API.gblMainMenuButton != null && UDUTU_API.gblMainMenuButton.image != null)
    {
      UDUTU_API.gblMainMenuButton.image.style.width = 0;
    }
}

if (UDUTU_API.gblResourcesScreenID < 1)
{
  try{
   UDUTU_API.gblResourcesButton.image.style.width = 0;
   }catch(ex){}
}

if (UDUTU_API.gblScreens.length > 0)
    UDUTU_API.initializeStudentView(); 
} 