   function getObjByName(name,doc) {
var o = 0;

if(!doc) doc = document;
if(doc[name]) o=doc[name];
if(!document.all)
{

return doc.getElementById(name);
}
if(document.all && doc.all[name]) 
{o=doc.all[name];}
  if(o){
  if(!o.getElementsByTagName) o.getElementsByTagName = getElementsArray;
  return o;
  }
if(document.layers) {
  for(var i=0;i < doc.layers.length;i++){
  var lyrdoc = doc.layers[i].document;

  if(lyrdoc[name]) return lyrdoc[name];
    if(lyrdoc.layers.length > 0) {
    var o = getObjByName(name,lyrdoc);
    if(o) return o;
    }
  }
}
return 0;
}
if(!document.getElementById) document.getElementById = getObjByName;

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
   var theAPI = null;
   try{
   // start by looking for the API in the current window
   theAPI = findUDUTU_API(window);
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
  } catch(ex){}
   return theAPI;
}


//initializes the sound for the page
//it is done this way to force IE to use BGSOUND instead of EMBED
//since IE sometimes can't resolve pathing with EMBED, and will ignore
//anything in a NOEMBED tag (since it thinks it supports EMBED).
//the background sound is expected to be in a 'UDUTU_BGSound1' span tag.
var gblAudioFilename = '';
var gblSoundLoaded = true;

function PlayNarration(strURL){
	
	//alert("playnarration"+strURL);

	$("#UDUTU_Narration_div").jPlayer("clearMedia");
    $(document).ready(function(){
		$("#UDUTU_Narration_div").jPlayer({
			ready: function (event) {
				$(this).jPlayer("setMedia", {
					mp3:strURL
				}).jPlayer("play");
			},
			play: function(){
				$(this).jPlayer("pauseOthers");

		 		var elemPlay = getObjByName('jp_container_1',document);
			 	elemPlay.style.visibility = "hidden";
				
			},
			swfPath: "jplayer",
			supplied: "mp3",
			cssSelectorAncestor: "#jp_container_1",
			wmode:"window"
			
		});
    });

    // if (navigator.userAgent.indexOf("Safari") == -1)
    // {
		// var elemPlay = getObjByName('jp_container_1',document);
		// elemPlay.style.visibility = "hidden";
    // }
}


//used as a catch-all initialization function
function InitSound()
{
    if (DefaultMI != null)
      UDUTU_MIClicked(DefaultMI);
    var isIE = navigator.appName.indexOf("Microsoft") != -1;
    var el = getObjByName('UDUTU_Narration',document);
    //alert(el);
    if(gblAudioFilename == '')gblAudioFilename = el.innerHTML;
    if (gblAudioFilename.search(/sample\.mp3/i) > -1)
        gblAudioFilename = '';
    var currScreen = UDUTU_API.getCurrScreen();
    if (gblAudioFilename != '')
    {
        if (!currScreen.streamNarration)
        {
		    UDUTU_API.stopSound();
		    try{parent.StopSound();}catch(ex){}
		    if (isIE)
		    {
			    el.innerHTML = '&nbsp;<BGSOUND src="' + gblAudioFilename + '" width="0" height="0">';
		    }
		    else
		    {
			    // var isWAV = (gblAudioFilename.indexOf(".wav") != -1) || (gblAudioFilename.indexOf(".WAV") != -1);
			    // if (isWAV)
				    // el.innerHTML = '&nbsp;<EMBED type="audio/x-wav" src="' + gblAudioFilename + '" height="1" width="1" autostart=true></embed>';
			    // else//assume it is an mp3
				    // el.innerHTML = '&nbsp;<EMBED type="audio/x-mpeg" src="' + gblAudioFilename + '" height="1" width="1" autostart=true></embed>';
				el.innerHTML = '&nbsp;<div id="jp_container_1" class="jp-audio"><div class="jp-gui jp-interface"><ul class="jp-controls"><li><a href="#play" class="jp-play" tabindex="1">play</a></li><li><a href="#play" class="jp-pause" tabindex="1">pause</a></li></ul></div></div><div id="UDUTU_Narration_div" class="jp-jplayer">'+gblAudioFilename+'</div>';
				el.style.visibility = 'visible';
				//$('body').prepend('<div id="jp_container_1" class="jp-audio"><div class="jp-gui jp-interface"><ul class="jp-controls"><li><a href="#play" class="jp-play" tabindex="1">play</a></li><li><a href="#play" class="jp-pause" tabindex="1">pause</a></li></ul></div></div><div id="UDUTU_Narration_div" class="jp-jplayer">'+gblAudioFilename+'</div>'); 
				PlayNarration(gblAudioFilename);		    
			}
 

	    }
	    else
	    {
		    //UDUTU_API.playSound(gblAudioFilename);
	    }
	}
	gblSoundLoaded = true;
	if (UDUTU_API.gblEvaluation)
	{
	    addWatermark();
	}
}

//we are stopping sound by having the sound embedded in a span and clearing the span, rather than 
//using .stop() on the sound tag directly, because firefox doesn't understand .stop() at this time.
function StopSound()
{
	var el = getObjByName('UDUTU_Narration',document);
	el.innerHTML = "";
	//stop cacheflash from playing sound, if it is
	UDUTU_API.stopSound();
	try{var m = getObjByName("KT_Flash1",document);
	m.SetVariable("stopSoundNow", true);
	}catch(ex){}
}
function MuteSound()
{
	//stop cacheflash from playing sound, if it is
	UDUTU_API.stopSound();

	var el = getObjByName('UDUTU_Narration',document);
	el.innerHTML = "";

	try{var m = getObjByName("KT_Flash1",document);
	m.SetVariable("stopSoundNow", true);

	}catch(ex){}
	gblSoundLoaded =false;
}
function StartSound()
{
  if(gblSoundLoaded == false)
  {
    InitSound();
  }
}
function startSoundTimer(){
	setTimeout('startSoundTimer()', 200);
	if (UDUTU_API.gblSoundOn == false)
	{
		MuteSound();	
	}
	else
	{
		StartSound();
	}
}
var themeDir;
var isInteractive = false;
try{
isInteractive = isAssessment;
}catch(e){}
try{ 

UDUTU_API = getUDUTU_API();
themeDir = UDUTU_API.gblThemeDir; 
document.write('<link rel=stylesheet href="' + UDUTU_API.gblRelativePathToFiles + 'student_structure.css">');
document.write('<link rel=stylesheet href="' + UDUTU_API.gblRelativePathToFiles + themeDir + 'student_structure.css">');
document.write('<link rel=stylesheet href="' + UDUTU_API.gblRelativePathToFiles + themeDir + 'student_text.css">');
if (isInteractive) document.write('<link rel=stylesheet href="' + UDUTU_API.gblRelativePathToFiles + themeDir + 'interactive_style.css">');
document.write('<link rel=stylesheet href="' + UDUTU_API.gblRelativePathToFiles + themeDir + 'student_options.css">');
document.write('<link rel=stylesheet href="' + UDUTU_API.gblRelativePathToFiles + themeDir + 'student_advanced.css">');

startSoundTimer();
}
catch(e){}
function UDUTU_MIClicked(strURL)
{
  var frame = getObjByName('UDUTU_MoreInfoFrame');
  frame.src=strURL;
}
var DefaultMI;
function SetDefaultMI(strURL)
{
  DefaultMI = strURL;
}
function UDUTU_JumpToClicked(intScreenID)
{
    UDUTU_API.goScreen(intScreenID);
}


function UDUTU_Flash1_DoFSCommand(command, args) {
  if (command == 'disableNext')
  {
	UDUTU_API.gblNextButton.btnEnabled(false);
  }
  else
  {
	UDUTU_API.gblNextButton.btnEnabled(true);
  }
}

//this function is assuming that the left and right edges are being padded 10 pixels
//may not always be a safe assumption to make, but we can't read the values from css
function UDUTU_ResizeFrame(width, height)
{
  if (width > 0 && height > 0)
  {
    UDUTU_API.setScreenFrameParams(width + 20,height);
  }
}

var isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && navigator.userAgent.indexOf("Windows") != -1 && navigator.userAgent.indexOf("Windows 3.1") == -1) {
	document.write('<script language=\"VBScript\"\>\n');
	document.write('On Error Resume Next\n');
	document.write('Sub UDUTU_Flash1_FSCommand(ByVal command, ByVal args)\n');
	document.write('	Call UDUTU_Flash1_DoFSCommand(command, args)\n');
	document.write('End Sub\n');
	document.write('</script\>\n');
}

function AC_AX_RunContent(){
  var ret = AC_AX_GetArgs(arguments);
  AC_Generateobj(ret.objAttrs, ret.params, ret.embedAttrs);
}

function AC_AX_GetArgs(args){
  var ret = new Object();
  ret.embedAttrs = new Object();
  ret.params = new Object();
  ret.objAttrs = new Object();
  for (var i=0; i < args.length; i=i+2){
    var currArg = args[i].toLowerCase();    

    switch (currArg){	
      case "pluginspage":
      case "type":
      case "src":
        ret.embedAttrs[args[i]] = args[i+1];
        break;
      case "data":
      case "codebase":
      case "classid":
      case "id":
      case "onafterupdate":
      case "onbeforeupdate":
      case "onblur":
      case "oncellchange":
      case "onclick":
      case "ondblClick":
      case "ondrag":
      case "ondragend":
      case "ondragenter":
      case "ondragleave":
      case "ondragover":
      case "ondrop":
      case "onfinish":
      case "onfocus":
      case "onhelp":
      case "onmousedown":
      case "onmouseup":
      case "onmouseover":
      case "onmousemove":
      case "onmouseout":
      case "onkeypress":
      case "onkeydown":
      case "onkeyup":
      case "onload":
      case "onlosecapture":
      case "onpropertychange":
      case "onreadystatechange":
      case "onrowsdelete":
      case "onrowenter":
      case "onrowexit":
      case "onrowsinserted":
      case "onstart":
      case "onscroll":
      case "onbeforeeditfocus":
      case "onactivate":
      case "onbeforedeactivate":
      case "ondeactivate":
        ret.objAttrs[args[i]] = args[i+1];
        break;
      case "width":
      case "height":
      case "align":
      case "vspace": 
      case "hspace":
      case "class":
      case "title":
      case "accesskey":
      case "name":
      case "tabindex":
        ret.embedAttrs[args[i]] = ret.objAttrs[args[i]] = args[i+1];
        break;
      default:
        ret.embedAttrs[args[i]] = ret.params[args[i]] = args[i+1];
    }
  }
  return ret;
}

function AC_AddExtension(src, ext)
{
  if (src.indexOf('?') != -1)
    return src.replace(/\?/, ext+'?'); 
  else
    return src + ext;
}

function AC_Generateobj(objAttrs, params, embedAttrs) 
{ 
  var str = '<object ';
  for (var i in objAttrs)
    str += i + '="' + objAttrs[i] + '" ';
  str += '>';
  for (var i in params)
    str += '<param name="' + i + '" value="' + params[i] + '" /> ';
  str += '<embed ';
  for (var i in embedAttrs)
    str += i + '="' + embedAttrs[i] + '" ';
  str += ' ></embed></object>';

  document.write(str);
}

function AC_FL_RunContent(){
  var ret = 
    AC_GetArgs
    (  arguments, ".swf", "movie", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
     , "application/x-shockwave-flash"
    );
  AC_Generateobj(ret.objAttrs, ret.params, ret.embedAttrs);
}

function AC_SW_RunContent(){
  var ret = 
    AC_GetArgs
    (  arguments, ".dcr", "src", "clsid:166B1BCA-3F9C-11CF-8075-444553540000"
     , null
    );
  AC_Generateobj(ret.objAttrs, ret.params, ret.embedAttrs);
}

function AC_GetArgs(args, ext, srcParamName, classid, mimeType){
  var ret = new Object();
  ret.embedAttrs = new Object();
  ret.params = new Object();
  ret.objAttrs = new Object();
  for (var i=0; i < args.length; i=i+2){
    var currArg = args[i].toLowerCase();    

    switch (currArg){	
      case "classid":
        break;
      case "pluginspage":
        ret.embedAttrs[args[i]] = args[i+1];
        break;
      case "src":
      case "movie":	
        args[i+1] = AC_AddExtension(args[i+1], ext);
        ret.embedAttrs["src"] = args[i+1];
        ret.params[srcParamName] = args[i+1];
        break;
      case "onafterupdate":
      case "onbeforeupdate":
      case "onblur":
      case "oncellchange":
      case "onclick":
      case "ondblClick":
      case "ondrag":
      case "ondragend":
      case "ondragenter":
      case "ondragleave":
      case "ondragover":
      case "ondrop":
      case "onfinish":
      case "onfocus":
      case "onhelp":
      case "onmousedown":
      case "onmouseup":
      case "onmouseover":
      case "onmousemove":
      case "onmouseout":
      case "onkeypress":
      case "onkeydown":
      case "onkeyup":
      case "onload":
      case "onlosecapture":
      case "onpropertychange":
      case "onreadystatechange":
      case "onrowsdelete":
      case "onrowenter":
      case "onrowexit":
      case "onrowsinserted":
      case "onstart":
      case "onscroll":
      case "onbeforeeditfocus":
      case "onactivate":
      case "onbeforedeactivate":
      case "ondeactivate":
      case "type":
      case "codebase":
        ret.objAttrs[args[i]] = args[i+1];
        break;
      case "width":
      case "height":
      case "align":
      case "vspace": 
      case "hspace":
      case "class":
      case "title":
      case "accesskey":
      case "name":
      case "id":
      case "tabindex":
        ret.embedAttrs[args[i]] = ret.objAttrs[args[i]] = args[i+1];
        break;
      default:
        ret.embedAttrs[args[i]] = ret.params[args[i]] = args[i+1];
    }
  }
  ret.objAttrs["classid"] = classid;
  if (mimeType) ret.embedAttrs["type"] = mimeType;
  return ret;
}

function embed(tag)
{
  document.write(tag);
}

function removeWatermark()
{
	var waterMark = document.getElementById("Water_Mark");
	waterMark.style.display = 'none';
}

function addWatermark()
{
	var waterMark = document.getElementById("Water_Mark");
	//waterMark.style.background='transparent url(watermark.png) center center no-repeat';
	if (waterMark != null)
	{
	  waterMark.style.height = '100%';
	  waterMark.style.left = '0';
	  waterMark.style.position = 'absolute';
	  waterMark.style.top = '0';
	  waterMark.style.width = '100%';
	  waterMark.style.textAlign = 'center';
	  waterMark.style.zIndex = '200';
	  waterMark.innerHTML = "<img src='../../../../watermark.png' alt='myUdutu: free preview version, click to remove watermark' style='margin:20px auto;height:432px;width:454px;'>";
	  waterMark.onclick = removeWatermark;
	}
}

function switchImage(strName,strType,strFLVPlayerPath,strFlashVars,height,width)
{

     var div = document.getElementById(strName);
    
    var html = div.innerHTML; 	


        
    var tag = document.getElementById("UDUTU_MultiMedia1_Content");
    
    div.removeChild(tag);
    
    if(strType == 'Image')
    {	    
      
      var obj = '<img id="UDUTU_MultiMedia1_Content" class="SomeClass" src="'+ strFLVPlayerPath +'" title="max dimensions:' + width +'px wide, ' + height + 'px high" width="' + width +'px" height="'+height+'px">'

	div.innerHTML = obj;	
	  	    
    }

   else if(strType == 'Flash')
   {
	
   	 var flashObj = '<object id="UDUTU_MultiMedia1_Content"  classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" height =' + height + ' width = ' + width + ' ><param name="movie" value="'+ strFLVPlayerPath + '"><param name="wmode" value="transparent"><embed name="UDUTU_MultiMedia1_Content" src="'+ strFLVPlayerPath + '" height =' + height + ' width = ' + width + ' quality="high" wmode="transparent" ALIGN=""  PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed></object>'
	 

	div.innerHTML = flashObj;
	
	 
   }
    else if(strType == 'Video')
   {
   
   	    var flashObj = '<object id="UDUTU_MultiMedia1_Content"  codeBase=http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0 type=application/x-shockwave-flash height='+ height + ' width=' + width + ' classid=clsid:d27cdb6e-ae6d-11cf-96b8-444553540000><param NAME="_cx" VALUE="6588"><param NAME="_cy" VALUE="7938"><param NAME="FlashVars" VALUE="' + strFlashVars +  '"><param NAME="Movie" VALUE="'+ strFLVPlayerPath +'"><param NAME="Src" VALUE="' + strFLVPlayerPath + '"><param NAME="WMode" VALUE="Transparent"><param NAME="Play" VALUE="0"><param NAME="Loop" VALUE="-1"><param NAME="Quality" VALUE="High"><param NAME="SAlign" VALUE=""><param NAME="Menu" VALUE="-1"><param NAME="Base" VALUE=""><param NAME="AllowScriptAccess" VALUE=""><param NAME="Scale" VALUE="ShowAll"><param NAME="DeviceFont" VALUE="0"><param NAME="EmbedMovie" VALUE="0"><param NAME="BGColor" VALUE=""><param NAME="SWRemote" VALUE=""><param NAME="MovieData" VALUE=""><param NAME="SeamlessTabbing" VALUE="1"><param NAME="Profile" VALUE="0"><param NAME="ProfileAddress" VALUE=""><param NAME="ProfilePort" VALUE="0"><param NAME="AllowNetworking" VALUE="all"><param NAME="AllowFullScreen" VALUE="false"><embed name="UDUTU_MultiMedia1_Content" FlashVars="' + strFlashVars +  '" src="'+ strFLVPlayerPath +'" width=' + width + ' height='+ height + ' quality="high" wmode="transparent" ALIGN=""  PLUGINSPAGE="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash"></embed></object>';
             
	   div.innerHTML = flashObj;
   }

	
}