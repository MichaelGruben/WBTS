/*
	IE7, version 0.9 (alpha) (2005-08-19)
	Copyright: 2004-2005, Dean Edwards (http://dean.edwards.name/)
	License: http://creativecommons.org/licenses/LGPL/2.1/
*/
IE7.addModule("ie7-graphics",function(){if(appVersion<5.5)return;var A="DXImageTransform.Microsoft.AlphaImageLoader";var F="progid:"+A+"(src='%1',sizingMethod='scale')";var _3=new RegExp((window.IE7_PNG_SUFFIX)+"$","i");var _0=[];function _2(e){var f=e.filters[A];if(f){f.src=e.src;f.enabled=true}else{e.runtimeStyle.filter=F.replace(/%1/,e.src);_0.push(e)}e.src=BLANK_GIF};function _5(e){e.src=e.pngSrc;e.filters[A].enabled=false};ie7CSS.addFix(/opacity\s*:\s*([\d.]+)/,function(m,o){return"zoom:1;filter:progid:DXImageTransform.Microsoft.Alpha(opacity="+((parseFloat(m[o+1])*100)||1)+")"});var B=/background(-image)?\s*:\s*([^\(};]*)url\(([^\)]+)\)([^;}]*)/;ie7CSS.addFix(B,function(m,o){var u=getString(m[o+3]);return _3.test(u)?"filter:"+F.replace(/scale/,"crop").replace(/%1/,u)+";zoom:1;background"+(m[o+1]||"")+":"+(m[o+2]||"")+"none"+(m[o+4]||""):m[o]});if(ie7HTML){ie7HTML.addRecalc("img,input",function(e){if(e.tagName=="INPUT"&&e.type!="image")return;_4(e);addEventHandler(e,"onpropertychange",function(){if(!_1&&event.propertyName=="src"&&e.src.indexOf(BLANK_GIF)==-1)_4(e)})});var B64=/^data:.*;base64/i;var _7=makePath("ie7-base64.php",path);function _4(e){if(_3.test(e.src)){var i=new Image(e.width,e.height);i.onload=function(){e.width=i.width;e.height=i.height;i=null};i.src=e.src;e.pngSrc=e.src;_2(e)}else if(B64.test(e.src)){e.src=_7+"?"+e.src.slice(5)}};var I=/^image/i;var _6=makePath("ie7-object.htc",path);ie7HTML.addRecalc("object",function(e){if(I.test(e.type)){var o=document.createElement("<object type=text/x-scriptlet>");o.style.width=e.currentStyle.width;o.style.height=e.currentStyle.height;o.data=_6;var u=makePath(e.data,getPath(location.href));e.parentNode.replaceChild(o,e);cssQuery.clearCache("object");addTimer(o,"",u);return o}})}var _1=false;addEventHandler(window,"onbeforeprint",function(){_1=true;for(var i=0;i<_0.length;i++)_5(_0[i])});addEventHandler(window,"onafterprint",function(){for(var i=0;i<_0.length;i++)_2(_0[i]);_1=false})});
