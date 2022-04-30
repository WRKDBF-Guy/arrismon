<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>arrismon</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<style>
p{font-weight:bolder}thead.collapsible-jquery{color:#fff;padding:0;width:100%;border:none;text-align:left;outline:none;cursor:pointer}th.keystatsnumber{font-size:20px!important;font-weight:bolder!important}td.keystatsnumber{font-size:20px!important;font-weight:bolder!important}td.nodata{height:65px!important;border:none!important;text-align:center!important;font:bolder 48px Arial!important}td.channelcell{padding:0!important;border:0!important}.StatsTable{table-layout:fixed!important;width:747px!important;text-align:center!important}.StatsTable th{background-color:#1F2D35!important;background:#2F3A3E!important;border-bottom:none!important;border-top:none!important;font-size:12px!important;color:#fff!important;padding:4px!important;width:740px!important}.StatsTable td{padding:4px!important;word-wrap:break-word!important;overflow-wrap:break-word!important;word-break:break-all!important}.StatsTable a{font-weight:bolder!important;text-decoration:underline!important}.StatsTable th:first-child,.StatsTable td:first-child{border-left:none!important}.StatsTable th:last-child,.StatsTable td:last-child{border-right:none!important}.StatsTable td:last-child{text-align:left!important}.SettingsTable{text-align:left}.SettingsTable input{text-align:left;margin-left:3px!important}.SettingsTable input.savebutton{text-align:center;margin-top:5px;margin-bottom:5px;border-right:solid 1px #000;border-left:solid 1px #000;border-bottom:solid 1px #000}.SettingsTable td.savebutton{border-right:solid 1px #000;border-left:solid 1px #000;border-bottom:solid 1px #000;background-color:#4d595d}.SettingsTable .cronbutton{text-align:center;min-width:50px;width:50px;height:23px;vertical-align:middle}.SettingsTable select{margin-left:3px!important}.SettingsTable label{margin-right:10px!important;vertical-align:top!important}.SettingsTable th{background-color:#1F2D35!important;background:#2F3A3E!important;border-bottom:none!important;border-top:none!important;font-size:12px!important;color:#fff!important;padding:4px!important;font-weight:bolder!important;padding:0!important}.SettingsTable td{word-wrap:break-word!important;overflow-wrap:break-word!important;border-right:none;border-left:none}.SettingsTable span.settingname{background-color:#1F2D35!important;background:#2F3A3E!important}.SettingsTable td.settingname{border-right:solid 1px #000;border-left:solid 1px #000;background-color:#1F2D35!important;background:#2F3A3E!important;width:35%!important}.SettingsTable td.settingvalue{text-align:left!important;border-right:solid 1px #000}.SettingsTable th:first-child{border-left:none!important}.SettingsTable th:last-child{border-right:none!important}.SettingsTable .invalid{background-color:#8b0000!important}.SettingsTable .disabled{background-color:#CCC!important;color:#888!important}.removespacing{padding-left:0!important;margin-left:0!important;margin-bottom:5px!important;text-align:center!important}.schedulespan{display:inline-block!important;width:70px!important;color:#FFF!important;font-weight:700!important}div.schedulesettings{margin-bottom:5px}label.filtervalue{vertical-align:top!important}div.sortTableContainer{height:300px;overflow-y:scroll;width:745px;border:1px solid #000}.sortTable{table-layout:fixed!important;border:none}thead.sortTableHeader th{background-image:linear-gradient(#92a0a5 0%,#66757c 100%);border-top:none!important;border-left:none!important;border-right:none!important;border-bottom:1px solid #000!important;font-weight:bolder;padding:2px;text-align:center;color:#fff;position:sticky;top:0;font-size:11px!important}thead.sortTableHeader th:first-child,thead.sortTableHeader th:last-child{border-right:none!important}thead.sortTableHeader th:first-child,thead.sortTableHeader td:first-child{border-left:none!important}tbody.sortTableContent td:last-child,tbody.sortTableContent tr.sortNormalRow td:last-child,tbody.sortTableContent tr.sortAlternateRow td:last-child{text-align:left}tbody.sortTableContent td{border-bottom:1px solid #000!important;border-left:none!important;border-right:1px solid #000!important;border-top:none!important;padding:2px;text-align:center;overflow:hidden!important;font-size:12px!important}tbody.sortTableContent tr.sortRow:nth-child(odd) td{background-color:#2F3A3E!important}tbody.sortTableContent tr.sortRow:nth-child(even) td{background-color:#475A5F!important}th.sortable{cursor:pointer}
</style>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/moment.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/chart.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/hammerjs.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/chartjs-plugin-zoom.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/chartjs-plugin-annotation.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/d3.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/ext/shared-jy/detect.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmhist.js"></script>
<script language="JavaScript" type="text/javascript" src="/tmmenu.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script>
var custom_settings;
function LoadCustomSettings(){
	custom_settings = <% get_custom_settings(); %>;
	for(var prop in custom_settings){
		if(Object.prototype.hasOwnProperty.call(custom_settings, prop)){
			if(prop.indexOf("arrismon") != -1 && prop.indexOf("arrismon_version") == -1){
				eval("delete custom_settings."+prop)
			}
		}
	}
}
var $j=jQuery.noConflict(),arraysortlistlines=[],sortname="Time",sortdir="desc",maxNoCharts=18,currentNoCharts=0,ShowLines=GetCookie("ShowLines","string"),DragZoom=!0,ChartPan=!1,metriclist=["RxPwr","RxSnr","RxFreq","SymRate","RxCorr","RxUncor","TxPwr"],titlelist=["Downstream Power","Downstream SNR","Frequency","Symbol Rate","Corrected","Uncorrectable","Upstream Power"],measureunitlist=["dBmV","dB","MHz","","","","dBmV"],chartlist=["daily","weekly","monthly"],timeunitlist=["hour","day","day"],intervallist=[24,7,30],RxCount,TxCount,RxColours,TxColours,chartColours=["rgba(24,113,65,1)","rgba(205,117,81,1)","rgba(230,55,90,1)","rgba(5,206,61,1)","rgba(131,4,176,1)","rgba(196,145,14,1)","rgba(169,229,70,1)","rgba(25,64,183,1)","rgba(23,153,199,1)","rgba(223,46,248,1)","rgba(240,92,214,1)","rgba(123,137,211,1)","rgba(141,68,215,1)","rgba(74,210,128,1)","rgba(223,247,240,1)","rgba(226,27,93,1)","rgba(253,78,222,1)","rgba(63,192,102,1)","rgba(82,66,162,1)","rgba(65,190,78,1)","rgba(154,113,118,1)","rgba(222,98,201,1)","rgba(198,186,137,1)","rgba(178,45,245,1)","rgba(95,245,50,1)","rgba(247,142,18,1)","rgba(103,152,205,1)","rgba(39,104,180,1)","rgba(132,165,5,1)","rgba(8,249,253,1)","rgba(227,170,207,1)","rgba(196,70,76,1)","rgba(11,197,73,1)","rgba(127,50,202,1)","rgba(33,248,170,1)","rgba(17,216,225,1)","rgba(176,123,12,1)","rgba(181,111,105,1)","rgba(104,122,233,1)","rgba(217,102,107,1)","rgba(188,174,88,1)","rgba(30,224,236,1)","rgba(169,39,247,1)","rgba(251,86,116,1)","rgba(217,163,80,1)","rgba(155,120,34,1)","rgba(82,124,118,1)","rgba(102,89,62,1)","rgba(48,126,7,1)","rgba(48,118,188,1)","rgba(223,246,227,1)","rgba(152,11,129,1)","rgba(66,97,241,1)","rgba(32,113,78,1)","rgba(83,142,226,1)","rgba(210,105,250,1)","rgba(125,115,7,1)","rgba(198,37,71,1)","rgba(253,99,153,1)","rgba(171,225,78,1)","rgba(66,82,121,1)","rgba(5,82,115,1)","rgba(22,62,141,1)","rgba(135,59,161,1)","rgba(20,223,59,1)","rgba(17,206,99,1)","rgba(142,162,133,1)","rgba(206,76,155,1)","rgba(131,87,41,1)","rgba(199,234,37,1)","rgba(176,94,156,1)","rgba(13,58,185,1)","rgba(147,19,178,1)","rgba(48,203,55,1)","rgba(250,31,116,1)","rgba(138,9,168,1)","rgba(90,208,244,1)","rgba(128,110,93,1)","rgba(222,202,95,1)","rgba(189,78,184,1)","rgba(122,41,65,1)","rgba(243,176,73,1)","rgba(23,123,71,1)","rgba(209,50,12,1)","rgba(253,218,100,1)","rgba(214,18,185,1)","rgba(31,254,215,1)","rgba(191,53,224,1)","rgba(117,197,238,1)","rgba(183,123,104,1)","rgba(88,34,248,1)","rgba(124,157,92,1)","rgba(76,59,160,1)","rgba(143,235,139,1)","rgba(59,85,112,1)","rgba(233,54,148,1)","rgba(244,176,124,1)","rgba(246,246,104,1)","rgba(169,171,44,1)","rgba(240,3,14,1)"];function keyHandler(t){82==t.keyCode?($j(document).off("keydown"),ResetZoom()):68==t.keyCode?($j(document).off("keydown"),ToggleDragZoom(document.form.btnDragZoom)):76==t.keyCode&&($j(document).off("keydown"),ToggleLines())}function Draw_Chart_NoData(t,e){document.getElementById("divLineChart_"+t).width="730",document.getElementById("divLineChart_"+t).height="500",document.getElementById("divLineChart_"+t).style.width="730px",document.getElementById("divLineChart_"+t).style.height="500px";t=document.getElementById("divLineChart_"+t).getContext("2d");t.save(),t.textAlign="center",t.textBaseline="middle",t.font="normal normal bolder 48px Arial",t.fillStyle="white",t.fillText(e,365,250),t.restore()}function Draw_Chart(t,e,o){var a=getChartPeriod($j("#"+t+"_Period option:selected").val()),r=timeunitlist[$j("#"+t+"_Period option:selected").val()],n=intervallist[$j("#"+t+"_Period option:selected").val()],i=window[t+"_"+a];if(null!=i)if(0!=i.length){var l=[],s=[];for(let t=0;t<i.length;t++)l[i[t].Channel]||(s.push(i[t].Channel),l[i[t].Channel]=1);i.map(function(t){return t.Channel});var d=i.map(function(t){return{x:t.Time,y:t.Value}}),c=window["LineChart_"+t],m=getTimeFormat($j("#Time_Format option:selected").val(),"axis"),u=getTimeFormat($j("#Time_Format option:selected").val(),"tooltip");factor=0,"hour"==r?factor=36e5:"day"==r&&(factor=864e5),null!=c&&c.destroy();a=document.getElementById("divLineChart_"+t).getContext("2d"),n={segmentShowStroke:!1,segmentStrokeColor:"#000",animation:{duration:0},responsiveAnimationDuration:0,maintainAspectRatio:!1,animateScale:!0,hover:{mode:"point"},legend:{display:!0,position:"bottom",labels:{boxWidth:10,fontSize:10}},title:{display:!0,text:e},tooltips:{callbacks:{title:function(t,e){return moment(t[0].xLabel,"X").format(u)},label:function(t,e){return e.datasets[t.datasetIndex].label+": "+round(e.datasets[t.datasetIndex].data[t.index].y,2).toFixed(2)+" "+o}},mode:"point",position:"cursor",intersect:!0},scales:{xAxes:[{type:"time",gridLines:{display:!0,color:"#282828"},ticks:{display:!0,min:moment().subtract(n,r+"s")},time:{parser:"X",unit:r,stepSize:1,displayFormats:m}}],yAxes:[{gridLines:{display:!1,color:"#282828"},scaleLabel:{display:!1,labelString:o},ticks:{display:!0,beginAtZero:startAtZero(t),labels:{index:["min","max"],removeEmptyLines:!0},callback:function(t,e,a){return round(t,2).toFixed(2)+" "+o}}}]},plugins:{zoom:{pan:{enabled:ChartPan,mode:"xy",rangeMin:{x:(new Date).getTime()-factor*n,y:getLimit(d,"y","min",!1)-.1*Math.sqrt(Math.pow(getLimit(d,"y","min",!1),2))},rangeMax:{x:(new Date).getTime(),y:getLimit(d,"y","max",!1)+.1*getLimit(d,"y","max",!1)}},zoom:{enabled:!0,drag:DragZoom,mode:"xy",rangeMin:{x:(new Date).getTime()-factor*n,y:getLimit(d,"y","min",!1)-.1*Math.sqrt(Math.pow(getLimit(d,"y","min",!1),2))},rangeMax:{x:(new Date).getTime(),y:getLimit(d,"y","max",!1)+.1*getLimit(d,"y","max",!1)},speed:.1}}},annotation:{drawTime:"afterDatasetsDraw",annotations:[{type:ShowLines,mode:"horizontal",scaleID:"y-axis-0",value:getAverage(d),borderColor:"#fc8500",borderWidth:1,borderDash:[5,5],label:{backgroundColor:"rgba(0,0,0,0.3)",fontFamily:"sans-serif",fontSize:10,fontStyle:"bold",fontColor:"#fff",xPadding:6,yPadding:6,cornerRadius:6,position:"center",enabled:!0,xAdjust:0,yAdjust:0,content:"Avg="+round(getAverage(d),2).toFixed(2)+o}},{type:ShowLines,mode:"horizontal",scaleID:"y-axis-0",value:getLimit(d,"y","max",!0),borderColor:"#fc8500",borderWidth:1,borderDash:[5,5],label:{backgroundColor:"rgba(0,0,0,0.3)",fontFamily:"sans-serif",fontSize:10,fontStyle:"bold",fontColor:"#fff",xPadding:6,yPadding:6,cornerRadius:6,position:"right",enabled:!0,xAdjust:15,yAdjust:0,content:"Max="+round(getLimit(d,"y","max",!0),2).toFixed(2)+o}},{type:ShowLines,mode:"horizontal",scaleID:"y-axis-0",value:getLimit(d,"y","min",!0),borderColor:"#fc8500",borderWidth:1,borderDash:[5,5],label:{backgroundColor:"rgba(0,0,0,0.3)",fontFamily:"sans-serif",fontSize:10,fontStyle:"bold",fontColor:"#fff",xPadding:6,yPadding:6,cornerRadius:6,position:"left",enabled:!0,xAdjust:15,yAdjust:0,content:"Min="+round(getLimit(d,"y","min",!0),2).toFixed(2)+o}}]}},d={datasets:getDataSets(t,i,s)},c=new Chart(a,{type:"line",data:d,options:n});window["LineChart_"+t]=c}else Draw_Chart_NoData(t,"No data to display");else Draw_Chart_NoData(t,"No data to display")}function getDataSets(t,e,a){var o=[];colourname="#fc8500";for(var r=0;r<a.length;r++){var n=e.filter(function(t){return t.Channel==a[r]}).map(function(t){return{x:t.Time,y:t.Value}});-1!=t.indexOf("RxFreq")?o.push({label:a[r],data:n,showLine:!1,borderWidth:1,pointRadius:1,lineTension:0,fill:!1,backgroundColor:chartColours[r],borderColor:chartColours[r]}):o.push({label:a[r],data:n,borderWidth:1,pointRadius:1,lineTension:0,fill:!1,backgroundColor:chartColours[r],borderColor:chartColours[r]})}return o}function LogarithmicFormatter(t,e,a){var o=this.options.scaleLabel.labelString;if("logarithmic"!=this.type)return isNaN(t)?t+" "+o:round(t,2).toFixed(2)+" "+o;var r=this.options.ticks.labels||{},n=r.index||["min","max"],i=r.significand||[1,2,5],l=t/Math.pow(10,Math.floor(Chart.helpers.log10(t))),s=!0===r.removeEmptyLines?void 0:"",d="";return 0===e?d="min":e===a.length-1&&(d="max"),"all"===r||-1!==i.indexOf(l)||-1!==n.indexOf(e)||-1!==n.indexOf(d)?0===t?"0 "+o:isNaN(t)?t+" "+o:round(t,2).toFixed(2)+" "+o:s}function getLimit(t,e,a,o){var r=0,t="x"==e?t.map(function(t){return t.x}):t.map(function(t){return t.y}),r=("max"==a?Math.max:Math.min).apply(Math,t);return"max"==a&&0==r&&0==o&&(r=1),r}function getAverage(t){for(var e=0,a=0;a<t.length;a++)e+=+t[a].y;return e/t.length}function startAtZero(t){var e=!1;return-1==t.indexOf("RxFreq")&&-1==t.indexOf("SymRate")&&-1==t.indexOf("RxCorr")&&-1==t.indexOf("RxUncor")||(e=!0),e}function round(t,e){return Number(Math.round(t+"e"+e)+"e-"+e)}function getRandomColor(){return"rgba("+Math.floor(255*Math.random())+","+Math.floor(255*Math.random())+","+Math.floor(255*Math.random())+",1)"}function poolColors(t){for(var e=[],a=0;a<t;a++)e.push(getRandomColor());return e}function SetRxTxColours(){RxColours=poolColors(22<RxCount?RxCount:22),TxColours=poolColors(TxCount)}function GetMaxChannels(){for(var t=[],e=0;e<metriclist.length;e++){var a="LineChart_"+metriclist[e];-1!=a.indexOf("Rx")?(a=window[a].data.datasets.length,t.push(a)):TxCount=4}RxCount=Math.max.apply(Math,t),TxCount=4}function ToggleLines(){SetCookie("ShowLines",ShowLines=""==ShowLines?"line":"");for(var t=0;t<metriclist.length;t++){for(var e=0;e<3;e++)window["LineChart_"+metriclist[t]].options.annotation.annotations[e].type=ShowLines;window["LineChart_"+metriclist[t]].update()}}function changeChart(t){value=+t.value,name=t.id.substring(0,t.id.indexOf("_")),SetCookie(t.id,value),"RxPwr"==name?Draw_Chart("RxPwr",titlelist[0],measureunitlist[0]):"RxSnr"==name?Draw_Chart("RxSnr",titlelist[1],measureunitlist[1]):"RxFreq"==name?Draw_Chart("RxFreq",titlelist[2],measureunitlist[2]):"SymRate"==name?Draw_Chart("SymRate",titlelist[3],measureunitlist[3]):"RxCorr"==name?Draw_Chart("RxCorr",titlelist[4],measureunitlist[4]):"RxUncor"==name?Draw_Chart("RxUncor",titlelist[5],measureunitlist[5]):"TxPwr"==name&&Draw_Chart("TxPwr",titlelist[6],measureunitlist[6])}function RedrawAllCharts(){for(var t=0;t<metriclist.length;t++){Draw_Chart_NoData(metriclist[t],"Data loading...");for(var e=0;e<chartlist.length;e++)d3.csv("/ext/arrismon/csv/"+metriclist[t]+"_"+chartlist[e]+".htm").then(ProcessChart.bind(null,t,e))}}function changeAllCharts(t){value=+t.value,name=t.id.substring(0,t.id.indexOf("_")),SetCookie(t.id,value);for(var e=0;e<metriclist.length;e++)Draw_Chart(metriclist[e],titlelist[e],measureunitlist[e])}function getTimeFormat(t,e){var a;return"axis"==e?0==t?a={millisecond:"HH:mm:ss.SSS",second:"HH:mm:ss",minute:"HH:mm",hour:"HH:mm"}:1==t&&(a={millisecond:"h:mm:ss.SSS A",second:"h:mm:ss A",minute:"h:mm A",hour:"h A"}):"tooltip"==e&&(0==t?a="YYYY-MM-DD HH:mm:ss":1==t&&(a="YYYY-MM-DD h:mm:ss A")),a}function ProcessChart(t,e,a){if(window[metriclist[t]+"_"+chartlist[e]]=a,++currentNoCharts==maxNoCharts){document.getElementById("modupdate_text").innerHTML="",showhide("imgModUpdate",!1),showhide("modupdate_text",!1),showhide("btnUpdateStats",!0);for(var o=0;o<metriclist.length;o++)$j("#"+metriclist[o]+"_Period").val(GetCookie(metriclist[o]+"_Period","number")),Draw_Chart(metriclist[o],titlelist[o],measureunitlist[o]);GetMaxChannels(),$j("#table_buttons2").after(BuildChannelFilterTable()),AddEventHandlers()}}function GetCookie(t,e){return null!=cookie.get("mod_"+t)?cookie.get("mod_"+t):"string"==e?"":"number"==e?0:void 0}function SetCookie(t,e){cookie.set("mod_"+t,e,3650)}function SetCurrentPage(){document.form.next_page.value=window.location.pathname.substring(1),document.form.current_page.value=window.location.pathname.substring(1)}function initial(){SetCurrentPage(),LoadCustomSettings(),show_menu(),$j("#sortTableContainer").empty(),$j("#sortTableContainer").append(BuildModemLogsTableNoData()),get_conf_file(),$j("#Time_Format").val(GetCookie("Time_Format","number")),ScriptUpdateLayout(),get_statstitle_file();for(var t="",e=0;e<metriclist.length;e++)t+=BuildMetricTable(metriclist[e],titlelist[e],e);$j("#table_modemlogs").after(t),get_modemlogs_file(),RedrawAllCharts()}function ScriptUpdateLayout(){var t=GetVersionNumber("local"),e=GetVersionNumber("server");$j("#arrismon_version_local").text(t),t!=e&&"N/A"!=e&&($j("#arrismon_version_server").text("Updated version available: "+e),showhide("btnChkUpdate",!1),showhide("arrismon_version_server",!0),showhide("btnDoUpdate",!0))}function reload(){location.reload(!0)}function getChartScale(t){var e="";return 0==t?e="linear":1==t&&(e="logarithmic"),e}function getChartPeriod(t){var e="daily";return 0==t?e="daily":1==t?e="weekly":2==t&&(e="monthly"),e}function ResetZoom(){for(var t=0;t<metriclist.length;t++){var e=window["LineChart_"+metriclist[t]];null!=e&&e.resetZoom()}}function ToggleDragZoom(t){for(var e=!0,a=!1,o="",o=-1!=t.value.indexOf("On")?(ChartPan=!(DragZoom=!(a=!(e=!1))),"Drag Zoom Off"):(ChartPan=!(DragZoom=!(a=!(e=!0))),"Drag Zoom On"),r=0;r<metriclist.length;r++){var n=window["LineChart_"+metriclist[r]];null!=n&&(n.options.plugins.zoom.zoom.drag=e,n.options.plugins.zoom.pan.enabled=a,t.value=o,n.update())}}function ExportCSV(){return location.href="/ext/arrismon/csv/arrismondata.zip",0}function update_status(){$j.ajax({url:"/ext/arrismon/detect_update.js",dataType:"script",error:function(t){setTimeout(update_status,1e3)},success:function(){"InProgress"==updatestatus?setTimeout(update_status,1e3):(document.getElementById("imgChkUpdate").style.display="none",showhide("arrismon_version_server",!0),"None"!=updatestatus?($j("#arrismon_version_server").text("Updated version available: "+updatestatus),showhide("btnChkUpdate",!1),showhide("btnDoUpdate",!0)):($j("#arrismon_version_server").text("No update available"),showhide("btnChkUpdate",!0),showhide("btnDoUpdate",!1)))}})}function CheckUpdate(){showhide("btnChkUpdate",!1),document.formScriptActions.action_script.value="start_arrismoncheckupdate",document.formScriptActions.submit(),document.getElementById("imgChkUpdate").style.display="",setTimeout(update_status,2e3)}function DoUpdate(){document.form.action_script.value="start_arrismondoupdate",document.form.action_wait.value=10,showLoading(),document.form.submit()}function Validate_Number_Setting(t,e,a){t.name;var o=+t.value;return e<o||o<a?($j(t).addClass("invalid"),!1):($j(t).removeClass("invalid"),!0)}function Format_Number_Setting(t){t.name;var e=+t.value;return 0!=t.value.length&&NaN!=e&&(t.value=parseInt(t.value),!0)}function Validate_All(){var t=!1;return Validate_Number_Setting(document.form.arrismon_daystokeep,365,10)||(t=!0),!t||(alert("Validation for some fields failed. Please correct invalid values and try again."),!1)}function SaveConfig(){if(!Validate_All())return!1;document.getElementById("amng_custom").value=JSON.stringify($j("form").serializeObject()),document.form.action_script.value="start_arrismonconfig",document.form.action_wait.value=5,showLoading(),document.form.submit()}function update_modtest(){$j.ajax({url:"/ext/arrismon/detect_arrismon.js",dataType:"script",error:function(t){setTimeout(update_modtest,1e3)},success:function(){"InProgress"==arrismonstatus?setTimeout(update_modtest,1e3):"GenerateCSV"==arrismonstatus?(document.getElementById("modupdate_text").innerHTML="Retrieving data for charts...",setTimeout(update_modtest,1e3)):"LOCKED"==arrismonstatus?(showhide("imgModUpdate",!1),document.getElementById("modupdate_text").innerHTML="Scheduled stat update already running!",showhide("btnUpdateStats",!0)):"Done"==arrismonstatus&&(document.getElementById("modupdate_text").innerHTML="Refreshing charts...",PostModUpdate())}})}function PostModUpdate(){currentNoCharts=0,$j("#table_filters").remove(),$j("#table_charts").remove(),$j("#Time_Format").val(GetCookie("Time_Format","number")),get_statstitle_file(),setTimeout(ResetLayout,3e3)}function ResetLayout(){for(var t="",e=0;e<metriclist.length;e++)t+=BuildMetricTable(metriclist[e],titlelist[e],e);$j("#table_modemlogs").after(t),get_modemlogs_file(),RedrawAllCharts()}function UpdateStats(){showhide("btnUpdateStats",!1),document.formScriptActions.action_script.value="start_arrismon",document.formScriptActions.submit(),document.getElementById("modupdate_text").innerHTML="Retrieving Arris stats",showhide("imgModUpdate",!0),showhide("modupdate_text",!0),setTimeout(update_modtest,5e3)}function GetVersionNumber(t){var e;return"local"==t?e=custom_settings.arrismon_version_local:"server"==t&&(e=custom_settings.arrismon_version_server),void 0===e||null==e?"N/A":e}function get_conf_file(){$j.ajax({url:"/ext/arrismon/config.htm",dataType:"text",error:function(t){setTimeout(get_conf_file,1e3)},success:function(data){for(var configdata=data.split("\n"),configdata=configdata.filter(Boolean),i=0;i<configdata.length;i++)eval("document.form.arrismon_"+configdata[i].split("=")[0].toLowerCase()).value=configdata[i].split("=")[1].replace(/(\r\n|\n|\r)/gm,"")}})}function get_statstitle_file(){$j.ajax({url:"/ext/arrismon/modstatstext.js",dataType:"script",error:function(t){setTimeout(get_statstitle_file,1e3)},success:function(){SetModStatsTitle()}})}function get_modemlogs_file(){$j.ajax({url:"/ext/arrismon/modlogs.htm",dataType:"text",error:function(t){setTimeout(get_modemlogs_file,1e3)},success:function(t){ParseModemLogs(t)}})}function ParseModemLogs(t){var e=(e=t.split("\n")).filter(Boolean);arraysortlistlines=[];for(var a=0;a<e.length;a++)try{var o=e[a].split(","),r=new Object;r.Time=moment(o[0].trim(),"ddd MMM DD HH:mm:ss YYYY").format("YYYY-MM-DD HH:mm:ss"),r.Priority=o[1].trim(),r.Message=o[2].trim(),arraysortlistlines.push(r)}catch{}SortTable(sortname+" "+sortdir.replace("desc","↑").replace("asc","↓").trim())}function SortTable(sorttext){sortname=sorttext.replace("↑","").replace("↓","").trim();var sorttype="string",sortfield=sortname;"Time"===sortname&&(sorttype="date"),"string"==sorttype?sortdir=-1==sorttext.indexOf("↓")&&-1==sorttext.indexOf("↑")||-1!=sorttext.indexOf("↓")?(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => (a."+sortfield+" > b."+sortfield+") ? 1 : ((b."+sortfield+" > a."+sortfield+") ? -1 : 0));"),"asc"):(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => (a."+sortfield+" < b."+sortfield+") ? 1 : ((b."+sortfield+" < a."+sortfield+") ? -1 : 0));"),"desc"):"number"==sorttype?sortdir=-1==sorttext.indexOf("↓")&&-1==sorttext.indexOf("↑")?(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => parseFloat(a."+sortfield+'.replace("m","000")) - parseFloat(b.'+sortfield+'.replace("m","000")));'),"asc"):-1!=sorttext.indexOf("↓")?(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => parseFloat(a."+sortfield+'.replace("m","000")) - parseFloat(b.'+sortfield+'.replace("m","000"))); '),"asc"):(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => parseFloat(b."+sortfield+'.replace("m","000")) - parseFloat(a.'+sortfield+'.replace("m","000")));'),"desc"):"date"==sorttype&&(sortdir=-1==sorttext.indexOf("↓")&&-1==sorttext.indexOf("↑")||-1!=sorttext.indexOf("↓")?(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => new Date(a."+sortfield+") - new Date(b."+sortfield+"));"),"asc"):(eval("arraysortlistlines = arraysortlistlines.sort((a,b) => new Date(b."+sortfield+") - new Date(a."+sortfield+"));"),"desc")),$j("#sortTableContainer").empty(),$j("#sortTableContainer").append(BuildModemLogsTable()),$j(".sortable").each(function(t,e){e.innerHTML==sortname&&(e.innerHTML="asc"==sortdir?e.innerHTML+" ↑":e.innerHTML+" ↓")})}function BuildModemLogsTableNoData(){return'<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="sortTable"><tr><td colspan="3" class="nodata">Data loading...</td></tr></table>'}function BuildModemLogsTable(){var t='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="sortTable">';t+='<col style="width:125px;">',t+='<col style="width:75px;">',t+='<col style="width:520px;">',t+='<thead class="sortTableHeader">',t+="<tr>",t+='<th class="sortable" onclick="SortTable(this.innerHTML)">Time</th>',t+='<th class="sortable" onclick="SortTable(this.innerHTML)">Priority</th>',t+='<th class="sortable" onclick="SortTable(this.innerHTML)">Message</th>',t+="</tr>",t+="</thead>",t+='<tbody class="sortTableContent">';for(var e=0;e<arraysortlistlines.length;e++)t+='<tr class="sortRow">',t+="<td>"+arraysortlistlines[e].Time+"</td>",t+="<td>"+arraysortlistlines[e].Priority+"</td>",t+="<td>"+arraysortlistlines[e].Message+"</td>",t+="</tr>";return t+="</tbody>",t+="</table>"}function BuildMetricTable(t,e,a){var o='<div style="line-height:10px;">&nbsp;</div>';return 0==a&&(o+='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="table_charts">',o+='<thead class="collapsible-jquery" id="thead_charts">',o+="<tr>",o+="<td>Charts (click to expand/collapse)</td>",o+="</tr>",o+="</thead>",o+='<tr><td align="center" style="padding: 0px;">',o+='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_buttons2">',o+='<thead class="collapsible-jquery" id="charttools">',o+='<tr><td colspan="2">Chart Display Options (click to expand/collapse)</td></tr>',o+="</thead>",o+="<tr>",o+='<th width="20%"><span style="color:#FFFFFF;background:#2F3A3E;">Time format</span><br /><span style="color:#FFCC00;background:#2F3A3E;">(for tooltips and Last 24h chart axis)</span></th>',o+="<td>",o+='<select style="width:100px" class="input_option" onchange="changeAllCharts(this)" id="Time_Format">',o+='<option value="0">24h</option>',o+='<option value="1">12h</option>',o+="</select>",o+="</td>",o+="</tr>",o+='<tr class="apply_gen" valign="top">',o+='<td style="background-color:rgb(77,89,93);" colspan="2">',o+='<input type="button" onclick="ToggleDragZoom(this);" value="Drag Zoom On" class="button_gen" name="button">',o+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",o+='<input type="button" onclick="ResetZoom();" value="Reset Zoom" class="button_gen" name="button">',o+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",o+='<input type="button" onclick="ToggleLines();" value="Toggle Lines" class="button_gen" name="button">',o+="</td>",o+="</tr>",o+="</table>",o+='<div style="line-height:10px;">&nbsp;</div>'),o+='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="table_metric_'+t+'">',o+='<thead class="collapsible-jquery" id="'+t+'">',o+="<tr>",o+='<td colspan="2">'+e+" (click to expand/collapse)</td>",o+="</tr>",o+="</thead>",o+='<tr class="even">',o+='<th width="40%">Period to display</th>',o+="<td>",o+='<select style="width:150px" class="input_option" onchange="changeChart(this)" id="'+t+'_Period">',o+='<option value="0">Last 24 hours</option>',o+='<option value="1">Last 7 days</option>',o+='<option value="2">Last 30 days</option>',o+="</select>",o+="</td>",o+="</tr>",o+="<tr>",o+='<td colspan="2" align="center" style="padding: 0px;">',o+='<div style="background-color:#2f3e44;border-radius:10px;width:730px;padding-left:5px;"><canvas id="divLineChart_'+t+'" height="500" /></div>',o+="</td>",o+="</tr>",o+="</table>",a==metriclist.length-1&&(o+="</td>",o+="</tr>",o+="</table>"),o}function BuildChannelFilterTable(){var t='<div style="line-height:10px;">&nbsp;</div>';return t+='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="table_filters">',t+='<thead class="collapsible-jquery" id="mod_filters">',t+="<tr>",t+='<td colspan="2">Chart Filters (click to expand/collapse)</td>',t+="</tr>",t+="</thead>",t+="<tr>",t+='<td colspan="2" align="center" style="padding: 0px;">',t+=BuildChannelFilterRow("rx","Downstream Channels",RxCount),t+=BuildChannelFilterRow("tx","Upstream Channels",TxCount),t+="</td>",t+="</tr>",t+="</table>"}function BuildChannelFilterRow(t,e,a){var o='<div style="line-height:10px;">&nbsp;</div>';for(o+='<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="table_'+t+'">',o+='<thead id="channel_table_'+t+'stream">',o+='<tr><td colspan="12">'+e+"</td></tr>",o+="</thead>",o+="<tr>",o+='<td colspan="12" align="center" style="padding: 0px;">',o+='<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border: 0px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+='<col style="width:60px;">',o+="<tr>",channelno=1;channelno<a+1;channelno++)o+='<td class="channelcell"><input type="checkbox" onchange="ToggleDataset(this);" name="'+t+"opt"+channelno+'" id="'+t+"opt"+channelno+'" checked/><label class="radio filtervalue">Ch. '+channelno+"</label></td>",channelno%12==0&&(o+="</tr><tr>");return o+="</tr>",o+="</table>",o+="</div>",o+="</td>",o+="</tr>",o+='<tr class="apply_gen" valign="top" height="35px" id="row_'+t+'_buttons">',o+="<td>",o+='<input type="button" onclick="SetAllChannels(this,true);" value="Select all" class="button_gen" name="'+t+'_button_select" id="'+t+'_button_select">',o+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;",o+='<input type="button" onclick="SetAllChannels(this,false);" value="Clear all" class="button_gen" name="'+t+'_button_clear" id="'+t+'_button_clear">',o+="</td></tr>",o+="</table>"}function ToggleDataset(t){for(var e=0;e<metriclist.length;e++)-1!=metriclist[e].toLowerCase().indexOf(t.id.substring(0,2))&&(window["LineChart_"+metriclist[e]].getDatasetMeta(+t.id.substring(5)-1).hidden=!t.checked,window["LineChart_"+metriclist[e]].update())}function SetAllChannels(t,e){var a="",o=0==e?1:0,a="rx"==t.id.substring(0,2)?"Rx":"Tx";1==o&&$j("#"+a.toLowerCase()+"opt1").prop("checked",!0);for(var r=1+o;r<window[a+"Count"]+1;r++)$j("#"+a.toLowerCase()+"opt"+r).prop("checked",e);for(r=0;r<metriclist.length;r++)if(-1!=metriclist[r].indexOf(a)){for(var n=0;n<window[a+"Count"];n++)window["LineChart_"+metriclist[r]].getDatasetMeta(n).hidden=!$j("#"+a.toLowerCase()+"opt"+(n+1)).prop("checked");window["LineChart_"+metriclist[r]].update()}}function AddEventHandlers(){$j(".collapsible-jquery").off("click").on("click",function(){$j(this).siblings().toggle("fast",function(){"none"==$j(this).css("display")?SetCookie($j(this).siblings()[0].id,"collapsed"):SetCookie($j(this).siblings()[0].id,"expanded")})}),$j(".collapsible-jquery").each(function(t,e){"collapsed"==GetCookie($j(this)[0].id,"string")?$j(this).siblings().toggle(!1):$j(this).siblings().toggle(!0)})}Chart.defaults.global.defaultFontColor="#CCC",Chart.Tooltip.positioners.cursor=function(t,e){return e},$j(document).keydown(function(t){keyHandler(t)}),$j(document).keyup(function(t){$j(document).keydown(function(t){keyHandler(t)})}),$j.fn.serializeObject=function(){var t=custom_settings,e=this.serializeArray();return $j.each(e,function(){void 0!==t[this.name]&&-1!=this.name.indexOf("arrismon")&&-1==this.name.indexOf("version")?(t[this.name].push||(t[this.name]=[t[this.name]]),t[this.name].push(this.value||"")):-1!=this.name.indexOf("arrismon")&&-1==this.name.indexOf("version")&&(t[this.name]=this.value||"")}),t};

</script>
</head>
<body onload="initial();" onunload="return unload_body();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="about:blank" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="action_script" value="start_arrismon">
<input type="hidden" name="current_page" value="">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_wait" value="30">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="SystemCmd" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>">
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="amng_custom" id="amng_custom" value="">
<table class="content" align="center" cellpadding="0" cellspacing="0">
<tr>
<td width="17">&nbsp;</td>
<td valign="top" width="202">
<div id="mainMenu"></div>
<div id="subMenu"></div></td>
<td valign="top">
<div id="tabMenu" class="submenuBlock"></div>
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
<tr>
<td valign="top">
<table width="760px" border="0" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
<tbody>
<tr bgcolor="#4D595D">
<td valign="top">
<div>&nbsp;</div>
<div class="formfonttitle" id="scripttitle" style="text-align:center;">arrismon</div>
<div id="statstitle" style="text-align:center;">Stats last updated:</div>
<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
<div class="formfontdesc">arrismon is a fork of modmon and balmon. It's nowhere near as polished as either.</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="border:0px;" id="table_buttons">
<thead class="collapsible-jquery" id="scripttools">
<tr><td colspan="2">Utilities (click to expand/collapse)</td></tr>
</thead>
<tr>
<th width="20%">Version information</th>
<td>
<span id="arrismon_version_local" style="color:#FFFFFF;"></span>
&nbsp;&nbsp;&nbsp;
<span id="arrismon_version_server" style="display:none;">Update version</span>
&nbsp;&nbsp;&nbsp;
<input type="button" class="button_gen" onclick="CheckUpdate();" value="Check" id="btnChkUpdate">
<img id="imgChkUpdate" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>
<input type="button" class="button_gen" onclick="DoUpdate();" value="Update" id="btnDoUpdate" style="display:none;">
&nbsp;&nbsp;&nbsp;
</td>
</tr>
<tr>
<th width="20%">Update stats</th>
<td>
<input type="button" onclick="UpdateStats();" value="Update stats" class="button_gen" name="btnUpdateStats" id="btnUpdateStats">
<img id="imgModUpdate" style="display:none;vertical-align:middle;" src="images/InternetScan.gif"/>
&nbsp;&nbsp;&nbsp;
<span id="modupdate_text" style="display:none;"></span>
</td>
</tr>
<tr>
<th width="20%">Export</th>
<td>
<input type="button" onclick="ExportCSV();" value="Export to CSV" class="button_gen" name="btnExport">
</td>
</tr>
</table>
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="#6b8fa3" class="FormTable SettingsTable" style="border:0px;" id="table_config">
<thead class="collapsible-jquery" id="scriptconfig">
<tr><td colspan="2">Configuration (click to expand/collapse)</td></tr>
</thead>
<tr class="even" id="rowdataoutput">
<td class="settingname">Data Output Mode<br/><span class="settingname">(for weekly and monthly charts)</span></td>
<td class="settingvalue">
<input type="radio" name="arrismon_outputdatamode" id="arrismon_dataoutput_average" class="input" value="average" checked>
<label for="arrismon_dataoutput_average">Average</label>
<input type="radio" name="arrismon_outputdatamode" id="arrismon_dataoutput_raw" class="input" value="raw">
<label for="arrismon_dataoutput_raw">Raw</label>
</td>
</tr>
<tr class="even" id="rowtimeoutput">
<td class="settingname">Time Output Mode<br/><span class="settingname">(for CSV export)</span></td>
<td class="settingvalue">
<input type="radio" name="arrismon_outputtimemode" id="arrismon_timeoutput_non-unix" class="input" value="non-unix" checked>
<label for="arrismon_timeoutput_non-unix">Non-Unix</label>
<input type="radio" name="arrismon_outputtimemode" id="arrismon_timeoutput_unix" class="input" value="unix">
<label for="arrismon_timeoutput_unix">Unix</label>
</td>
</tr>
<tr class="even" id="rowdaystokeep">
<td class="settingname">Number of days of data to keep</td>
<td class="settingvalue">
<input autocomplete="off" type="text" maxlength="3" class="input_6_table removespacing" name="arrismon_daystokeep" value="30" onkeypress="return validator.isNumber(this,event)" onblur="Validate_Number_Setting(this,365,10);Format_Number_Setting(this)" onkeyup="Validate_Number_Setting(this,365,10)"/>
&nbsp;days <span style="color:#FFCC00;">(between 10 and 365, default: 30)</span>
</td>
</tr>
<tr class="even" id="rowstorageloc">
<td class="settingname">Data Storage Location - <a href="https://github.com/RMerl/asuswrt-merlin.ng/wiki/Jffs/29a43db5de76c2ada7a3362745bfce08a9e7d029">recommended</a>: USB</td>
<td class="settingvalue">
<input type="radio" name="arrismon_storagelocation" id="arrismon_storageloc_jffs" class="input" value="jffs" >
<label for="arrismon_storageloc_jffs">JFFS</label>
<input type="radio" name="arrismon_storagelocation" id="arrismon_storageloc_usb" class="input" value="usb" checked>
<label for="arrismon_storageloc_usb">USB</label>
</td>
</tr>
<tr class="even" id="rowshownotice">
<td class="settingname">Include Notice messages in Logs (False)<br/><span class="settingname">(Critical and Error messages always reported)</span></td>
<td class="settingvalue">
<input type="radio" name="arrismon_shownotice" id="arrismon_shownotic_true" class="input" value="true" checked>
<label for="arrismon_shownotice_true">True</label>
<input type="radio" name="arrismon_shownotice" id="arrismon_shownotice_false" class="input" value="false">
<label for="arrismon_shownotice_false">False</label>
</td>
</tr>
<tr class="even" id="rowcredentials">
<td class="settingname">Cable Modem credentials, if required</td>
<td class="settingvalue">
<input autocomplete="off" type="text" maxlength="10" class="input_10_table removespacing" name="arrismon_loginname"/>
&nbsp; login name <span style="color:#FFCC00;">(*NA denotes not applicable)</span>
<input autocomplete="off" type="text" maxlength="25" class="input_25_table removespacing" name="arrismon_password"/>
&nbsp;password
</td>
</tr>
<tr class="apply_gen" valign="top" height="35px">
<td colspan="2" class="savebutton">
<input type="button" onclick="SaveConfig();" value="Save" class="button_gen savebutton" name="button">
</td>
</tr>
</table>
<div style="line-height:10px;">&nbsp;</div>
<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="table_modemlogs">
<thead class="collapsible-jquery" id="thead_modemlogs">
<tr><td colspan="2">Modem Logs (click to expand/collapse)</td></tr>
</thead>
<tr>
<td colspan="2" align="center" style="padding: 0px;">
<div id="sortTableContainer" class="sortTableContainer"></div>
</td>
</tr>
</table>
<!-- Chart legend filters inserted here -->
<!-- Charts inserted here -->
</td>
</tr>
</tbody>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</form>
<form method="post" name="formScriptActions" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="current_page" value="">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="action_wait" value="">
</form>
<div id="footer"></div>
</body>
</html>
