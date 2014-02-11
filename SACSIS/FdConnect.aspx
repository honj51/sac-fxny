<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FdConnect.aspx.cs"
    Inherits="WebApplication2.FdConnect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>省份情况</title>
    <link href="css/main.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/default/easyui.css" rel="stylesheet" type="text/css" />
    <link href="../Js/jQueryEasyUI/themes/icon.css" rel="stylesheet" type="text/css" />
    <script src="../Js/jquery-1.8.2.min.js" type="text/javascript"></script>
    <script src="../Js/jquery.easyui.min.js" type="text/javascript"></script>
    <script src="../Js/highcharts.js" type="text/javascript"></script>
    <script src="../Js/highcharts-more.js" type="text/javascript"></script>
    <script src="../Js/exporting.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-family: 微软雅黑;
        }
        #tabId td
        {
            border: solid thin #6BA5BD;
        }
        #Table1 td
        {
            border: solid thin #6BA5BD;
        }
    </style>
    <script type="text/javascript" language="javascript">
        $(function () {


            load();
            var int = self.setInterval("load()", 30000);

        });


        function load() {

            $.ajax({
                url: "FdConnect.aspx?funCode=init",
                type: "POST",
                success: function (json) {
                    var json = $.parseJSON(json);

                    $("#mgy1fh").html(json.mgy1fh);
                    $("#mgy2fh").html(json.mgy2fh);
                    $("#fldfh").html(json.fldfh);
                    $("#ssfh").html(json.ssfh);

                    $("#mgy1fs").html(json.mgy1fs);
                    $("#mgy2fs").html(json.mgy2fs);
                    $("#fldfs").html(json.fldfs);
                    $("#ssfs").html(json.ssfs);

                    $("#mgy1rdl").html(json.mgy1rdl);
                    $("#mgy2rdl").html(json.mgy2rdl);
                    $("#fldrdl").html(json.fldrdl);
                    $("#ssrdl").html(json.ssrdl);

                    $("#mgy1ydl").html(json.mgy1ydl);
                    $("#mgy2ydl").html(json.mgy2ydl);
                    $("#fldydl").html(json.fldydl);
                    $("#ssydl").html(json.ssydl);

                    $("#mgy1jhdl").html(json.mgy1jhdl + "%");
                    $("#mgy2jhdl").html(json.mgy2jhdl + "%");
                    $("#fldjhdl").html(json.fldjhdl + "%");
                    $("#ssjhdl").html(json.ssjhdl + "%");

                    $("#mgy1yxts").html(json.mgy1yxts);
                    $("#mgy2yxts").html(json.mgy2yxts);
                    $("#fldyxts").html(json.fldyxts);
                    $("#ssyxts").html(json.ssyxts);

                    $("#mgy1tjts").html(json.mgy1tjts);
                    $("#mgy2tjts").html(json.mgy2tjts);
                    $("#fldtjts").html(json.fldtjts);
                    $("#sstjts").html(json.sstjts);

                    $("#mgy1yxl").html(json.mgy1yxl + "%");
                    $("#mgy2yxl").html(json.mgy2yxl + "%");
                    $("#fldyxl").html(json.fldyxl + "%");
                    $("#ssyxl").html(json.ssyxl + "%");

                    $("#mgy1tjl").html(json.mgy1tjl + "%");
                    $("#mgy2tjl").html(json.mgy2tjl + "%");
                    $("#fldtjl").html(json.fldtjl + "%");
                    $("#sstjl").html(json.sstjl + "%");

                }
            });
        }
    </script>
</head>
<body style="background-color: #F7F7FF;">
    <form id="form1">
    <div style="width: 1000px; height: 1006px; background-color: #023668; margin: 5px auto;">
        <div style="width: 1000px; height:800px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;风电产业分布
            </div>
            <div id="box" style="width: 1000px; height: 760px; float: left; background-image: url(img/fdfb.jpg);">
                <a href="MainConnect.aspx" style="float: right; margin-bottom: 200px; margin-right: 70px; height: 93px;
                    width: 115px;"><img style="border: 0" src="img/back.jpg" /></a>
            </div>
        </div>
        <div style="width: 1000px; height: 190px; float: left;">
            <div style="width: 1000px; height: 35px; float: left; background-image: url(img/20131211144004.png);
                font-size: 19px; color: White; line-height: 30px">
                &nbsp;详细数据
            </div>
            <table id="Table1" style="border-collapse: collapse; background-color: White; width: 985px;
                text-align: center; margin-left: 8px; margin-top: 2px; height: 150px" border="1">
                <tr>
                    <td style="width: 80px;">
                        省份
                    </td>
                    <td style="width: 100px;">
                        风场
                    </td>
                    <td style="width: 70px;">
                        装机容量
                    </td>
                    <td style="width: 60px;">
                        负荷
                    </td>
                    <td style="width: 60px;">
                        风速
                    </td>
                    <td style="width: 70px;">
                        日发电量
                    </td>
                    <td style="width: 80px;">
                        年累计电量
                    </td>
                    <td style="width: 70px;">
                        完成率
                    </td>
                    <td style="width: 70px;">
                        运行台数
                    </td>
                    <td style="width: 70px;">
                        停机台数
                    </td>
                    <td style="width: 70px;">
                        投运率
                    </td>
                    <td style="width: 70px;">
                        停机率
                    </td>

                </tr>
                <tr>
                    <td rowspan="4">
                        内蒙古
                    </td>
                    <td>
                        玫瑰营一期
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="mgy1fh">
                        &nbsp;
                    </td>
                    <td id="mgy1fs">
                        &nbsp;
                    </td>
                    <td id="mgy1rdl">
                        &nbsp;
                    </td>
                    <td id="mgy1ydl">
                        &nbsp;
                    </td>
                    <td id="mgy1jhdl">
                        &nbsp;
                    </td>
                    <td id="mgy1yxts">
                        &nbsp;
                    </td>
                    <td id="mgy1tjts">
                        &nbsp;
                    </td>
                    <td id="mgy1yxl">
                        &nbsp;
                    </td>
                    <td id="mgy1tjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        玫瑰营二期
                    </td>
                    <td>
                        200
                    </td>
                    <td id="mgy2fh">
                        &nbsp;
                    </td>
                    <td id="mgy2fs">
                        &nbsp;
                    </td>
                    <td id="mgy2rdl">
                        &nbsp;
                    </td>
                    <td id="mgy2ydl">
                        &nbsp;
                    </td>
                    <td id="mgy2jhdl">
                        &nbsp;
                    </td>
                    <td id="mgy2yxts">
                        &nbsp;
                    </td>
                    <td id="mgy2tjts">
                        &nbsp;
                    </td>
                    <td id="mgy2yxl">
                        &nbsp;
                    </td>
                    <td id="mgy2tjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        富丽达风场
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="fldfh">
                        &nbsp;
                    </td>
                    <td id="fldfs">
                        &nbsp;
                    </td>
                    <td id="fldrdl">
                        &nbsp;
                    </td>
                    <td id="fldydl">
                        &nbsp;
                    </td>
                    <td id="fldjhdl">
                        &nbsp;
                    </td>
                    <td id="fldyxts">
                        &nbsp;
                    </td>
                    <td id="fldtjts">
                        &nbsp;
                    </td>
                    <td id="fldyxl">
                        &nbsp;
                    </td>
                    <td id="fldtjl">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        三胜风场
                    </td>
                    <td>
                        49.5
                    </td>
                    <td id="ssfh">
                        &nbsp;
                    </td>
                    <td id="ssfs">
                        &nbsp;
                    </td>
                    <td id="ssrdl">
                        &nbsp;
                    </td>
                    <td id="ssydl">
                        &nbsp;
                    </td>
                    <td id="ssjhdl">
                        &nbsp;
                    </td>
                    <td id="ssyxts">
                        &nbsp;
                    </td>
                    <td id="sstjts">
                        &nbsp;
                    </td>
                    <td id="ssyxl">
                        &nbsp;
                    </td>
                    <td id="sstjl">
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
