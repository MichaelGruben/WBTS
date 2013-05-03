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
UDUTU_API=getUDUTU_API();

function InitializeGlossary()
{
    var strHTML = '';
    
    var intItemCount = 0;
    
    for(var i = 0; i < UDUTU_API.gblGlossary.length; i++)
    {
        strHTML += '<div class="glossaryItem"><span class="glossWord">' + UDUTU_API.gblGlossary[i].phrase + '</span><span class="glossDescrip"> - ' + UDUTU_API.gblGlossary[i].definition + '</span></div>';
        
        //alternate styles
        intItemCount += 1;
        var sItemStyle = ((intItemCount % 2 == 0) ? 'ItemStyle' : 'altItemStyle');
        strHTML = formatString(strHTML, [sItemStyle]); 
    }
    
    var span = getObjByName('spnContent')
    span.innerHTML = strHTML;
    
    //scroll to the top of the page
    document.location.hash = '#top';
    
    var lblCurrCourse = getObjByName('lblCurrentCourse',document);
    if (lblCurrCourse != null && lblCurrCourse != 0)
    {
      lblCurrCourse.innerHTML = UDUTU_API.gblCourse.name;
    }
    
    return;
}
