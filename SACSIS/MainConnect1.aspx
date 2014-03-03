<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MainConnect1.aspx.cs" Inherits="SACSIS.MainConnect1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body
        {
            height: 100%;
            overflow: auto;
            margin: 0px;
            padding: 0px;
            background-color: #f4f4f4;
        }
        map_all
        {
            height: 100%;
            overflow: auto;
            margin: 0px;
            padding: 0px;
            background-color: #f4f4f4;
			background-image:url(img/map_bg_1.jpg);
        }
		.div_title
		{
			background-image:url(img/map_bg_2.jpg);
			background-repeat:repeat-x;
			height:31px;
			color:#333333;
			font-family:"微软雅黑";
			font-size:19px;
		}
		.map
		{
			background-image:url(img/map_bg_1.jpg);
			
		}
		.text_1
		{
			color:#333333;
			font:Arial, Helvetica, sans-serif;
			font-size:28px;
			position: absolute; 
			top: 38px; 
			left: 20px;
		}
		.text_2
		{
			color:#0189ff;
			font:"Arial Black", Gadget, sans-serif;
			font-size:40px;
			display:inline;
			font-weight:bold;
		}
		.div_title_1
		{
			background-image:url(img/DataZL_title_1.jpg);
			background-repeat:no-repeat;
			background-color:#0568bd;
			background-position:top left;
			width:197px;
			height:84px;
			position: relative; display: block;
		}
		.div_title_2
		{
			background-image:url(img/DataZL_title_2.jpg);
			background-repeat:no-repeat;
			background-color:#0568bd;
			background-position:top left;
			width:192px;
			height:84px;
			position: relative; display: block;
		}
		.div_title_3
		{
			background-image:url(img/DataZL_title_3.jpg);
			background-repeat:no-repeat;
			background-color:#0568bd;
			background-position:top left;
			width:195px;
			height:84px;
			position: relative; display: block;
		}
		.div_title_4
		{
			background-image:url(img/DataZL_title_4.jpg);
			background-repeat:no-repeat;
			background-color:#0568bd;
			background-position:top left;
			width:195px;
			height:84px;
			position: relative; display: block;
		}
		.div_title_5
		{
			background-image:url(img/DataZL_title_5.jpg);
			background-repeat:no-repeat;
			background-color:#0568bd;
			background-position:top left;
			width:199px;
			height:84px;
			position: relative; display: block;
		}
		.div_title_6
		{
			background-color:#f4f4f4;
			color:#333333;
			font-family:"微软雅黑";    
			font-size:22px;
			height:27px;
		}
		.div_fg
		{
			background-image:url(img/DataZL_1.jpg);
			background-repeat:no-repeat;
			background-color:#0568bd;
			width:4px;
			height:84px;
		}
		.div_table_1
		{
			background-image:url(img/DataZL_2.jpg);
			background-repeat:repeat-x;
			color:#333333;
			font-family:"微软雅黑";    
			font-size:18px;
			height:43px;
		}
		.div_table_2
		{
			background-image:url(img/DataZL_4.jpg);
			background-repeat:repeat-x;
			color:#333333;
			font-family:"微软雅黑";    
			font-size:30px;
			height:56px;
		}
		.div_table_2_1
		{
			background-image:url(img/DataZL_4.jpg);
			background-repeat:repeat-x;
			height:56px;
		}
		
		
</style>
<script type="text/javascript">
  $(function () {

            //var highchartsOptions = Highcharts.setOptions(Highcharts.theme);

            //LOADCHARTS();
            load();
            //var int = self.setInterval("load()", 30000);

        });
function load() {

            //alert(1);

            $.ajax({
                url: "MainConnect.aspx?funCode=init",
                type: "POST",
                beforeSend: function () {
                    //Handle the beforeSend event
                },
                success: function (json) {
                    //json = eval("("+json+")");
                    var json = $.parseJSON(json);
                    //总容量 产业容量 
                    $("#ZRL").html("装机容量</br><label>" + json.ZRL + "<label style='font-size:14px'>MW</label></label>");
                    $("#HDRL").html(json.HDRL);
                    $("#FDRL").html(json.FDRL);
                    $("#SDRL").html(json.SDRL);
                    $("#TYNRL").html(json.TYNRL);
                    $("#FBSRL").html(json.FBSRL);
                    $("#SRZRL").html(json.SRZRL);

                    //总负荷 产业负荷
                    $("#ZFH").html("有功功率</br><label>" + (json.ZFH + json.SDFH + json.HDFH).toFixed(2) + "<label style='font-size:14px'>MW</label></label>");
                    //$("#FDFH").html(json.FDFH);
                    $("#HDFH").html(json.HDFH);
                    $("#SDFH").html(json.SDFH);
                    $("#TYNFH").html(json.TYNFH);
                    $("#FBSFH").html(json.FBSFH);
                    $("#SRZFH").html(json.SRZFH);


                    //日月电量
                    $("#DDL").html("日发电量</br><label>" + (json.DDL + json.HDDDL + json.SDDDL).toFixed(2) + "<label style='font-size:14px'>万kWh</label></label>");
                    $("#FDDDL").html(json.FDDDL);
                    $("#HDDDL").html(json.HDDDL);
                    $("#SDDDL").html(json.SDDDL);
                    $("#TYNDDL").html(json.TYNDDL);
                    $("#FBSDDL").html(json.FBSDDL);
                    $("#SRZDDL").html(json.SRZDDL);

                    $("#MDL").html("月发电量</br><label>" + ((json.MDL + json.HDMDL + json.SDMDL) / 10000).toFixed(2) + "<label style='font-size:14px'>亿kWh</label></label>");

                    $("#YDL").html("年发电量</br><label>" + ((json.YDL + json.HDYDL + json.SDYDL) / 10000).toFixed(2) + "<label style='font-size:14px'>亿kWh</label></label>");

                    $("#hd_progressbar").progressbar({
                        value: json.HDWCL
                    })
                    $("#sd_progressbar").progressbar({
                        value: json.SDWCL
                    })
                    $("#fd_progressbar").progressbar({
                        value: json.FDWCL
                    })
                    $("#tyn_progressbar").progressbar({
                        value: json.TYNWCL
                    })
                    $("#fbs_progressbar").progressbar({
                        value: json.FBSWCL
                    })
                    $("#qt_progressbar").progressbar({
                        value: json.SRZWCL
                    })
                    $("#hdss_progressbar").progressbar({
                        value: json.HDSS
                    })
                    $("#sdss_progressbar").progressbar({
                        value: json.SDSS
                    })
                    $("#fdss_progressbar").progressbar({
                        value: json.FDSS
                    })
                    $("#fbsss_progressbar").progressbar({
                        value: json.FBSSS
                    })
                    $("#tynss_progressbar").progressbar({
                        value: json.TYNSS
                    })
                    $("#srzss_progressbar").progressbar({
                        value: json.SRZSS
                    })
                },
                error: function (x, e) {
                    alert(x.responseText);
                },
                complete: function () {
                    //Handle the complete event
                }
            });

</script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f4f4f4">
<tr><td><div>
<table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#0568bd">
<tr>
<td class="div_title_1"><div class="text_1" id="ZRL">12345678</div></td>
<td class="div_fg"></td>
<td class="div_title_2"><div class="text_1" id="ZFH">12345678</div></td>
<td class="div_fg"></td>
<td class="div_title_3"><div class="text_1" id="DDL">1234567</div></td>
<td class="div_fg"></td>
<td class="div_title_4"><div class="text_1" id="MDL">1234567</div></td>
<td class="div_fg"></td>
<td class="div_title_5"><div class="text_1" id="YDL">1234567</div></td>
</tr>
</table></div>
</td></tr>
<tr><td><div>
<table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
<tr>
<td class="div_table_1"></td>
<td class="div_table_1" align="center" valign="middle">装机容量</td>
<td class="div_table_1" align="center" valign="middle">日发电量&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td class="div_table_1" align="center" valign="middle">实时负荷&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td class="div_table_1" align="center" valign="middle">计划完成率&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr>
<td class="div_table_2" align="center" valign="middle">火&nbsp;&nbsp;&nbsp;电</td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="HDRL">123456</div><div style="display:inline"><img src="img/DataZL_mw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="HDDRL">123456</div><div style="display:inline"><img src="img/DataZL_wkwh.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="HDFH">123456</div><div style="display:inline"><img src="img/DataZL_wkw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div id="hd_progressbar"></div></td>
</tr>
<tr>
<td class="div_table_2" align="center" valign="middle">水&nbsp;&nbsp;&nbsp;电</td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="SDRL">123456</div><div style="display:inline"><img src="img/DataZL_mw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="SDDRL">123456</div><div style="display:inline"><img src="img/DataZL_wkwh.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="SDFH">123456</div><div style="display:inline"><img src="img/DataZL_wkw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div id="sd_progressbar"></div></td>
</tr>
<tr>
<td class="div_table_2" align="center" valign="middle">风&nbsp;&nbsp;&nbsp;电</td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="FDRL">123456</div><div style="display:inline"><img src="img/DataZL_mw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="FDDRL">123456</div><div style="display:inline"><img src="img/DataZL_wkwh.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="FDFH">123456</div><div style="display:inline"><img src="img/DataZL_wkw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div id="fd_progressbar"></div></td>
</tr>
<tr>
<td class="div_table_2" align="center" valign="middle">太阳能</td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="TYNRL">123456</div><div style="display:inline"><img src="img/DataZL_mw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="TYNDRL">123456</div><div style="display:inline"><img src="img/DataZL_wkwh.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="TYNFH">123456</div><div style="display:inline"><img src="img/DataZL_wkw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div id="tyn_progressbar"></div></td>
</tr>
<tr>
<td class="div_table_2" align="center" valign="middle">分布式</td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="FBSRL">123456</div><div style="display:inline"><img src="img/DataZL_mw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="FBSDRL">123456</div><div style="display:inline"><img src="img/DataZL_wkwh.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="FBSFH">123456</div><div style="display:inline"><img src="img/DataZL_wkw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div id="fbs_progressbar"></div></td>
</tr>
<tr>
<td class="div_table_2" align="center" valign="middle">其&nbsp;&nbsp;&nbsp;他</td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="SRZRL">123456</div><div style="display:inline"><img src="img/DataZL_mw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="SRZDRL">123456</div><div style="display:inline"><img src="img/DataZL_wkwh.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div class="text_2" id="SRZFH">123456</div><div style="display:inline"><img src="img/DataZL_wkw.jpg" /></div></td>
<td class="div_table_2_1" align="center" valign="middle"><div id="srz_progressbar"></div></td>
</tr>
</table>
</div></td></tr>
<tr><td><div>
<table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f4f4f4">
<tr>
<td colspan="3" style="background-image:url(img/DataZL_3.jpg); background-repeat:repeat-x; height:5px;"></td>
</tr>
<tr>
<td colspan="3" align="left" valign="middle" class="div_title_6" >&nbsp;&nbsp;实时负荷</td>
</tr>
<tr>
<td align="left" valign="middle" bgcolor="#f4f4f4"><div style="width:300px; height:200px;"></div></td>
<td align="left" valign="middle" bgcolor="#f4f4f4"><div style="width:300px; height:200px;"></div></td>
<td align="left" valign="middle" bgcolor="#f4f4f4"><div style="width:300px; height:200px;"></div></td>
</tr>
</table>
</div></td></tr>
</table>
<div class="map_all">
<table  height="100%" width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#f4f4f4">
<tr>
<td class="div_title" align="left" valign="middle">&nbsp;&nbsp;项目分布</td>
</tr>
<tr>
<td class="map"><img src="img/map_1.jpg"  alt=""/></td>
</tr>
</table>
</div>
    </div>
    </form>
</body>
</html>
