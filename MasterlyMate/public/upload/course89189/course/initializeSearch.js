   //utility functions

var gblSearchScreens = new Array();
function initSearchScreen(id,screenname,topicname,modulename,textcontent)
{
	this.id = id;
	this.ScreenName = screenname;
	this.ModuleName = modulename;
	this.TopicName = topicname;
	this.TextContent = textcontent;
}	


function goScreen(intScreenID)
{
opener.top.goScreen(intScreenID);
  window.close();
}
function doSearch()
{
  var strSearchVal = getObjByName('txtSearch',document).value;
  var regEx = new RegExp(strSearchVal,"i");
  var divResults = getObjByName('divSearchResults',document);
  var spanSearchDesc = getObjByName('lblSearchDesc',document);

  var strResultsHdr = '<table cellspacing="3" cellpadding="2" rules="all" border="0" id="dgScreens" style="border-width:0px;width:100%;">'
	+ '<tr class="HeaderStyle">'
		+ '<td class="categories">Module Name</td><td class="categories">Topic Name</td><td class="categories">Screen Name</td>'
	+ '</tr>';
  var strResultRows = '';
  var intRowCount = 0;
  for(var i = 0;i<srchScreens.length;i++)
  {
  //test whether the content contains the search string
	if (regEx.test(srchScreens[i].TextContent))
	{
	  var strRowStyle;
	  //alternate row styles
	  intRowCount++;
	  if (intRowCount%2==1)
	  {strRowStyle = 'ItemStyle';}
	  else
	  {strRowStyle = 'altItemStyle';}
	  
	  var strResultRow = '<tr class="' + strRowStyle + '">'
		+ '<td class="text">' + srchScreens[i].ModuleName + '</td>'
		+ '<td class="text">' + srchScreens[i].TopicName + '</td>'
		+ '<td><a title="Go to this screen" href="javascript: goScreen(' + srchScreens[i].id + ')" style="color:#990000;">' + srchScreens[i].ScreenName + '</a></td>'
	+ '</tr>';
	  strResultRows += strResultRow;
	}
  }

  var strResultsEnd = '</table>';
  if (strResultRows.length > 0)
  {
    spanSearchDesc.innerHTML='The keyword(s) were found on the following screens:';
    divResults.innerHTML = strResultsHdr + strResultRows + strResultsEnd;
  }
  else
  {
    spanSearchDesc.innerHTML='There are no screens matching that search.';
    divResults.innerHTML = '';
  }

}